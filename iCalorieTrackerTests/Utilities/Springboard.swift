//
//  Springboard.swift
//  iCalorieTrackerUITests
//
//  Created by Kieron Cairns on 27/09/2023.
//

import Foundation
import XCTest

class Springboard {
    
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    class func deleteApp() {
        
        XCUIApplication().terminate()
        springboard.activate()
        
        let appIcon = springboard.icons.matching(identifier: "iCalorieTracker").firstMatch
        appIcon.press(forDuration: 0.75)
        
        let _ = springboard.buttons["Remove App"].waitForExistence(timeout: 0.5)
        
        springboard.buttons["Remove App"].tap()
        
        let deleteButton = springboard.alerts.buttons["Delete App"].firstMatch
        
        if deleteButton.waitForExistence(timeout: 0.75) {
            deleteButton.tap()
            springboard.alerts.buttons["Delete"].tap()
        }
    }
}
