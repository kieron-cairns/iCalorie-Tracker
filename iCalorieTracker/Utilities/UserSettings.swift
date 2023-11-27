//
//  UserSettings.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 05/10/2023.
//

import Foundation
import SwiftUI

class UserSettings: ObservableObject {
    
    @AppStorage("oboarding") var onboarding = true
    @AppStorage("acknowledgedOnboarding") var acknowledgedOnboarding = false

    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    @Published var dailyCalorieIntakeGoal: Int = UserDefaults.standard.integer(forKey: "dailyCalorieIntakeGoal") {
        didSet {
            UserDefaults.standard.set(dailyCalorieIntakeGoal, forKey: "dailyCalorieIntakeGoal")
        }
    }

    @Published var dailyCalorieBurnGoal: Int = UserDefaults.standard.integer(forKey: "dailyCalorieBurnGoal") {
        didSet {
            UserDefaults.standard.set(dailyCalorieBurnGoal, forKey: "dailyCalorieBurnGoal")
        }
    }
    
    @Published var hasShownHealthKitAuthorization: Bool {
            didSet {
               
                UserDefaults.standard.set(hasShownHealthKitAuthorization, forKey: "hasShownHealthKitAuthorization")
                
                onboarding = false
                acknowledgedOnboarding = true

                
                print("*** health kit authorsation has been granted: \(hasShownHealthKitAuthorization)")
            }
        }

    init() {
        if let _ = UserDefaults.standard.value(forKey: "isDarkMode") as? Bool {
            // If the value exists in UserDefaults, fetch it
            self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        } else {
            // If the value doesn't exist, set a default value
            self.isDarkMode = true
        }
        
        if let _ = UserDefaults.standard.value(forKey: "hasShownHealthKitAuthorization") as? Bool {
                    self.hasShownHealthKitAuthorization = UserDefaults.standard.bool(forKey: "hasShownHealthKitAuthorization")
            } else {
                // Set a default value or initial state for HealthKit authorization
                self.hasShownHealthKitAuthorization = false
            }
    }
}
