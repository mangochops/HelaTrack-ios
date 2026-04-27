//
//  SupabaseManager.swift
//  HelaTrack
//
//  Created by mac on 4/21/26.
//

import Foundation
import Supabase

enum APIConfig {
    static var supabaseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? ""
    }
    
    static var supabaseKey: String {
        return Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String ?? ""
    }
}

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Guard against empty strings to prevent the URL(string:) nil crash
        guard let url = URL(string: APIConfig.supabaseURL), !APIConfig.supabaseURL.isEmpty else {
            fatalError("SUPABASE_URL is missing or invalid. Check your XCConfig and Info.plist mapping.")
        }
        
        // Add this options block to bypass the URL parsing crash
        let options = SupabaseClientOptions(
            auth: .init(
                storageKey: "local-dev-key" // This stops the library from trying to split the URL
            ),
            global: .init(
                // Adding a dummy project ID in headers stops the library from
                // trying to extract one from the URL host string.
                headers: ["x-supabase-project-id": "local-dev"]
            )
        )
        
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: APIConfig.supabaseKey,
            options: options // Pass the options here
        )
    }
    
    // 1. Sign in anonymously to get a stable User ID
    func signIn() async throws {
        _ = try await client.auth.signInAnonymously()
    }
    
    /// Clears the session for testing or logout
        func signOut() async throws {
            try await client.auth.signOut()
        }
    
    /// Registers a business to track app impact without storing transactions
    func registerBusiness(name: String, provider: String, identifier: String) async throws {
        
        let session = try await client.auth.session
        let userId = session.user.id
        
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

