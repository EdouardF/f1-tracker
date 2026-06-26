import Foundation
import Observation

@MainActor @Observable
final class HomeViewModel {
    var nextRace: Race?
    var topDrivers: [DriverStanding] = []
    var recentResults: [RaceResult] = []
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared

    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let racesTask = jolpica.fetchRaces(season: 2026)
            async let standingsTask = jolpica.fetchDriverStandings(season: 2026)

            let races = try await racesTask
            let standings = try await standingsTask

            self.nextRace = races.first
            self.topDrivers = Array(standings.prefix(5))
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refresh() async {
        await loadData()
    }
}