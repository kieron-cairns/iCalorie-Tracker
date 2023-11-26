//
//  HealthKitAuthorizationView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 26/11/2023.
//

import SwiftUI
import HealthKit

struct OnboardingView: View {
    

    
    let healthStore = HKHealthStore()
    let userSettings = UserSettings()
    
    let healthKitAuthViewModel = HealthKitAuthorizationViewModel()
    
    var body: some View {
        
        Button(action: {
            
            healthKitAuthViewModel.requestHealthKitAuthorization(healthStore: healthStore, userSettings: userSettings)
            
        })
        {
            Text("Continue")
        }
        
    }
}

//struct HealthKitAuthorizationView_Previews: PreviewProvider {
//    static var previews: some View {
//        HealthKitAuthorizationView()
//    }
//}
