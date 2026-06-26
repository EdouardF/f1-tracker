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