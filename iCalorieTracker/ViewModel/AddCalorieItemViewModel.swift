//
//  AddCalorieItemViewModel.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 28/09/2023.
//

import Foundation
import CoreData

class AddCalorieItemViewModel: ObservableObject {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func deleteItem(_ item: CalorieItem?) {
        guard let itemToDelete = item else { return }
        
        viewContext.delete(itemToDelete)
        do {
            try viewContext.save()
            print("*** Item Deleted ***")
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}
