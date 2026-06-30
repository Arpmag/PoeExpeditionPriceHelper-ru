import SwiftUI

@main
struct SobrietyTrackerApp: App {
    @StateObject private var store = SobrietyStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
