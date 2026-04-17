//
//  OverviewTabs.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct OverviewTabs: View {
    let todayIncome: Double
    let totalBalance: Double
    @State private var isBalanceHidden = true
    
    var body: some View {
        HStack(spacing: 12) {
            // Today's Income Card
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Income")
                    .font(.caption)
                    .fontWeight(.medium)
                Text("KES \(Int(todayIncome))")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.05, green: 0.1, blue: 0.2)) // Dark theme from your UI
            .foregroundColor(.white)
            .cornerRadius(12)
            
            // Total Balance Card
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Total Balance")
                        .font(.caption)
                    Spacer()
                    Button(action: { isBalanceHidden.toggle() }) {
                        Image(systemName: isBalanceHidden ? "eye.slash" : "eye")
                            .font(.caption)
                    }
                }
                Text(isBalanceHidden ? "KES ••••••" : "KES \(Int(totalBalance))")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(12)
        }
    }
}
