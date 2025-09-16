//
//  MenuViewModel.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI
import Combine

@MainActor
class MenuViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        loadMenu()
    }
    
    // MARK: - Public Methods
    
    func loadMenu() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedCategories = try await apiService.fetchMenu()
                self.categories = fetchedCategories
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func retryLoading() {
        loadMenu()
    }
    
    // MARK: - Computed Properties
    
    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return categories
        }
        
        return categories.compactMap { category in
            let filteredItems = category.items.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText)
            }
            
            if filteredItems.isEmpty {
                return nil
            }
            
            return Category(id: category.id, name: category.name, items: filteredItems)
        }
    }
    
    var hasError: Bool {
        return errorMessage != nil
    }
    
    var isEmpty: Bool {
        return categories.isEmpty && !isLoading
    }
    
    // MARK: - Cart Integration
    
    func addToCart(_ menuItem: MenuItem, cartViewModel: CartViewModel) {
        cartViewModel.addItem(menuItem)
    }
    
    func removeFromCart(_ menuItem: MenuItem, cartViewModel: CartViewModel) {
        cartViewModel.removeItem(menuItem)
    }
    
    func getCartQuantity(for menuItem: MenuItem, cartViewModel: CartViewModel) -> Int {
        return cartViewModel.getQuantity(for: menuItem)
    }
}
