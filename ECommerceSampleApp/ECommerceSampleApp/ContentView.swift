//
//  ContentView.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    private var cart = CartModel()
    var body: some View {
        TabView {
            Tab("Products", systemImage: "coat") {
                ProductsView()
                    .cart(cart)
            }
            Tab("Cart", systemImage: "cart") {
                CartView()
                    .cart(cart)
            }
        }
    }
}
