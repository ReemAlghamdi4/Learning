
import SwiftUI

@main // Marks this as the app's starting point
struct Learning_journeyApp: App {

    @StateObject var appState = AppState()

    // Defines the app's user interface structure
    var body: some Scene {
        WindowGroup { // The main window scene for your app
            MainView()
                .environmentObject(appState)
        }
    }
}
