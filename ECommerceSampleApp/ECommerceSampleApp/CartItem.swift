//
//  CartItem.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import Foundation
import Combine

@MainActor
class CartItem: NSObject, ObservableObject, Identifiable {
    
    var id: String {
        product.id
    }
    let product: ProductModel
    @Published var quantity: Int
    
    init(product: ProductModel, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
