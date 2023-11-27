//
//  OnboardingCardView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 27/11/2023.
//

import SwiftUI

struct OnboardingCardView: View {
    
    var onboardingModel: OnboardingModel
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
      ZStack {
        VStack(spacing: 20) {
          // FRUIT: IMAGE
          Image(onboardingModel.image)
            .resizable()
            .scaledToFit()
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
            .scaleEffect(isAnimating ? 1.0 : 0.6)
          
          // FRUIT: TITLE
          Text(onboardingModel.title)
            .foregroundColor(Color.white)
            .font(.largeTitle)
            .fontWeight(.heavy)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
          
          // FRUIT: HEADLINE
          Text(onboardingModel.headline)
            .foregroundColor(Color.white)
            .font(.system(size: 20))
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .frame(maxWidth: 480)
          
          // BUTTON: START
          GoToTargetsButtonView()
        } //: VSTACK
      } //: ZSTACK
      .onAppear {
        withAnimation(.easeOut(duration: 0.5)) {
          isAnimating = true
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
      .background(LinearGradient(gradient: Gradient(colors: onboardingModel.gradientColors), startPoint: .top, endPoint: .bottom))
      .cornerRadius(20)
      .padding(.horizontal, 20)
    }
  }


struct OnboardingCardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCardView(onboardingModel: onboardingData[0])
            .previewLayout(.fixed(width: 320, height: 640))
    }
}
