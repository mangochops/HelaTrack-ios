//
//  MessageParser.swift
//  HelaTrack
//
//  Created by mac on 4/17/26.
//

import Foundation

struct MessageParser {
    static func parse(sender: String, body: String) -> TransactionEntity? {
        let mpesaPattern = "([A-Z0-9]{10}) Confirmed\\. (?:Ksh|KES) ([\\d,]+\\.\\d{2}) received from (.+?)(?: on|\\.|$)"
        
        if sender.lowercased().contains("mpesa") {
            if let match = body.range(of: mpesaPattern, options: .regularExpression) {
                // Simplified extraction for logic flow
                // In a full implementation, use NSTextCheckingResult to grab groups
                return TransactionEntity(
                    ref: "EXTRACTED_REF",
                    amount: 0.0, // Call cleanAmount helper
                    person: "EXTRACTED_NAME",
                    category: "MPESA",
                    timestamp: Date(),
                    rawMessage: body
                )
            }
        }
        return nil
    }

    private static func cleanAmount(_ amt: String) -> Double {
        let clean = amt.replacingOccurrences(of: ",", with: "")
        return Double(clean) ?? 0.0
    }
}
