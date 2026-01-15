//
//  ContentViewModel.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import Combine
import Foundation

/// Thread yielding
/// Since properties marked with the @Published property wrapper will be accessed by SwiftUI,
/// we mark ContentViewModel with @MainActor to ensure they are always accessed from the main queue.
/// By contrast, any async call in the view model will be executed on a background queue.
@MainActor
class ContentViewModel: NSObject, ObservableObject {
    
    @Published public var isLoading: Bool = false
    @Published public var products = [ProductModel]()
    
    private var productsService = ProductService()
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        subscribe()
        do {
            try productsService.loadProducts()
            isLoading = true
        }
        catch {
            // FIXME: Show user facing initialization error
            print(error)
        }
    }
    
    private func subscribe() {
        productsService.$products.dropFirst().receive(on: DispatchQueue.main).sink { [weak self] products in
            self?.products = products
            self?.isLoading = false
        }.store(in: &cancellables)
    }
}
