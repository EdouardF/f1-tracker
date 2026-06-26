import SwiftUI

struct SettingsView: View {
    @AppStorage("favoriteDriverId") private var favoriteDriverId: String = ""
    @AppStorage("favoriteConstructorId") private var favoriteConstructorId: String = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("raceStartNotifications") private var raceStartNotifications: Bool = true
    @AppStorage("resultsNotifications") private var resultsNotifications: Bool = true
    @AppStorage("selectedSeason") private var selectedSeason: Int = 2026

    var body: some View {
        NavigationStack {
            Form {
                // Notifications
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .tint(.gridAccent)

                    if notificationsEnabled {
                        Toggle("Race Start Alerts", isOn: $raceStartNotifications)
                            .tint(.gridAccent)
                        Toggle("Results Alerts", isOn: $resultsNotifications)
                            .tint(.gridAccent)
                    }
                }

                // Favorites
                Section("Favorites") {
                    TextField("Favorite Driver ID", text: $favoriteDriverId)
                        .foregroundStyle(.gridOnSurface)
                    TextField("Favorite Constructor ID", text: $favoriteConstructorId)
                        .foregroundStyle(.gridOnSurface)
                }

                // Season
                Section("Season") {
                    Stepper("Season: \(selectedSeason)", value: $selectedSeason, in: 2020...2030)
                        .foregroundStyle(.gridOnSurface)
                }

                // About
                Section("About") {
                    HStack {
                        Text("GridPulse")
                            .font(GridPulseTypography.cardTitle)
                        Spacer()
                        Text("v0.1.0")
                            .font(GridPulseTypography.caption)
                            .foregroundStyle(.gridOnSurfaceSecondary)
                    }

                    Text("F1 tracker — le pulse du départ")
                        .font(GridPulseTypography.caption)
                        .foregroundStyle(.gridOnSurfaceSecondary)

                    Link("Jolpica F1 API", destination: URL(string: "https://api.jolpica.com")!)
                        .font(GridPulseTypography.caption)

                    Link("OpenF1 API", destination: URL(string: "https://openf1.org")!)
                        .font(GridPulseTypography.caption)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.gridBackground)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}