import SwiftUI
import SwiftData

@main
struct GridPulseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Driver.self,
            Constructor.self,
            Circuit.self,
            Race.self,
            Session.self,
            DriverStanding.self,
            ConstructorStanding.self,
            LapData.self,
            CacheEntry.self
        ])
    }
}