//
//  OnboardingTargetsView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 27/11/2023.
//

import SwiftUI
import HealthKit

struct OnboardingTargetsView: View {
    
//    @AppStorage("acknowledgedOnboarding") var acknowledgedOnboarding = false

    
    let healthStore = HKHealthStore()
    let userSettings = UserSettings()
    
    let healthKitAuthViewModel = HealthKitAuthorizationViewModel()
    
    
    var body: some View {
        VStack {
            TargetsView()
                .background(.black)
            
            Button(action: {
                
                healthKitAuthViewModel.requestHealthKitAuthorization(healthStore: healthStore, userSettings: userSettings)
                
            })
            {
                Text("Continue")
            }
        }.background(.black)
    }
}

struct OnboardingTargetsView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTargetsView()
    }
}
