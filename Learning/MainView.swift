import SwiftUI

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
