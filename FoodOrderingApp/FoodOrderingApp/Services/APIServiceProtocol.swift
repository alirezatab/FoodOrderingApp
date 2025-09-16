//
//  APIServiceProtocol.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation
import Combine

// MARK: - Protocol for Dependency Injection
protocol APIServiceProtocol {
    func fetchMenu() async throws -> [Category]
    func fetchMenuPublisher() -> AnyPublisher<[Category], APIError>
}

// MARK: - Mock Implementation for Testing
class MockAPIService: APIServiceProtocol {
    private let mockCategories: [Category]
    
    init(mockCategories: [Category] = []) {
        self.mockCategories = mockCategories.isEmpty ? Category.sampleCategories : mockCategories
    }
    
    func fetchMenu() async throws -> [Category] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        if Bool.random() {
            throw APIError.networkError(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock network error"]))
        }
        
        return mockCategories
    }
    
    func fetchMenuPublisher() -> AnyPublisher<[Category], APIError> {
        Future { promise in
            Task {
                do {
                    let categories = try await self.fetchMenu()
                    promise(.success(categories))
                } catch {
                    if let apiError = error as? APIError {
                        promise(.failure(apiError))
                    } else {
                        promise(.failure(.unknown(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
