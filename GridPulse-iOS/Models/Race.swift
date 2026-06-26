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
}