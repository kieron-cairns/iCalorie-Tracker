//
//  DateSelectionView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 08/05/2023.
//

import SwiftUI

struct DateSelectionView: View {
     
    @State private var date = Date()
    @Binding var isPresented: Bool
    
    var body: some View {
          DatePicker("Birth Date", selection: $date, displayedComponents: .date)
              .datePickerStyle(GraphicalDatePickerStyle())
              .labelsHidden()
              .onChange(of: date) { newDate in
                  print("Selected date: \(newDate)")
                  isPresented = false
              }
      }
  }

struct DateSelectionView_Previews: PreviewProvider {
    
    @State static var mockIsPresented = true
    
    static var previews: some View {
        DateSelectionView(isPresented: $mockIsPresented)
    }
}
