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

    // ... Similarly, other tests can be added.

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
