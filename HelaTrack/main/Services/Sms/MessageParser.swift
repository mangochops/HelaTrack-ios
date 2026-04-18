//
//  MessageParser.swift
//  HelaTrack
//
//  Created by mac on 4/17/26.
//

import Foundation

struct MessageParser {
    // Regex Patterns (Mirrored from Kotlin version)
    private static let mpesaReceivedPattern = "([A-Z0-9]{10})\\sConfirmed\\.\\s(?:Ksh|KES)\\s?([\\d,]+\\.\\d{2})\\sreceived\\sfrom\\s(.+?)(?=\\son|\\.|$)"
    private static let mpesaMerchantPattern = "([A-Z0-9]{10})\\sConfirmed\\.\\s(?:Ksh|KES)\\s?([\\d,]+\\.\\d{2})\\spaid\\sto\\s(.+?)(?:\\son|\\.|$)"
    private static let airtelPattern = "ID:\\s?(\\w+).*?Amount:\\s(?:Ksh|KES)\\s?([\\d,]+\\.\\d{2})\\sfrom\\s(.+?)(?:\\son|$)"
    private static let bankPattern = "(?:Ksh|KES)\\s?([\\d,]+\\.\\d{2})\\sby\\s(.+?)(?:\\son|\\.|$)"

    static func parse(sender: String, body: String) -> TransactionEntity? {
        let senderLower = sender.lowercased()
        
        if senderLower.contains("mpesa") {
            return extract(from: body, pattern: mpesaReceivedPattern, category: "MPESA") ??
                   extract(from: body, pattern: mpesaMerchantPattern, category: "MPESA")
        } else if senderLower.contains("airtel") {
            return extract(from: body, pattern: airtelPattern, category: "AIRTEL")
        } else if senderLower.range(of: ".*(equity|familybank|247247|222111|400000).*", options: .regularExpression) != nil {
            return extractBank(from: body, sender: sender)
        }
        
        return nil
    }

    private static func extract(from body: String, pattern: String, category: String) -> TransactionEntity? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else { return nil }
        let nsString = body as NSString
        let results = regex.matches(in: body, range: NSRange(location: 0, length: nsString.length))

        // This uses the results, resolving the "defined but never used" warning
        guard let match = results.first, match.numberOfRanges >= 4 else { return nil }

        let ref = nsString.substring(with: match.range(at: 1))
        let amt = nsString.substring(with: match.range(at: 2))
        let name = nsString.substring(with: match.range(at: 3)).trimmingCharacters(in: .whitespaces)

        return TransactionEntity(
            ref: ref,
            amount: cleanAmount(amt),
            person: name,
            category: category,
            timestamp: Date(),
            rawMessage: body
        )
    }

    private static func extractBank(from body: String, sender: String) -> TransactionEntity? {
        guard let regex = try? NSRegularExpression(pattern: bankPattern, options: .caseInsensitive) else { return nil }
        let nsString = body as NSString
        let results = regex.matches(in: body, range: NSRange(location: 0, length: nsString.length))

        guard let match = results.first, match.numberOfRanges >= 3 else { return nil }

        let amt = nsString.substring(with: match.range(at: 1))
        let name = nsString.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespaces)
        
        let prefix = (sender.contains("Equity") || sender.contains("247247")) ? "EQ-BNK-" : "BNK-"

        return TransactionEntity(
            ref: "\(prefix)\(Int(Date().timeIntervalSince1970))",
            amount: cleanAmount(amt),
            person: String(name.prefix(25)), // Matches safety truncate from Kotlin
            category: "BANK",
            timestamp: Date(),
            rawMessage: body
        )
    }

    private static func cleanAmount(_ amt: String) -> Double {
        let clean = amt.replacingOccurrences(of: ",", with: "")
        return Double(clean) ?? 0.0
    }
}
