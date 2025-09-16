//
//  APIService.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation
import Combine

class APIService: APIServiceProtocol, ObservableObject {
    
    // MARK: - Menu Data Loading
    func fetchMenu() async throws -> [Category] {
        guard let url = Bundle.main.url(forResource: "Menu", withExtension: "json") else {
            throw APIError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let menuResponse = try JSONDecoder().decode(MenuResponse.self, from: data)
            return menuResponse.categories
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - Combine Support
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

// MARK: - API Errors
enum APIError: Error, LocalizedError {
    case fileNotFound
    case decodingError(Error)
    case networkError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Menu data file not found"
        case .decodingError(let error):
            return "Failed to decode menu data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
