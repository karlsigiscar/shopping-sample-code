//
//  ProductModel.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import Foundation
import Combine

struct ProductModel: Identifiable, Sendable, Decodable {
    public var id: String
    public var sku: String
    public var name: String
    public var description: String
    public var image: String
    public var price: Double
    
    init(id: String, sku: String, name: String, description: String, image: String, price: Double) {
        self.id = id
        self.sku = sku
        self.name = name
        self.description = description
        self.image = image
        self.price = price
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var priceString: String {
        "£\(Int(price))" // Would normally depend on locale and local price data and use proper formatting
    }
}
