//
//  MenuView.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.apiService) private var apiService
    @EnvironmentObject private var cartViewModel: CartViewModel
    @StateObject private var menuViewModel: MenuViewModel
    
    init() {
        // Initialize with default service, will be overridden by environment
        self._menuViewModel = StateObject(wrappedValue: MenuViewModel(apiService: APIService()))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if menuViewModel.isLoading {
                    LoadingView()
                } else if menuViewModel.hasError {
                    ErrorView(message: menuViewModel.errorMessage ?? "Failed to load menu") {
                        menuViewModel.retryLoading()
                    }
                } else if menuViewModel.isEmpty {
                    EmptyStateView()
                } else {
                    MenuContentView(
                        categories: menuViewModel.filteredCategories,
                        cartViewModel: cartViewModel
                    )
                }
            }
            .navigationTitle("Menu")
            .searchable(text: $menuViewModel.searchText, prompt: "Search menu items...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CartSummaryLabel(cartViewModel: cartViewModel)
                }
            }
        }
        .onAppear {
            // Re-initialize with injected service if needed
            if menuViewModel.categories.isEmpty && !menuViewModel.isLoading {
                menuViewModel.loadMenu()
            }
        }
    }
}

#Preview {
    MenuView()
}
