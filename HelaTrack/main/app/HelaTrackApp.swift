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
