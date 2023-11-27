//
//  FirstLoadView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 26/11/2023.
//

import SwiftUI

struct FirstLoadView: View {
    
    @AppStorage("oboarding") var onboarding = true
    @AppStorage("acknowledgedOnboarding") var acknowledgedOnboarding = false

//    @ObservedObject var userSettings = UserSettings()
    @StateObject var userSettings = UserSettings()

    let persistenceContainer = CoreDataManager.shared.persistentContainer

    var body: some View {
        
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

struct FirstLoadView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLoadView()
    }
}
