//
//  HealthKitAuthorizationViewModel.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 26/11/2023.
//

import Foundation
import HealthKit


struct HealthKitAuthorizationViewModel {
    
//    var userSettings: UserSettings
    
  
    
    // Function to request HealthKit authorization
    func requestHealthKitAuthorization(healthStore: HKHealthStore, userSettings: UserSettings) {
        let readTypes: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: .stepCount)!]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
           
            DispatchQueue.main.async {
                if success {
                    userSettings.hasShownHealthKitAuthorization = true
                } else {
                    // Handle error
                }
            }
        }
    }
}
