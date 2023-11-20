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
    @State private var caloireQuantity: String = ""
    @State private var showErrorAlert = false
    @State private var errorMessage: ErrorMessage? = nil
    
    var commonViewModel = CommonViewModel()
    @Binding var isPresented: Bool
    @Binding var isTappedCell: Bool
//    @Binding var date: Date?
    
    var item: CalorieItem?
    var date: Date?
    var calorieItemListViewModel = CalorieItemListViewModel()
    
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

                HStack {
                    if isTappedCell
                    {
                        Button(action: {
                            if let itemId = item?.id { // Check if there's an ID from the tapped item
                                   calorieItemListViewModel.deleteCalorieItem(withId: itemId, from: viewContext)
                               }
                            self.isPresented = false
                        })
                        {
                            VStack{
                                Text("Delete Item")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            .frame(width: UIScreen.main.bounds.width / 2  - 40, height: 50)
                            .padding(10)
                            .background(Color.red)
                            .cornerRadius(20)
                            
                        }
                        .accessibilityIdentifier("deleteCalorieItemButton")
                        
                        Spacer(minLength: 10)
                    }
                    Button(action: {
                        let result: (success: Bool, message: String)
                        if isTappedCell, let itemId = item?.id {
                            // Assuming updateCalorieItem now returns (Bool, String) for consistency
                            result = calorieItemListViewModel.updateCalorieItem(withId: itemId, title: calorieTitle, calorieCount: Int32(calorieCount) ?? 0, viewContext: viewContext)
                        } else {
                            result = calorieItemListViewModel.saveCalorieItem(title: calorieTitle, id: UUID(), calorieCount: Int32(calorieCount) ?? 0, date: date, viewContext: viewContext)
                        }
                        
                        if result.success {
                            self.isPresented = false
                        } else {
                            errorMessage = ErrorMessage(message: result.message)
                        }
                    })
                    {
                        VStack{
                            if isTappedCell {
                                Text("Update Item")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            else
                            {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .background(Color.green)
                                    .foregroundColor(.black)
                                    .font(.system(size: 50))
                                    .frame( height: 50)
                            }
                        }
                            .frame(width: UIScreen.main.bounds.width / 2 - 40, height: 50)
                            .padding(10)
                            .background(Color.green)
                            .cornerRadius(20)

                    }
                    .accessibilityIdentifier("saveCalorieItemButton")
                }
            }
                
            .padding(20)
            .cornerRadius(20)
            .background(colorScheme == .dark ? .white : .white)
        }
        .onTapGesture {
            commonViewModel.hideKeyboard()
        }

        .background(colorScheme == .dark ? .white : .white)
        .onAppear {
               if let item = item {
                   calorieTitle = item.title ?? ""
                   calorieCount = String(item.calorieCount)
               }
           }
        .alert(item: $errorMessage) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}



struct AddCalorieItemView_Previews: PreviewProvider {
    @State static var dummyIsPresented = true
    @State static var dummyIsTappedCell = false
    
    let persistedController = CoreDataManager.shared.persistentContainer


    static var previews: some View {
        AddCalorieItemView(isPresented: $dummyIsPresented, isTappedCell: $dummyIsTappedCell)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

