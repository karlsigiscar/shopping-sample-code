//
//  DiscountResponse.swift
//  ContinuityCamera
//
//  Created by Writer on 18/05/2025.
//  Copyright © 2025 Apple. All rights reserved.
//

import Foundation

class DiscountResponse: Decodable {
    private(set) var promotions: [PromotionModel]?
}
