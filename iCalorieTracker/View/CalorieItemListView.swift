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
    @State private var showAddCalorieItemView = false
    
    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>
    
    var calorieItemListViewModel = CalorieItemListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCalorieItems) { item in
                    Text(item.title ?? "Error loading")
                }
//                .onDelete(perform: calorieItemListViewModel.deleteCalorieItems)
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let task = allCalorieItems[index]
                        viewContext.delete(task)
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
                        showAddCalorieItemView = true
                        
                    })
                    {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }.sheet(isPresented: $showAddCalorieItemView) {
                AddCalorieItemView()
                    .presentationDetents([.medium, .medium])
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
