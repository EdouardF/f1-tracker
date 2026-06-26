import Foundation
import SwiftData

@Model
final class Driver {
    @Attribute(.unique) var id: String
    var number: Int
    var code: String
    var firstName: String
    var lastName: String
    var nationality: String
    var teamColor: String
    var constructorId: String

    init(
        id: String,
        number: Int,
        code: String,
        firstName: String,
        lastName: String,
        nationality: String,
        teamColor: String,
        constructorId: String
    ) {
        self.id = id
        self.number = number
        self.code = code
        self.firstName = firstName
        self.lastName = lastName
        self.nationality = nationality
        self.teamColor = teamColor
        self.constructorId = constructorId
    }

    var displayName: String {
        "\(firstName) \(lastName)"
    }

    var shortName: String {
        "\(code) — \(lastName)"
    }
}

// MARK: - DTO for API decoding
struct DriverDTO: Codable, Identifiable {
    let driverId: String
    let permanentNumber: String
    let code: String?
    let givenName: String
    let familyName: String
    let nationality: String
    let url: String?

    var id: String { driverId }
}

// MARK: - OpenF1 Driver DTO
struct OpenF1DriverDTO: Codable, Identifiable {
    let driverNumber: Int
    let firstName: String
    let lastName: String
    let countryCode: String
    let teamName: String
    let teamColour: String
    let headshotUrl: String?
    let broadcastName: String

    var id: String { String(driverNumber) }

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case teamName = "team_name"
        case teamColour = "team_colour"
        case headshotUrl = "headshot_url"
        case broadcastName = "broadcast_name"
    }
}

extension Driver {
    convenience init(from dto: OpenF1DriverDTO) {
        self.init(
            id: String(dto.driverNumber),
            number: dto.driverNumber,
            code: dto.broadcastName,
            firstName: dto.firstName,
            lastName: dto.lastName,
            nationality: dto.countryCode,
            teamColor: "#\(dto.teamColour)",
            constructorId: dto.teamName
        )
    }
}