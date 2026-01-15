//
//  ProductsView.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ContentViewModel()
    @EnvironmentObject var cart: CartModel

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.products) { product in
                    NavigationLink {
                        ProductDetailView(product: product)
                            .cart(cart)
                    } label: {
                        HStack(spacing: 20) {
                            Image(product.image)
                                .resizable()
                                .aspectRatio(320 / 180, contentMode: .fit)
                                .containerRelativeFrame(.horizontal, count: 5, spacing: 40)
                            Text(product.description)
                        }
                    }
                    .buttonStyle(.borderless)
                    .focusable()
                    .hoverEffect(.lift)
                }
            }
        }
    }
}

#Preview {
    ProductsView()
}
