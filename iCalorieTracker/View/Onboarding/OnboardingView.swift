//
//  HealthKitAuthorizationView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 26/11/2023.
//

import SwiftUI
import HealthKit

struct OnboardingView: View {
    
    @AppStorage("oboarding") var onboarding = true

    
    let healthStore = HKHealthStore()
    let userSettings = UserSettings()
    
    var onboardingCards: [OnboardingModel] = onboardingData
    
    let healthKitAuthViewModel = HealthKitAuthorizationViewModel()
    
    var body: some View {
//        ZStack {
//            Color(.black)
//                .ignoresSafeArea()

//            VStack {
//                Spacer()
//                Button(action: {
//
//                    onboarding = false
//                    print("Onboading is: \(onboarding)")
//                })
//                {
//                    Text("Continue From Onboarding")
//
//                }.background(.black)
//            }
            
            TabView {
                ForEach(onboardingCards[0...1]) { item in
                    OnboardingCardView(onboardingModel: item)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .padding(.vertical, 20)
            
        }
    }
//}

struct HealthKitAuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onboardingCards: onboardingData)
    }
}
