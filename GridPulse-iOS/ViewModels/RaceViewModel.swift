import Foundation
import Observation

@Observable
final class RaceViewModel {
    var race: Race?
    var sessions: [Session] = []
    var grid: [OpenF1GridDTO] = []
    var results: [OpenF1ResultDTO] = []
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared
    private let openF1 = OpenF1Service.shared

    // MARK: - Load Race Weekend

    func loadRaceWeekend(raceId: String, season: Int = 2026) async {
        isLoading = true
        errorMessage = nil

        do {
            let races = try await jolpica.fetchRaceSchedule(season: season)
            race = races.first { $0.id == raceId }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Load Session Data

    func loadSessionData(sessionKey: Int) async {
        isLoading = true
        errorMessage = nil

        async let sessionsTask = openF1.fetchSessions(meetingKey: sessionKey)
        async let gridTask = openF1.fetchStartingGrid(sessionKey: sessionKey)
        async let resultsTask = openF1.fetchSessionResults(sessionKey: sessionKey)

        do {
            let (sessionsData, gridData, resultsData) = try await (
                sessionsTask, gridTask, resultsTask
            )
            self.sessions = sessionsData.map { Session(from: $0) }
            self.grid = gridData
            self.results = resultsData
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}