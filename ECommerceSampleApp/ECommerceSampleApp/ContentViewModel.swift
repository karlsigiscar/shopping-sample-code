//
//  ContentViewModel.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//

import Combine
import Foundation

/// Thread yielding used here.
/// Since properties marked with the @Published property wrapper will be accessed by SwiftUI,
/// we mark ContentViewModel with @MainActor to ensure it's accessed from the main queue
/// Any async call in the view model will be executed on a background queue
@MainActor
class ContentViewModel: NSObject, ObservableObject {
    
    @Published public var products = [ProductModel]()

    enum AppError: Error {
        case configuration
    }
    
    override init() {
        do {
            let configuration = try Configuration()
            guard let products = configuration.products else {
                throw AppError.configuration
            }
            self.products = products
        }
        catch {
            // Show user facing initialization error
            print(error)
        }
    }
}
