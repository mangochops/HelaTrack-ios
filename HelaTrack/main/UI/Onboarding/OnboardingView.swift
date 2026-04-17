//
//  OnboardingView.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//
import SwiftUI
import Lottie





// MARK: - Onboarding View
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $viewModel.currentPage) {
                // Page 0: Animation
                AnimationPage(
                    title: "Track Every Coin",
                    desc: "Automatically sync your M-Pesa, Airtel Money or Bank transactions safely.",
                    lottieName: "finance",
                    onNext: { viewModel.currentPage = 1 }
                ).tag(0)
                
                // Page 1: Animation
                AnimationPage(
                    title: "Your Personal Assistant",
                    desc: "Close your books every evening. Track cash and mobile payments in one place.",
                    lottieName: "assistant",
                    onNext: { viewModel.currentPage = 2 }
                ).tag(1)
                
                // Page 2: Animation
                AnimationPage(
                    title: "Smart Insights",
                    desc: "See your earning with clean, automated graphs.",
                    lottieName: "analytics",
                    onNext: { viewModel.currentPage = 3 }
                ).tag(2)
                
                // Page 3: Selection
                PaymentSelectionPage(
                    selectedMethod: $viewModel.selectedMethod,
                    onNext: { viewModel.currentPage = 4 }
                ).tag(3)
                
                // Page 4: Credentials
                if let provider = viewModel.selectedMethod {
                    CredentialsPage(
                        provider: provider,
                        businessName: $viewModel.businessName,
                        identifier: $viewModel.identifier,
                        onFinish: viewModel.completeOnboarding
                    )
                    .tag(4)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // We build a custom indicator below
            
            // Custom Pager Indicator (Matching Kotlin Row)
            HStack(spacing: 8) {
                ForEach(0..<5) { index in
                    Circle()
                        .fill(viewModel.currentPage == index ? Color.primaryBrand : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        // Trigger navigation to Main App here
    }
}




#Preview {
    OnboardingView()
}
