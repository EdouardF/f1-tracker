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