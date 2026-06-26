import Foundation
import SwiftData

@Model
final class Constructor {
    @Attribute(.unique) var id: String
    var name: String
    var fullName: String
    var nationality: String
    var color: String
    var colorSecondary: String

    init(
        id: String,
        name: String,
        fullName: String,
        nationality: String,
        color: String,
        colorSecondary: String
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.nationality = nationality
        self.color = color
        self.colorSecondary = colorSecondary
    }
}

// MARK: - DTO for Jolpica API decoding
struct ConstructorDTO: Codable, Identifiable {
    let constructorId: String
    let url: String?
    let name: String
    let nationality: String

    var id: String { constructorId }
}

extension Constructor {
    convenience init(from dto: ConstructorDTO, color: String = "#666666", colorSecondary: String = "#333333") {
        self.init(
            id: dto.constructorId,
            name: dto.name,
            fullName: dto.name,
            nationality: dto.nationality,
            color: color,
            colorSecondary: colorSecondary
        )
    }
}