//
//  ZApplyIcon.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI


struct ZApplyIcon: View {
    let icon: Image // This now correctly matches your Icons.swift extension
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 44, height: 44)
            
            icon // Use the Image object directly
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(color)
        }
    }
}
