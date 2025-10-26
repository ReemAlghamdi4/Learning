import SwiftUI

@main // Marks this as the app's starting point
struct Learning_journeyApp: App {

    @StateObject var appState = AppState()
    @Environment(\.scenePhase) private var scenePhase

    // Defines the app's user interface structure
    var body: some Scene {
        WindowGroup { // The main window scene for your app
            MainView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                // Enforce the 32-hour rule whenever the app becomes active
                appState.enforceStreakRuleNow()
            }
        }
    }
}

