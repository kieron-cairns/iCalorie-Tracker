//
//  iCalorieTrackerUITests.swift
//  iCalorieTrackerUITests
//
//  Created by Kieron Cairns on 30/04/2023.
//

import XCTest

class iCalorieTrackerUITests: XCTestCase {
    
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

class BaseUITestCases : XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func addNewCalorieItem() -> (app: XCUIApplication, calorieTable: XCUIElement) {
        
        let addCalorieItemButton = app.buttons["addCalorieItem"]
        //        XCTAssertTrue(addCalorieItemButton.exists, "Add Item button should exist.")
        addCalorieItemButton.tap()
        
        let titleTextField = app.textFields["calorieTitleTextField"]
        titleTextField.tap()
        titleTextField.typeText("Test Item")
        
        let calorieCountTextField = app.textFields["calorieCountTextField"]
        calorieCountTextField.tap()
        calorieCountTextField.typeText("100")
        
        let calorieTable = app.collectionViews["calorieList"]
        
        let saveCalorieItemButton = app.buttons["saveCalorieItemButton"]
        saveCalorieItemButton.tap()
        
        return (app, calorieTable)
    }
}

class when_user_adds_new_calorie_item: BaseUITestCases {
    
    func testCalorieItemCountTotals() {
        
            let result = addNewCalorieItem()
            let app = result.app
            
            //Get all the elements with the given accessibility identifier
            let calorieCounts = app.staticTexts.matching(identifier: "calorieItemCount")
            
            //Count all these elements
            let numberOfCalorieItems = calorieCounts.count
            XCTAssert(numberOfCalorieItems > 0, "No calorie items found.")
            
            //Total up the values of these items
            var totalCalories = 0
            for i in 0..<numberOfCalorieItems {
                if let calorieValue = Int(calorieCounts.element(boundBy: i).label) {
                    totalCalories += calorieValue
                }
            }
            
            //assert on the total value
            
            print("Total calories for all items: \(totalCalories)")
            sleep(4)
        
        XCTAssertEqual(String(totalCalories), app.staticTexts["totalCaloireCount"].label, "Total calories doesn't match the expected value.")
        }
        
        override func tearDown() {
            Springboard.deleteApp()
        }
    
}


class when_user_taps_on_cell_item: BaseUITestCases {
    
    func test_add_calorie_item_view_is_populated() {
        
        let result = addNewCalorieItem()
        let calorieTable = result.calorieTable
        
        let cell = calorieTable.cells.children(matching: .other).element(boundBy: 1)
        cell.tap()

        let calorieItemTitle = cell.staticTexts["calorieItemTitle"]
        let calorieItemCount = cell.staticTexts["calorieItemCount"]

        //Make sure the calorie cells exits along with correct titles:
        XCTAssert(calorieItemTitle.exists, "Calorie Item Title does not exist")
        XCTAssertEqual(calorieItemTitle.label, "Test Item", "The title doesn't match expected")

        XCTAssert(calorieItemCount.exists, "Calorie Item Count does not exist")
        XCTAssertEqual(calorieItemCount.label, "100", "The count doesn't match expected")
    }
    
    func test_tapped_cell_items_match_add_caloire_item_view_fields() {
        
        
        let result = addNewCalorieItem()
        let calorieTable = result.calorieTable

        let cell = calorieTable.cells.children(matching: .other).element(boundBy: 1)
        cell.tap()

        let calorieItemTitle = cell.staticTexts["calorieItemTitle"]
        let calorieItemCount = cell.staticTexts["calorieItemCount"]
        
//        let addCalItemViewCalTitleField =
        
        
        
    }
    
    func test_delete_caloire_item_button_should_be_present() {
        
        let result = addNewCalorieItem()
        let calorieTable = result.calorieTable
        
        let cell = calorieTable.cells.children(matching: .other).element(boundBy: 1)
        cell.tap()
        
        let deleteCaloireItemButton = app.buttons["deleteCalorieItemButton"]
        XCTAssert(deleteCaloireItemButton.exists)
    }

    override func tearDown() {
        Springboard.deleteApp()
    }
}

class when_user_taps_on_add_new_calorie_item_button: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func test_delete_caloire_item_button_should_not_be_present() {
        
        let addCalorieItemButton = app.buttons["addCalorieItem"]
        addCalorieItemButton.tap()
        
        let deleteCaloireItemButton = app.buttons["deleteCalorieItemButton"]
        XCTAssert(!deleteCaloireItemButton.exists)
    }
}


