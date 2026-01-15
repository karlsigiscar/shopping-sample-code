//
//  CartItem.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import Foundation

class CartItem: Identifiable {
    var id: String {
        product.id
    }
    let product: ProductModel
    var quantity: Int
    
    init(product: ProductModel, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
