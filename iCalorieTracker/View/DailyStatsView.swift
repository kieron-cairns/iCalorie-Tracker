//
//  ContentView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 30/04/2023.
//

import SwiftUI
import CoreData

struct DailyStatsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    @State private var title: String = ""
    @State private var message: String = ""
    @State private var showAddCalorieItemView = false
    @State private var selectedDate = Date()
    @State private var totCalCount: Int = 0
    
    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>
    
    var dailyStatsViewModel = DailyStatsViewModel()
    var commonViewModel = CommonViewModel()
    
    var body: some View {
        GeometryReader { geometry in

            TabView {
                // Day Overview Tap
                VStack {
                    VStack(alignment: .leading) {
                        Text("\(dailyStatsViewModel.statsTitleText(selectedDate: selectedDate)) Stats")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.custom("HelveticaNeue-Bold", size: 24))
                            .padding(.top, 100)
                            .padding(.leading, 20)
                            .accessibilityIdentifier("statsTitle")
                        
                        Spacer(minLength: 10)

                        VStack {

                            //upper
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(String(totCalCount))
                                        .font(.custom("HelveticaNeue-Bold", size: 64))
                                        .foregroundColor(.init(orangeHexColor))
                                        .frame(alignment: .leading)
                                        .accessibilityIdentifier("totalCaloireCount")


                                    Text("Calories Consumed")
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(.custom("HelveticaNeue-Bold", size: 15))
                                        .frame(alignment: .leading)
                                }

                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("305")
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
                                    Text("+2095")
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
                                    Text("+350")
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
                        
                        //Stats view background colour
                        .background(colorScheme == .dark ? Color(hex: "1C1B1D") : .white)
                        .cornerRadius(20)
                        .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(lightGrayHexColor, lineWidth: 1)
                            )
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.33)

                    }
                    .onTapGesture {
                        commonViewModel.hideKeyboard()
                    }
                    .padding(.horizontal, 20)
                    
                    CalorieItemListView(filter: selectedDate, selectedDate: $selectedDate, totCalCount: $totCalCount)
                        .frame(height: geometry.size.height * 0.66).padding(.top, 5)
                }
                
                .tabItem {
                    Text("Day Overview")
                }
           
                //Below implementation is for adding a second screen and tab item
                TargetsView()
                SettingsView()
                .tabItem {
                    Text("Targets")
                }
                .tabItem{
                    Text("Settings")
                }
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

struct DailyStatsView_Previews: PreviewProvider {
    static var previews: some View {
        //        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        let persistedController = CoreDataManager.shared.persistentContainer
        DailyStatsView().environment(\.managedObjectContext, persistedController.viewContext)
    }
}
