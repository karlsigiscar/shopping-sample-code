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
    public var discountInPercent: Int?

    init(id: String, sku: String,
         name: String,
         description: String,
         image: String,
         price: Double,
         discountInPercent: Int
    ) {
        self.id = id
        self.sku = sku
        self.name = name
        self.description = description
        self.image = image
        self.price = price
        self.discountInPercent = discountInPercent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var priceString: String {
        // Would normally depend on locale and local price data and use proper formatting
        "£\(Int(price) + (Int(price) * (discountInPercent ?? 0)) / 100) - \(discountString)"
    }
    
    public var discountString: String {
        if let discountInPercent = discountInPercent {
            return "\(Int(discountInPercent))% OFF"
        }
        return ""
    }
}
