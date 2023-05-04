//
//  DayItemListViewModel.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 03/05/2023.
//

import Foundation
import SwiftUI

struct DayItemListViewModel {
    
    @State private var title: String = ""
    @State private var message: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    var fetchRequest: FetchRequest<CalorieItem>
    
    
    private func saveCalorieItem() {
        
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
    
}
