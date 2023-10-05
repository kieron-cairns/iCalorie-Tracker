//
//  ErrorMessage.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 05/10/2023.
//

import Foundation

struct ErrorMessage: Identifiable {
    let id = UUID()  // This gives the Identifiable conformance
    let message: String
}
