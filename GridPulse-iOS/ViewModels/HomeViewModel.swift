import Foundation
import Observation

@Observable
final class HomeViewModel {
    var nextRace: Race?
    var recentResults: [RaceResult] = []
    var topDrivers: [DriverStanding] = []
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared
    private let openF1 = OpenF1Service.shared
    private let cache = CacheService.shared

    // MARK: - Load All Data
    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let nextRaceTask = loadNextRace()
            async let standingsTask = loadTopDrivers()
            async let resultsTask = loadRecentResults()

            try await nextRaceTask
            try await standingsTask
            try await resultsTask
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Next Race
    func loadNextRace() async throws {
        let races = try await cache.loadOrFetch([Race].self, forKey: CacheKey.currentSchedule(), ttl: .schedule) {
            try await self.jolpica.fetchCurrentSchedule()
        }

        // Find the next upcoming race
        let now = Date()
        nextRace = races
            .filter { $0.date > now }
            .min(by: { $0.date < $1.date })
    }

    // MARK: - Top Drivers
    func loadTopDrivers() async throws {
        let standings = try await cache.loadOrFetch([DriverStanding].self, forKey: CacheKey.driverStandings(season: 2026), ttl: .standings) {
            try await self.jolpica.fetchDriverStandings(season: 2026)
        }
        topDrivers = Array(standings.prefix(5))
    }

    // MARK: - Recent Results
    func loadRecentResults() async throws {
        let races = try await cache.loadOrFetch([Race].self, forKey: CacheKey.currentSchedule(), ttl: .schedule) {
            try await self.jolpica.fetchCurrentSchedule()
        }

        let now = Date()
        let pastRaces = races
            .filter { $0.date < now }
            .sorted { $0.date > $1.date }

        guard let lastRace = pastRaces.first else { return }

        recentResults = try await cache.loadOrFetch([RaceResult].self, forKey: CacheKey.raceResults(season: lastRace.season, round: lastRace.round), ttl: .sessionResult) {
            try await self.jolpica.fetchRaceResults(season: lastRace.season, round: lastRace.round)
        }
    }

    // MARK: - Refresh
    func refresh() async {
        try? cache.invalidateAll()
        await loadData()
    }
}