//
//  LegalView.swift
//  HelaTrack
//
//  Created by mac on 4/19/26.
//

import SwiftUI

// Reusable row for the legal section
struct LegalRow: View {
    let icon: String
    let label: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 24)
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// 1. Settings View
struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("enableNotifications") private var enableNotifications = true

    var body: some View {
        List {
            Section("Preferences") {
                Toggle("Dark Mode", isOn: $isDarkMode)
                Toggle("EOD Notifications", isOn: $enableNotifications)
            }
            Section("App Info") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0").foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

// 2. Terms & Conditions
struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms and Conditions")
                    .font(.title.bold())
                Text("Last updated: April 2026")
                    .font(.caption).foregroundColor(.secondary)
                
                Text("By using HelaTrack, you agree to track your business collections responsibly. This app is a tool for digital and cash collection management...")
                // Add more boilerplate as needed
            }
            .padding()
        }
        .navigationTitle("Terms")
    }
}

// 3. Privacy Policy
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.title.bold())
                
                Text("Your data is stored locally on your device. HelaTrack does not upload your transaction history to external servers unless specifically integrated by you...")
            }
            .padding()
        }
        .navigationTitle("Privacy")
    }
}
