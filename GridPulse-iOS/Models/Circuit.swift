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
    var url: String

    init(
        id: String,
        name: String,
        locality: String = "",
        country: String = "",
        latitude: Double = 0,
        longitude: Double = 0,
        url: String = ""
    ) {
        self.id = id
        self.name = name
        self.locality = locality
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
    }
}