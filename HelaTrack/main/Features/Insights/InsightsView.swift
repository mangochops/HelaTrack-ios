//
//  InsightsView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct InsightsView: View {
    @State private var showCashDialog = false
    
    // Mock Data for UI alignment
    let mockCustomers = [
        CustomerPaymentSummary(name: "Villa Rosa on", amount: 1300)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 16) {
                        InsightCard(
                            monthName: "April Performance",
                            totalAmount: 1300,
                            isIncrease: true,
                            digitalAmount: 1300,
                            cashAmount: 0,
                            topCustomers: mockCustomers
                        )
                    }
                    .padding()
                }
                
                // Floating Action Button
                Button(action: { showCashDialog = true }) {
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
            .background(Color.white.ignoresSafeArea())
        }
        .sheet(isPresented: $showCashDialog) {
            Text("Add Cash Dialog Placeholder") // Replace with actual dialog
        }
    }
}
