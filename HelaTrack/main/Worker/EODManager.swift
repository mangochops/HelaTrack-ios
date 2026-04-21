//
//  EODManager.swift
//  HelaTrack
//
//  Created by mac on 4/18/26.
//

import Foundation
import BackgroundTasks
import CoreData
import UserNotifications

class EODManager {
    static let shared = EODManager()
    let taskIdentifier = "com.helatrack.eodsummary"

    func scheduleEODTask() {
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 20 // Sets the trigger for 8:00 PM
        components.minute = 0
        
        let scheduledDate = Calendar.current.date(from: components) ?? Date()
        request.earliestBeginDate = scheduledDate > Date() ? scheduledDate : scheduledDate.addingTimeInterval(86400)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule EOD task: \(error)")
        }
    }

    func handleEODTask(task: BGAppRefreshTask) {
        scheduleEODTask()

        task.expirationHandler = { }

        // --- REAL CALCULATION LOGIC ---
        let context = PersistenceController.shared.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        // Predicate to get transactions from 12:00 AM today onwards
        fetchRequest.predicate = NSPredicate(format: "timestamp >= %@", startOfToday as NSDate)

        do {
            let results = try context.fetch(fetchRequest)
            let totalIncome = results.reduce(0.0) { $0 + $1.amount }
            let count = results.count

            if count > 0 {
                sendNotification(
                    title: "Daily Recap",
                    message: "You collected KES \(Int(totalIncome)) from \(count) transactions today!"
                )
            }
        } catch {
            print("Failed to fetch EOD data: \(error)")
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
