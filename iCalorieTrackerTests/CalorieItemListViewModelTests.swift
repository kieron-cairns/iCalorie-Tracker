//
//  CalorieItemListViewModelTests.swift
//  iCalorieTrackerTests
//
//  Created by Kieron Cairns on 28/09/2023.
//

import XCTest
import CoreData
@testable import iCalorieTracker

class CalorieItemListViewModelTests: XCTestCase {
    
    var sut: CalorieItemListViewModel!
    var mockContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        sut = CalorieItemListViewModel()
        mockContext = setUpInMemoryManagedObjectContext()
    }

    override func tearDown() {
        sut = nil
        mockContext = nil
        super.tearDown()
    }

    func test_save_with_valid_data() {
        let id = UUID()
        sut.saveCalorieItem(title: "TestTitle", id: id, calorieCount: 100, viewContext: mockContext)

        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        let items = try! mockContext.fetch(fetchRequest)

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, "TestTitle")
        XCTAssertEqual(items.first?.id, id)
        XCTAssertEqual(items.first?.calorieCount, 100)
    }

    func test_save_with_invalid_data() {
        
        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        let items = try! mockContext.fetch(fetchRequest)
        
        // Test with a nil or  "" title
        let resultNilTitle = sut.saveCalorieItem(title: nil, id: UUID(), calorieCount: 100, viewContext: mockContext)
        XCTAssertFalse(resultNilTitle.success)
        XCTAssertTrue(resultNilTitle.message.contains("The title cannot be nil."))

        let resultEmptyTitle = sut.saveCalorieItem(title: "", id: UUID(), calorieCount: 100, viewContext: mockContext)
        XCTAssertFalse(resultEmptyTitle.success)
        XCTAssertTrue(resultEmptyTitle.message.contains("The title cannot be empty."))

        //Ensure no item has been saved to the database in both title cases
        XCTAssertEqual(items.count, 0)
        
        //Test with a nil calorieCount
        let resultNilCalorieCount = sut.saveCalorieItem(title: "ValidTitle", id: UUID(), calorieCount: nil, viewContext: mockContext)
        XCTAssertFalse(resultNilCalorieCount.success)
        XCTAssertTrue(resultNilCalorieCount.message.contains("Calorie count cannot be nil."))

        //Test with a zero calorieCount
        let resultZeroCalorieCount = sut.saveCalorieItem(title: "ValidTitle", id: UUID(), calorieCount: 0, viewContext: mockContext)
        XCTAssertFalse(resultZeroCalorieCount.success)
        XCTAssertTrue(resultZeroCalorieCount.message.contains("Calorie count must be greater than zero."))

        //Test with a negative calorieCount
        let resultNegativeCalorieCount = sut.saveCalorieItem(title: "ValidTitle", id: UUID(), calorieCount: -100, viewContext: mockContext)
        XCTAssertFalse(resultNegativeCalorieCount.success)
        XCTAssertTrue(resultNegativeCalorieCount.message.contains("Calorie count must be greater than zero."))

        // Ensure no item has been saved to the database in calorie count cases
        XCTAssertEqual(items.count, 0)
        
        //Test with a nil title and nil calorieCount
        let resultNilTitleAndNilCalorieCount = sut.saveCalorieItem(title: nil, id: UUID(), calorieCount: nil, viewContext: mockContext)
        XCTAssertFalse(resultNilTitleAndNilCalorieCount.success)
        XCTAssertTrue(resultNilTitleAndNilCalorieCount.message.contains("The title cannot be nil."))
        XCTAssertTrue(resultNilTitleAndNilCalorieCount.message.contains("Calorie count cannot be nil."))

        //Test with an empty title and zero calorieCount
        let resultEmptyTitleAndZeroCalorieCount = sut.saveCalorieItem(title: "", id: UUID(), calorieCount: 0, viewContext: mockContext)
        XCTAssertFalse(resultEmptyTitleAndZeroCalorieCount.success)
        XCTAssertTrue(resultEmptyTitleAndZeroCalorieCount.message.contains("The title cannot be empty."))
        XCTAssertTrue(resultEmptyTitleAndZeroCalorieCount.message.contains("Calorie count must be greater than zero."))

        //Test with a nil title and negative calorieCount
        let resultNilTitleAndNegativeCalorieCount = sut.saveCalorieItem(title: nil, id: UUID(), calorieCount: -100, viewContext: mockContext)
        XCTAssertFalse(resultNilTitleAndNegativeCalorieCount.success)
        XCTAssertTrue(resultNilTitleAndNegativeCalorieCount.message.contains("The title cannot be nil."))
        XCTAssertTrue(resultNilTitleAndNegativeCalorieCount.message.contains("Calorie count must be greater than zero."))

        //Ensure no item has been saved to the database in all cases
        XCTAssertEqual(items.count, 0)
    }

    
    

    func testDeleteCalorieItem() {
        // Setup: Insert a sample item into the mock context
        let idToDelete = UUID()
        let calorieItem = CalorieItem(context: mockContext)
        calorieItem.id = idToDelete
        calorieItem.title = "SampleTitle"
        calorieItem.calorieCount = 100
        try! mockContext.save()

        // Initial check: Ensure item is in the context
        var fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", idToDelete as CVarArg)
        var items = try! mockContext.fetch(fetchRequest)
        XCTAssertEqual(items.count, 1)

        // Action: Delete the item
        sut.deleteCalorieItem(withId: idToDelete, from: mockContext)

        // Verify: Ensure item is no longer in the context
        fetchRequest = CalorieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", idToDelete as CVarArg)
        items = try! mockContext.fetch(fetchRequest)
        XCTAssertEqual(items.count, 0)
    }
    
    func test_update_with_invalid_data() {
        // Pre-setup: create a valid item to update
        let validId = UUID()
        sut.saveCalorieItem(title: "InitialValidTitle", id: validId, calorieCount: 123, viewContext: mockContext)
        
        // 1. Test with a nil title
        var result = sut.updateCalorieItem(withId: validId, title: nil, calorieCount: 100, viewContext: mockContext)
        XCTAssertFalse(result.success)
        XCTAssertTrue(result.message.contains("The title cannot be nil."))
        
        // 2. Test with an empty title
        result = sut.updateCalorieItem(withId: validId, title: "", calorieCount: 100, viewContext: mockContext)
        XCTAssertFalse(result.success)
        XCTAssertTrue(result.message.contains("The title cannot be empty."))

        // 3. Test with a nil calorieCount
        result = sut.updateCalorieItem(withId: validId, title: "ValidTitle", calorieCount: nil, viewContext: mockContext)
        XCTAssertFalse(result.success)
        XCTAssertTrue(result.message.contains("Calorie count cannot be nil."))

        // 4. Test with a zero calorieCount
        result = sut.updateCalorieItem(withId: validId, title: "ValidTitle", calorieCount: 0, viewContext: mockContext)
        XCTAssertFalse(result.success)
        XCTAssertTrue(result.message.contains("Calorie count must be greater than zero."))

        // 5. Test with a negative calorieCount
        result = sut.updateCalorieItem(withId: validId, title: "ValidTitle", calorieCount: -100, viewContext: mockContext)
        XCTAssertFalse(result.success)
        XCTAssertTrue(result.message.contains("Calorie count must be greater than zero."))

        // 6. Test with a nil title and nil calorieCount
        result = sut.updateCalorieItem(withId: validId, title: nil, calorieCount: nil, viewContext: mockContext)
        XCTAssertFalse(result.success)
        XCTAssertTrue(result.message.contains("The title cannot be nil."))
        XCTAssertTrue(result.message.contains("Calorie count cannot be nil."))

        // 7. Test with an empty title and zero calorieCount
        result = sut.updateCalorieItem(withId: validId, title: "", calorieCount: 0, viewContext: mockContext)
        XCTAssertFalse(result.success)
        XCTAssertTrue(result.message.contains("The title cannot be empty."))
        XCTAssertTrue(result.message.contains("Calorie count must be greater than zero."))

        // 8. Test with a nil title and negative calorieCount
        result = sut.updateCalorieItem(withId: validId, title: nil, calorieCount: -100, viewContext: mockContext)
        XCTAssertFalse(result.success)
        XCTAssertTrue(result.message.contains("The title cannot be nil."))
        XCTAssertTrue(result.message.contains("Calorie count must be greater than zero."))

        // Cleanup: remove the initially created item to ensure isolation of the test
        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        let items = try! mockContext.fetch(fetchRequest)
        for item in items {
            mockContext.delete(item)
        }
        try! mockContext.save()
    }

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
