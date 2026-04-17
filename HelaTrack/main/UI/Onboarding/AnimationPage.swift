//
//  AnimationPage.swift
//  HelaTrack
//
//  Created by mac on 4/16/26.
//

import SwiftUI

struct AnimationPage: View {
    let title: String
    let desc: String
    let lottieName: String
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            LottieView(name: lottieName)
                .frame(width: 300, height: 300)
                .padding(.top, 50)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.title.bold())
                Text(desc)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button(action: onNext) {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBrand)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(24)
        }
    }
}


