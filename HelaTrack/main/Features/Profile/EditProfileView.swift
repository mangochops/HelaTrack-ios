//
//  EditProfileView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var businessName: String
    @Binding var phoneNumber: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Business Name Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Business Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                
                TextField("", text: $businessName)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.5)))
            }
            
            // Phone Number Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Phone Number")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                
                TextField("", text: $phoneNumber)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.5)))
            }
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Save Changes")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.05, green: 0.1, blue: 0.2))
                    .foregroundColor(.white)
                    .cornerRadius(25) // Pill shape like your screenshot
            }
        }
        .padding(24)
        .navigationTitle("Edit Profile")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}
