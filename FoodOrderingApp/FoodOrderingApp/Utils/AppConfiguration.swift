//
//  AppConfiguration.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI

class AppConfiguration {
    static let shared = AppConfiguration()
    
    // MARK: - Dependencies
    lazy var apiService: APIServiceProtocol = {
        #if DEBUG
        // Use mock service in debug mode for testing
        return MockAPIService()
        #else
        // Use real service in production
        return APIService()
        #endif
    }()
    
    lazy var cartStorageService: CartStorageServiceProtocol = {
        #if DEBUG
        // Use mock service in debug mode for testing
        return MockCartStorageService()
        #else
        // Use real service in production
        return CartStorageService()
        #endif
    }()
    
    private init() {}
}

// MARK: - View Extension for Dependency Injection
extension View {
    func withAppDependencies() -> some View {
        let config = AppConfiguration.shared
        
        return self
            .environment(\.apiService, config.apiService)
            .environment(\.cartStorageService, config.cartStorageService)
    }
}
