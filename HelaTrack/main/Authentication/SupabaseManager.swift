//
//  SupabaseManager.swift
//  HelaTrack
//
//  Created by mac on 4/21/26.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    // Replace with the values provided by 'supabase start' in your terminal
    let client = SupabaseClient(
        supabaseURL: URL(string: "http://172.20.10.3:54321")!,
        supabaseKey: "sb_publishable_ACJWlzQH1ZjBrEguHvfOxg_3BJgxAaH"
    )
    
    private init() {}
    
    // 1. Sign in anonymously to get a stable User ID
    func signIn() async throws {
        try await client.auth.signInAnonymously()
    }
    
    /// Registers a business to track app impact without storing transactions
    func registerBusiness(name: String, provider: String, identifier: String) async throws {
        // Get the current user's UID
        guard let userId = try? await client.auth.session.user.id else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
        }
        
        let registration = BusinessRegistration(
            business_name: name,
            provider_type: provider,
            identifier_hash: identifier, // Use the raw identifier or a stable hash now
            user_id: userId
        )
        
        try await client
            .from("businesses")
            .insert(registration)
            .execute()
    }
    
    // Add this to SupabaseManager.swift
    func fetchBusinessProfile() async throws -> BusinessRegistration? {
        let registrations: [BusinessRegistration] = try await client
            .from("businesses")
            .select()
            .limit(1) // RLS will handle getting the right one
            .execute()
            .value
        return registrations.first
    }
}

// Model matching your Supabase 'businesses' table columns
struct BusinessRegistration: Codable {
    let business_name: String
    let provider_type: String
    let identifier_hash: String
    let user_id: UUID
    
    enum CodingKeys: String, CodingKey {
            case business_name, provider_type, identifier_hash, user_id
        }
}

