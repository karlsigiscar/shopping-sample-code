//
//  AppError.swift
//  ECommerceSampleApp
//
//  Created by Writer on 19/01/2026.
//

import Foundation

enum AppError: Error {
    case configuration
    case invalidURL
    case networkFailure(Error)
    case decodingFailure(Error)
    case cacheExpired
    case unauthorized
    
    var localizedDescription: String {
        switch self {
        case .configuration: return "Configuration error"
        case .invalidURL: return "Invalid URL"
        case .networkFailure(let error): return "Network error: \(error.localizedDescription)"
        case .decodingFailure(let error): return "Decoding error: \(error.localizedDescription)"
        case .cacheExpired: return "Cache expired"
        case .unauthorized: return "Unauthorized access"
        }
    }
}
