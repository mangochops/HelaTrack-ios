//
//  EODManager.swift
//  HelaTrack
//
//  Created by mac on 4/18/26.
//

import Foundation
import BackgroundTasks
import UserNotifications

class EODManager {
    static let shared = EODManager()
    let taskIdentifier = "com.helatrack.eodsummary"

    // 1. Schedule the task to run (e.g., at 9:00 PM)
    func scheduleEODTask() {
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        
        // Schedule for 9 PM today, or tomorrow if it's already past 9 PM
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 20
        let scheduledDate = Calendar.current.date(from: components) ?? Date()
        
        request.earliestBeginDate = scheduledDate > Date() ? scheduledDate : scheduledDate.addingTimeInterval(86400)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule EOD task: \(error)")
        }
    }

    // 2. The logic that runs in the background
    func handleEODTask(task: BGAppRefreshTask) {
        // Schedule the next one so it repeats daily
        scheduleEODTask()

        task.expirationHandler = {
            // Cleanup if the system kills the task
        }

        // --- CALCULATION LOGIC ---
        // Fetch transactions from your local DB (SwiftData/CoreData)
        // This matches your Android 'getTransactionsAfter(startOfToday)'
        let startOfToday = Calendar.current.startOfDay(for: Date())
        
        // Mocking your DB fetch
        // let transactions = database.fetchTodayTransactions(since: startOfToday)
        let totalIncome: Double = 9300 // Match your current KES 9,300 UI
        let count = 5

        if count > 0 {
            sendNotification(
                title: "Daily Recap",
                message: "You collected KES \(String(format: "%,.0f", totalIncome)) from \(count) transactions today!"
            )
        }

        task.setTaskCompleted(success: true)
    }

    private func sendNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default

        let request = UNNotificationRequest(identifier: "EOD_NOTIFICATION", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
