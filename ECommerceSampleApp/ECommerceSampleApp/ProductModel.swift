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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
