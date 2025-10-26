//
//  ContentViewModel.swift
//  Learning
//
//  Created by Reem alghamdi on 01/05/1447 AH.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    // This state is temporary, for the form
    @Published var name: String = ""
    @Published var selectedDuration: Duration = .week
    
    // A reference to the main app data
    var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    // The logic for the "Start" button
    func startGoal() {
        appState.startGoal(goal: name, duration: selectedDuration)
    }
}
