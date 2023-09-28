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

    func testSaveWithValidData() {
        let id = UUID()
        sut.saveCalorieItem(title: "TestTitle", id: id, calorieCount: 100, viewContext: mockContext)

        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        let items = try! mockContext.fetch(fetchRequest)

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, "TestTitle")
        XCTAssertEqual(items.first?.id, id)
        XCTAssertEqual(items.first?.calorieCount, 100)
    }

    func testSaveWithEmptyTitle() {
        let id = UUID()
        sut.saveCalorieItem(title: "", id: id, calorieCount: 100, viewContext: mockContext)

        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        let items = try! mockContext.fetch(fetchRequest)

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
0
        // Verify: Ensure item is no longer in the context
        fetchRequest = CalorieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", idToDelete as CVarArg)
        items = try! mockContext.fetch(fetchRequest)
        XCTAssertEqual(items.count, 0)
    }
    
    func testUpdateCalorieItem() {
        // Setup: Insert a sample item into the mock context
        let idToUpdate = UUID()
        let originalTitle = "OriginalTitle"
        let updatedTitle = "UpdatedTitle"
        let originalCount: Int32 = 100
        let updatedCount: Int32 = 200
        
        let calorieItem = CalorieItem(context: mockContext)
        calorieItem.id = idToUpdate
        calorieItem.title = originalTitle
        calorieItem.calorieCount = originalCount
        try! mockContext.save()

        // Initial check: Ensure item is in the context with original values
        var fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", idToUpdate as CVarArg)
        var items = try! mockContext.fetch(fetchRequest)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, originalTitle)
        XCTAssertEqual(items.first?.calorieCount, originalCount)

        // Action: Update the item
        sut.updateCalorieItem(withId: idToUpdate, title: updatedTitle, calorieCount: updatedCount, viewContext: mockContext)

        // Verify: Ensure item in the context has updated values
        fetchRequest = CalorieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", idToUpdate as CVarArg)
        items = try! mockContext.fetch(fetchRequest)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, updatedTitle)
        XCTAssertEqual(items.first?.calorieCount, updatedCount)
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
