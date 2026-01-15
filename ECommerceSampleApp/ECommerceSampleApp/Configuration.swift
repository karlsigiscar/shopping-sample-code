//
//  Configuration.swift
//  ContinuityCamera
//
//  Created by Writer on 18/05/2025.
//  Copyright © 2025 Apple. All rights reserved.
//

import Foundation

class Configuration: Decodable {

    private(set) var products: [ProductModel]?
    
     init() throws {
         let config = try config()
         self.products = config?.products
     }
    
    private func config() throws -> Configuration? {
        if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") {
            let fileURL = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: fileURL)
            let dictionary = try PropertyListDecoder().decode(Configuration.self, from: data)
            return dictionary
        }
        return nil
    }
}
