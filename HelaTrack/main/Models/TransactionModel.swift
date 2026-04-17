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
}
