//
//  SettingsView.swift
//  iCalorieTracker
//
//  Created by Kieron Cairns on 05/10/2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var isSwitchOn: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")

    var body: some View {
        List {
            Toggle(isOn: $isSwitchOn) {
                Text("Dark Mode")
            }
            .onChange(of: isSwitchOn) { newValue in
                UserDefaults.standard.set(newValue, forKey: "isDarkMode")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Settings")
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
