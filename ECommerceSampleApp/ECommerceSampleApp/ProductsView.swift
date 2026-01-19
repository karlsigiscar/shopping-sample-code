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
        if viewModel.isLoading {
            ProgressView()
        } else {
            NavigationView {
                VStack {
                    Text("SALE - UP to 60% OFF")
                        .font(.title)
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
                                VStack(alignment: .leading) {
                                    Text(product.priceString)
                                        .font(.subheadline)
                                    Text(product.description)
                                }
                            }
                        }
                        .focusable()
                        #if os(tvOS)
                        .hoverEffect(.lift)
                        #endif
                    }
                }
                #if os(tvOS)
                .frame(height: 1080) // size in pts, not px, so it works for both 2K and 4K TV sets
                .padding([.top], 160)
                #endif
            }
        }
    }
}

#Preview {
    ProductsView()
}
