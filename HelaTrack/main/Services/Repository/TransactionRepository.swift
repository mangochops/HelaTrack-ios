//
//  TransactionRepository.swift
//  HelaTrack
//
//  Created by mac on 4/17/26.
//

import Foundation

class TransactionRepository {
    private let pc = PersistenceController.shared

    func addManualCashSale(amount: Double) {
        let cashRef = "CSH-\(Int(Date().timeIntervalSince1970))"
        let entity = TransactionEntity(
            ref: cashRef,
            amount: amount,
            person: "Cash Sale",
            category: "CASH",
            timestamp: Date(),
            rawMessage: nil
        )
        pc.saveTransaction(entity)
    }

    func getStartOfDay() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
}
