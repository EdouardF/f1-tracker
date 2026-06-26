import Foundation
import SwiftData

@Model
final class Constructor {
    @Attribute(.unique) var id: String
    var name: String
    var fullName: String
    var nationality: String
    var url: String
    var color: String
    var colorSecondary: String

    init(
        id: String,
        name: String,
        fullName: String = "",
        nationality: String = "",
        url: String = "",
        color: String = "#666666",
        colorSecondary: String = "#333333"
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.nationality = nationality
        self.url = url
        self.color = color
        self.colorSecondary = colorSecondary
    }
}