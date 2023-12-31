//
//  SQLiteEndToEndTest.swift
//  iCalorieTrackerUITests
//
//  Created by Kieron Cairns on 27/09/2023.
//

import XCTest
import CoreData
@testable import iCalorieTracker

class BasePersistenceTestCases: XCTestCase {

    var commonViewModel: CommonViewModel!
    var mockPersistentContainer: NSPersistentContainer!
    var mockViewContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        // Setup the mock persistent container
        mockPersistentContainer = createMockPersistentContainer()
        mockViewContext = mockPersistentContainer.viewContext

        // Initialize your ViewModel
        commonViewModel = CommonViewModel()
    }

    func createMockPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "iCalorieTrackerAppModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load in-memory database: \(error)")
            }
        }
        return container
    }

    func addNewCalorieItemToInMemDb(title: String, id: UUID, caloireCount: Int32, date: Date) -> CalorieItem  {
        
        // Use the mockViewContext
       let firstItem = commonViewModel.saveCalorieItem(title: title, id: id, calorieCount: caloireCount, date: date, viewContext: mockViewContext)

        let calorieItem = commonViewModel.fetchCaloireItem(withId: id, viewContext: mockViewContext)!
        
        return calorieItem
    }

    override func tearDown() {
        super.tearDown()

        // Clean up
        mockViewContext = nil
        mockPersistentContainer = nil
    }
}


class when_user_saves_a_new_calorie_item: BasePersistenceTestCases {

    let caloireTitle = "Unit Test Caloire Item Title"
    let itemId = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")
    let caloireCount = 100
    let dateAdded = "2023-11-22"
    
    let newCaloireTitle = "New Unit Test Caloire Item Title"
    let newItemId = UUID(uuidString: "2a81e997-0028-4935-9f4b-b4d088907200")
    let newCaloireCount = 200
    let newDateAdded = "2023-11-21"
    
    func test_should_save_new_calorie_item_successfully() {
        
        let result = addNewCalorieItemToInMemDb(title: caloireTitle, id: itemId!, caloireCount: Int32(caloireCount), date: dateStringToDate(dateString: dateAdded)!)
        let calorieItem = result

        XCTAssertEqual("Unit Test Caloire Item Title" , calorieItem.title)
        XCTAssertEqual(UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000"), calorieItem.id)
        XCTAssertEqual(100 , calorieItem.calorieCount)
        XCTAssertEqual(dateStringToDate(dateString: "2023-11-22")!, calorieItem.dateCreated)
    }
    
    func test_update_caloire_item() {
    
        let result = addNewCalorieItemToInMemDb(title: caloireTitle, id: itemId!, caloireCount: Int32(caloireCount), date: dateStringToDate(dateString: dateAdded)!)
        let calorieItem = result
        
        calorieItem.title = newCaloireTitle
        calorieItem.id = newItemId
        calorieItem.calorieCount = Int32(newCaloireCount)
        calorieItem.dateCreated = dateStringToDate(dateString: newDateAdded)!
        
        XCTAssertEqual("New Unit Test Caloire Item Title" , calorieItem.title)
        XCTAssertEqual(UUID(uuidString: "2a81e997-0028-4935-9f4b-b4d088907200"), calorieItem.id)
        XCTAssertEqual(200 , calorieItem.calorieCount)
        XCTAssertEqual(dateStringToDate(dateString: "2023-11-21")!, calorieItem.dateCreated)
    }
    
    func test_delete_caloire_item() {
        
        let firstItem = addNewCalorieItemToInMemDb(title: caloireTitle, id: itemId!, caloireCount: Int32(caloireCount), date: dateStringToDate(dateString: dateAdded)!)
        
        let secondItem = addNewCalorieItemToInMemDb(title: newCaloireTitle, id: newItemId!, caloireCount: Int32(newCaloireCount), date: dateStringToDate(dateString: newDateAdded)!)
        
        commonViewModel.deleteCalorieItem(withId: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!, from: mockViewContext)

        let caloireItems = commonViewModel.fetchAllCalorieItems(viewContext: mockViewContext)!
        
        XCTAssertEqual(caloireItems.count, 1)
        XCTAssertTrue(caloireItems.contains(secondItem))
    }
    
    func dateStringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}


