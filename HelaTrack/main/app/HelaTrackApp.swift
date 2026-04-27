//
//  HelaTrackApp.swift
//  HelaTrack
//
//  Created by mac on 4/13/26.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

@main
struct HelaTrackApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.scenePhase) private var scenePhase
    
    let persistenceController = PersistenceController.shared
    
    // Register the task in the init
    init() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.helatrack.eodsummary", using: nil) { task in
            EODManager.shared.handleEODTask(task: task as! BGAppRefreshTask)
        }
        
        // 2. REQUEST NOTIFICATION PERMISSION HERE
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted!")
            } else if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    if newPhase == .background {
                        print("DEBUG: App moved to background. Scheduling EOD task...")
                        EODManager.shared.scheduleEODTask()
                    }
                }
                
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
