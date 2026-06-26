import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "flag.checkered", value: 0) {
                HomeView()
            }

            Tab("Schedule", systemImage: "calendar", value: 1) {
                ScheduleView()
            }

            Tab("Standings", systemImage: "trophy.fill", value: 2) {
                StandingsTabView()
            }

            Tab("Settings", systemImage: "gearshape.fill", value: 3) {
                SettingsView()
            }
        }
        .tint(GridPulseTheme.accent)
    }
}

// MARK: - Standings Tab (with segmented control for Drivers / Constructors)
struct StandingsTabView: View {
    @State private var selectedSegment = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented picker
                Picker("Standings Type", selection: $selectedSegment) {
                    Text("Drivers").tag(0)
                    Text("Constructors").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, GridPulseTheme.paddingMedium)
                .padding(.vertical, GridPulseTheme.paddingSmall)

                // Content
                if selectedSegment == 0 {
                    DriverStandingsView()
                } else {
                    ConstructorStandingsView()
                }
            }
            .background(GridPulseTheme.background)
            .navigationTitle("Standings")
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}