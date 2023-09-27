//
//  SQLiteEndToEndTest.swift
//  iCalorieTrackerUITests
//
//  Created by Kieron Cairns on 27/09/2023.
//

import XCTest
import CoreData

class when_app_is_launched: XCTestCase {
 
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
    
    func addNewCalorieItem() -> XCUIElement {
        
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
        
        return calorieTable
    }
}

class when_user_saves_a_new_calorie_item: BaseUITestCases {
    
    func test_should_save_new_calorie_item_successfully() {
        
        let calorieTable = addNewCalorieItem()

        XCTAssert(calorieTable.exists)
        XCTAssertEqual(1, calorieTable.cells.count)
    }
    
    override func tearDown() {
        Springboard.deleteApp()
    }
}

class when_user_deletes_a_calorie_item: BaseUITestCases {
  
    func test_should_delete_calorie_item() {
       
        let calorieTable = addNewCalorieItem()
        
        let cell = calorieTable.cells.children(matching: .other).element(boundBy: 1)
        cell.swipeLeft()
        app.collectionViews["calorieList"].buttons["Delete"].tap()
        XCTAssertFalse(cell.exists)
    }
    
    override func tearDown() {
        Springboard.deleteApp()
    }
  
}


