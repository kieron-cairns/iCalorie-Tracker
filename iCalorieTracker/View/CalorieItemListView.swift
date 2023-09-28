//
//  DayItemListView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 03/05/2023.
//

import SwiftUI
import CoreData


struct CalorieItemListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    @State private var title: String = "Passed from view to view model 2"
    @State private var message: String = ""
    @State private var showAddCalorieItemView = false
    @State private var showDateCalendar = false
    @State private var selectedItem: CalorieItem?
    @State private var isTappedCell = false

    
    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>
    
    var calorieItemListViewModel = CalorieItemListViewModel()
    let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()

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
                            Text(item.title ?? "Error loading")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.custom("Inter-Semibold", size: 17))
                                .frame(alignment: .leading)
                                .accessibilityIdentifier("calorieItemTitle")

                            
//                            Text(item.title ?? "Error loading")
                            Text("Description...")
                                .foregroundColor(colorScheme == .dark ? cellLightGrayHexColor : cellLightGrayHexColor)
                                .font(.custom("Inter-Regular", size: 15))
                                .frame(alignment: .leading)
                            
                        }
                        Spacer()
                        Text(String(item.calorieCount) ?? "Error loading")
                            .foregroundColor(.init(redHexColor))
                            .font(.custom("Inter-Regular", size: 23))
                            .accessibilityIdentifier("calorieItemCount")


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
                    .onTapGesture {
                        selectedItem = item
                        isTappedCell = true
                        showAddCalorieItemView = true
                    }
                }
//                .onDelete(perform: calorieItemListViewModel.deleteCalorieItems)
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let task = allCalorieItems[index]
                        viewContext.delete(task)
                        do {
                            try viewContext.save()
                            print("*** Item Deleted ***")

                            do {
                                let items = try viewContext.fetch(fetchRequest)
                                for item in items {
                                    print("******** New Item Added ******")
                                    print("ID: \(item.id ?? UUID()), Title: \(item.title ?? ""), CalorieCount: \(item.calorieCount)")
                                }
                            } catch {
                                print("Error fetching data: \(error)")
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }.accessibilityIdentifier("calorieList")
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
                        isTappedCell = false
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .accessibilityIdentifier("addCalorieItem")

                }
            }.sheet(isPresented: $showAddCalorieItemView) {
                AddCalorieItemView(isPresented: $showAddCalorieItemView, isTappedCell: $isTappedCell, item: selectedItem)
            }
            .sheet(isPresented: $showDateCalendar) {
                DateSelectionView(isPresented: $showDateCalendar)
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
