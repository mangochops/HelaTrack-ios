//
//  HelaTrackApp.swift
//  HelaTrack
//
//  Created by mac on 4/13/26.
//

import SwiftUI

@main
struct HelaTrackApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


//
//  HelaTrackApp.swift
//  HelaTrack
//
//  Created by mac on 4/13/26.
//

//import SwiftUI
//
//@main
//struct HelaTrackApp: App {
//    let persistenceController = PersistenceController.shared
//    
//
//    @Environment(\.scenePhase) private var scenePhase
//
//    @StateObject private var securityManager = SecurityManager()
//
//    var body: some Scene {
//        WindowGroup {
//            Group {
//                if securityManager.isUnlocked {
//                    ContentView()
//                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                } else {
//                    
//                    VStack(spacing: 20) {
//                        Image(systemName: "lock.shield.fill")
//                            .font(.system(size: 70))
//                            .foregroundColor(.accentColor)
//                        
//                        Text("HelaTrack is Locked")
//                            .font(.title2.bold())
//                        
//                        Button("Unlock App") {
//                            securityManager.authenticate()
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .controlSize(.large)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color(.systemBackground))
//                }
//            }
//            .onAppear {
//                // Trigger biometric check on launch
//                securityManager.authenticate()
//            }
//            .onChange(of: scenePhase) { newPhase in
//                
//                if newPhase == .inactive || newPhase == .background {
//                    securityManager.isUnlocked = false
//                } else if newPhase == .active {
//                    securityManager.authenticate()
//                }
//            }
//        }
//    }
//}
