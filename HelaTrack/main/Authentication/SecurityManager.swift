//
//  SecurityManager.swift
//  HelaTrack
//
//  Created by mac on 4/19/26.
//

import LocalAuthentication
import SwiftUI

class SecurityManager: ObservableObject {
    @Published var isUnlocked = false
    @AppStorage("isBiometricsEnabled") var isBiometricsEnabled = false

    func authenticate() {
        // If the user turned off the setting, don't lock the app
        guard isBiometricsEnabled else {
            self.isUnlocked = true
            return
        }

        let context = LAContext()
        var error: NSError?

        // Check if the device is capable (FaceID, TouchID, or Passcode)
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Unlock HelaTrack to access your financial data."

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true // This is what triggers the view to swap
                        print("Successfully Unlocked!")
                    } else {
                        print("Authentication failed: \(String(describing: authenticationError))")
                    }
                }
            }
        } else {
            // No biometrics available on device
            self.isUnlocked = true
        }
    }
}
