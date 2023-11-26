//
//  HealthKitAuthorizationView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 26/11/2023.
//

import SwiftUI
import HealthKit

struct HealthKitAuthorizationView: View {
    
    let healthStore = HKHealthStore()
    
    var healthKitAuthorizationViewModel = HealthKitAuthorizationViewModel()
    
    var body: some View {
        
        Button(action: {
            healthKitAuthorizationViewModel.requestHealthKitAuthorization(healthStore: healthStore)
        }) {
            Text("Authorize HealthKit Access")
        }
    }
}

struct HealthKitAuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitAuthorizationView()
    }
}
