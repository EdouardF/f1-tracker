import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("favoriteDriverId") private var favoriteDriverId = ""
    @AppStorage("selectedSeason") private var selectedSeason = 2026

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Notifications
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                            .foregroundStyle(.white)
                    }
                    .tint(GridPulseTheme.accent)
                } header: {
                    Text("RACE ALERTS")
                        .font(GridPulseTheme.caption)
                        .foregroundStyle(GridPulseTheme.accent)
                }

                // MARK: - Season
                Section {
                    Picker("Season", selection: $selectedSeason) {
                        ForEach(2020...2026, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .tint(GridPulseTheme.accent)
                } header: {
                    Text("SEASON")
                        .font(GridPulseTheme.caption)
                        .foregroundStyle(GridPulseTheme.accent)
                }

                // MARK: - Favorite Driver
                Section {
                    TextField("Favorite Driver ID", text: $favoriteDriverId)
                        .foregroundStyle(.white)
                        .tint(GridPulseTheme.accent)
                } header: {
                    Text("FAVORITE DRIVER")
                        .font(GridPulseTheme.caption)
                        .foregroundStyle(GridPulseTheme.accent)
                }

                // MARK: - About
                Section {
                    HStack {
                        Text("Version")
                            .foregroundStyle(.white)
                        Spacer()
                        Text("0.1.0")
                            .foregroundStyle(GridPulseTheme.mutedText)
                    }

                    HStack {
                        Text("Built with")
                            .foregroundStyle(.white)
                        Spacer()
                        Text("SwiftUI + Liquid Glass")
                            .foregroundStyle(GridPulseTheme.mutedText)
                    }

                    HStack {
                        Text("Data")
                            .foregroundStyle(.white)
                        Spacer()
                        Text("Jolpica F1 + OpenF1")
                            .foregroundStyle(GridPulseTheme.mutedText)
                    }
                } header: {
                    Text("ABOUT")
                        .font(GridPulseTheme.caption)
                        .foregroundStyle(GridPulseTheme.accent)
                }

                // MARK: - Links
                Section {
                    Link(destination: URL(string: "https://github.com/EdouardF/f1-tracker")!) {
                        Label("GitHub", systemImage: "swift")
                            .foregroundStyle(.white)
                    }

                    Link(destination: URL(string: "https://api.jolpica.com")!) {
                        Label("Jolpica F1 API", systemImage: "network")
                            .foregroundStyle(.white)
                    }

                    Link(destination: URL(string: "https://openf1.org")!) {
                        Label("OpenF1 API", systemImage: "network")
                            .foregroundStyle(.white)
                    }
                } header: {
                    Text("LINKS")
                        .font(GridPulseTheme.caption)
                        .foregroundStyle(GridPulseTheme.accent)
                }
            }
            .scrollContentBackground(.hidden)
            .background(GridPulseTheme.background)
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}