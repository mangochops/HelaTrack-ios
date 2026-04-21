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
    
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
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
            
            Button(action: performRegistration) {
                            HStack {
                                if isSubmitting {
                                    ProgressView()
                                        .tint(Color(UIColor.systemBackground))
                                        .padding(.trailing, 8)
                                }
                                Text(isSubmitting ? "Linking..." : "Start Tracking Payments")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(businessName.isEmpty || identifier.isEmpty || isSubmitting ?
                                        provider.brandColor.opacity(0.3) : provider.brandColor)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .cornerRadius(12)
                        }
            .disabled(businessName.isEmpty || identifier.isEmpty || isSubmitting)
        }
        .padding(24)
    }
    private func performRegistration() {
            isSubmitting = true
            errorMessage = nil
            
            Task {
                do {
                    try await SupabaseManager.shared.registerBusiness(
                        name: businessName,
                        provider: provider.name,
                        identifier: identifier
                    )
                    await MainActor.run {
                        isSubmitting = false
                        onFinish()
                    }
                } catch {
                    await MainActor.run {
                        isSubmitting = false
                        errorMessage = "Connection failed. Check if Supabase is running."
                        print("Registration Error: \(error)")
                    }
                }
            }
        }
}


