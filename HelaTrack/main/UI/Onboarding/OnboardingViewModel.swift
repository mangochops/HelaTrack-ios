//
//  OnboardingViewModel.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var selectedMethod: PaymentProvider? = nil
    @Published var businessName = ""
    @Published var identifier = ""
    
    // Logic for button states
    var canMoveToCredentials: Bool {
        selectedMethod != nil
    }
    
    var canFinish: Bool {
        !businessName.isEmpty && !identifier.isEmpty
    }
    
    func selectProvider(_ provider: PaymentProvider) {
        selectedMethod = provider
        withAnimation {
            currentPage = 4 // Move to Credentials Page
        }
    }
    
    func completeOnboarding() {
        // Save to UserDefaults or your backend
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        print("Saving: \(businessName) with \(selectedMethod?.name ?? "") ID: \(identifier)")
    }
}

