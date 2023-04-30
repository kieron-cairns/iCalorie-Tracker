//
//  iCalorieTrackerApp.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 30/04/2023.
//

import SwiftUI

@main
struct iCalorieTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
