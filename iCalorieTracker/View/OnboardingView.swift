//
//  HealthKitAuthorizationView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 26/11/2023.
//

import SwiftUI
import HealthKit

struct OnboardingView: View {
    
    @AppStorage("oboarding") var onboarding = true

    
//    let healthStore = HKHealthStore()
//
//    @ObservedObject var userSettings: UserSettings
    
    var body: some View {
        
        Button(action: {
            onboarding = false
        })
        {
            Text("Continue")
        }
        //        let healthKitAuthorizationViewModel = HealthKitAuthorizationViewModel(userSettings: userSettings)
        //
        //        Button(action: {
        //            healthKitAuthorizationViewModel.requestHealthKitAuthorization(healthStore: healthStore)
        //        }) {
        //            Text("Authorize HealthKit Access")
        //        }
        //    }
    }
}

//struct HealthKitAuthorizationView_Previews: PreviewProvider {
//    static var previews: some View {
//        HealthKitAuthorizationView()
//    }
//}
