//
//  CartStorage.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import Foundation
import Combine

@MainActor
class CartStorage: ObservableObject {
    static let shared = CartStorage()
    
    private let userDefaults = UserDefaults.standard
    private let cartItemsKey = "cartItems"
    private let tipPercentageKey = "tipPercentage"
    private let lastSavedKey = "lastSaved"
    
    // MARK: - Published Properties
    @Published var cartItems: [CartItem] = []
    @Published var tipPercentage: Double = 0.0
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadCart()
    }
    
    // MARK: - Public Methods
    
    func saveCart(_ items: [CartItem], tipPercentage: Double) {
        do {
            let encodedItems = try JSONEncoder().encode(items)
            userDefaults.set(encodedItems, forKey: cartItemsKey)
            userDefaults.set(tipPercentage, forKey: tipPercentageKey)
            userDefaults.set(Date(), forKey: lastSavedKey)
            
            // Update published properties
            self.cartItems = items
            self.tipPercentage = tipPercentage
            
            print("✅ Cart saved successfully with \(items.count) items")
        } catch {
            print("❌ Failed to save cart: \(error.localizedDescription)")
        }
    }
    
    func loadCart() {
        do {
            // Load cart items
            if let itemsData = userDefaults.data(forKey: cartItemsKey) {
                let items = try JSONDecoder().decode([CartItem].self, from: itemsData)
                self.cartItems = items
                print("✅ Cart loaded successfully with \(items.count) items")
            } else {
                self.cartItems = []
                print("ℹ️ No saved cart found, starting with empty cart")
            }
            
            // Load tip percentage
            self.tipPercentage = userDefaults.double(forKey: tipPercentageKey)
            
        } catch {
            print("❌ Failed to load cart: \(error.localizedDescription)")
            self.cartItems = []
            self.tipPercentage = 0.0
        }
    }
    
    func clearCart() {
        userDefaults.removeObject(forKey: cartItemsKey)
        userDefaults.removeObject(forKey: tipPercentageKey)
        userDefaults.removeObject(forKey: lastSavedKey)
        
        self.cartItems = []
        self.tipPercentage = 0.0
        
        print("🗑️ Cart cleared successfully")
    }
    
    // MARK: - Computed Properties
    
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
    
    // MARK: - Auto-save functionality
    
    func autoSave(_ items: [CartItem], tipPercentage: Double) {
        // Only auto-save if there are items or if we're clearing the cart
        if !items.isEmpty || self.cartItems.isEmpty {
            saveCart(items, tipPercentage: tipPercentage)
        }
    }
    
    // MARK: - CartViewModel Integration
    
    func syncWithCartViewModel(_ cartViewModel: CartViewModel) {
        // Load saved data into CartViewModel
        cartViewModel.cartItems = self.cartItems
        cartViewModel.tipPercentage = self.tipPercentage
        
        // Set up auto-save when CartViewModel changes
        cartViewModel.$cartItems
            .combineLatest(cartViewModel.$tipPercentage)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] items, tipPercentage in
                self?.autoSave(items, tipPercentage: tipPercentage)
            }
            .store(in: &cancellables)
    }
}
