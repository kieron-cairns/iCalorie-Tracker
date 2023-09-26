//
//  DayItemListView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 03/05/2023.
//

import SwiftUI

struct CalorieItemListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    @State private var title: String = "Passed from view to view model 2"
    @State private var message: String = ""
    @State private var showAddCalorieItemView = false
    @State private var showDateCalendar = false
    
    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>
    
    var calorieItemListViewModel = CalorieItemListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCalorieItems) { item in
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.init(orangePinHexColor))
                            .font(.system(size: 50))
                        
                        VStack(alignment: .leading){
//                            Text(item.title ?? "Error loading")
                            Text("Label")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.custom("Inter-Semibold", size: 17))
                                .frame(alignment: .leading)
                            
//                            Text(item.title ?? "Error loading")
                            Text("Description...")
                                .foregroundColor(colorScheme == .dark ? cellLightGrayHexColor : cellLightGrayHexColor)
                                .font(.custom("Inter-Regular", size: 15))
                                .frame(alignment: .leading)
                            
                        }
                        Spacer()
//                        Text(String(item.calorieCount))
                        Text("+200")
                            .foregroundColor(.init(redHexColor))
                            .font(.custom("Inter-Regular", size: 23))

                    }
                    .listRowBackground(colorScheme == .dark ? .black : backgroundLightModeColor)
                    .listRowSeparator(.hidden)
                    .padding(10)
                    .background(colorScheme == .dark ? .black : .white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(lightGrayHexColor, lineWidth: 1)
                    )
                    .shadow(radius: 5)
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
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(colorScheme == .dark ? .black : backgroundLightModeColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button(action: {
                        showDateCalendar = true
                    }) {
                        Text("Today")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showAddCalorieItemView = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }.sheet(isPresented: $showAddCalorieItemView) {
                AddCalorieItemView(isPresented: $showAddCalorieItemView)
            }

            .sheet(isPresented: $showDateCalendar) {
                                DateSelectionView()
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
