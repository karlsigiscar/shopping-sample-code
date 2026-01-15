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
        if let cartItem = findItem(by: product.id) {
            cartItem.quantity += 1
        } else {
            let cartItem = CartItem(product: product, quantity: 1)
            items.append(cartItem)
        }
    }
    
    public func removeProduct(_ product: ProductModel) {
        items.removeAll(where: { $0.product.id == product.id })
    }
    
    public func increaseQuantity(_ item: CartItem) {
        if let cartItem = findItem(by: item.id) {
            cartItem.quantity += 1
        }
    }
    
    public func decreaseQuantity(_ item: CartItem) {
        if let cartItem = findItem(by: item.id) {
            cartItem.quantity -= 1
        }
    }

    public func contains(_ product: ProductModel) -> Bool {
        items.filter( { $0.product.id == product.id }).count > 0
    }
    
    var numberOfItems: Int {
        items.reduce(into: 0) { $0 += $1.quantity }
    }
    
    private func findItem(by id: String) -> CartItem? {
        let correspondingItems: [CartItem] = items.filter( { $0.product.id == id })
        if correspondingItems.count > 0 {
            return correspondingItems[0]
        } else {
            return nil
        }
    }
}
