import Foundation
import Observation

@Observable
final class StandingsViewModel {
    var driverStandings: [DriverStanding] = []
    var constructorStandings: [ConstructorStanding] = []
    var selectedTab: StandingsTab = .drivers
    var selectedSeason: Int = 2026
    var isLoading = false
    var errorMessage: String?

    enum StandingsTab: String, CaseIterable {
        case drivers = "Drivers"
        case constructors = "Constructors"
    }

    private let jolpica = JolpicaService.shared
    private let cache = CacheService.shared

    // MARK: - Load Standings
    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let driversTask = loadDriverStandings()
            async let constructorsTask = loadConstructorStandings()
            try await driversTask
            try await constructorsTask
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func loadDriverStandings() async throws {
        driverStandings = try await cache.loadOrFetch(
            [DriverStanding].self,
            forKey: CacheKey.driverStandings(season: selectedSeason),
            ttl: .standings
        ) {
            try await self.jolpica.fetchDriverStandings(season: self.selectedSeason)
        }
    }

    private func loadConstructorStandings() async throws {
        constructorStandings = try await cache.loadOrFetch(
            [ConstructorStanding].self,
            forKey: CacheKey.constructorStandings(season: selectedSeason),
            ttl: .standings
        ) {
            try await self.jolpica.fetchConstructorStandings(season: self.selectedSeason)
        }
    }

    // MARK: - Driver Team Color
    func teamColor(for constructorId: String) -> Color {
        Color.teamColor(for: constructorId)
    }

    // MARK: - Change Season
    func changeSeason(to year: Int) async {
        selectedSeason = year
        await loadData()
    }

    // MARK: - Refresh
    func refresh() async {
        try? cache.invalidateAll()
        await loadData()
    }
}