//
//  ReselectGoalViewModel.swift
//  Learning
//
//  Created by Reem alghamdi on 01/05/1447 AH.
//

import Foundation
import Combine

class ReselectGoalViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var selectedDuration: Duration = .week
    @Published var showingConfirmationAlert = false
    
    var appState: AppState
    
    // Computed property for form validation
    var isFormValid: Bool {
        !name.isEmpty
    }
    
    init(appState: AppState) {
        self.appState = appState
        // Pre-fill the form with the current goal details
        self.name = appState.goal
        self.selectedDuration = appState.duration
    }
    
    // Logic to show the alert
    func confirmUpdate() {
        showingConfirmationAlert = true
    }
    
    // Logic to perform the update and dismiss
    func executeUpdate(dismissAction: () -> Void) {
        appState.startGoal(goal: name, duration: selectedDuration)
        dismissAction()
    }
}
