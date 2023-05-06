//
//  AddCalorieItemView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 05/05/2023.
//

import SwiftUI

struct AddCalorieItemView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var calorieTitle: String = ""
    @State private var calorieCount: String = ""
    
    var calorieItemListViewModel = CalorieItemListViewModel()
    
    var body: some View {
        VStack(spacing: 20)
        {
            TextField("Enter Item Name:", text: $calorieTitle)
                .textFieldStyle(.plain)
                .accessibilityIdentifier("calorieTitleTextField")
            
            TextField("Enter Calorie Count:", text: $calorieCount)
                .textFieldStyle(.plain)
                .accessibilityIdentifier("calorieCountTextField")
            
            Button(action: {
                calorieItemListViewModel.saveCalorieItem(title: calorieTitle, viewContext: viewContext)
            })
            {
                Label("Add Item", systemImage: "plus")
            }
        }
    }
}

struct AddCalorieItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddCalorieItemView()
    }
}
