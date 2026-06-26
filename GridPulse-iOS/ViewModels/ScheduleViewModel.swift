import Foundation
import Observation

@MainActor @Observable
final class ScheduleViewModel {
    var races: [Race] = []
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared

    var racesByMonth: [(String, [Race])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: races) { race in
            calendar.component(.month, from: race.date)
        }
        let monthNames = calendar.monthSymbols
        return grouped
            .sorted { $0.key < $1.key }
            .map { (monthNames[$0.key - 1], $0.value) }
    }

    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            races = try await jolpica.fetchRaces(season: 2026)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refresh() async {
        await loadData()
    }
}