//
//  MainTabView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Feature 1: Home Dashboard
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            // Feature 2: Transactions (Money-In)
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "chart.bar.xaxis")
                }

            // Feature 3: Insights (Graphs)
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
                }

            // Feature 4: Profile/Settings
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.primaryBrand) // Consistent brand feel
    }
}
