//
//  CredentialsPage.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct CredentialsPage: View {
    let provider: PaymentProvider
    @Binding var businessName: String
    @Binding var identifier: String
    let onFinish: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Link \(provider.name)")
                .font(.title.bold())
            
            TextField("Business Name", text: $businessName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top)
            
            TextField(provider.identifierLabel, text: $identifier)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            Spacer()
            
            Button(action: onFinish) {
                Text("Start Tracking Payments")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(businessName.isEmpty || identifier.isEmpty ?
                                provider.brandColor.opacity(0.3) : provider.brandColor)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .cornerRadius(12)
            }
            .disabled(businessName.isEmpty || identifier.isEmpty)
        }
        .padding(24)
    }
}


