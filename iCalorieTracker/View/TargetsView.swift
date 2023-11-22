//
//  TargetsView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 20/11/2023.
//

import SwiftUI

struct TargetsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userSettings: UserSettings

        
    @State private var calorieTitle: String = ""
    @State private var calorieCount: String = ""
    @State private var caloireQuantity: String = ""
    @State private var showErrorAlert = false
    @State private var errorMessage: ErrorMessage? = nil
    
    var targetsViewModel = TargetsViewModel()
    
    var body: some View {
        ZStack {
            Color.clear
            .edgesIgnoringSafeArea(.all)
        
            VStack(spacing: 20) {
                
                Text("Targets")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.custom("HelveticaNeue-Bold", size: 24))
                
                Text("Daily Calorie Intake Goal:")
                TextField("", value: $userSettings.dailyCalorieIntakeGoal, formatter: NumberFormatter())
                
                    .onChange(of: userSettings.dailyCalorieIntakeGoal) { newValue in
                        
                        userSettings.dailyCalorieIntakeGoal = targetsViewModel.roundToInt(Double(newValue))
                    }
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .padding(10)
                    .background(lightGrayHexColor)
                    .cornerRadius(20)
                    .accessibilityIdentifier("targetCalorieIntakeTextField")
                
                Text("Daily Caloire Burn Goal:")
                TextField("", value: $userSettings.dailyCalorieBurnGoal, formatter: NumberFormatter())
                
                    .onChange(of: userSettings.dailyCalorieBurnGoal) { newValue in
                        
                        userSettings.dailyCalorieBurnGoal = targetsViewModel.roundToInt(Double(newValue))
                    }
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .padding(10)
                    .background(lightGrayHexColor)
                    .cornerRadius(20)
                    .keyboardType(UIKeyboardType.decimalPad)
                    .accessibilityIdentifier("targetCalorieBurnTextField")
            }

            .padding(20)
            .cornerRadius(20)
        }
        

      
        .alert(item: $errorMessage) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }

}

struct TargetsView_Previews: PreviewProvider {
    static var previews: some View {
        TargetsView()
    }
}


