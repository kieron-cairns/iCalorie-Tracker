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
    @Environment(\.colorScheme) var colorScheme

    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>

    @State private var title: String = ""
    @State private var message: String = ""

    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>

    var body: some View {
        GeometryReader { geometry in

            let totCalCount = allCalorieItems.reduce(0.0) { $0 + ($1.calorieCount) }
            TabView {
                // Day Overview Tap
                VStack {

                    Text("iCalorieTracker")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.custom("Inter-Bold", size: 16))
                        .padding(.top, geometry.safeAreaInsets.top)
                        .padding(.top, 30)

                    VStack(alignment: .leading) {
                        Text("Todays Stats")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.custom("HelveticaNeue-Bold", size: 24))
                            .padding(.leading, 20)

                        Spacer(minLength: 5)

                        VStack {

                            //upper
                            HStack {
                                VStack(alignment: .leading) {
//                                    Text(String(totCalCount))
                                    Text("1995")
                                        .font(.custom("HelveticaNeue-Bold", size: 64))
                                        .foregroundColor(.init(orangeHexColor))
                                        .frame(alignment: .leading)

                                    Text("Calories Consumed")
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(.custom("HelveticaNeue-Bold", size: 15))
                                        .frame(alignment: .leading)
                                }

                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("2305")
                                        .font(.custom("HelveticaNeue-Bold", size: 64))
                                        .foregroundColor(.init(orangeHexColor))
                                        .frame(alignment: .trailing)

                                    Text("Calories Burned")
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(.custom("HelveticaNeue-Bold", size: 15))
                                        .frame(alignment: .trailing)
                                }
                            }
                            .padding(10)

                            Spacer()

                            //lower
                            HStack {
                                VStack(alignment: .leading) {
//                                    Text(String(totCalCount))
                                    Text("+305")
                                        .font(.custom("HelveticaNeue-Bold", size: 48))
                                        .foregroundColor(.init(purpleHexColor))
                                        .frame(alignment: .leading)

                                    VStack(alignment: .leading) {
                                        Text("Calories remaining for")
                                        Text("today")
                                    }
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .font(.custom("HelveticaNeue-Bold", size: 15))
                                    .frame(alignment: .leading)
                                }

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("+200")
                                        .font(.custom("HelveticaNeue-Bold", size: 48))
                                        .foregroundColor(.init(redHexColor))
                                        .frame(alignment: .trailing)
                                    VStack(alignment: .trailing) {
                                        Text("Calories left to burn")
                                        Text("today")
                                    }
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .font(.custom("HelveticaNeue-Bold", size: 15))
                                    .frame(alignment: .trailing)
                                }
                            }
                            .padding(10)
                        }
                        .background(colorScheme == .dark ? .black : .white)
                        .cornerRadius(20)
                        .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(lightGrayHexColor, lineWidth: 1)
                            )
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.33)

                    }
                    .padding(.horizontal, 20)

                    CalorieItemListView().frame(height: geometry.size.height * 0.66)
                }.tabItem {
                    Text("Day Overview")
                }
                .background(colorScheme == .dark ? .black : backgroundLightModeColor)



                //Below implementation is for adding a second screen and tab item
                Text("Test Tab 2")
                    .tabItem {
                        Text("Track Item")
                    }
            }
        }
    }

    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }

    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        let persistedController = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistedController.viewContext)
    }
}
