import SwiftUI

@main 
struct Learning_journeyApp: App {

    @StateObject var appState = AppState()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup { // The main window scene for your app
            MainView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                appState.enforceStreakRuleNow()
            }
        }
    }
}
struct MainView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isGoalActive {
            Logday(appState: appState)
        } else {
            ContentView(appState: appState)
        }
    }
}
