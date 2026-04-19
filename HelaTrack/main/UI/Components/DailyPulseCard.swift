//
//  DailyPulseCard.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct DailyPulseCard: View {
    let cashTotal: Double
    let digitalTotal: Double
    var onAddCash: () -> Void
    
    // logic: Summing totals just like the Kotlin 'totalSales' variable
    private var totalSales: Double {
        cashTotal + digitalTotal
    }
    
    private var hasCash: Bool {
        cashTotal > 0.0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Performance")
                        .font(.caption)
                        .foregroundColor(.primaryBrand)
                    Text(totalSales > 0 ? "KES \(totalSales.formatted(.number.precision(.fractionLength(0))))" : "Ready for today?")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                if !hasCash {
                    // Action Required State
                    Button(action: onAddCash) {
                        Label("Add Cash", systemImage: "plus")
                            .font(.subheadline.bold())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.05, green: 0.1, blue: 0.2)) // Using your theme color
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                } else {
                    // Habit Completed State
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.brandsafaricom)
                }
            }
            
            if !hasCash {
                HStack(alignment: .top) {
                    Image(systemName: "lightbulb.fill")
                    Text("Habit: Record your cash sales every evening to see your true profit.")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}


