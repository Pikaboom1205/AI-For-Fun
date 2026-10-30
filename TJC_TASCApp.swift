//
//  TJC_TASCApp.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import SwiftUI
import UserNotifications

@main
struct TJC_TASCApp: App {
    
    @StateObject private var foodManager = FoodManager()
    
    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView2()
                .environmentObject(foodManager)
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            
            if let error = error {
                print("Notification permission error:", error)
            }
            
            print("Notifications enabled:", granted)
        }
    }
}
