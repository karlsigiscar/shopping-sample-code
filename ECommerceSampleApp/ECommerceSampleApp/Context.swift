//
//  Context.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import SwiftUI

private struct CartModelKey: EnvironmentKey {
    static let defaultValue = CartModel()
}

extension EnvironmentValues {
    var cart: CartModel {
        get { self[CartModelKey.self] }
        set { self[CartModelKey.self] = newValue }
    }
}

extension View {
    func cart(_ cart: CartModel) -> some View {
        environmentObject(cart)
    }
}
