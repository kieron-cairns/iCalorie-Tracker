//
//  TargetsView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 20/11/2023.
//

import SwiftUI

struct TargetsView: View {

    @AppStorage("acknowledgedOnboarding") var acknowledgedOnboarding = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userSettings: UserSettings

    @State private var caloireQuantity: String = ""
    @State private var showErrorAlert = false
    @State private var errorMessage: ErrorMessage? = nil
    @State private var calIntakeTextField = ""
    @State private var calBurnTextField = ""
    @FocusState private var calIntakeTextFieldFocused: Bool

    var targetsViewModel = TargetsViewModel()
    
    var body: some View {
        ZStack {
            Color.clear
            .edgesIgnoringSafeArea(.all)
        
            VStack(spacing: 20) {
                
                Text("Targets")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.custom("HelveticaNeue-Bold", size: 24))
                
                
                if !acknowledgedOnboarding {
                    Text("Daily Calorie Intake Goal:")
                    TextField("0", text: $calIntakeTextField)

                        .onChange(of: calIntakeTextField) {  newValue in
                          
                            if let doubleValue = Double(calIntakeTextField) {
                                let roundedValue = Int(doubleValue.rounded())
                                
                                userSettings.dailyCalorieIntakeGoal = roundedValue
                            }
                            else
                            {
                                showErrorAlert = true
                            }
                          
                        }
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .padding(10)
                        .background(lightGrayHexColor)
                        .cornerRadius(20)
                        .keyboardType(UIKeyboardType.decimalPad)
                    
                    Text("Daily Caloire Burn Goal:")
                    TextField("0", text: $calBurnTextField)

                        .onChange(of: calBurnTextField) {  newValue in
                          
                            if let doubleValue = Double(calBurnTextField) {
                                let roundedValue = Int(doubleValue.rounded())
                                
                                userSettings.dailyCalorieBurnGoal = roundedValue
                            }
                            else
                            {
                                showErrorAlert = true
                            }
                          
                        }
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .padding(10)
                        .background(lightGrayHexColor)
                        .cornerRadius(20)
                        .keyboardType(UIKeyboardType.decimalPad)

                }
                else {
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
                        .keyboardType(UIKeyboardType.decimalPad)
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


