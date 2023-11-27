//
//  StartButtonView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 27/11/2023.
//

import SwiftUI

struct StartButtonView: View {
    
    @AppStorage("oboarding") var onboarding = true
    
    var body: some View {
        
        
        Button(action: {
            onboarding = false
            print("Onboading is: \(onboarding)")
        }) {
            HStack(spacing: 8) {
              Text("Start")
              
              Image(systemName: "arrow.right.circle")
                .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
              Capsule().strokeBorder(Color.white, lineWidth: 1.25)
            )
          } //: BUTTON
          .accentColor(Color.white)
        }
        
}

struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StartButtonView()
    }
}
