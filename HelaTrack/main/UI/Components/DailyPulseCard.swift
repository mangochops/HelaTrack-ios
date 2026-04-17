//
//  DailyPulseCard.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct DailyPulseCard: View {
    let performance: Double
    var onAddCash: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Performance")
                        .font(.caption)
                        .foregroundColor(.primaryBrand)
                    Text("KES \(Int(performance))")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Button(action: onAddCash) {
                    Label("Add Cash", systemImage: "plus")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.05, green: 0.1, blue: 0.2))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
            
            Label("Habit: Record your cash sales every evening to see your true profit.", systemImage: "lightbulb.fill")
                .font(.caption2)
                .foregroundColor(.primaryBrand)
        }
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}


