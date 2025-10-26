//
//  GoalCreationFormView.swift
//  Learning
//
//  Created by Reem alghamdi on 01/05/1447 AH.
//

import SwiftUI

struct GoalCreationFormView: View {
    // Bindings to the parent view's state
    @Binding var goalText: String
    @Binding var selectedDuration: Duration

    var body: some View {
        // Group all the related inputs together
        VStack(alignment: .leading, spacing: 20) {
            
            // --- Goal Prompt and TextField ---
            VStack(alignment: .leading, spacing: 8) {
                Text("I want to learn")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                
                VStack(spacing: 0) {
                    // Use the 'goalText' binding
                    TextField("Swift", text: $goalText)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .background(Color.black)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.7))
                        .frame(height: 1)
                }
            }
            
            // --- Duration Prompt and Buttons ---
            VStack(alignment: .leading, spacing: 12) {
                Text("I want to learn it in a")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    // These functions now use the bindings
                    durationButton(.week)
                    durationButton(.month)
                    durationButton(.year)
                }
            }
        }
    }
    
    // --- This function is part of GoalCreationFormView ---
    @ViewBuilder
    private func durationButton(_ duration: Duration) -> some View {
        // 'selectedDuration' now refers to the @Binding
        let isSelected = selectedDuration == duration
        
        Button {
            withAnimation(.easeInOut(duration: 0.18)) {
                // This updates the @Binding, changing the state in the parent
                selectedDuration = duration
            }
        } label: {
            ZStack {
                if isSelected {
                    StyleGuide.selectedPill
                } else {
                    StyleGuide.unselectedPill
                }
                
                Text(duration.rawValue)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 97, height: 48)
            .contentShape(RoundedRectangle(cornerRadius: 1000, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(duration.rawValue))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
