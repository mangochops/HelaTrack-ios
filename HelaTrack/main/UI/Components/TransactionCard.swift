//
//  TransactionCard.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: TransactionModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Reusable Icon component
            ZApplyIcon(icon: transaction.logo, color: transaction.color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.senderName)
                    .font(.subheadline.bold())
                Text(transaction.referenceCode)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                // Quick readability: hide decimals for busy SMEs
                Text("KES \(Int(transaction.amount))")
                    .font(.subheadline.bold())
                    .foregroundColor(transaction.color)
                
                Text(transaction.date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        // Adding a subtle shadow to match your Android design
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}
