import Foundation
import Observation

@MainActor @Observable
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

    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let driversTask = jolpica.fetchDriverStandings(season: selectedSeason)
            async let constructorsTask = jolpica.fetchConstructorStandings(season: selectedSeason)
            driverStandings = try await driversTask
            constructorStandings = try await constructorsTask
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func changeSeason(to year: Int) async {
        selectedSeason = year
        await loadData()
    }

    func refresh() async {
        await loadData()
    }
}