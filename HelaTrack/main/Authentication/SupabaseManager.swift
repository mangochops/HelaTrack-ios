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
    
    /// Registers a business to track app impact without storing transactions
    func registerBusiness(name: String, provider: String, identifier: String) async throws {
        let registration = BusinessRegistration(
            business_name: name,
            provider_type: provider,
            // We hash the identifier to maintain user privacy
            identifier_hash: String(identifier.hashValue)
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
            .limit(1)
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
    
    enum CodingKeys: String, CodingKey {
            case business_name, provider_type, identifier_hash
        }
}

