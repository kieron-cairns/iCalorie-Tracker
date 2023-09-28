//
//  DayItemListViewModel.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 03/05/2023.
//

import Foundation
import SwiftUI
import CoreData

struct CalorieItemListViewModel {
    
    @State private var message: String = ""
    
    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //    private var items: FetchedResults<CalorieItem>
    
    func saveCalorieItem(title: String, id: UUID, calorieCount: Int32, viewContext: NSManagedObjectContext) {
        
        if title.isEmpty { return }
        
        do {
            if let _ = CalorieItem.by(id: id) {
                message = "This item has already been added. Do you want to add it again?"
            }
            else {
                let calorieItem = CalorieItem(context: viewContext)
                calorieItem.id = UUID()
                calorieItem.title = title
                calorieItem.calorieCount = calorieCount
                try viewContext.save()
                
                let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()
                do {
                    let items = try viewContext.fetch(fetchRequest)
                    for item in items {
                        print("******** New Item Added ******")
                        print("ID: \(item.id ?? UUID()), Title: \(item.title ?? ""), CalorieCount: \(item.calorieCount)")
                    }
                } catch {
                    print("Error fetching data: \(error)")
                }
            }
        } catch {
            print(error)
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
                } else {
                    print("Error: Item with the provided id not found")
                }
            } catch {
                print("Error deleting the item: \(error)")
            }
        }
}
