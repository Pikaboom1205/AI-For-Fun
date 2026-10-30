//
//  FoodRow.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import SwiftUI

struct FoodRow: View {
    
    let food: FoodItem
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            Image(systemName: "fork.knife")
                .font(.title2)
                .frame(
                    width: 45,
                    height: 45
                )
                .background(
                    .gray.opacity(0.15)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 10
                    )
                )
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(food.name)
                    .font(.headline)
                
                if let days = food.daysRemaining {
                    
                    if days < 0 {
                        
                        Text("Expired")
                            .foregroundStyle(.red)
                        
                    } else if days == 0 {
                        
                        Text("Expires today")
                            .foregroundStyle(.red)
                        
                    } else {
                        
                        Text("\(days) days remaining")
                            .foregroundStyle(
                                days <= 2
                                ? .orange
                                : .green
                            )
                    }
                    
                } else {
                    
                    Text("Expiry unknown")
                        .foregroundStyle(.orange)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            .gray.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 15
            )
        )
    }
}
