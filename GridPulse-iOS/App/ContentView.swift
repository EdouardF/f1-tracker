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
            HomeView()
                .tabItem {
                    Label(Tab.home.rawValue, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)

            ScheduleView()
                .tabItem {
                    Label(Tab.schedule.rawValue, systemImage: Tab.schedule.icon)
                }
                .tag(Tab.schedule)

            StandingsTabView()
                .tabItem {
                    Label(Tab.standings.rawValue, systemImage: Tab.standings.icon)
                }
                .tag(Tab.standings)

            SettingsView()
                .tabItem {
                    Label(Tab.settings.rawValue, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .modelContainer(for: [Driver.self, Constructor.self, Race.self, CacheEntry.self])
}