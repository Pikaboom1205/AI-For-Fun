//
//  AddFoodView.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import SwiftUI

struct AddFoodView: View {
    
    @EnvironmentObject var foodManager: FoodManager
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var name = ""
    
    @State private var hasExpiry = true
    
    @State private var expiryDate =
        Calendar.current.date(
            byAdding: .day,
            value: 3,
            to: Date()
        ) ?? Date()
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Food") {
                    
                    TextField(
                        "Food name",
                        text: $name
                    )
                }
                
                Section("Expiry") {
                    
                    Toggle(
                        "Expiry date known",
                        isOn: $hasExpiry
                    )
                    
                    if hasExpiry {
                        
                        DatePicker(
                            "Expiry date",
                            selection: $expiryDate,
                            displayedComponents: .date
                        )
                    }
                }
                
                Section {
                    
                    Button("Add Food") {
                        
                        let cleanName =
                            name.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                        
                        foodManager.addFood(
                            name: cleanName,
                            expiryDate:
                                hasExpiry
                                ? expiryDate
                                : nil
                        )
                        
                        dismiss()
                    }
                    .disabled(
                        name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(
                    placement: .topBarLeading
                ) {
                    
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
