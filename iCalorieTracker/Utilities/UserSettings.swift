//
//  UserSettings.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 05/10/2023.
//

import Foundation

class UserSettings: ObservableObject {
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

    init() {
        if let _ = UserDefaults.standard.value(forKey: "isDarkMode") as? Bool {
            // If the value exists in UserDefaults, fetch it
            self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        } else {
            // If the value doesn't exist, set a default value
            self.isDarkMode = true
        }
    }
}
