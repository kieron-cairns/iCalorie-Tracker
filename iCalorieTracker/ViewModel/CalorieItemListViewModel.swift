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
    
    func saveCalorieItem(title: String, id: UUID, calorieCount: Float, viewContext: NSManagedObjectContext) {
        
        if title.isEmpty {
            return
        }
        
        do {
            
            if let _ = CalorieItem.by(id: id)
            {
                message = "This item has already been added. Do you want to add it again?"
            }
            else
            {
                let calorieItem = CalorieItem(context: viewContext)
                calorieItem.id = UUID()
                calorieItem.title = title
                calorieItem.calorieCount = calorieCount
                
                try viewContext.save()
                
            }
        } catch {
            print(error)
        }
        
    }
    
//    func deleteCalorieItems(offsets: IndexSet) {
//        print("*** Offsets: \(offsets) *****")
//        
//        
//        let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.allCalorieItemsFetchRequest()
//        
//        print(fetchRequest)
//        
//        do {
//            viewContext.save()
//        }
//    }
}
