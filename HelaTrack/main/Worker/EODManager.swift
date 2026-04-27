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
        // Change to BGProcessingTaskRequest for better reliability on real hardware
        let request = BGProcessingTaskRequest(identifier: taskIdentifier)
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false // Set to true if you only want it to run while charging
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 20
        components.minute = 0
        
        let scheduledDate = Calendar.current.date(from: components) ?? Date()
        request.earliestBeginDate = scheduledDate > Date() ? scheduledDate : scheduledDate.addingTimeInterval(86400)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ EOD Task Scheduled successfully!")
        } catch {
            print("❌ Could not schedule EOD task: \(error)")
        }
    }

    func handleEODTask(task: BGAppRefreshTask) {
        // 1. Immediately schedule the next one
        scheduleEODTask()

        // 2. Add a direct print to confirm the task started
        print("DEBUG: handleEODTask execution started")

        task.expirationHandler = {
            print("DEBUG: Task expired by system")
        }

        // 3. Bypass the fetch logic temporarily to see if the notification works
        self.sendNotification(title: "Test", message: "If you see this, the BG Task is working!")

        task.setTaskCompleted(success: true)
    }

    private func sendNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        
        // FIX 2: Explicitly set a non-nil trigger or keep nil for immediate delivery
        let request = UNNotificationRequest(identifier: "EOD_NOTIFICATION", content: content, trigger: nil)
        
        // FIX 3: Ensure notification registration happens on the main thread
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Notification Error: \(error.localizedDescription)")
                } else {
                    print("🚀 Notification successfully pushed to system!")
                }
            }
        }
    }
}
