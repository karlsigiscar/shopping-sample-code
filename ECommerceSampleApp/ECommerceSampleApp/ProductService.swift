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
    
    @Published var products: [ProductModel] = []
    private var cancellables: Set<AnyCancellable> = []
    
    public func loadProducts() throws {
        // This could be deserialized directly from the included data.json file, but instead, we download it from github for the sake of example
        // Likewise, images should be downloaded, but for the sake of example, they are just Image Resources from the Asset Catalog
        guard let url = URL(string: "https://raw.githubusercontent.com/karlsigiscar/shopping-sample-code/refs/heads/main/ECommerceSampleApp/data.json") else{
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Configuration.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Api Error: \(error)")
                }
            },
                  receiveValue: {[weak self] configuration in
                guard let products = configuration.products else {
                    return
                }
                self?.products = products
            }).store(in: &cancellables)
    }
}
