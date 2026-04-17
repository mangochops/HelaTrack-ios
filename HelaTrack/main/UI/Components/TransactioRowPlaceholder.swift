//
//  TransactioRowPlaceholder.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct TransactionRowPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<3) { _ in
                HStack {
                    ZApplyIcon(icon: .mpesaLogo, color: .brandsafaricom)
                    VStack(alignment: .leading) {
                        Text("WANGUI on")
                            .font(.subheadline.bold())
                        Text("SJK71234XX")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("KES 1000") // Quick readability for busy SMEs
                            .font(.subheadline.bold())
                            .foregroundColor(.brandsafaricom)
                        Text("15 Apr | 15:21")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
            }
        }
    }
}
