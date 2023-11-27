//
//  OnboardingTargetsView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 27/11/2023.
//

import SwiftUI
import HealthKit

struct OnboardingTargetsView: View {
    
//    @AppStorage("acknowledgedOnboarding") var acknowledgedOnboarding = false

    
    let healthStore = HKHealthStore()
    let userSettings = UserSettings()
    
    let healthKitAuthViewModel = HealthKitAuthorizationViewModel()
    let commonViewModel = CommonViewModel()
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            VStack {
                TargetsView()
                
                SaveTargetsButtonView()
                    .padding(.bottom, 150)
                
            }
        }.onTapGesture {
            commonViewModel.hideKeyboard()
        }
    }
}

struct OnboardingTargetsView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTargetsView()
    }
}
