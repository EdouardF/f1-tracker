import Foundation
import Observation

@MainActor @Observable
final class RaceViewModel {
    var race: Race?
    var results: [RaceResult] = []
    var grid: [GridPosition] = []
    var weather: [WeatherInfo] = []
    var raceControlMessages: [RaceControlMessage] = []
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared
    private let openF1 = OpenF1Service.shared

    func loadRaceDetail(raceId: String, season: Int, round: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            async let racesTask = jolpica.fetchRaces(season: season)
            async let resultsTask = jolpica.fetchRaceResults(season: season, round: round)

            let races = try await racesTask
            results = try await resultsTask

            if let found = races.first(where: { $0.round == round }) {
                race = found
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadGrid(sessionKey: Int) async {
        do {
            grid = try await openF1.fetchStartingGrid(sessionKey: sessionKey)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadWeather(sessionKey: Int) async {
        do {
            weather = try await openF1.fetchWeather(sessionKey: sessionKey)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadLaps(sessionKey: Int, driverNumber: Int? = nil) async {
        do {
            let laps = try await openF1.fetchLaps(sessionKey: sessionKey, driverNumber: driverNumber)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadRaceControl(sessionKey: Int) async {
        do {
            raceControlMessages = try await openF1.fetchRaceControl(sessionKey: sessionKey)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refresh(raceId: String, season: Int, round: Int) async {
        await loadRaceDetail(raceId: raceId, season: season, round: round)
    }
}