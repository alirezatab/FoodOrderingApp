//
//  EnvironmentKeys.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI

// MARK: - Environment Keys for Dependency Injection

struct APIServiceKey: EnvironmentKey {
    static let defaultValue: APIServiceProtocol = APIService()
}

struct CartStorageServiceKey: EnvironmentKey {
    static let defaultValue: CartStorageServiceProtocol = CartStorageService()
}

// MARK: - Environment Values Extensions

extension EnvironmentValues {
    var apiService: APIServiceProtocol {
        get { self[APIServiceKey.self] }
        set { self[APIServiceKey.self] = newValue }
    }
    
    var cartStorageService: CartStorageServiceProtocol {
        get { self[CartStorageServiceKey.self] }
        set { self[CartStorageServiceKey.self] = newValue }
    }
}

// MARK: - View Extensions for Easy Access

extension View {
    func injectAPIService(_ service: APIServiceProtocol) -> some View {
        environment(\.apiService, service)
    }
    
    func injectCartStorageService(_ service: CartStorageServiceProtocol) -> some View {
        environment(\.cartStorageService, service)
    }
}
