import SwiftUI
import SwiftData

@Model
final class FavoriteDriver {
    @Attribute(.unique) var driverId: String
    var constructorId: String
    var driverCode: String
    var addedAt: Date

    init(driverId: String, constructorId: String, driverCode: String) {
        self.driverId = driverId
        self.constructorId = constructorId
        self.driverCode = driverCode
        self.addedAt = Date()
    }
}

@Model
final class FavoriteConstructor {
    @Attribute(.unique) var constructorId: String
    var addedAt: Date

    init(constructorId: String) {
        self.constructorId = constructorId
        self.addedAt = Date()
    }
}