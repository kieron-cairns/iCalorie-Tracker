//
//  DayItemListViewModel.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 03/05/2023.
//

import Foundation
import SwiftUI
import CoreData

class CalorieItemListViewModel: ObservableObject {
    
    @State private var message: String = ""
    
    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>
    @Environment(\.managedObjectContext) private var viewContext
    
    func dateButtonText(selectedDate: Date) -> String {
        let today = Date()
        let calendar = Calendar.current

        // Calculate the difference in days
        let daysDiff = calendar.dateComponents([.day], from: selectedDate, to: today).day ?? 0

        switch daysDiff {
        case 0:
            return "Today"
        case 1:
            return "Yesterday"
        default:
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter.string(from: selectedDate)
        }
    }
    
    func saveCalorieItem(title: String, id: UUID, calorieCount: Int32, viewContext: NSManagedObjectContext) {
        
        if title.isEmpty { return }
        
        let calorieItem = CalorieItem(context: viewContext)
        
        calorieItem.id = id
        calorieItem.title = title
        calorieItem.calorieCount = calorieCount
        calorieItem.dateCreated = Date()
        
        try? viewContext.save()
        
//        do {
//            if let _ = CalorieItem.by(id: id) {
//                message = "This item has already been added. Do you want to add it again?"
//            }
//            else {
//                let calorieItem = CalorieItem(context: viewContext)
//                calorieItem.id = id
//                calorieItem.title = title
//                calorieItem.calorieCount = calorieCount
//                try viewContext.save()
//
//                logTableEntries(type: "Added", viewContext: viewContext)
//
//            }
//        } catch {
//            print(error)
//        }
    }
    
    func deleteCalorieItem(withId id: UUID, from viewContext: NSManagedObjectContext) {
            let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let items = try viewContext.fetch(fetchRequest)
                if let itemToDelete = items.first {
                    viewContext.delete(itemToDelete)
                    try viewContext.save()
                    
                    logTableEntries(type: "Deleted", viewContext: viewContext)

                    
                } else {
                    print("Error: Item with the provided id not found")
                }
            } catch {
                print("Error deleting the item: \(error)")
            }
        }
    
    func updateCalorieItem(withId id: UUID, title: String, calorieCount: Int32, viewContext: NSManagedObjectContext) {
            let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let items = try viewContext.fetch(fetchRequest)
                if let itemToUpdate = items.first {
                    itemToUpdate.title = title
                    itemToUpdate.calorieCount = calorieCount
                    try viewContext.save()
                    
                    logTableEntries(type: "Updated", viewContext: viewContext)
                    
                } else {
                    print("Error: Item with the provided id not found")
                }
            } catch {
                print("Error updating the item: \(error)")
            }
        }
    
    func logTableEntries(type: String, viewContext: NSManagedObjectContext) {
        
        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        do {
            let items = try viewContext.fetch(fetchRequest)
            for item in items {
                print("******** Item \(type) ******")
                print("ID: \(item.id ?? UUID()), Title: \(item.title ?? ""), CalorieCount: \(item.calorieCount)")
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
    }
}
