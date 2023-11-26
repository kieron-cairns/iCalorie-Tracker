//
//  ContentView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 30/04/2023.
//

import SwiftUI
import CoreData
import HealthKit

struct DailyStatsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var showAddCalorieItemView = false
    @State private var selectedDate = Date()
    @State private var totCalCount: Int = 0
    @State private var totCalsRemainingCalc: Int = 0
    @State private var scale: CGFloat = 1.0
    @State private var calorieInfo: String = "Loading..."
    
    @FetchRequest(fetchRequest: CalorieItem.allCalorieItemsFetchRequest())
    private var allCalorieItems: FetchedResults<CalorieItem>
    
    @StateObject var dailyStatsViewModel = DailyStatsViewModel()
    var commonViewModel = CommonViewModel()
    var calorieItemListViewModel = CalorieItemListViewModel()
    let healthStore = HKHealthStore()

    //Below values are static for time being until HealthKit framework is implemented
    @State private var totCalsBurned: String = "Loading... "
    @State private var totRemainingCalsToBurn: Int = 350
    
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
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(String(totCalCount))
                                            .font(.custom("HelveticaNeue-Bold", size: 64))
                                            .foregroundColor(.init(orangeHexColor))
                                            .frame(alignment: .leading)
                                            .accessibilityIdentifier("totalCaloireCount")
                                            .scaleEffect(scale)
                                            .onChange(of: totCalCount) { _ in
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    self.scale = 1.5 // Scales up
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                        self.scale = 1.0 // Scales down to normal
                                                    }
                                                }
                                            }
                                        Text("Calories Consumed")
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .font(.custom("HelveticaNeue-Bold", size: 15))
                                            .frame(alignment: .leading)
                                    }
                                    
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text(dailyStatsViewModel.calorieInfo)
                                            .font(.custom("HelveticaNeue-Bold", size: 64))
                                            .foregroundColor(.init(orangeHexColor))
                                            .frame(alignment: .trailing)
                                            .scaleEffect(scale)
                                            .onAppear{
                                                
                                                dailyStatsViewModel.getCaloriesForDate(date: selectedDate)

                                            }
                                            .onChange(of: totCalsBurned) { _ in
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    self.scale = 1.5 // Scales up
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                        self.scale = 1.0 // Scales down to normal
                                                    }
                                                }
                                            }
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
                                        //Tot cals remaining for day goes in below text view
                                        
                                        if totCalsRemainingCalc >= 0 {
                                            
                                            Text("+" + String(totCalsRemainingCalc))
                                                .font(.custom("HelveticaNeue-Bold", size: 48))
                                                .foregroundColor(.init(purpleHexColor))
                                                .frame(alignment: .leading)
                                                .scaleEffect(scale)
                                                .onAppear {
                                                    totCalsRemainingCalc = userSettings.dailyCalorieIntakeGoal - calorieItemListViewModel.sumAllCaloreItems(forDate: selectedDate, viewContext: viewContext)
                                                }
                                                .onChange(of: totCalsRemainingCalc) { _ in
                                                    withAnimation(.easeInOut(duration: 0.5)) {
                                                        self.scale = 1.5 // Scales up
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                            self.scale = 1.0 // Scales down to normal
                                                        }
                                                    }
                                                }
                                        }
                                        else
                                        {
                                            Text("+" + String(totCalsRemainingCalc))
                                                .font(.custom("HelveticaNeue-Bold", size: 48))
                                                .foregroundColor(.init(redHexColor))
                                                .frame(alignment: .leading)
                                                .scaleEffect(scale)
                                                .onAppear {
                                                    totCalsRemainingCalc = userSettings.dailyCalorieIntakeGoal - calorieItemListViewModel.sumAllCaloreItems(forDate: selectedDate, viewContext: viewContext)
                                                }
                                                .onChange(of: totCalsRemainingCalc) { _ in
                                                    withAnimation(.easeInOut(duration: 0.5)) {
                                                        self.scale = 1.1 // Scales up
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                            self.scale = 1.0 // Scales down to normal
                                                        }
                                                    }
                                                }
                                        }
                                        
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
                                        Text("+" + String(totRemainingCalsToBurn))
                                            .font(.custom("HelveticaNeue-Bold", size: 48))
                                            .foregroundColor(.init(redHexColor))
                                            .frame(alignment: .trailing)
                                            .scaleEffect(scale)
                                            .onChange(of: totRemainingCalsToBurn) { _ in
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    self.scale = 1.1 // Scales up
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                        self.scale = 1.0 // Scales down to normal
                                                    }
                                                }
                                            }
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
                        
                        CalorieItemListView(filter: selectedDate, selectedDate: $selectedDate, totCalCount: $totCalCount, totCalsRemainingCalc: $totCalsRemainingCalc)
                            .frame(height: geometry.size.height * 0.66).padding(.top, 5)
                    }
                    
                    .tabItem {
                        Image(systemName: "sun.haze.fill")
                        Text("Daily Overview")
                    }
                    
                    //Below implementation is for adding a second screen and tab item
                    TargetsView()
                        .tabItem {
                            Image(systemName: "target")
                            Text("Targets")
                        }
                    SettingsView()
                        .tabItem{
                            Image(systemName: "gear")
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
