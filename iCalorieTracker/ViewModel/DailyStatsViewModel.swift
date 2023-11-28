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
import Combine

class DailyStatsViewModel: ObservableObject {
    
    let healthStore: HKHealthStore
    
    @Published var calorieInfo: String = ""
    @Published var isHealthDataAvailable: Bool = false
    @Published var healthKitIsAuthorised: Bool = false
    @Published var date: Date = Date()
    @Published var calculatedActiveCalories: Int = 0
    
    private var cancellables = Set<AnyCancellable>()

    
    init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
        
        //Call entry function here
        setupHealthDataAvailabilityPublisher()
        
        $isHealthDataAvailable
            .receive(on: RunLoop.main)
            .sink{ [weak self] available in
                if available {
                    
                    self?.requestHealthAuthorization()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupHealthDataAvailabilityPublisher() {
        
        $isHealthDataAvailable
            .receive(on: RunLoop.main)
            .sink{ [weak self] available in
                if available {
                    
                    self?.requestHealthAuthorization()
                }
            }
            .store(in: &cancellables)
    }
    
    //Pass the date here - main entry for getting caloire info
    func checkHealthDataAvailability() {
        isHealthDataAvailable = HKHealthStore.isHealthDataAvailable()
    }
    
    private func requestHealthAuthorization() {
        
        let readTypes = Set([HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
                             HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!])

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                print("Authorization error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.calorieInfo = "Authorization failed"
                }
                return
            }
            
            if !success {
                print("Authorization was not successful")
                DispatchQueue.main.async {
                    self.calorieInfo = "Authorization failed"
                }
                return
            }
        }
    }
    
    func fetchActiveCalories(for date: Date, completion: @escaping (Result<Double, Error>) -> Void) {
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let activeQuery = HKStatisticsQuery(quantityType: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, statistics, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let activeCalories = statistics?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            completion(.success(activeCalories))
        }
        healthStore.execute(activeQuery)
    }
    
    
    func fetchRestingCalories(for date: Date, completion: @escaping (Result<Double, Error>) -> Void) {
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let restingQuery = HKStatisticsQuery(quantityType: HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
                                             quantitySamplePredicate: predicate,
                                             options: .cumulativeSum) { _, restingStatistics, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let restingCalories = restingStatistics?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))

                return
            }
            completion(.success(restingCalories))
        }
        healthStore.execute(restingQuery)
    }
    
    func calculateTotalCalories(for date: Date) {
        fetchActiveCalories(for: date) { [weak self] activeResult in
            switch activeResult {
            case .success(let activeCalories):
                self?.fetchRestingCalories(for: date) { restingResult in
                    switch restingResult {
                    case .success(let restingCalories):
                        let totalCalories = activeCalories + restingCalories
                        let roundedCalories = Int(totalCalories.rounded())
                        DispatchQueue.main.async {
                            self?.calorieInfo = "\(roundedCalories)"
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            self?.calorieInfo = "Resting calories data not available"
                        }
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.calorieInfo = "Active calories data not available"
                }
            }
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
