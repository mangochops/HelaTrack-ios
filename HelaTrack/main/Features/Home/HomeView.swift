//
//  HomeView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showCashDialog = false
    
    @FetchRequest(
            entity: Transaction.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.timestamp, ascending: false)],
            predicate: nil,
            animation: .default
        )
    private var allTransactions: FetchedResults<Transaction>

        // 1. Calculate Total Balance (Sum of all transaction amounts)
        var totalBalance: Double {
            allTransactions.reduce(0) { $0 + $1.amount }
        }

        // 2. Calculate Today's Income (Sum of amounts where date is today)
        var todayIncome: Double {
            let calendar = Calendar.current
            return allTransactions
                .filter { transaction in
                    guard let date = transaction.timestamp else { return false }
                    return calendar.isDateInToday(date)
                }
                .reduce(0) { $0 + $1.amount }
        }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    OverviewTabs(todayIncome: todayIncome, totalBalance: totalBalance)
                    
                    // Daily Pulse Section
                    DailyPulseCard(performance: todayIncome) {
                        showCashDialog = true
                    }
                    
                    // Weekly Money-In Placeholder
                    VStack(alignment: .leading) {
                        
                        IncomeBarGraph(
                            data: [200, 400, 600, 800, 1200, 1500, todayIncome],
                            days: ["T", "F", "S", "S", "M", "T", "W"]
                        )
                    }
                    
                    // Latest Transactions Header
                    HStack {
                        Text("Latest Transactions")
                            .font(.caption)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Button("View all") { /* Navigate to Transactions */ }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Transaction Cards
                    // Replace with a ForEach when we have the Transaction model
                    ForEach(Array(allTransactions.prefix(5)),id: \.self) { tx in
                            TransactionRow(transaction: tx)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("HelaTrack")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryBrand)
                }
            }
            .background(Color.secondary.opacity(0.05).ignoresSafeArea())
        }
//        .sheet(isPresented: $showCashDialog) {
//            // Add Cash View/Dialog will go here
//            Text("Add Cash Dialog Placeholder")
//        }
    }

