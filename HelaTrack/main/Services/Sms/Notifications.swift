//
//  Notifications.swift
//  HelaTrack
//
//  Created by mac on 4/17/26.
//

import UserNotifications

func showNotification(transaction: TransactionEntity) {
    let content = UNMutableNotificationContent()
    content.title = "New \(transaction.category) Transaction"
    
    let amountFormatted = String(format: "%.0f", transaction.amount)
    content.body = "KES \(amountFormatted) received from \(transaction.person)"
    content.sound = .default

    let request = UNNotificationRequest(
        identifier: transaction.ref,
        content: content,
        trigger: nil // Immediate
    )
    UNUserNotificationCenter.current().add(request)
}
