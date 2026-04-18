//
//  InsightCard.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct InsightCard: View {
    let monthName: String
        let totalAmount: Double
        let isIncrease: Bool
        let digitalAmount: Double
        let cashAmount: Double
        let topCustomers: [CustomerPaymentSummary]
        
        @State private var isExpanded = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                // Header: Month & Performance
                HStack {
                    Text(monthName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Label(isIncrease ? "Increase" : "Decrease", systemImage: isIncrease ? "arrow.up" : "arrow.down")
                        .font(.caption.bold())
                        .foregroundColor(isIncrease ? .green : .red)
                }
                
                Text("KES \(Int(totalAmount))") // Decimal-free for quick readability
                    .font(.system(size: 32, weight: .bold))
                
                // Progress Bar (Digital vs Cash)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Digital vs Cash Collection")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    GeometryReader { geo in
                        HStack(spacing: 0) {
                            // Digital Segment
                            Rectangle()
                                .fill(Color(red: 0.05, green: 0.1, blue: 0.2))
                            // Change this line inside your GeometryReader
                            .frame(width: totalAmount > 0 ? geo.size.width * CGFloat(digitalAmount / totalAmount) : 0)
                            // Cash Segment
                            Rectangle()
                                .fill(Color.secondary.opacity(0.2))
                        }
                    }
                    .frame(height: 8)
                    .cornerRadius(4)
                    
                    HStack {
                        Text("Digital: \(Int((digitalAmount / totalAmount) * 100))%")
                        Spacer()
                        Text("Cash: \(Int((cashAmount / totalAmount) * 100))%")
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
                
                // Expandable Customer List
                if isExpanded {
                    Divider()
                    Text("Top 3 Customers (This Month)")
                        .font(.caption.bold())
                        .padding(.top, 4)
                    
                    ForEach(Array(topCustomers.enumerated()), id: \.element.id) { index, customer in
                        HStack {
                            Text("#\(index + 1)  \(customer.name)")
                            Spacer()
                            Text("KES \(Int(customer.amount))")
                                .fontWeight(.bold)
                        }
                        .font(.subheadline)
                        .padding(.vertical, 4)
                    }
                }
                
                // Toggle Button
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Text(isExpanded ? "Tap again to collapse" : "Tap to see top customers")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 8)
            }
            .padding()
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(20)
        }
    }
