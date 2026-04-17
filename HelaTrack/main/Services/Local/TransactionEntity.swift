//
//  TransactionEntity.swift
//  HelaTrack
//
//  Created by mac on 4/17/26.
//

import Foundation

struct TransactionEntity: Identifiable, Codable {
    var id: String { ref }
    let ref: String        // M-Pesa/Bank Ref
    let amount: Double
    let person: String
    let category: String   // "MPESA", "AIRTEL", "BANK", "CASH"
    let timestamp: Date
    let rawMessage: String?
}
