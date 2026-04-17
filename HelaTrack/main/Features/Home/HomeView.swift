//
//  HomeView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct HomeView: View {
    // These will eventually come from your UserViewModel
    @State private var todayIncome: Double = 1000
    @State private var totalBalance: Double = 45000
    @State private var showCashDialog = false
    
    // Example Mock Data
    let recentTransactions = [
        TransactionModel(senderName: "WANGUI on", referenceCode: "SJK71234XX", amount: 1000, date: "15 Apr | 15:21", logo: .mpesaLogo, color: .brandsafaricom),
        TransactionModel(senderName: "NJERI on", referenceCode: "RK923456YY", amount: 2500, date: "15 Apr | 14:05", logo: .airtelLogo, color: .brandairtel)
    ]
    
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
                            data: [200, 400, 600, 800, 1200, 1500, 2000],
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
                    ForEach(recentTransactions) { tx in
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

