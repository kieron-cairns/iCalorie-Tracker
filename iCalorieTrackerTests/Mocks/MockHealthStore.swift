//
//  MockHealthStore.swift
//  iCalorieTrackerTests
//
//  Created by Kieron Cairns on 28/11/2023.
//

import Foundation
import HealthKit

class MockHealthStore: HKHealthStore {
    var shouldReturnError: Bool = false
    var activeCalories: Double?

    override func execute(_ query: HKQuery) {
        if let query = query as? HKStatisticsQuery {
            if shouldReturnError {
                query.statisticsUpdateHandler?(query, nil, nil, NSError(domain: "TestError", code: 1, userInfo: nil))
            } else if let activeCalories = activeCalories {
                let quantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: activeCalories)
                let statistics = HKStatistics(quantityType: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, quantitySamplePredicate: nil, options: .cumulativeSum, startDate: Date(), endDate: Date(), sumQuantity: quantity)
                query.statisticsUpdateHandler?(query, statistics, nil, nil)
            } else {
                query.statisticsUpdateHandler?(query, nil, nil, nil)
            }
        }
    }
}
