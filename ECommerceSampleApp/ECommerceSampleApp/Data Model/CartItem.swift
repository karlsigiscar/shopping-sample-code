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
    
    @Published var quantity: Int
    let product: ProductModel
    let shippingAddress: String = "111 Park Avenue, New York, NY 10001, United States of America"
    let billingAddress: String? = nil
    let isShippingAddressSameAsBillingAddress: Bool = true
    
    var id: String {
        product.id
    }
    
    init(product: ProductModel, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
