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
    @Binding var selectedDate: Date
    @Binding var totCalCount: Int

    
//    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
//    private var allCalorieItems: FetchedResults<CalorieItem>
    
    @FetchRequest var allCalorieItems: FetchedResults<CalorieItem>

    init(filter: Date, selectedDate: Binding<Date>, totCalCount: Binding<Int>) {
        
        self._selectedDate = selectedDate
        self._totCalCount = totCalCount
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: filter)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = NSPredicate(format: "(dateCreated >= %@) AND (dateCreated < %@)", startOfDay as CVarArg, endOfDay as CVarArg)
        
        _allCalorieItems = FetchRequest<CalorieItem>(sortDescriptors: [], predicate: predicate)
    }
    
    var calorieItemListViewModel = CalorieItemListViewModel()
    let fetchRequest: NSFetchRequest<CalorieItem> = CalorieItem.fetchRequest()


    var body: some View {
        NavigationStack {
            List {
                ForEach(allCalorieItems, id: \.self) { item in
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
                .onAppear {
                            totCalCount = allCalorieItems.reduce(0, {
                                $0 + Int($1.calorieCount)
                            })
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
                    }.accessibilityIdentifier("dateButton")
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
//            .sheet(isPresented: $showDateCalendar, selectedDate: $selectedDate) {
//                DateSelectionView(isPresented: $showDateCalendar)
//                    .presentationDetents([.medium, .medium])
//            }
            .sheet(isPresented: $showDateCalendar) {
                            VStack {
                                DatePicker("Select a Date", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding()
                                    .onChange(of: selectedDate) { _ in
                                        showDateCalendar = false
                                    }
                            }
                        }
        }
    }
}

//struct DayItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let persistedController = CoreDataManager.shared.persistentContainer
//
//        CalorieItemListView().environment(\.managedObjectContext, persistedController.viewContext)
//    }
//}
