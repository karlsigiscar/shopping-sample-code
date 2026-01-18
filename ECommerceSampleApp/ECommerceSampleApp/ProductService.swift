//
//  ProductService.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import Foundation
import Combine

class ProductService: NSObject, ObservableObject {
    
    enum AppError: Error {
        case configuration
    }
    
    private let baseURLString = "https://raw.githubusercontent.com/karlsigiscar/shopping-sample-code/refs/heads/main/ECommerceSampleApp"
    
    @Published var products: [ProductModel]?
    private var cancellables: Set<AnyCancellable> = []
    
    public func loadUserAndPromotions() {
        guard let url = URL(string: "\(baseURLString)/login.json") else {
            return
        }

        let userPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .flatMap { user -> AnyPublisher<[ProductModel], Error> in
                self.loadProductsOnPromotionForUser(userID: user.id)
                    .map { products in
                        products.filter { !$0.membersOnly || user.isClubMember }
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { print("Completed: \($0)") },
                  receiveValue: { [weak self] products in
                self?.products = products
            })
        
        userPublisher.store(in: &cancellables)
    }
    
    public func loadProductsOnPromotionForUser(userID: Int) -> AnyPublisher<[ProductModel], Error> {
        // This could be deserialized directly from the included data.json file, but instead, we download it from github for the sake of example
        // Likewise, images should be downloaded, but for the sake of example, they are just Image Resources from the Asset Catalog
        guard let url = URL(string: "\(baseURLString)/products.json?userID = \(userID)") else{
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [ProductModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
