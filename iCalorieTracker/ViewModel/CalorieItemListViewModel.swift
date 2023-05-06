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
    
    func saveCalorieItem(title: String, viewContext: NSManagedObjectContext) {
        
        if title.isEmpty {
            return
        }
        
        do {
            
            // see if calorie item is already added and confirm if user still wants to add the item
            
            if let _ = CalorieItem.by(title: title)
            {
                message = "This item has already been added. Do you want to add it again?"
            }
            else
            {
                let caloreItem = CalorieItem(context: viewContext)
                caloreItem.title = title
                
                try viewContext.save()
                
            }
        } catch {
            print(error)
        }
        
    }
    
    func deleteCalorieItems(offsets: IndexSet) {
        
//        var offsets: IndexSet = [0]
        
        withAnimation {
            offsets.map {
                allCalorieItems[$0]
            }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            }
            catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")            }
        }
    }
}
