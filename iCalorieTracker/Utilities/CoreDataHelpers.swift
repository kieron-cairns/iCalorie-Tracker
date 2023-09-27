//
//  CoreDataHelpers.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 03/05/2023.
//

import Foundation
import CoreData

extension CalorieItem {
    
    static func allCalorieItemsFetchRequest() -> NSFetchRequest<CalorieItem> {
        let request: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        return request
    }
    
    static func by(id: UUID) -> CalorieItem? {
        let request: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let viewContext = CoreDataManager.shared.persistentContainer.viewContext
        do {
            let task = try viewContext.fetch(request).first
            return task
        } catch {
            return nil
        }
    }
}
