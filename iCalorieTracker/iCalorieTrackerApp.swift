//
//  iCalorieTrackerApp.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 30/04/2023.
//

import SwiftUI

@main
struct iCalorieTrackerApp: App {
//    let persistenceController = PersistenceController.shared

    let persistenceContainer = CoreDataManager.shared.persistentContainer
    @StateObject var userSettings = UserSettings()


    var body: some Scene {
        WindowGroup {
            DailyStatsView()
                .environment(\.managedObjectContext, persistenceContainer.viewContext)
                .environment(\.colorScheme, userSettings.isDarkMode ? .dark : .light)
                 .environmentObject(userSettings)
        }
    }
}
