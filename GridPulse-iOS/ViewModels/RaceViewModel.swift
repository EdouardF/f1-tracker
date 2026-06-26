import Foundation
import Observation

@Observable
final class RaceViewModel {
    var race: Race?
    var sessions: [Session] = []
    var results: [SessionResult] = []
    var grid: [GridPosition] = []
    var laps: [LapData] = []
    var weather: [WeatherInfo] = []
    var raceControlMessages: [RaceControlMessage] = []
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared
    private let openF1 = OpenF1Service.shared
    private let cache = CacheService.shared

    // MARK: - Load Race Detail
    func loadRaceDetail(raceId: String, season: Int, round: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            async let racesTask = loadRace(season: season)
            async let resultsTask = loadResults(season: season, round: round)

            try await racesTask
            try await resultsTask

            // Try OpenF1 for live data if we have a session key
            if let sessionKey = sessions.first?.id.toInt() {
                async let gridTask = loadGrid(sessionKey: sessionKey)
                async let weatherTask = loadWeather(sessionKey: sessionKey)
                try await gridTask
                try await weatherTask
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Load Race
    private func loadRace(season: Int) async throws {
        let allRaces = try await cache.loadOrFetch(
            [Race].self,
            forKey: CacheKey.races(season: season),
            ttl: .schedule
        ) {
            try await self.jolpica.fetchRaces(season: season)
        }
        if let found = allRaces.first(where: { $0.season == season }) {
            race = found
        }
    }

    // MARK: - Load Results
    private func loadResults(season: Int, round: Int) async throws {
        results = try await cache.loadOrFetch(
            [RaceResult].self,
            forKey: CacheKey.raceResults(season: season, round: round),
            ttl: .sessionResult
        ) {
            try await self.jolpica.fetchRaceResults(season: season, round: round)
        }
    }

    // MARK: - Load Grid (OpenF1)
    private func loadGrid(sessionKey: Int) async throws {
        grid = try await openF1.fetchStartingGrid(sessionKey: sessionKey)
    }

    // MARK: - Load Weather (OpenF1)
    private func loadWeather(sessionKey: Int) async throws {
        weather = try await openF1.fetchWeather(sessionKey: sessionKey)
    }

    // MARK: - Load Laps (OpenF1)
    func loadLaps(sessionKey: Int, driverNumber: Int? = nil) async {
        do {
            laps = try await openF1.fetchLaps(sessionKey: sessionKey, driverNumber: driverNumber)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Load Race Control
    func loadRaceControl(sessionKey: Int) async {
        do {
            raceControlMessages = try await openF1.fetchRaceControl(sessionKey: sessionKey)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Refresh
    func refresh(raceId: String, season: Int, round: Int) async {
        try? cache.invalidateAll()
        await loadRaceDetail(raceId: raceId, season: season, round: round)
    }
}

// MARK: - Helper
extension String {
    func toInt() -> Int? { Int(self) }
}