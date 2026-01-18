//
//  PromotionModel.swift
//  ECommerceSampleApp
//
//  Created by Writer on 18/01/2026.
//

import Foundation

struct PromotionModel: Identifiable, Sendable, Decodable {
    public var id: String
    public var sku: String
    public var discountInPercent: Int
    
    init(id: String, sku: String,
         name: String,
         discountInPercent: Int
    ) {
        self.id = id
        self.sku = sku
        self.discountInPercent = discountInPercent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var discountString: String {
        "\(Int(discountInPercent))% OFF"
    }
}
