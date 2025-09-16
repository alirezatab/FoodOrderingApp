//
//  TipSelectorView.swift
//  FoodOrderingApp
//
//  Created by Temp on 9/15/25.
//

import SwiftUI

struct TipSelectorView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let tipOptions: [Double] = [0.0, 0.15, 0.18, 0.20, 0.25]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Add Tip")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Show your appreciation for great service")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Tip Options
                VStack(spacing: 12) {
                    ForEach(tipOptions, id: \.self) { percentage in
                        TipOptionRow(
                            percentage: percentage,
                            subtotal: cartViewModel.subtotal,
                            isSelected: cartViewModel.tipPercentage == percentage,
                            onTap: {
                                cartViewModel.setTipPercentage(percentage)
                            }
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Custom Tip Input
                VStack(spacing: 12) {
                    Text("Or enter custom amount")
                        .font(.headline)
                    
                    HStack {
                        Text("$")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        TextField("0.00", value: $cartViewModel.tipPercentage, format: .number)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Tip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct TipOptionRow: View {
    let percentage: Double
    let subtotal: Double
    let isSelected: Bool
    let onTap: () -> Void
    
    private var tipAmount: Double {
        subtotal * percentage
    }
    
    private var formattedPercentage: String {
        if percentage == 0.0 {
            return "No Tip"
        } else {
            return "\(Int(percentage * 100))%"
        }
    }
    
    private var formattedAmount: String {
        return String(format: "$%.2f", tipAmount)
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedPercentage)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if percentage > 0 {
                        Text(formattedAmount)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.orange.opacity(0.1) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
