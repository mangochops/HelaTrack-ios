//
//  HomeView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showingAddCashSheet = false
    
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
    
    var todayCashIncome: Double {
        let calendar = Calendar.current
        return allTransactions
            .filter { tx in
                guard let date = tx.timestamp else { return false }
                // Check if it's today AND if it's marked as a "Cash" transaction
                let transactionKind = tx.category ?? ""
                return calendar.isDateInToday(date) && tx.category == "Cash"
            }
            .reduce(0) { $0 + $1.amount }
    }

    // Filter for Today's Digital (MPESA/Bank) Transactions
    var todayDigitalIncome: Double {
        let calendar = Calendar.current
        return allTransactions
            .filter { tx in
                guard let date = tx.timestamp else { return false }
                // Check if it's today AND NOT a cash transaction
                let transactionKind = tx.category ?? ""
                return calendar.isDateInToday(date) && tx.category != "Cash"
            }
            .reduce(0) { $0 + $1.amount }
    }

        // 2. Calculate Today's Income (Sum of amounts where date is today)
    var todayIncome: Double {
        todayCashIncome + todayDigitalIncome
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    OverviewTabs(todayIncome: todayIncome, totalBalance: totalBalance)
                    
                    // Daily Pulse Section
                    DailyPulseCard(cashTotal: todayCashIncome,
                                   digitalTotal: todayDigitalIncome) {
                        showingAddCashSheet = true
                    }
                    
                    // Weekly Money-In Placeholder
                    VStack(alignment: .leading) {
                        
                        IncomeBarGraph(
                            data: [200, 400, 600, 800, 1200, 1500, todayIncome]
                        )
                    }
                    
                    // Latest Transactions Header
                    HStack {
                        Text("Latest Transactions")
                            .font(.caption)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        
                        NavigationLink(destination: TransactionsView()) {
                            Text("View all")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
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
        .refreshable {
            // Trigger any background sync check here
            print("Home View Dashboard updated")
            try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
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
            .sheet(isPresented: $showingAddCashSheet) {
                AddCashTransactionView()
            }
        }
        
    }

