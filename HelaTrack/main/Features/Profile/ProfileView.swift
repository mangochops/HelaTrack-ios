//
//  ProfileView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

enum PaymentMethod: String {
    case mpesa = "M-PESA"
    case airtel = "Airtel Money"
    case equity = "Equity Bank"
    case family = "Family Bank"
    case ncba = "NCBA"
    case absa = "ABSA"
    
    var brandColor: Color {
        switch self {
        case .mpesa: return .brandsafaricom
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
    @State var businessName: String = "Tinga"
    @State var phoneNumber: String = "012345678"
    @State var selectedMethod: PaymentMethod = .mpesa
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                        ProfileItem(icon: "phone.fill", label: "Phone Number", value: phoneNumber)
                        
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
                        NavigationLink(destination: EditProfileView(businessName: $businessName, phoneNumber: $phoneNumber)) {
                            Label("Edit Business Profile", systemImage: "pencil")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(colorScheme == .dark ? Color.accentColor : Color(red: 0.05, green: 0.1, blue: 0.2)) // Your dark brand color
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        Button(action: { /* Logout Logic */ }) {
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
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
        }
    }
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
            }
        }
    }
}
