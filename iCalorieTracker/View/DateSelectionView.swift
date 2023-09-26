//
//  DateSelectionView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 08/05/2023.
//

import SwiftUI

struct DateSelectionView: View {
     
    @State private var date = Date()
    
    var body: some View {
        DatePicker("Birth Date", selection: $date, displayedComponents: .date)
                                   .datePickerStyle(GraphicalDatePickerStyle())
                                   .labelsHidden()    }
}

struct DateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DateSelectionView()
    }
}
