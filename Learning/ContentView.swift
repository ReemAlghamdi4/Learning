import SwiftUI

struct ContentView: View {

    let appState: AppState
    
    // Use @StateObject for the ViewModel
    @StateObject private var viewModel: ContentViewModel
    
    let discSize: CGFloat = 109

    init(appState: AppState) {
        self.appState = appState
        _viewModel = StateObject(wrappedValue: ContentViewModel(appState: appState))
    }
    
    var body: some View {
        NavigationStack {

                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
                        Spacer()
                        headerIcon
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    Spacer().frame(height: 34)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello Learner")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("This app will help you learn everyday!")
                            .font(.system(size: 17))
                            .foregroundColor(.primary.opacity(0.6))
                    }
                    
                    Spacer().frame(height: 24)

                    GoalCreationFormView(
                        goalText: $viewModel.name,
                        selectedDuration: $viewModel.selectedDuration
                    )
                    
                    Spacer(minLength: 20)
                    
                    HStack {
                        Spacer()
                        Button {
                            viewModel.startGoal()
                        } label: {
                            ZStack {
                                StyleGuide.selectedPill
                                Text("Start learning")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 182, height: 48)
                            .contentShape(RoundedRectangle(cornerRadius: 1000, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }

    }
    
    // (headerIcon remains the same)
    private var headerIcon: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.black,
                            Color(red: 0, green: 0.05, blue: 0).opacity(0),
                            Color.orange.opacity(0.15)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: discSize / 2
                    )
                )
                .overlay(
                    Circle()
                        .strokeBorder(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    Color.orange.opacity(0.4),
                                    Color.orange.opacity(0.25),
                                    Color.black.opacity(0.8),
                                    Color.white.opacity(0.3),
                                    Color.orange.opacity(0),
                                    Color.orange.opacity(0.4)
                                ]),
                                center: .center
                            ),
                            lineWidth: 2
                        )
                )
                .frame(width: discSize, height: discSize)
                .shadow(color: Color.orange.opacity(0.25), radius: 20, x: 0, y: 10)
            
            Circle()
                .fill(Color.primary.opacity(1.20))
                .frame(width: discSize, height: discSize)
                .blur(radius: 0.25)
                .blendMode(.overlay)
                .mask(
                    Circle()
                        .padding(2)
                        .blendMode(.destinationOut)
                )
                .shadow(color: Color.primary.opacity(0.45), radius: 0.25, x: 2, y: 2)
            
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.orange)
                .frame(width: 67, height: 43)
        }
    }
}
