//
//  CartModel.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import Foundation
import Combine

@MainActor
class CartModel: NSObject, ObservableObject {
    
    @Published public var items = [CartItem]()
    
    public func addProduct(_ product: ProductModel) {
        
        let correspondingItems: [CartItem] = self.items.filter( { $0.product.id == product.id })
        if correspondingItems.count > 0 {
            correspondingItems[0].quantity += 1
            return
        } else {
            let cartItem = CartItem(product: product, quantity: 1)
            items.append(cartItem)
        }
    }
    
    public func removeProduct(_ product: ProductModel) {
        items.removeAll(where: { $0.product.id == product.id })
    }
    
    public func contains(_ product: ProductModel) -> Bool {
        items.filter( { $0.product.id == product.id }).count > 0
    }
    
    var numberOfItems: Int {
        items.reduce(into: 0) { $0 += $1.quantity }
    }
}
