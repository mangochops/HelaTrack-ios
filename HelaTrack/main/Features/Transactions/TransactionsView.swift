//
//  TransactionsView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct TransactionsView: View {
    @State private var searchQuery = ""
    @State private var selectedFilter: TimeFilter = .all
    
    // Mock data for UI development
    let recenttransactions = [
        TransactionModel(senderName: "Villa Rosa on", referenceCode: "SJK71234XX", amount: 1300, date: "15 Apr | 18:08", logo: .mpesaLogo, color: .brandsafaricom)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 16) {
                    // --- SEARCH & FILTERS ---
                    VStack(spacing: 12) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search by name or reference...", text: $searchQuery)
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Horizontal Filter Chips (LazyRow equivalent)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(TimeFilter.allCases, id: \.self) { filter in
                                    FilterChip(
                                        label: filter.rawValue,
                                        isSelected: selectedFilter == filter
                                    ) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // --- TRANSACTION LIST ---
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(recenttransactions) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // --- FLOATING ACTION BUTTON ---
                Button(action: { /* PDF Export Logic */ }) {
                    Label("Export PDF", systemImage: "doc.plaintext.fill")
                        .font(.subheadline.bold())
                        .padding()
                        .background(Color(red: 0.05, green: 0.1, blue: 0.2)) // Dark brand color
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                }
                .padding(24)
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.secondary.opacity(0.05).ignoresSafeArea())
        }
    }
}
