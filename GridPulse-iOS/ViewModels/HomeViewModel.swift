import Foundation
import Observation

@Observable
final class HomeViewModel {
    var nextRace: Race?
    var recentResults: [RaceResult] = []
    var driverStandings: [DriverStanding] = []
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared
    private let openF1 = OpenF1Service.shared
    private let cache = CacheService.shared

    // MARK: - Load All Data

    func loadAll() async {
        isLoading = true
        errorMessage = nil

        async let nextRaceTask = loadNextRace()
        async let standingsTask = loadStandings()

        do {
            _ = try await nextRaceTask
            _ = try await standingsTask
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Next Race

    func loadNextRace() async throws {
        do {
            let races = try await jolpica.fetchRaceSchedule(season: 2026)
            nextRace = races.filter { $0.date > Date() }.sorted(by: { $0.date < $1.date }).first
        } catch {
            throw error
        }
    }

    // MARK: - Standings Snapshot

    func loadStandings() async throws {
        do {
            driverStandings = try await jolpica.fetchDriverStandings(season: 2026)
        } catch {
            throw error
        }
    }

    // MARK: - Countdown

    var countdownString: String {
        guard let race = nextRace else { return "--:--:--" }
        let interval = race.date.timeIntervalSinceNow
        guard interval > 0 else { return "LIVE" }

        let hours = Int(interval) / 3600
        let minutes = Int(interval) % 3600 / 60
        let seconds = Int(interval) % 60

        if hours >= 24 {
            let days = hours / 24
            let remainingHours = hours % 24
            return "\(days)d \(remainingHours)h"
        }

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}