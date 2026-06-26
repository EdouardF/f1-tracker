import SwiftUI
import SwiftData

@main
struct GridPulseApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                Driver.self,
                Constructor.self,
                Circuit.self,
                Race.self,
                Session.self,
                DriverStanding.self,
                ConstructorStanding.self,
                LapData.self,
                CacheEntry.self,
                FavoriteDriver.self,
                FavoriteConstructor.self
            ])
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if UserDefaults.standard.bool(forKey: "notificationsEnabled") {
                        await NotificationsManager.shared.requestAuthorization()
                    }
                }
        }
        .modelContainer(modelContainer)
    }
}