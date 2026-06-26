import Foundation
import Observation

@Observable
final class ScheduleViewModel {
    var races: [Race] = []
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared

    // MARK: - Load Schedule

    func loadSchedule(season: Int = 2026) async {
        isLoading = true
        errorMessage = nil

        do {
            races = try await jolpica.fetchRaceSchedule(season: season)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Grouped by Month

    var racesByMonth: [(String, [Race])] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let grouped = Dictionary(grouping: races) { race in
            formatter.string(from: race.date)
            formatter.dateFormat = "yyyy-MM"
            return formatter.string(from: race.date)
        }

        return grouped.sorted { $0.key < $1.key }
    }

    // MARK: - Past / Upcoming

    var pastRaces: [Race] {
        races.filter { $0.date < Date() }
    }

    var upcomingRaces: [Race] {
        races.filter { $0.date >= Date() }
    }

    var nextRace: Race? {
        upcomingRaces.sorted(by: { $0.date < $1.date }).first
    }
}