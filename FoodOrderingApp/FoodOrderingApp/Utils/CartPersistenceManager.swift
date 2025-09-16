//
//  CartPersistenceManager.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation
import SwiftUI

class CartPersistenceManager: ObservableObject {
    static let shared = CartPersistenceManager()
    
    @Published var showStaleCartWarning = false
    @Published var persistenceError: String?
    
    private init() {}
    
    // MARK: - Cart Validation
    @MainActor
    func checkCartValidity(cartViewModel: CartViewModel) {
        if cartViewModel.hasStaleCart() {
            showStaleCartWarning = true
        }
    }
    
    @MainActor
    func dismissStaleCartWarning() {
        showStaleCartWarning = false
    }
    
    @MainActor
    func clearStaleCart(cartViewModel: CartViewModel) {
        cartViewModel.clearCart()
        showStaleCartWarning = false
    }
    
    // MARK: - Error Handling
    
    @MainActor
    func handlePersistenceError(_ error: Error) {
        persistenceError = error.localizedDescription
    }
    
    @MainActor
    func clearError() {
        persistenceError = nil
    }
    
    // MARK: - Cart Age Formatting
    
    func formatCartAge(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m ago"
        } else {
            return "\(minutes)m ago"
        }
    }
    
    // MARK: - Backup and Restore
    
    func createCartBackup(_ cartItems: [CartItem], tipPercentage: Double) -> Data? {
        let backup = CartBackup(
            items: cartItems,
            tipPercentage: tipPercentage,
            timestamp: Date()
        )
        
        do {
            return try JSONEncoder().encode(backup)
        } catch {
            Task { @MainActor in
                handlePersistenceError(error)
            }
            return nil
        }
    }
    
    func restoreFromBackup(_ data: Data) -> (items: [CartItem], tipPercentage: Double)? {
        do {
            let backup = try JSONDecoder().decode(CartBackup.self, from: data)
            return (backup.items, backup.tipPercentage)
        } catch {
            Task { @MainActor in
                handlePersistenceError(error)
            }
            return nil
        }
    }
}

// MARK: - Cart Backup Model
struct CartBackup: Codable {
    let items: [CartItem]
    let tipPercentage: Double
    let timestamp: Date
}
