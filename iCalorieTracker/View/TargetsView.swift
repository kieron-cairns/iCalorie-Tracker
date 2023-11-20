//
//  TargetsView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 20/11/2023.
//

import SwiftUI

struct TargetsView: View {
    @Environment(\.colorScheme) var colorScheme

    
    @State private var calorieTitle: String = ""
    @State private var calorieCount: String = ""
    @State private var caloireQuantity: String = ""
    @State private var showErrorAlert = false
    @State private var errorMessage: ErrorMessage? = nil
    
    var body: some View {
        ZStack {
            Color.clear
            .edgesIgnoringSafeArea(.all)
        
            VStack(spacing: 20) {
                
                Text("Add New Item")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.custom("HelveticaNeue-Bold", size: 24))
                
                TextField("", text: $calorieTitle)
                    .placeholder(when: calorieTitle.isEmpty) {
                            Text("Enter Item Name:").foregroundColor(.gray)
                    }
                    .textFieldStyle(.plain)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .padding(10)
                    .background(lightGrayHexColor)
                    .cornerRadius(20)
                    .accessibilityIdentifier("calorieTitleTextField")

                HStack {
                    
                    TextField("", text: $calorieCount)
                        .placeholder(when: calorieCount.isEmpty) {
                            Text("Caloires:").foregroundColor(.gray)
                        }
                        .textFieldStyle(.plain)
                        .foregroundColor(.black)
                        .frame(height: 50)
                        .padding(10)
                        .background(lightGrayHexColor)
                        .cornerRadius(20)
                        .keyboardType(UIKeyboardType.decimalPad)
                        .accessibilityIdentifier("calorieCountTextField")
                    
                    TextField("", text: $caloireQuantity)
                        .placeholder(when: caloireQuantity.isEmpty) {
                                Text("Qunatity:").foregroundColor(.gray)
                        }
                        .textFieldStyle(.plain)
                        .foregroundColor(.black)
                        .frame(height: 50)
                        .padding(10)
                        .background(lightGrayHexColor)
                        .cornerRadius(20)
                        .keyboardType(UIKeyboardType.decimalPad)
                        .accessibilityIdentifier("calorieQuantityTextField")
                }

            }
                
            .padding(20)
            .cornerRadius(20)
            .background(colorScheme == .dark ? .white : .white)
        }
        

        .background(colorScheme == .dark ? .white : .white)
      
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
