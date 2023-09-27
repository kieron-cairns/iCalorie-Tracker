//
//  AddCalorieItemView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 05/05/2023.
//

import SwiftUI

struct AddCalorieItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    @State private var calorieTitle: String = ""
    @State private var calorieCount: String = ""
    
    @Binding var isPresented: Bool
        
    var item: CalorieItem?
    var calorieItemListViewModel = CalorieItemListViewModel()
    
    var body: some View {
        ZStack {
            Color.clear
            .edgesIgnoringSafeArea(.all)
        
            VStack(spacing: 20) {
                
                Text("Add New Item")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.custom("HelveticaNeue-Bold", size: 24))

                TextField("Enter Item Name:", text: $calorieTitle)
                    .textFieldStyle(.plain)
                    .accessibilityIdentifier("calorieTitleTextField")
                    .frame(height: 50)
                    .padding(10)
                    .background(lightGrayHexColor)
                    .cornerRadius(20)
                    .multilineTextAlignment(.center)
                
                TextField("Enter Calorie Count:", text: $calorieCount)
                    .textFieldStyle(.plain)
                    .accessibilityIdentifier("calorieCountTextField")
                    .frame(height: 50)
                    .padding(10)
                    .background(lightGrayHexColor)
                    .cornerRadius(20)
                    .multilineTextAlignment(.center)

                HStack {
                    Button(action: {
                        calorieItemListViewModel.saveCalorieItem(title: calorieTitle, id: UUID(), calorieCount: Float(calorieCount) ?? 0.0, viewContext: viewContext)
                        self.isPresented = false
                    })
                    {
                        VStack{
                            Image(systemName: "minus.circle")
                                .resizable()
                                .scaledToFit()
                                .background(Color.red)
                                .foregroundColor(.black)
                                .font(.system(size: 50))
                                .frame( height: 50)
                        }
                            .frame(width: UIScreen.main.bounds.width / 2  - 40, height: 50)
                            .padding(10)
                            .background(Color.red)
                            .cornerRadius(20)

                    }

                    Spacer(minLength: 10)
                    Button(action: {
                        calorieItemListViewModel.saveCalorieItem(title: calorieTitle, id: UUID(), calorieCount: Float(calorieCount) ?? 0.0, viewContext: viewContext)
                        self.isPresented = false
                    }) {
                        VStack{
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .background(Color.green)
                                .foregroundColor(.black)
                                .font(.system(size: 50))
                                .frame( height: 50)
                        }
                            .frame(width: UIScreen.main.bounds.width / 2 - 40, height: 50)
                            .padding(10)
                            .background(Color.green)
                            .cornerRadius(20)

                    }
                }
            }
            .padding(20)
            .cornerRadius(20)
            .background(colorScheme == .dark ? .black : .white)
        }
        .background(colorScheme == .dark ? .black : .white)
        .onAppear {
               if let item = item {
                   calorieTitle = item.title ?? ""
                   calorieCount = String(item.calorieCount)
               }
           }
        
    }
}

struct AddCalorieItemView_Previews: PreviewProvider {
    @State static var dummyIsPresented = true

    static var previews: some View {
        AddCalorieItemView(isPresented: $dummyIsPresented)
    }
}

