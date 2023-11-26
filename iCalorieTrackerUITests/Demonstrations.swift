//
//  Demonstrations.swift
//  iCalorieTrackerUITests
//
//  Created by Kieron Cairns on 20/11/2023.
//

import XCTest

class Demonstrations: XCTestCase {
    
    var app: XCUIApplication!
       
       override func setUpWithError() throws {
           // This method is called before the invocation of each test method in the class.
           continueAfterFailure = false
           app = XCUIApplication()
           app.launch()
       }

       func testCalorieItemTableHasNoCellsAtLaunch() {
           // Assuming you have set the accessibility identifier for the table as "CalorieItem"
           let calorieTable = app.tables["CalorieItem"]
           
           // Assert that the table has no cells
           XCTAssertEqual(calorieTable.cells.count, 0, "CalorieItem table should have no cells at app launch")
       }
    
    override func tearDown() {
        Springboard.deleteApp()
    }
}

class DemonstrationsBaseUITestCases : XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func addFirstCaloireItem() -> (app: XCUIApplication, calorieTable: XCUIElement) {
        
        sleep(3)
        let addCalorieItemButton = app.buttons["addCalorieItem"]
        //        XCTAssertTrue(addCalorieItemButton.exists, "Add Item button should exist.")
        addCalorieItemButton.tap()
        
        let titleTextField = app.textFields["calorieTitleTextField"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: titleTextField, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        titleTextField.tap()
        titleTextField.typeText("Yoghurt")

        let calorieCountTextField = app.textFields["calorieCountTextField"]
        calorieCountTextField.tap()

        calorieCountTextField.typeText("125")

        let calorieQuantityTextField = app.textFields["calorieQuantityTextField"]
        calorieQuantityTextField.tap()
        calorieQuantityTextField.typeText("1")

        let calorieTable = app.collectionViews["calorieList"]
        
        let saveCalorieItemButton = app.buttons["saveCalorieItemButton"]
        saveCalorieItemButton.tap()
        
        return (app, calorieTable)
    }
    
    func addSecondCaloireItem() -> (app: XCUIApplication, calorieTable: XCUIElement) {
        
        let addCalorieItemButton = app.buttons["addCalorieItem"]
        //        XCTAssertTrue(addCalorieItemButton.exists, "Add Item button should exist.")
        addCalorieItemButton.tap()
        
        let titleTextField = app.textFields["calorieTitleTextField"]
        let exists = NSPredicate(format: "exists == true")
        sleep(1)
        expectation(for: exists, evaluatedWith: titleTextField, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        titleTextField.tap()

        for char in "Blueberries" {
            titleTextField.typeText(String(char))
            usleep(1) // Sleep for 0.5 seconds (adjust the delay as needed)
        }
        
        let calorieCountTextField = app.textFields["calorieCountTextField"]
        calorieCountTextField.tap()
        sleep(1)
        for char in "85" {
            calorieCountTextField.typeText(String(char))
            usleep(1) // Sleep for 0.5 seconds (adjust the delay as needed)
        }
        
        let calorieQuantityTextField = app.textFields["calorieQuantityTextField"]
        calorieQuantityTextField.tap()
        sleep(1)
        for char in "1" {
            calorieQuantityTextField.typeText(String(char))
            usleep(1) // Sleep for 0.5 seconds (adjust the delay as needed)
        }

        let calorieTable = app.collectionViews["calorieList"]
        
        let saveCalorieItemButton = app.buttons["saveCalorieItemButton"]
        saveCalorieItemButton.tap()
        
        return (app, calorieTable)
    }
    
    func addThirdCaloireItem() -> (app: XCUIApplication, calorieTable: XCUIElement) {

        let addCalorieItemButton = app.buttons["addCalorieItem"]
        addCalorieItemButton.tap()

        let titleTextField = app.textFields["calorieTitleTextField"]
        let exists = NSPredicate(format: "exists == true")
        sleep(1)
        titleTextField.tap()

        // Type the text character by character with a delay
        for char in "Protein Shake" {
            titleTextField.typeText(String(char))
            usleep(1) // Sleep for 0.5 seconds (adjust the delay as needed)
        }

        let calorieCountTextField = app.textFields["calorieCountTextField"]
        calorieCountTextField.tap()
        sleep(1)
        for char in "100" {
            calorieCountTextField.typeText(String(char))
            usleep(1) // Sleep for 0.5 seconds (adjust the delay as needed)
        }
        
        let calorieQuantityTextField = app.textFields["calorieQuantityTextField"]
        calorieQuantityTextField.tap()
        sleep(1)
        for char in "2" {
            calorieQuantityTextField.typeText(String(char))
            usleep(1) // Sleep for 0.5 seconds (adjust the delay as needed)
        }

        let calorieTable = app.collectionViews["calorieList"]

        let saveCalorieItemButton = app.buttons["saveCalorieItemButton"]
        saveCalorieItemButton.tap()

        return (app, calorieTable)
    }

}

class demonstration_initial_items: DemonstrationsBaseUITestCases {

    func testAddFirstItems() {
//        let firstItem = addFirstCaloireItem()
        let secondIem = addSecondCaloireItem()
        let thirditem = addThirdCaloireItem()
        sleep(5)
    }
    
}

