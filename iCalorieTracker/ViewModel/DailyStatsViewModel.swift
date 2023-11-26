//
//  DailyStatsViewModel.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 05/10/2023.
//

import Foundation
import UIKit
import HealthKit
import SwiftUI

class DailyStatsViewModel: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    var calorieInfo: String = "Loading..."
    
    
    func getCaloriesForToday() {
           let today = Date() // Get today's date
           getCaloriesForDate(date: today) { result in
               DispatchQueue.main.async {
                   self.calorieInfo = result
               }
           }
       }
    
    func getCaloriesForDate(date: Date, completion: @escaping (String) -> Void) {
        let healthStore = HKHealthStore()
        
        let calendar = Calendar.current
//        let now = Date()
        var todayStart = calendar.startOfDay(for: date)
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion("Health data not available")
            return
        }
        
        let readTypes = Set([HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
                             HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!])
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if !success {
                completion("Authorization failed")
                return
            }

            let startDate = Calendar.current.startOfDay(for: todayStart)
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                          quantitySamplePredicate: predicate,
                                          options: .cumulativeSum) { _, statistics, _ in
                guard let activeCalories = statistics?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) else {
                    completion("Active calories data not available")
                    return
                }

                let restingQuery = HKStatisticsQuery(quantityType: HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
                                                     quantitySamplePredicate: predicate,
                                                     options: .cumulativeSum) { _, restingStatistics, _ in
                    guard let restingCalories = restingStatistics?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) else {
                        completion("Resting calories data not available")
                        return
                    }

                    let totalCalories = activeCalories + restingCalories
                    completion("Total calories for \(date): \(totalCalories) kcal")
                }

                healthStore.execute(restingQuery)
            }

            healthStore.execute(query)
        }
    }
    
    func statsTitleText(selectedDate: Date) -> String {
       
        let today = Date()
        let calendar = Calendar.current

        // Calculate the difference in days
        let daysDiff = calendar.dateComponents([.day], from: selectedDate, to: today).day ?? 0

        switch daysDiff {
        case 0:
            return "Today's"
        case 1:
            return "Yesterday's"
        default:
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter.string(from: selectedDate)
        }
    }
    
   

}
