//
//  TransactionModel.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct TransactionModel: Identifiable {
    let id = UUID()
        let senderName: String
        let referenceCode: String // e.g., SJK71234XX
        let amount: Double
        let date: String // e.g., "15 Apr | 15:21"
        let logo: Image
        let color: Color
}

enum TimeFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    
    func startDate() -> Date? {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .all:
            return nil
        case .today:
            return calendar.startOfDay(for: now)
        case .week:
            return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))
        case .month:
            return calendar.date(from: calendar.dateComponents([.year, .month], from: now))
        }
    }
}
