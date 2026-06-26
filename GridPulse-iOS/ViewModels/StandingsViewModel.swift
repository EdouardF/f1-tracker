import Foundation
import Observation

@Observable
final class StandingsViewModel {
    var driverStandings: [DriverStanding] = []
    var constructorStandings: [ConstructorStanding] = []
    var drivers: [Driver] = []
    var constructors: [Constructor] = []
    var isLoading = false
    var errorMessage: String?
    var selectedSeason: Int = 2026

    private let jolpica = JolpicaService.shared
    private let openF1 = OpenF1Service.shared

    // MARK: - Load Standings

    func loadStandings() async {
        isLoading = true
        errorMessage = nil

        async let driverTask = jolpica.fetchDriverStandings(season: selectedSeason)
        async let constructorTask = jolpica.fetchConstructorStandings(season: selectedSeason)
        async let driversTask = jolpica.fetchDrivers(season: selectedSeason)
        async let constructorsTask = jolpica.fetchConstructors(season: selectedSeason)

        do {
            let (driverResults, constructorResults, driversList, constructorsList) = try await (
                driverTask, constructorTask, driversTask, constructorsTask
            )
            self.driverStandings = driverResults
            self.constructorStandings = constructorResults
            self.drivers = driversList
            self.constructors = constructorsList
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Helpers

    func driverName(for driverId: String) -> String {
        drivers.first { $0.id == driverId }?.displayName ?? driverId
    }

    func constructorName(for constructorId: String) -> String {
        constructors.first { $0.id == constructorId }?.name ?? constructorId
    }

    func teamColor(for driverId: String) -> String {
        guard let standing = driverStandings.first(where: { $0.driverId == driverId }),
              let driver = drivers.first(where: { $0.id == driverId } ?? drivers.first(where: { $0.id == standing.driverId })) else {
            return "#666666"
        }
        return driver.teamColor
    }

    func teamColorHex(for constructorId: String) -> String {
        constructors.first { $0.id == constructorId }?.color ?? "#666666"
    }
}