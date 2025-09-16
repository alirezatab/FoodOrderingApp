//
//  UpsellViewModel.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI
import Combine

@MainActor
class UpsellViewModel: ObservableObject {
    @Published var currentSuggestion: UpsellSuggestion?
    @Published var isShowingSuggestion = false
    
    private let triggerThreshold: Double = 20.0
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    
    func checkForUpsell(cartSubtotal: Double, cartViewModel: CartViewModel) {
        if cartSubtotal >= triggerThreshold {
            // Check if current suggestion is still valid (not in cart)
            if let currentSuggestion = currentSuggestion {
                let isCurrentSuggestionInCart = cartViewModel.cartItems.contains { $0.menuItemID == currentSuggestion.id }
                if isCurrentSuggestionInCart {
                    hideSuggestion()
                }
            }
            
            // Generate new suggestion if none is showing
            if !isShowingSuggestion {
                generateSuggestion(for: cartSubtotal, cartViewModel: cartViewModel)
            }
        } else {
            hideSuggestion()
        }
    }
    
    func addSuggestionToCart(_ suggestion: UpsellSuggestion, cartViewModel: CartViewModel) {
        // Create a MenuItem from the suggestion
        let menuItem = MenuItem(
            id: suggestion.id,
            name: suggestion.title,
            description: suggestion.description,
            price: suggestion.price,
            category: suggestion.category
        )
        
        cartViewModel.addItem(menuItem)
        
        // Hide the suggestion immediately after adding to cart
        hideSuggestion()
        
        // Re-check for upsell opportunities with the updated cart
        // This will either show a new suggestion or hide if no more available
        checkForUpsell(cartSubtotal: cartViewModel.subtotal, cartViewModel: cartViewModel)
    }
    
    func dismissSuggestion() {
        hideSuggestion()
    }
    
    // MARK: - Private Methods
    
    private func generateSuggestion(for subtotal: Double, cartViewModel: CartViewModel) {
        // Get available suggestions that aren't already in cart
        let availableSuggestions = UpsellSuggestion.sampleSuggestions.filter { suggestion in
            !cartViewModel.cartItems.contains { $0.menuItemID == suggestion.id }
        }
        
        // Select a random suggestion
        if let randomSuggestion = availableSuggestions.randomElement() {
            currentSuggestion = randomSuggestion
            isShowingSuggestion = true
        }
    }
    
    private func hideSuggestion() {
        currentSuggestion = nil
        isShowingSuggestion = false
    }
    
    // MARK: - Computed Properties
    
    var shouldShowSuggestion: Bool {
        return isShowingSuggestion && currentSuggestion != nil
    }
    
    var suggestionTitle: String {
        return currentSuggestion?.title ?? ""
    }
    
    var suggestionDescription: String {
        return currentSuggestion?.description ?? ""
    }
    
    var suggestionPrice: String {
        return currentSuggestion?.formattedPrice ?? ""
    }
}
