//
//  CartViewModel.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI
import Combine

@MainActor
class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var tipPercentage: Double = 0.0
    @Published var isShowingTipSelector = false
    
    private let storageService: CartStorageServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(storageService: CartStorageServiceProtocol) {
        self.storageService = storageService
        loadCartFromStorage()
        setupAutoSave()
    }
    
    // MARK: - Computed Properties
    
    var totalItems: Int {
        return cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        return cartItems.reduce(0.0) { $0 + $1.subtotal }
    }
    
    var tax: Double {
        return subtotal * 0.08 // 8% tax rate
    }
    
    var tip: Double {
        return subtotal * tipPercentage
    }
    
    var deliveryFee: Double {
        return subtotal > 0 ? 2.99 : 0.0
    }
    
    var serviceFee: Double {
        return subtotal > 0 ? 1.50 : 0.0
    }
    
    var total: Double {
        return subtotal + tax + tip + deliveryFee + serviceFee
    }
    
    var cartSummary: CartSummary {
        return CartSummary(
            totalItems: totalItems,
            subtotal: subtotal,
            tax: tax,
            tip: tip,
            fees: serviceFee,
            delivery: deliveryFee
        )
    }
    
    var isEmpty: Bool {
        return cartItems.isEmpty
    }
    
    var formattedSubtotal: String {
        return String(format: "$%.2f", subtotal)
    }
    
    var formattedTotal: String {
        return String(format: "$%.2f", total)
    }
    
    // MARK: - Cart Management
    
    func addItem(_ menuItem: MenuItem) {
        if let existingIndex = cartItems.firstIndex(where: { $0.menuItemID == menuItem.id }) {
            cartItems[existingIndex] = cartItems[existingIndex].incrementQuantity()
        } else {
            let newCartItem = CartItem(menuItem: menuItem, quantity: 1)
            cartItems.append(newCartItem)
        }
    }
    
    func removeItem(_ menuItem: MenuItem) {
        if let existingIndex = cartItems.firstIndex(where: { $0.menuItemID == menuItem.id }) {
            let updatedItem = cartItems[existingIndex].decrementQuantity()
            if updatedItem.quantity <= 0 {
                cartItems.remove(at: existingIndex)
            } else {
                cartItems[existingIndex] = updatedItem
            }
        }
    }
    
    func updateQuantity(for menuItem: MenuItem, to quantity: Int) {
        if quantity <= 0 {
            removeItem(menuItem)
            return
        }
        
        if let existingIndex = cartItems.firstIndex(where: { $0.menuItemID == menuItem.id }) {
            cartItems[existingIndex] = cartItems[existingIndex].withQuantity(quantity)
        } else if quantity > 0 {
            let newCartItem = CartItem(menuItem: menuItem, quantity: quantity)
            cartItems.append(newCartItem)
        }
    }
    
    func getQuantity(for menuItem: MenuItem) -> Int {
        return cartItems.first(where: { $0.menuItemID == menuItem.id })?.quantity ?? 0
    }
    
    func clearCart() {
        cartItems.removeAll()
        tipPercentage = 0.0
        storageService.clearCart()
    }
    
    // MARK: - Tip Management
    
    func setTipPercentage(_ percentage: Double) {
        tipPercentage = percentage
    }
    
    func showTipSelector() {
        isShowingTipSelector = true
    }
    
    func hideTipSelector() {
        isShowingTipSelector = false
    }
    
    // MARK: - Checkout
    
    func proceedToCheckout() {
        // This would typically navigate to a checkout screen
        // For now, we'll just clear the cart as a placeholder
        clearCart()
    }
    
    // MARK: - Persistence
    
    private func loadCartFromStorage() {
        let (items, tipPercentage) = storageService.loadCart()
        self.cartItems = items
        self.tipPercentage = tipPercentage
    }
    
    private func setupAutoSave() {
        // Auto-save cart changes with debouncing
        $cartItems
            .combineLatest($tipPercentage)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] items, tipPercentage in
                self?.storageService.saveCart(items, tipPercentage: tipPercentage)
            }
            .store(in: &cancellables)
    }
    
    func saveCart() {
        storageService.saveCart(cartItems, tipPercentage: tipPercentage)
    }
    
    func hasStaleCart() -> Bool {
        return storageService.isCartStale
    }
    
    func getCartAge() -> TimeInterval? {
        return storageService.cartAge
    }
}