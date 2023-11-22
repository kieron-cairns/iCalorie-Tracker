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

    var calorieItemListViewModel: CalorieItemListViewModel!
    var mockPersistentContainer: NSPersistentContainer!
    var mockViewContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        // Setup the mock persistent container
        mockPersistentContainer = createMockPersistentContainer()
        mockViewContext = mockPersistentContainer.viewContext

        // Initialize your ViewModel
        calorieItemListViewModel = CalorieItemListViewModel()
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
        calorieItemListViewModel.saveCalorieItem(title: title, id: id, calorieCount: caloireCount, date: date, viewContext: mockViewContext)

        let calorieItem = calorieItemListViewModel.fetchCaloireItem(withId: id, viewContext: mockViewContext)!
        
        
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
    
    func test_should_save_new_calorie_item_successfully() {
        
        let result = addNewCalorieItemToInMemDb(title: caloireTitle, id: itemId!, caloireCount: Int32(caloireCount), date: dateStringToDate(dateString: dateAdded)!)
        let calorieItem = result

        XCTAssertEqual("Unit Test Caloire Item Title" , calorieItem.title)
        XCTAssertEqual(UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000"), calorieItem.id)
        XCTAssertEqual(100 , calorieItem.calorieCount)
        XCTAssertEqual(dateStringToDate(dateString: "2023-11-22")!, calorieItem.dateCreated)
    }
    
    func dateStringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}


