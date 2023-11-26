//
//  HealthKitAuthorizationViewModel.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 26/11/2023.
//

import Foundation
import HealthKit


class HealthKitAuthorizationViewModel {
    
    var userSettings = UserSettings()
    
    // Function to request HealthKit authorization
    func requestHealthKitAuthorization(healthStore: HKHealthStore) {
        let readTypes: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: .stepCount)!]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if success {
                // Authorization granted, you can now read HealthKit data
                self.userSettings.hasShownHealthKitAuthorization = true
                
            } else {
                // Handle the error or inform the user about the need for authorization
            }
        }
    }
}
