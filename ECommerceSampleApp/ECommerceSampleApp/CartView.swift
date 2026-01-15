//
//  CartView.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cart: CartModel

    var body: some View {
        if cart.items.isEmpty {
            Text("Your shopping cart is empty")
                .font(.largeTitle)
        } else {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Number of items in your cart: \(cart.numberOfItems)")
                        .font(.title2)
                    List(cart.items) { item in
                        VStack(alignment: .trailing) {
                            HStack(spacing: 20) {
                                Image(item.product.image)
                                    .resizable()
                                    .aspectRatio(320 / 180, contentMode: .fit)
                                    .containerRelativeFrame(.horizontal, count: 5, spacing: 40)
                                Text(item.product.description)
                            }
                            Text("Quantity: \(String(item.quantity))")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding([.top], 20)
            }
        }
    }
}

#Preview {
    CartView()
}
