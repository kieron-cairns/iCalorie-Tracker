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
    @State private var dragOffset = CGSize.zero

    @Binding var selectedDate: Date
    @Binding var totCalCount: Int
        
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
        
        //Binding of bool in order for sheetIsPresented logic to work on iOS 12.0+
        let bindingShowAddCalorieItemView = Binding<Bool>(
            get: {
                self.showAddCalorieItemView
            },
            set: {
                self.showAddCalorieItemView = $0
                if !$0 {  // i.e., when the sheet is dismissed
                    totCalCount = allCalorieItems.reduce(0, {
                        $0 + Int($1.calorieCount)
                    })
                    print("bindingShowAddCalorieItemView set closure called, totCalCount updated to \(totCalCount)")

                }
            }
        )
        
        NavigationView {
            List {
                ForEach(allCalorieItems, id: \.self) { item in
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.init(orangePinHexColor))
                            .font(.system(size: 50))
                        
                        VStack(alignment: .leading){
                            Text(item.title ?? "Error loading")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.custom("Inter-Semibold", size: 17))
                                .frame(alignment: .leading)
                                .accessibilityIdentifier("calorieItemTitle")

//                            Text("Description...")
//                                .foregroundColor(colorScheme == .dark ? cellLightGrayHexColor : cellLightGrayHexColor)
//                                .font(.custom("Inter-Regular", size: 15))
//                                .frame(alignment: .leading)
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
                    .background(colorScheme == .dark ? Color(hex: "1C1B1D") : .white)
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

                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let task = allCalorieItems[index]
                        viewContext.delete(task)
                        do {
                            try viewContext.save()
                            print("*** Item Deleted ***")
                            
                            totCalCount = allCalorieItems.reduce(0, {
                                $0 + Int($1.calorieCount)
                            })
                            
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
//            .scrollContentBackground(.hidden)
            .background(colorScheme == .dark ? .black : backgroundLightModeColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                // Backward arrow button
                ToolbarItem {
                        Button(action: {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                            
                            totCalCount = allCalorieItems.reduce(0, {
                                $0 + Int($1.calorieCount)
                            })
                        }) {
                            Image(systemName: "arrow.left")
                        }.onChange(of: selectedDate) { _ in
                            showDateCalendar = false
                            print("*** Date Changed to \(selectedDate) ***")
                            
                            totCalCount = allCalorieItems.reduce(0, {
                                $0 + Int($1.calorieCount)
                            })
                        }.accessibilityIdentifier("backDateButton")
                    }
                
                ToolbarItem {
                    Button(action: {
                        showDateCalendar = true
                    }) {
                        Text(calorieItemListViewModel.dateButtonText(selectedDate: selectedDate))
                    }
                    .accessibilityIdentifier("dateButton")
                }
                
                // Forward arrow button
                ToolbarItem {
                    Button(action: {
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(calorieItemListViewModel.isToday(selectedDate: selectedDate) ? .gray : .blue)
                    }
                    .disabled(calorieItemListViewModel.isToday(selectedDate: selectedDate))
                    .onChange(of: selectedDate) { _ in
                        showDateCalendar = false
                        print("*** Date Changed to \(selectedDate) ***")
                        
                        totCalCount = allCalorieItems.reduce(0, {
                            $0 + Int($1.calorieCount)
                        })
                    }.accessibilityIdentifier("forwardDateButton")
                }

                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            
                            showAddCalorieItemView = true
                            isTappedCell = false
                        }

                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .accessibilityIdentifier("addCalorieItem")

                }
            }.overlay(
                Group {
                    if showAddCalorieItemView {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showAddCalorieItemView = false
                                }
                            }

                        AddCalorieItemView(isPresented: bindingShowAddCalorieItemView, isTappedCell: $isTappedCell, item: selectedItem)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                            .offset(y: max(0, self.dragOffset.height))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        self.dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        if self.dragOffset.height > 100 { // adjust this value as needed
                                            withAnimation {
                                                showAddCalorieItemView = false
                                            }
                                        }
                                        self.dragOffset = .zero
                                    }
                            )
                    }
                }
            )


            .sheet(isPresented: $showDateCalendar) {
                VStack {
                    DatePicker("Select a Date", selection: $selectedDate, in: calorieItemListViewModel.getCalendarDateRange(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .onChange(of: selectedDate) { _ in
                            showDateCalendar = false
                            print("*** Date Changed to \(selectedDate) ***")
                            
                            totCalCount = allCalorieItems.reduce(0, {
                                $0 + Int($1.calorieCount)
                            })
                        }
                        .accessibilityIdentifier("datePicker")
                }
            }
        }
    }
}

struct CalorieItemListView_Previews: PreviewProvider {
    @State static var mockDate = Date()
    @State static var mockTotalCalories = 0

    static var previews: some View {
        let persistedController = CoreDataManager.shared.persistentContainer

        CalorieItemListView(filter: mockDate, selectedDate: $mockDate, totCalCount: $mockTotalCalories)
            .environment(\.managedObjectContext, persistedController.viewContext)
    }
}
