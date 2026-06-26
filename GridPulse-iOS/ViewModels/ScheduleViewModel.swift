import Foundation
import Observation

@Observable
final class ScheduleViewModel {
    var races: [Race] = []
    var filteredRaces: [Race] = []
    var selectedSeason: Int = 2026
    var isLoading = false
    var errorMessage: String?

    private let jolpica = JolpicaService.shared
    private let cache = CacheService.shared

    // MARK: - Grouped Races
    var racesByMonth: [(String, [Race])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredRaces) { race in
            calendar.component(.month, from: race.date)
        }
        return grouped
            .sorted { $0.key < $1.key }
            .map { (month, races) in
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "fr_FR")
                formatter.dateFormat = "MMMM yyyy"
                let title = formatter.string(from: races.first?.date ?? Date())
                return (title.capitalized, races)
            }
    }

    // MARK: - Load Schedule
    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            races = try await cache.loadOrFetch(
                [Race].self,
                forKey: CacheKey.races(season: selectedSeason),
                ttl: .schedule
            ) {
                try await self.jolpica.fetchRaces(season: self.selectedSeason)
            }
            filterRaces()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Filter
    func filterRaces() {
        filteredRaces = races.sorted { $0.date < $1.date }
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