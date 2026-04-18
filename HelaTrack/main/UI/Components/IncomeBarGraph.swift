//
//  IncomeBarGraph.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct IncomeBarGraph: View {
    let data: [Double] // Revenue values
    let maxHeight: CGFloat = 150
    
    @Environment(\.colorScheme) var colorScheme
    
    // --- Dynamic Days Calculation ---
        var dynamicDays: [String] {
            let calendar = Calendar.current
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEEE" // Returns a single letter (T, F, S, S, M, T, W)
            
            return (0..<7).reversed().compactMap { dayOffset in
                if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                    return formatter.string(from: date)
                }
                return nil
            }
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Money-In")
                .font(.caption)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.primary)
            
            HStack(alignment: .bottom, spacing: 36) {
                ForEach(0..<data.count, id: \.self) { index in
                    VStack(spacing: 8) {
                        // The Bar
                        ZStack(alignment: .bottom) {
                            // Background Track
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(UIColor.tertiarySystemFill))
                                .frame(width: 12, height: maxHeight)
                            
                            // Progress Fill (Money-In)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(colorScheme == .dark ? Color.accentColor : Color(red: 0.05, green: 0.1, blue: 0.2)) // Dark theme from UI
                                .frame(width: 12, height: calculateHeight(value: data[index]))
                        }
                        
                        // Day Label
                        Text(dynamicDays[index])
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    // Logic to scale the bar height based on revenue
    private func calculateHeight(value: Double) -> CGFloat {
        let maxDataValue = data.max() ?? 1.0
        return CGFloat(value / maxDataValue) * maxHeight
    }
}
#Preview {
    ZStack {
        Color.secondary.opacity(0.05).ignoresSafeArea()
        
        IncomeBarGraph(
            data: [300, 500, 1200, 900, 1800, 2500, 1000]
        )
        .padding()
    }
}
