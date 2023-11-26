//
//  FirstLoadView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 26/11/2023.
//

import SwiftUI

struct FirstLoadView: View {
    
    @AppStorage("oboarding") var onboarding = true
    
    @ObservedObject var userSettings = UserSettings()
    let persistenceContainer = CoreDataManager.shared.persistentContainer

    var body: some View {
        
        if onboarding {
            OnboardingView()
        }
        else
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
