//
//  ContentView.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import SwiftUI

struct ContentView2: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            InventoryView()
                .tabItem {
                    Label("Food", systemImage: "refrigerator")
                }

            RecipesView()
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }
        }
    }
}
