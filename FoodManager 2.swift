//
//  FoodManager.swift
//  TJC_TASC
//
//  Created by JC on 24/10/26.
//

import Foundation
import Combine
import UserNotifications

class FoodManager: ObservableObject {

    @Published var foods: [FoodItem] = [] {
        didSet {
            saveFoods()
        }
    }

    @Published var points: Int = 0
    @Published var streak: Int = 0

    private let saveKey = "FoodGuardFoods"
    private let pointsKey = "FoodGuardPoints"
    private let streakKey = "FoodGuardStreak"
    private let lastSaveDateKey = "FoodGuardLastSaveDate"

    init() {
        loadFoods()
        loadProgress()
    }

    // MARK: - Food

    func addFood(name: String, expiryDate: Date?) {
        let food = FoodItem(
            name: name,
            expiryDate: expiryDate
        )

        foods.append(food)

        if let expiryDate = expiryDate {
            scheduleNotification(
                for: food,
                expiryDate: expiryDate
            )
        }
    }

    func removeFood(_ food: FoodItem) {
        foods.removeAll {
            $0.id == food.id
        }

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [food.id.uuidString]
            )
    }

    // MARK: - Save Food

    func saveFood(_ food: FoodItem) {

        // Remove the food because it has been used
        foods.removeAll {
            $0.id == food.id
        }

        // Award points
        points += 10

        updateStreak()

        saveProgress()
    }

    private func updateStreak() {

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = UserDefaults.standard.object(
            forKey: lastSaveDateKey
        ) as? Date {

            let lastDay = calendar.startOfDay(
                for: lastDate
            )

            let difference = calendar.dateComponents(
                [.day],
                from: lastDay,
                to: today
            ).day ?? 0

            if difference == 1 {
                // Saved food yesterday → continue streak
                streak += 1

            } else if difference > 1 {
                // Missed a day → restart
                streak = 1
            }

            // Same day → don't increase streak
            else if difference == 0 {
                streak = max(streak, 1)
            }

        } else {
            // First ever saved food
            streak = 1
        }

        UserDefaults.standard.set(
            Date(),
            forKey: lastSaveDateKey
        )
    }

    // MARK: - Level

    var level: Int {
        return (points / 50) + 1
    }

    var pointsToNextLevel: Int {
        let nextLevel = level * 50
        return nextLevel - points
    }

    // MARK: - Saving

    private func saveFoods() {
        if let encoded = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(
                encoded,
                forKey: saveKey
            )
        }
    }

    private func saveProgress() {
        UserDefaults.standard.set(
            points,
            forKey: pointsKey
        )

        UserDefaults.standard.set(
            streak,
            forKey: streakKey
        )
    }

    private func loadFoods() {
        guard let data = UserDefaults.standard.data(
            forKey: saveKey
        ) else {
            return
        }

        guard let decoded = try? JSONDecoder().decode(
            [FoodItem].self,
            from: data
        ) else {
            return
        }

        foods = decoded
    }

    private func loadProgress() {
        points = UserDefaults.standard.integer(
            forKey: pointsKey
        )

        streak = UserDefaults.standard.integer(
            forKey: streakKey
        )
    }

    // MARK: - Notifications

    private func scheduleNotification(
        for food: FoodItem,
        expiryDate: Date
    ) {

        let calendar = Calendar.current

        guard let notificationDate =
                calendar.date(
                    byAdding: .day,
                    value: -2,
                    to: expiryDate
                )
        else {
            return
        }

        guard notificationDate > Date() else {
            return
        }

        let content = UNMutableNotificationContent()

        content.title = "FoodGuard"

        content.body =
            "\(food.name) is expiring soon. Use it before it goes to waste!"

        content.sound = .default

        let components =
            calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: notificationDate
            )

        let trigger =
            UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )

        let request =
            UNNotificationRequest(
                identifier: food.id.uuidString,
                content: content,
                trigger: trigger
            )

        UNUserNotificationCenter.current().add(
            request
        )
    }
}
