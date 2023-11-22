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
    @EnvironmentObject var userSettings: UserSettings

    
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
    
    func isToday(selectedDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(selectedDate)
    }
    
    func getCalendarDateRange() -> ClosedRange<Date> {
        return Date(timeIntervalSinceReferenceDate: -123456789.0)...Date()
    }
    
    func saveCalorieItem(title: String?, id: UUID, calorieCount: Int32?, date: Date? ,viewContext: NSManagedObjectContext) -> (success: Bool, message: String) {
        
        
        // Initialize an array to store error messages
        var errorMessages: [String] = []
        
        // Check title validity
        if let title = title, title.isEmpty {
            errorMessages.append("The title cannot be empty.")
        } else if title == nil {
            errorMessages.append("The title cannot be nil.")
        }
        
        // Check calorieCount validity
        if let calorieCount = calorieCount, calorieCount <= 0 {
            errorMessages.append("Calorie count must be greater than zero.")
        } else if calorieCount == nil {
            errorMessages.append("Calorie count cannot be nil.")
        }
        
        // If there are error messages, return them combined
        if !errorMessages.isEmpty {
            return (false, errorMessages.joined(separator: " "))
        }

        let calorieItem = CalorieItem(context: viewContext)
        
        calorieItem.id = id
        calorieItem.title = title
        calorieItem.calorieCount = calorieCount!
        calorieItem.dateCreated = date
        
        do {
            try viewContext.save()
            logTableEntries(type: calorieItem.title!, viewContext: viewContext)
            
//            sumAllCaloreItems(viewContext: viewContext)
            
            return (true, "Item saved successfully with date of: \(date)")
        } catch {
            print("Error saving item: \(error)")
            return (false, "Error saving item.")
        }
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
    
    func updateCalorieItem(withId id: UUID, title: String?, calorieCount: Int32?, viewContext: NSManagedObjectContext) -> (success: Bool, message: String) {
        
        // Initialize an array to store error messages
        var errorMessages: [String] = []
        
        // Check title validity
        if let title = title, title.isEmpty {
            errorMessages.append("The title cannot be empty.")
        } else if title == nil {
            errorMessages.append("The title cannot be nil.")
        }
        
        // Check calorieCount validity
        if let calorieCount = calorieCount, calorieCount <= 0 {
            errorMessages.append("Calorie count must be greater than zero.")
        } else if calorieCount == nil {
            errorMessages.append("Calorie count cannot be nil.")
        }
        
        // If there are error messages, return them combined
        if !errorMessages.isEmpty {
            return (false, errorMessages.joined(separator: " "))
        }
        
        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let items = try viewContext.fetch(fetchRequest)
            if let itemToUpdate = items.first {
                itemToUpdate.title = title
                itemToUpdate.calorieCount = calorieCount!
                try viewContext.save()
                
                logTableEntries(type: "Updated", viewContext: viewContext)
                return (true, "Item updated successfully.")
            } else {
                print("Error: Item with the provided id not found")
                return (false, "Item with the provided id not found.")
            }
        } catch {
            print("Error updating the item: \(error)")
            return (false, "Error updating the item.")
        }
    }
    
    func fetchCaloireItem(withId id: UUID, viewContext: NSManagedObjectContext) -> CalorieItem?  {
        
        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            
            let items = try viewContext.fetch(fetchRequest)
            print(items)
            return items.first
            
        } catch let error {
            print("Failed to fetch calorie item: \(error)")
        }
        
        return nil
    }
    
    func fetchAllCalorieItems(viewContext: NSManagedObjectContext) -> [CalorieItem]? {
        
        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        // No predicate is set, so it fetches all items

        do {
            let caloireItems = try viewContext.fetch(fetchRequest)
            print(caloireItems)
            return caloireItems
        } catch let error {
            print("Failed to fetch calorie items: \(error)")
        }

        return nil
    }

    func sumAllCaloreItems(forDate date: Date, viewContext: NSManagedObjectContext) -> Int {
        
        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
        
        // Get the start and end of the given date
        let calendar = Calendar.current
        let dateStart = calendar.startOfDay(for: date)
        let dateEnd = calendar.date(byAdding: .day, value: 1, to: dateStart)?.addingTimeInterval(-1)

        // Create a predicate to fetch items from the given date
        let predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", dateStart as NSDate, dateEnd! as NSDate)
        fetchRequest.predicate = predicate
        
        var caloireCount = 0

        do {
            let caloireItems = try viewContext.fetch(fetchRequest)
            
            for item in caloireItems {
                caloireCount += Int(item.calorieCount)
            }
            
            print("Caloire count is: \(caloireCount)")
            
        } catch let error {
            print("Failed to fetch calorie items: \(error)")

        }
        
        return caloireCount
        
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
