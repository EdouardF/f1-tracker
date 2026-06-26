import Foundation
import SwiftData

@Model
final class Race {
    @Attribute(.unique) var id: String
    var name: String
    var circuitId: String
    var date: Date
    var season: Int
    var round: Int

    init(
        id: String,
        name: String,
        circuitId: String,
        date: Date,
        season: Int,
        round: Int
    ) {
        self.id = id
        self.name = name
        self.circuitId = circuitId
        self.date = date
        self.season = season
        self.round = round
    }

    var isUpcoming: Bool {
        date > Date()
    }
}

// MARK: - DTO for Jolpica API decoding
struct RaceDTO: Codable, Identifiable {
    let season: String
    let round: String
    let url: String?
    let raceName: String
    let circuit: CircuitDTO
    let date: String
    let time: String?

    var id: String { "\(season)-\(round)" }

    struct CircuitDTO: Codable {
        let circuitId: String
        let url: String?
        let circuitName: String
        let location: LocationDTO
    }

    struct LocationDTO: Codable {
        let lat: String
        let long: String
        let locality: String
        let country: String
    }
}

extension Race {
    convenience init(from dto: RaceDTO) {
        let dateString = dto.time != nil ? "\(dto.date)T\(dto.time!)" : dto.date
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let parsedDate = formatter.date(from: dateString) ?? Date.distantPast

        self.init(
            id: "\(dto.season)-\(dto.round)",
            name: dto.raceName,
            circuitId: dto.circuit.circuitId,
            date: parsedDate,
            season: Int(dto.season) ?? 2026,
            round: Int(dto.round) ?? 0
        )
    }
}