//
//  PaymentSelectionPage.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct PaymentSelectionPage: View {
    @Binding var selectedMethod: PaymentProvider?
    let onNext: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Payment Source")
                .font(.title2.bold())
            Text("Which service do you use for your SME payments?")
                .foregroundColor(.secondary)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(PaymentMethods.providers) { (provider: PaymentProvider) in
                        Button(action: {
                            selectedMethod = provider
                            onNext()
                        }) {
                            HStack(spacing: 16) {
                                ZApplyIcon(icon: provider.logo, color: provider.brandColor)
                                Text(provider.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .frame(height: 72)
                            .background(RoundedRectangle(cornerRadius: 16)
                                .stroke(provider.brandColor.opacity(0.5), lineWidth: 1.5))
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(24)
    }
}


