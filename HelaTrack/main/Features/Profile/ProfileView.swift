//
//  ProfileView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

enum PaymentMethod: String {
    case mpesa = "M-Pesa"
    case mpesaTill = "M-Pesa Till"
    case mpesaPaybill = "M-Pesa Paybill"
    case airtel = "Airtel Money"
    case equity = "Equity Bank"
    case family = "Family Bank"
    case ncba = "NCBA Bank"
    case absa = "ABSA Bank"
    
    var brandColor: Color {
        switch self {
        case .mpesa: return .brandsafaricom
        case .mpesaTill: return .brandsafaricom
        case .mpesaPaybill: return .brandsafaricom
        case .airtel: return .brandairtel
        case .equity: return .brandequity
        case .family: return .brandfamilyBank
        case .ncba: return .brandncba
        case .absa: return .brandabsa
        }
    }
}

struct ProfileView: View {
    // These would typically come from a ViewModel in your production code
    @State var businessName: String = "Loading..."
    @State var identifierHash: String = "..."
    @State var selectedMethod: PaymentMethod = .mpesa
    @State private var isLoading = true
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    ProgressView("Fetching your profile...")
                        .padding(.top, 50)
                } else {
                    VStack(spacing: 0) {
                        // --- HEADER ---
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundStyle(selectedMethod.brandColor) // Using your brand colors
                                    .frame(width: 80, height: 80)
                                
                                Text(businessName.prefix(1).uppercased())
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .drawingGroup()
                            
                            Text(businessName)
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                                .padding(.top, 12)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .background(selectedMethod.brandColor.opacity(0.1))
                        
                        // --- IDENTITY SECTION ---
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Identity")
                                .font(.caption.bold())
                                .foregroundColor(.brandsafaricom)
                                .padding(.top, 24)
                            
                            ProfileItem(icon: "storefront.fill", label: "Business Name", value: businessName)
                            ProfileItem(icon: "phone.fill", label: "Identifier", value: formatIdentifier(identifierHash))
                            
                            Spacer(minLength: 32)
                            
                            // --- NEW: SUPPORT & LEGAL SECTION ---
                            Text("Support & Legal")
                                .font(.caption.bold())
                                .foregroundColor(.brandsafaricom)
                                .padding(.top, 16)
                            
                            NavigationLink(destination: SettingsView()) {
                                LegalRow(icon: "gearshape.fill", label: "App Settings")
                            }
                            
                            NavigationLink(destination: TermsView()) {
                                LegalRow(icon: "doc.text.fill", label: "Terms & Conditions")
                            }
                            
                            NavigationLink(destination: PrivacyPolicyView()) {
                                LegalRow(icon: "lock.shield.fill", label: "Privacy Policy")
                            }
                            
                            Spacer(minLength: 32)
                            // --- ACTIONS ---
                            NavigationLink(destination: EditProfileView(businessName: $businessName, phoneNumber: $identifierHash)) {
                                Label("Edit Business Profile", systemImage: "pencil")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(colorScheme == .dark ? Color.accentColor : Color(red: 0.05, green: 0.1, blue: 0.2)) // Your dark brand color
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: { logout() }) {
                                Label("Logout & Reset", systemImage: "rectangle.portrait.and.arrow.right")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.red)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.red, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }}
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
            .task {
                // This is the trigger you were missing!
                await loadProfileData()
            }
        }
    }
    private func loadProfileData() async {
        print("🚀 Fetching profile for the authenticated user...")
        do {
            // No need to pass a phone number anymore!
            // Supabase Auth handles the identity.
            if let profile = try await SupabaseManager.shared.fetchBusinessProfile() {
                print("✅ Correct Profile received: \(profile.business_name)")
                await MainActor.run {
                    self.businessName = profile.business_name
                    self.identifierHash = profile.identifier_hash
                    
                    if let method = PaymentMethod(rawValue: profile.provider_type) {
                        self.selectedMethod = method
                    }
                    self.isLoading = false
                }
            } else {
                print("❓ No profile found. User might need to complete registration.")
                await MainActor.run { self.isLoading = false }
            }
        } catch {
            print("❌ Supabase Error: \(error)")
            await MainActor.run { self.isLoading = false }
        }
    }
    
    private func logout() {
        Task {
            try? await SupabaseManager.shared.client.auth.signOut()
            // Reset local UI or navigate back to Onboarding
            await MainActor.run {
                self.businessName = "Guest"
                self.isLoading = true
            }
        }
    }
    
    private func formatIdentifier(_ raw: String) -> String {
        // Remove the negative sign if present
        let clean = raw.replacingOccurrences(of: "-", with: "")
        
        // If it's a long hash, show a cleaner version
        if clean.count > 10 {
            return "ID: " + clean.prefix(10)
        }
        return clean.isEmpty ? "..." : clean
    }
    
    // Sub-component for Row Items
    struct ProfileItem: View {
        let icon: String
        let label: String
        let value: String
        
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
            }
        }
    }
}
