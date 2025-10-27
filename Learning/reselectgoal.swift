import SwiftUI

struct reselectgoal: View {

    @Environment(\.dismiss) var dismiss
    
    // ✅ Add a regular property
    let appState: AppState
    
    // Use @StateObject for the ViewModel
    @StateObject private var viewModel: ReselectGoalViewModel
    
    init(appState: AppState) {
        self.appState = appState
        _viewModel = StateObject(wrappedValue: ReselectGoalViewModel(appState: appState))
    }

    var body: some View {
        NavigationStack {

                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            ZStack {
                                StyleGuide.graniteCircle
                                Image(systemName: "chevron.left")
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(Color.primary.opacity(0.90))
                            }
                        }
                        
                        Spacer()
                        Text("Learning Goal")
                            .foregroundColor(.primary)
                            .font(.system(size: 17, weight: .bold))
                        Spacer()
                        
                        Button {
                            if viewModel.isFormValid {
                                viewModel.confirmUpdate()
                            }
                        } label: {
                            ZStack {
                                StyleGuide.selectedPill
                                Image(systemName: "checkmark")
                                    .font(.title3.weight(.bold))
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .opacity(viewModel.isFormValid ? 1.0 : 0.5)
                        }
                        .disabled(!viewModel.isFormValid)
                    }
                    .padding(.top, 24)
                    
                    Spacer().frame(height: 34)
                    
                    GoalCreationFormView(
                        goalText: $viewModel.name,
                        selectedDuration: $viewModel.selectedDuration
                    )
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .alert("Update Learning goal", isPresented: $viewModel.showingConfirmationAlert) {
                Button("Dismiss", role: .cancel) { }
                Button("Update") {
                    viewModel.executeUpdate { dismiss() }
                }
            } message: {
                Text("If you update now, your streak will start over.")
            }
            .navigationBarHidden(true)
        }
    }

