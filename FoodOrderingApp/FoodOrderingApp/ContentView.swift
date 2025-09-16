//
//  ContentView.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.cartStorageService) private var cartStorageService
    @Environment(\.apiService) private var apiService
    
    var body: some View {
        ContentViewWithDependencies(
            cartStorageService: cartStorageService,
            apiService: apiService
        )
    }
}

struct ContentViewWithDependencies: View {
    let cartStorageService: CartStorageServiceProtocol
    let apiService: APIServiceProtocol
    
    @StateObject private var cartViewModel: CartViewModel
    
    init(cartStorageService: CartStorageServiceProtocol, apiService: APIServiceProtocol) {
        self.cartStorageService = cartStorageService
        self.apiService = apiService
        self._cartViewModel = StateObject(wrappedValue: CartViewModel(storageService: cartStorageService))
    }
    
    var body: some View {
        TabView {
            MenuView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Menu")
                }
            
            CartView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
                .badge(cartViewModel.totalItems)
        }
        .environmentObject(cartViewModel)
        .accentColor(.orange)
    }
}

#Preview {
    ContentView()
}
