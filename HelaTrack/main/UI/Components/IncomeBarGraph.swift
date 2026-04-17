//
//  IncomeBarGraph.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct IncomeBarGraph: View {
    let data: [Double] // Revenue values
    let days: [String] // ["T", "F", "S", "S", "M", "T", "W"]
    
    // Set a max height for the bars
    let maxHeight: CGFloat = 150
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Money-In")
                .font(.caption)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.primary)
            
            HStack(alignment: .bottom, spacing: 40) {
                ForEach(0..<data.count, id: \.self) { index in
                    VStack(spacing: 8) {
                        // The Bar
                        ZStack(alignment: .bottom) {
                            // Background Track
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.accentColor.opacity(0.1))
                                .frame(width: 12, height: maxHeight)
                            
                            // Progress Fill (Money-In)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(red: 0.05, green: 0.1, blue: 0.2)) // Dark theme from UI
                                .frame(width: 12, height: calculateHeight(value: data[index]))
                        }
                        
                        // Day Label
                        Text(days[index])
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
        .background(Color.white)
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
            data: [300, 500, 1200, 900, 1800, 2500, 1000],
            days: ["T", "F", "S", "S", "M", "T", "W"]
        )
        .padding()
    }
}
