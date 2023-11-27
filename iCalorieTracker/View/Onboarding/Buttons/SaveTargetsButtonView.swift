//
//  SaveTargetsButtonView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 27/11/2023.
//

import SwiftUI
import HealthKit

struct SaveTargetsButtonView: View {
    
    let healthStore = HKHealthStore()
    let userSettings = UserSettings()
    let healthKitAuthViewModel = HealthKitAuthorizationViewModel()
    
    var body: some View {
        
        Button(action: {
            healthKitAuthViewModel.requestHealthKitAuthorization(healthStore: healthStore, userSettings: userSettings)
        }) {
            HStack(spacing: 8) {
              Text("Start")
              
              Image(systemName: "arrow.right.circle")
                .imageScale(.large)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 20)
            .background(
              Capsule().strokeBorder(Color.white, lineWidth: 1.25)
            )
          } //: BUTTON
          .accentColor(Color.white)
        }
    }

struct SaveTargetsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SaveTargetsButtonView()
    }
}
