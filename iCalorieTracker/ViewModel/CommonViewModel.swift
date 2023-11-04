//
//  CommonViewModel.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 04/11/2023.
//

import Foundation
import UIKit
 
class CommonViewModel {
    
    
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}
