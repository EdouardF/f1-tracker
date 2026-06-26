import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable {
        case home = "Home"
        case schedule = "Schedule"
        case standings = "Standings"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .schedule: return "flag.checkered"
            case .standings: return "chart.bar.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: Tab.home.icon, value: Tab.home) {
                HomeView()
            }

            Tab("Schedule", systemImage: Tab.schedule.icon, value: Tab.schedule) {
                ScheduleView()
            }

            Tab("Standings", systemImage: Tab.standings.icon, value: Tab.standings) {
                StandingsTabView()
            }

            Tab("Settings", systemImage: Tab.settings.icon, value: Tab.settings) {
                SettingsView()
            }
        }
        #if compiler(>=6.2)
        .tabViewStyle(.glassTabView)
        #endif
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .modelContainer(for: [Driver.self, Constructor.self, Race.self, CacheEntry.self])
}