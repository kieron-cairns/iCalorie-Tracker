//
//  CoreDataManager.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 03/05/2023.
//

import Foundation
import CoreData

public class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    init() {
        persistentContainer = NSPersistentContainer(name: "iCalorieTrackerAppModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }    
}
