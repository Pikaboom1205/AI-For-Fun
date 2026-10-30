//
//  HomeView.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var foodManager: FoodManager
    
    var expiringFoods: [FoodItem] {
        foodManager.foods.filter { food in
            
            guard let days = food.daysRemaining else {
                return false
            }
            
            return days >= 0 && days <= 3
        }
    }
    
    var unknownFoods: [FoodItem] {
        foodManager.foods.filter {
            $0.expiryDate == nil
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {
                    
                    Text("FoodGuard")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Save food. Earn points. Build your streak.")
                        .foregroundStyle(.secondary)
                    
                    // MARK: Points
                    
                    HStack {
                        
                        VStack(
                            alignment: .leading,
                            spacing: 5
                        ) {
                            
                            Text("POINTS")
                                .font(.caption)
                                .bold()
                            
                            Text("\(foodManager.points)")
                                .font(.system(
                                    size: 36,
                                    weight: .bold
                                ))
                            
                            Text(
                                "\(foodManager.pointsToNextLevel) points to Level \(foodManager.level + 1)"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 45))
                    }
                    .padding()
                    .background(.green.opacity(0.15))
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
                    
                    // MARK: Streak
                    
                    HStack {
                        
                        Image(systemName: "flame.fill")
                            .font(.system(size: 35))
                        
                        VStack(
                            alignment: .leading
                        ) {
                            
                            Text(
                                "\(foodManager.streak) day streak"
                            )
                            .font(.title2)
                            .bold()
                            
                            Text(
                                "Keep saving food to maintain your streak!"
                            )
                            .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(.orange.opacity(0.15))
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
                    
                    // MARK: Expiring Food
                    
                    HStack {
                        
                        Image(
                            systemName:
                                "exclamationmark.triangle.fill"
                        )
                        
                        VStack(
                            alignment: .leading
                        ) {
                            
                            Text(
                                "\(expiringFoods.count) items"
                            )
                            .font(.headline)
                            
                            Text(
                                "need your attention"
                            )
                            .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(.orange.opacity(0.15))
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15
                        )
                    )
                    
                    if !expiringFoods.isEmpty {
                        
                        Text("USE THESE SOON")
                            .font(.caption)
                            .bold()
                        
                        ForEach(expiringFoods) { food in
                            
                            FoodRow(food: food)
                        }
                    }
                    
                    // MARK: Unknown expiry
                    
                    if !unknownFoods.isEmpty {
                        
                        Text("NEEDS ATTENTION")
                            .font(.caption)
                            .bold()
                        
                        ForEach(unknownFoods) { food in
                            
                            FoodRow(food: food)
                        }
                    }
                    
                    if expiringFoods.isEmpty &&
                        unknownFoods.isEmpty {
                        
                        VStack(spacing: 10) {
                            
                            Image(
                                systemName:
                                    "checkmark.circle.fill"
                            )
                            .font(.largeTitle)
                            
                            Text("You're all good!")
                                .font(.headline)
                            
                            Text(
                                "No food needs your attention right now."
                            )
                            .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}
