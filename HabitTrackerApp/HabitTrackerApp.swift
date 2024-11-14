//
//  HabitTrackerAppApp.swift
//  HabitTrackerApp
//
//  Created by Max Seidlitz on 14.11.24.
//

import SwiftUI
import UserNotifications

@main
struct HabitTrackerApp: App {
    // Verknüpfe den AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
