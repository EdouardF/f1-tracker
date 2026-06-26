import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""
    @State private var drivers: [DriverStanding] = []
    @State private var constructors: [ConstructorStanding] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let jolpica = JolpicaService.shared

    var body: some View {
        NavigationStack {
            List {
                if !filteredDrivers.isEmpty {
                    Section("Drivers") {
                        ForEach(filteredDrivers) { driver in
                            HStack(spacing: GridPulseSpacing.sm) {
                                PositionChip(position: driver.position, style: .circle)
                                TeamColorBadge(
                                    constructorId: driver.constructorId,
                                    driverCode: driverCode(for: driver),
                                    size: 28
                                )
                                Text(driver.driverId.replacingOccurrences(of: "_", with: " "))
                                    .font(GridPulseTypography.body)
                                    .foregroundStyle(.gridOnSurface)
                                Spacer()
                                Text("\(driver.points, specifier: "%.0f") pts")
                                    .font(GridPulseTypography.mono)
                                    .foregroundStyle(.gridOnSurfaceSecondary)
                            }
                        }
                    }
                }

                if !filteredConstructors.isEmpty {
                    Section("Teams") {
                        ForEach(filteredConstructors) { constructor in
                            HStack(spacing: GridPulseSpacing.sm) {
                                PositionChip(position: constructor.position, style: .circle)
                                Circle()
                                    .fill(Color.teamColor(for: constructor.constructorId))
                                    .frame(width: 24, height: 24)
                                Text(constructor.constructorId.replacingOccurrences(of: "_", with: " ").capitalized)
                                    .font(GridPulseTypography.body)
                                    .foregroundStyle(.gridOnSurface)
                                Spacer()
                                Text("\(constructor.points, specifier: "%.0f") pts")
                                    .font(GridPulseTypography.mono)
                                    .foregroundStyle(.gridOnSurfaceSecondary)
                            }
                        }
                    }
                }

                if searchText.isEmpty {
                    ContentUnavailableView(
                        "Search",
                        systemImage: "magnifyingglass",
                        description: Text("Search for drivers and teams")
                    )
                } else if filteredDrivers.isEmpty && filteredConstructors.isEmpty && !isLoading {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "person.crop.circle",
                        description: Text("No drivers or teams matching \"\(searchText)\"")
                    )
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.gridBackground)
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Driver or team name")
            .task {
                await loadData()
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    // MARK: - Data
    private func loadData() async {
        isLoading = true
        do {
            async let driversTask = jolpica.fetchDriverStandings(season: 2026)
            async let constructorsTask = jolpica.fetchConstructorStandings(season: 2026)
            drivers = try await driversTask
            constructors = try await constructorsTask
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Filtering
    private var filteredDrivers: [DriverStanding] {
        guard !searchText.isEmpty else { return [] }
        return drivers.filter {
            $0.driverId.lowercased().contains(searchText.lowercased()) ||
            $0.constructorId.lowercased().contains(searchText.lowercased())
        }
    }

    private var filteredConstructors: [ConstructorStanding] {
        guard !searchText.isEmpty else { return [] }
        return constructors.filter {
            $0.constructorId.lowercased().contains(searchText.lowercased())
        }
    }

    private func driverCode(for standing: DriverStanding) -> String {
        let parts = standing.driverId.split(separator: "_")
        if parts.count >= 2 {
            return String(parts[1]).prefix(3).uppercased().description
        }
        return String(standing.driverId.prefix(3)).uppercased()
    }
}

#Preview {
    SearchView()
        .modelContainer(for: [Driver.self, CacheEntry.self])
}