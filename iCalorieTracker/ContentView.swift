//
//  ContentView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 30/04/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    
    

    var body: some View {
        GeometryReader { geometry in
            
            TabView {
                
                VStack {
                    Text("First VStack")
                        .font(.title)
                        .padding(.bottom, -10)
                        .padding(.top, geometry.safeAreaInsets.top) // add safe area inset to top
                    VStack {
                       Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                Text("0")
                                Text("Calories Consumed")
                            }
                            VStack {
                                Text("0")
                                Text("Calories Burned")
                            }
                            Spacer()

                        }.frame(width: geometry.size.width - 25)
                        Spacer()
                    }.background(Color.white)
                    .cornerRadius(20)
                    .padding(10)
                    .frame( height: geometry.size.height * 0.33)
                    
                    
                    NavigationView {
                        List {
                            ForEach(items) { item in
                                NavigationLink {
                                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                } label: {
                                    Text(item.timestamp!, formatter: itemFormatter)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                            ToolbarItem {
                                Button(action: addItem) {
                                    Label("Add Item", systemImage: "plus")
                                }
                            }
                        }
                        Text("Select an item")
                    }.frame(height: geometry.size.height * 0.66)
                    
                }.tabItem {
                    Text("Day Overview")
                }.background(backgroundLightModeColor)
               
                
                //Below implementation is for adding a second screen and tab item
                Text("Test Tab 2").tabItem {
                    Text("Track Item")
                }
            }
        }
    }


    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
