//
//  TransactionCard.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    // 1. Computed property to pick the logo based on category
        var logo: Image {
            switch transaction.category?.uppercased() {
            case "MPESA": return .mpesaLogo
            case "AIRTEL": return .airtelLogo
            case "ABSA": return .absaLogo
            case "EQUITY": return .equityLogo
            case "FAMILY BANK": return .familyBankLogo
            case "NCBA": return .ncbaLogo
            default: return Image(systemName: "banknote") // Fallback for Bank
            }
        }
        
        // 2. Computed property to pick the brand color
        var brandColor: Color {
            switch transaction.category?.uppercased() {
            case "MPESA": return .brandsafaricom
            case "AIRTEL": return .brandairtel
            case "ABSA": return .brandabsa
            case "EQUITY": return .brandequity
            case "FAMILY BANK": return .brandfamilyBank
            case "NCBA": return .brandncba
            default: return Color.primaryBrand // Your dark brand color for Banks
            }
        }
    
    var body: some View {
        HStack(spacing: 12) {
            // Reusable Icon component
            ZApplyIcon(icon: logo, color: brandColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.person ?? "Unknown")
                    .font(.subheadline.bold())
                Text(transaction.ref ?? "No Reference")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                // Quick readability: hide decimals for busy SMEs
                Text("KES \(Int(transaction.amount))")
                    .font(.subheadline.bold())
                    .foregroundColor(brandColor)
                
                Text(transaction.timestamp?.formatted(.dateTime.day().month().hour().minute()) ?? "")
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
