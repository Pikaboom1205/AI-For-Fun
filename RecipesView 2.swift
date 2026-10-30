//
//  RecipesView.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import SwiftUI

struct RecipesView: View {
    
    @EnvironmentObject var foodManager: FoodManager
    
    var expiringFoods: [FoodItem] {
        
        foodManager.foods.filter {
            
            guard let days = $0.daysRemaining else {
                return false
            }
            
            return days >= 0 && days <= 3
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                Section("Use These Soon") {
                    
                    if expiringFoods.isEmpty {
                        
                        Text(
                            "No food is expiring soon."
                        )
                        .foregroundStyle(.secondary)
                        
                    } else {
                        
                        ForEach(expiringFoods) { food in
                            
                            HStack {
                                
                                Image(
                                    systemName:
                                        "clock.fill"
                                )
                                
                                Text(food.name)
                            }
                        }
                    }
                }
                
                Section("Suggested Recipes") {
                    
                    RecipeCard(
                        name: "French Toast",
                        ingredients:
                            "Bread + Eggs + Milk"
                    )
                    
                    RecipeCard(
                        name: "Creamy Pasta",
                        ingredients:
                            "Milk + Cheese + Pasta"
                    )
                    
                    RecipeCard(
                        name: "Vegetable Stir Fry",
                        ingredients:
                            "Vegetables + Rice"
                    )
                }
            }
            .navigationTitle("Recipes")
        }
    }
}

struct RecipeCard: View {
    
    let name: String
    let ingredients: String
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            
            Text(name)
                .font(.headline)
            
            Text(ingredients)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
    }
}
