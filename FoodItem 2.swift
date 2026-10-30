//
//  FoodItem.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import Foundation

struct FoodItem: Identifiable, Codable {
    
    var id = UUID()
    var name: String
    var expiryDate: Date?
    
    var daysRemaining: Int? {
        guard let expiryDate = expiryDate else {
            return nil
        }
        
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: Date())
        let expiry = calendar.startOfDay(for: expiryDate)
        
        return calendar.dateComponents(
            [.day],
            from: today,
            to: expiry
        ).day
    }
    
    var status: String {
        guard let days = daysRemaining else {
            return "Expiry unknown"
        }
        
        if days < 0 {
            return "Expired"
        } else if days <= 2 {
            return "Expiring soon"
        } else {
            return "Fresh"
        }
    }
}
