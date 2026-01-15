//
//  ProductDetailView.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var cart: CartModel
    public var product: ProductModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(product.image)
                .resizable()
                .aspectRatio(320 / 180, contentMode: .fill)
                .containerRelativeFrame(.horizontal, count: 5, spacing: 40)
            VStack(spacing: 20) {
                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(product.description)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding([.top], 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .overlay(alignment: .bottom) {
            buttonsView()
                .offset(x: 0, y: -40)
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 100) {
            
            #if os(tvOS)
            // We would not normally have this kind of button on Apple TV to navigate back, but this is just for this code sample
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Back", systemImage: "lessthan")
                    .font(.system(size: 50))
            }
            #endif

            if !cart.contains(product) {
                Button {
                    cart.addProduct(product)
                } label: {
                    Label("Add to cart", systemImage: "cart.badge.plus")
                        .font(.system(size: 50))
                }
            }
            
            if cart.contains(product) {
                Button {
                    cart.removeProduct(product)
                } label: {
                    Label("Remove from cart", systemImage: "cart.badge.minus")
                        .font(.system(size: 50))
                }
            }
        }
        .labelStyle(.iconOnly)
        .padding(EdgeInsets(top: 30, leading: 40, bottom: 30, trailing: 40))
        .cornerRadius(15)
    }
}
