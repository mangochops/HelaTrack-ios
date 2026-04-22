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
    @State private var pdfToShare: PDFShareItem?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<Transaction>
    
    // 1. Calculate digital total (Transactions that are NOT cash)
    private var calculatedDigitalAmount: Double {
        let allTransactions = Array(transactions)
        return allTransactions
            .filter { $0.category != "Cash" }
            .reduce(0) { $0 + $1.amount }
    }

    // 2. Calculate cash total (Transactions explicitly marked as cash)
    private var calculatedCashAmount: Double {
        let allTransactions = Array(transactions)
        return allTransactions
            .filter { $0.category == "Cash" }
            .reduce(0) { $0 + $1.amount }
    }

    // 3. Updated internal total using the new calculated values
    private var internalTotal: Double {
        let sum = calculatedDigitalAmount + calculatedCashAmount
        return sum > 0 ? sum : 1
    }
    
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
                
                // 1. Calculate ratios safely to avoid crashes if total is 0
                let digitalRatio = CGFloat(calculatedDigitalAmount / internalTotal)
                let digitalPercent = Int((calculatedDigitalAmount / internalTotal) * 100)
                let cashPercent = Int((calculatedCashAmount / internalTotal) * 100)
                
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        // Digital Segment
                        Rectangle()
                            .fill(Color.accentColor)
                        // Change this line inside your GeometryReader
                            .frame(width: geo.size.width * digitalRatio)
                        // Cash Segment
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                    }
                }
                .frame(height: 8)
                .cornerRadius(4)
                
                HStack {
                    Text("Digital: \(digitalPercent)%")
                    Spacer()
                    Text("Cash: \(cashPercent)%")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            
            // Expandable Customer List
            if isExpanded {
                Divider()
                customerListSection
                
                // --- NEW: CALL TO ACTION BUTTONS ---
                HStack(spacing: 12) {
                    // Download Report Button
                    Button(action: { generateMonthlyReport() }) {
                        Label("Download Report", systemImage: "arrow.down.doc.fill")
                            .font(.caption.bold())
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Close Button
                    Button(action: { withAnimation { isExpanded = false } }) {
                        Text("Close")
                            .font(.caption.bold())
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.secondary.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 12)
            } else {
                // Toggle Button for collapsed state
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Text("Tap to see top customers")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 8)
            }
        }
        
        
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(20)
        .sheet(item: $pdfToShare) { item in
            ShareSheet(activityItems: [item.data])
        }
    }
    
    private func generateMonthlyReport() {
        let calendar = Calendar.current
        let monthlyData = transactions.filter { tx in
            guard let date = tx.timestamp else { return false }
            
            // This produces "April"
            let txMonth = date.formatted(.dateTime.month(.wide))
            
            // Check if "April Performance" contains "April"
            return monthName.localizedCaseInsensitiveContains(txMonth)
        }

        guard !monthlyData.isEmpty else {
            // Helpful debug: prints what we were looking for vs what we have
            print("No data found. Business Name: '\(monthName)'. Check if transactions exist for this month.")
            return
        }

        let data = PDFManager.createTransactionReport(transactions: Array(monthlyData))

        DispatchQueue.main.async {
            self.pdfToShare = PDFShareItem(data: data)
        }
    }
}

// Sub-views for cleaner body code
extension InsightCard {
    private var headerSection: some View {
        HStack {
            Text(monthName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Label(isIncrease ? "Increase" : "Decrease", systemImage: isIncrease ? "arrow.up" : "arrow.down")
                .font(.caption.bold())
                .foregroundColor(isIncrease ? .green : .red)
        }
    }
    
    private var totalAmountSection: some View {
        Text("KES \(Int(totalAmount))")
            .font(.system(size: 32, weight: .bold))
    }
    
    private var progressBarSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Digital vs Cash Collection")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            let digitalRatio = CGFloat(digitalAmount / internalTotal)
            let digitalPercent = Int((digitalAmount / internalTotal) * 100)
            let cashPercent = Int((cashAmount / internalTotal) * 100)
            
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: geo.size.width * digitalRatio)
                    Rectangle()
                        .fill(Color.secondary.opacity(0.2))
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
            
            HStack {
                Text("Digital: \(digitalPercent)%")
                Spacer()
                Text("Cash: \(cashPercent)%")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
    }
    
    private var customerListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
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
    }
}
