//
//  InventoryView.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import SwiftUI

struct InventoryView: View {

    @EnvironmentObject var foodManager: FoodManager

    @State private var showingAddFood = false

    var body: some View {

        NavigationStack {

            List {

                if foodManager.foods.isEmpty {

                    ContentUnavailableView(
                        "No Food Yet",
                        systemImage: "refrigerator",
                        description: Text(
                            "Add food to start tracking your inventory."
                        )
                    )

                } else {

                    ForEach(foodManager.foods) { food in

                        VStack(spacing: 10) {

                            FoodRow(food: food)

                            Button {
                                foodManager.saveFood(food)
                            } label: {
                                Label(
                                    "I Used This Food",
                                    systemImage: "checkmark.circle.fill"
                                )
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete { indexSet in
                        
                        for index in indexSet {

                            let food =
                                foodManager.foods[index]

                            foodManager.removeFood(food)
                        }
                    }
                }
            }

            .navigationTitle("My Food")

            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {
                        showingAddFood = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }

            .sheet(isPresented: $showingAddFood) {

                AddFoodView()
                    .environmentObject(foodManager)
            }
        }
    }
}
