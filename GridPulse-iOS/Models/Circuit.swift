import Foundation
import SwiftData

@Model
final class Circuit {
    @Attribute(.unique) var id: String
    var name: String
    var locality: String
    var country: String
    var latitude: Double
    var longitude: Double
    var circuitLength: String
    var laps: Int
    var lapRecord: String

    init(
        id: String,
        name: String,
        locality: String,
        country: String,
        latitude: Double,
        longitude: Double,
        circuitLength: String,
        laps: Int,
        lapRecord: String
    ) {
        self.id = id
        self.name = name
        self.locality = locality
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.circuitLength = circuitLength
        self.laps = laps
        self.lapRecord = lapRecord
    }

    var locationString: String {
        "\(locality), \(country)"
    }
}

// MARK: - DTO for Jolpica API decoding
struct CircuitDTO: Codable, Identifiable {
    let circuitId: String
    let url: String?
    let circuitName: String
    let location: LocationDTO

    var id: String { circuitId }

    struct LocationDTO: Codable {
        let lat: String
        let long: String
        let locality: String
        let country: String
    }
}

extension Circuit {
    convenience init(from dto: CircuitDTO) {
        self.init(
            id: dto.circuitId,
            name: dto.circuitName,
            locality: dto.location.locality,
            country: dto.location.country,
            latitude: Double(dto.location.lat) ?? 0,
            longitude: Double(dto.location.long) ?? 0,
            circuitLength: "",
            laps: 0,
            lapRecord: ""
        )
    }
}