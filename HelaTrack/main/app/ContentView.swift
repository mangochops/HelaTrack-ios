//
//  ContentView.swift
//  HelaTrack
//
//  Created by mac on 4/13/26.
//

import SwiftUI

struct ContentView: View {
    // This automatically checks UserDefaults for the key
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some View {
        if hasSeenOnboarding {
            MainTabView() // Your features live here
        } else {
            OnboardingView() // Your entry point for new users
        }
    }
}
