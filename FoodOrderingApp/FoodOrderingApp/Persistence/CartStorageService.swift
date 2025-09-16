//
//  CartStorageService.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation
import Combine

// MARK: - Protocol for Dependency Injection
protocol CartStorageServiceProtocol {
    func saveCart(_ items: [CartItem], tipPercentage: Double)
    func loadCart() -> (items: [CartItem], tipPercentage: Double)
    func clearCart()
    var hasSavedCart: Bool { get }
    var lastSavedDate: Date? { get }
    var cartAge: TimeInterval? { get }
    var isCartStale: Bool { get }
}

// MARK: - Concrete Implementation
class CartStorageService: CartStorageServiceProtocol, ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let cartItemsKey = "cartItems"
    private let tipPercentageKey = "tipPercentage"
    private let lastSavedKey = "lastSaved"
    
    func saveCart(_ items: [CartItem], tipPercentage: Double) {
        do {
            let encodedItems = try JSONEncoder().encode(items)
            userDefaults.set(encodedItems, forKey: cartItemsKey)
            userDefaults.set(tipPercentage, forKey: tipPercentageKey)
            userDefaults.set(Date(), forKey: lastSavedKey)
            print("✅ Cart saved successfully with \(items.count) items")
        } catch {
            print("❌ Failed to save cart: \(error.localizedDescription)")
        }
    }
    
    func loadCart() -> (items: [CartItem], tipPercentage: Double) {
        do {
            var items: [CartItem] = []
            var tipPercentage: Double = 0.0
            
            if let itemsData = userDefaults.data(forKey: cartItemsKey) {
                items = try JSONDecoder().decode([CartItem].self, from: itemsData)
                print("✅ Cart loaded successfully with \(items.count) items")
            } else {
                print("ℹ️ No saved cart found, starting with empty cart")
            }
            
            tipPercentage = userDefaults.double(forKey: tipPercentageKey)
            return (items, tipPercentage)
            
        } catch {
            print("❌ Failed to load cart: \(error.localizedDescription)")
            return ([], 0.0)
        }
    }
    
    func clearCart() {
        userDefaults.removeObject(forKey: cartItemsKey)
        userDefaults.removeObject(forKey: tipPercentageKey)
        userDefaults.removeObject(forKey: lastSavedKey)
        print("🗑️ Cart cleared successfully")
    }
    
    var hasSavedCart: Bool {
        return userDefaults.data(forKey: cartItemsKey) != nil
    }
    
    var lastSavedDate: Date? {
        return userDefaults.object(forKey: lastSavedKey) as? Date
    }
    
    var cartAge: TimeInterval? {
        guard let lastSaved = lastSavedDate else { return nil }
        return Date().timeIntervalSince(lastSaved)
    }
    
    var isCartStale: Bool {
        guard let age = cartAge else { return false }
        // Consider cart stale after 24 hours
        return age > 24 * 60 * 60
    }
}

// MARK: - Mock Implementation for Testing
class MockCartStorageService: CartStorageServiceProtocol {
    private var mockCartItems: [CartItem] = []
    private var mockTipPercentage: Double = 0.0
    private var mockLastSaved: Date?
    
    func saveCart(_ items: [CartItem], tipPercentage: Double) {
        mockCartItems = items
        mockTipPercentage = tipPercentage
        mockLastSaved = Date()
        print("🧪 Mock: Cart saved with \(items.count) items")
    }
    
    func loadCart() -> (items: [CartItem], tipPercentage: Double) {
        print("🧪 Mock: Cart loaded with \(mockCartItems.count) items")
        return (mockCartItems, mockTipPercentage)
    }
    
    func clearCart() {
        mockCartItems = []
        mockTipPercentage = 0.0
        mockLastSaved = nil
        print("🧪 Mock: Cart cleared")
    }
    
    var hasSavedCart: Bool {
        return !mockCartItems.isEmpty
    }
    
    var lastSavedDate: Date? {
        return mockLastSaved
    }
    
    var cartAge: TimeInterval? {
        guard let lastSaved = mockLastSaved else { return nil }
        return Date().timeIntervalSince(lastSaved)
    }
    
    var isCartStale: Bool {
        guard let age = cartAge else { return false }
        return age > 24 * 60 * 60
    }
}
