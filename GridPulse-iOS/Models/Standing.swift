import Foundation
import SwiftData

@Model
final class DriverStanding {
    @Attribute(.unique) var id: String
    var driverId: String
    var position: Int
    var points: Double
    var wins: Int
    var constructorId: String

    init(
        id: String,
        driverId: String,
        position: Int,
        points: Double,
        wins: Int,
        constructorId: String
    ) {
        self.id = id
        self.driverId = driverId
        self.position = position
        self.points = points
        self.wins = wins
        self.constructorId = constructorId
    }
}

@Model
final class ConstructorStanding {
    @Attribute(.unique) var id: String
    var constructorId: String
    var position: Int
    var points: Double
    var wins: Int

    init(
        id: String,
        constructorId: String,
        position: Int,
        points: Double,
        wins: Int
    ) {
        self.id = id
        self.constructorId = constructorId
        self.position = position
        self.points = points
        self.wins = wins
    }
}

// MARK: - Jolpica DTOs
struct DriverStandingsTableDTO: Codable {
    let standingsTable: StandingsTableDTO

    struct StandingsTableDTO: Codable {
        let season: String
        let standingsLists: [StandingsListDTO]
    }

    struct StandingsListDTO: Codable {
        let driverStandings: [DriverStandingDTO]
    }

    struct DriverStandingDTO: Codable {
        let position: String
        let positionText: String?
        let points: String
        let wins: String
        let driver: DriverDTO
        let constructors: [ConstructorDTO]
    }
}

struct ConstructorStandingsTableDTO: Codable {
    let standingsTable: StandingsTableDTO

    struct StandingsTableDTO: Codable {
        let season: String
        let standingsLists: [StandingsListDTO]
    }

    struct StandingsListDTO: Codable {
        let constructorStandings: [ConstructorStandingDTO]
    }

    struct ConstructorStandingDTO: Codable {
        let position: String
        let positionText: String?
        let points: String
        let wins: String
        let constructor: ConstructorDTO
    }
}

extension DriverStanding {
    convenience init(from dto: DriverStandingsTableDTO.DriverStandingDTO) {
        self.init(
            id: dto.driver.driverId,
            driverId: dto.driver.driverId,
            position: Int(dto.position) ?? 0,
            points: Double(dto.points) ?? 0,
            wins: Int(dto.wins) ?? 0,
            constructorId: dto.constructors.first?.constructorId ?? ""
        )
    }
}

extension ConstructorStanding {
    convenience init(from dto: ConstructorStandingsTableDTO.ConstructorStandingDTO) {
        self.init(
            id: dto.constructor.constructorId,
            constructorId: dto.constructor.constructorId,
            position: Int(dto.position) ?? 0,
            points: Double(dto.points) ?? 0,
            wins: Int(dto.wins) ?? 0
        )
    }
}