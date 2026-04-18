//
//  InsightsView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct InsightsView: View {
    @State private var showingAddCashSheet = false
    
    // Fetch transactions for the current month
        @FetchRequest(
            entity: Transaction.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.timestamp, ascending: false)],
            animation: .default
        )
        private var allTransactions: FetchedResults<Transaction>

        // --- Computed Properties for Live Data ---

        var currentMonthTransactions: [Transaction] {
            let calendar = Calendar.current
            return allTransactions.filter { tx in
                guard let date = tx.timestamp else { return false }
                return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
            }
        }

    var monthlyDigitalTotal: Double {
            currentMonthTransactions
                .filter { ($0.category ?? "") != "Cash" }
                .reduce(0) { $0 + $1.amount }
        }

        var monthlyCashTotal: Double {
            currentMonthTransactions
                .filter { ($0.category ?? "") == "Cash" }
                .reduce(0) { $0 + $1.amount }
        }

        var monthlyGrandTotal: Double {
            monthlyDigitalTotal + monthlyCashTotal
        }

        var topCustomers: [CustomerPaymentSummary] {
            let grouped = Dictionary(grouping: currentMonthTransactions) { $0.person ?? "Cash Sale" }
            return grouped.map { name, txs in
                CustomerPaymentSummary(name: name, amount: txs.reduce(0) { $0 + $1.amount })
            }
            .sorted { $0.amount > $1.amount }
            .prefix(3).map { $0 }
        }
        
        var currentMonthName: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            return formatter.string(from: Date())
        }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 16) {
                        InsightCard(
                            monthName: "\(currentMonthName) Performance",
                            totalAmount: monthlyGrandTotal,
                            isIncrease: true,
                            digitalAmount: 1300,
                            cashAmount: 0,
                            topCustomers: topCustomers
                        )
                    }
                    .padding()
                }
                
                // Floating Action Button
                Button(action: { showingAddCashSheet = true }) {
                    Label("Add Cash Sale", systemImage: "plus")
                        .font(.subheadline.bold())
                        .padding()
                        .background(Color(red: 0.05, green: 0.1, blue: 0.2))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                }
                .padding(24)
            }
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
        }
        .sheet(isPresented: $showingAddCashSheet) {
            AddCashTransactionView()
        }
    }
}
