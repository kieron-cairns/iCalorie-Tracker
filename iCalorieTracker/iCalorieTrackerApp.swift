//
//  iCalorieTrackerApp.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 30/04/2023.
//

import SwiftUI

@main
struct iCalorieTrackerApp: App {

    let persistenceContainer = CoreDataManager.shared.persistentContainer
    @StateObject var userSettings = UserSettings()

    @AppStorage("oboarding") var onboarding = true
    @AppStorage("acknowledgedOnboarding") var acknowledgedOnboarding = false
    
    var onboardingCards: [OnboardingModel] = onboardingData
    
    init() {
           if CommandLine.arguments.contains("UITesting") {
               onboarding = false
               acknowledgedOnboarding = true

               userSettings.dailyCalorieIntakeGoal = 1500
               userSettings.dailyCalorieBurnGoal = 500
           }
       }

    var body: some Scene {
        WindowGroup {
            
            if onboarding && !acknowledgedOnboarding {
                OnboardingView()
            }
            if !onboarding && !acknowledgedOnboarding
            {
                OnboardingTargetsView()
                    .environmentObject(userSettings)
                    .environment(\.colorScheme, userSettings.isDarkMode ? .dark : .light)

            }
            if !onboarding && acknowledgedOnboarding
            {
                DailyStatsView()
                    .environment(\.managedObjectContext, persistenceContainer.viewContext)
                    .environment(\.colorScheme, userSettings.isDarkMode ? .dark : .light)
                    .environmentObject(userSettings)
            }
        }
    }
}
