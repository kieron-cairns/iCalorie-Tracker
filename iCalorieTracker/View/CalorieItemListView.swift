//
//  DayItemListView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 03/05/2023.
//

import SwiftUI

struct CalorieItemListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var title: String = "Passed from view to view model 2"
    @State private var message: String = ""
    
    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>
    
    var calorieItemListViewModel = CalorieItemListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(allCalorieItems) { item in
                    Text(item.title ?? "Error loading")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
                        calorieItemListViewModel.saveCalorieItem(title: title ,viewContext: viewContext)
                        
                    })
                    {
                        
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
}



struct DayItemListView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedController = CoreDataManager.shared.persistentContainer

        CalorieItemListView().environment(\.managedObjectContext, persistedController.viewContext)
    }
}
