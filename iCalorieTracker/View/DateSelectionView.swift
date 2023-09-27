//
//  DateSelectionView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 08/05/2023.
//

import SwiftUI

struct DateSelectionView: View {
    @Binding var isPresented: Bool
    @State private var date = Date()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // The DatePicker
            DatePicker("Birth Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
            
            // The button at the top left
            Button(action: {
                isPresented = false
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: 30, height: 30)
                    
                    Text("X")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            .padding(.leading, 16)
            .padding(.top, -20)
        }
    }
}

struct DateSelectionView_Previews: PreviewProvider {
    
    @State static var mockIsPresented = true
    
    static var previews: some View {
        DateSelectionView(isPresented: $mockIsPresented)
    }
}
