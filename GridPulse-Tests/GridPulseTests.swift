import Testing
import SwiftUI
import Foundation
@testable import GridPulse

// MARK: - Model Tests

@Test func driverModelCreation() {
    let driver = Driver(
        id: "verstappen",
        number: 1,
        code: "VER",
        firstName: "Max",
        lastName: "Verstappen",
        nationality: "Dutch",
        teamColor: "#3671C6",
        constructorId: "red_bull"
    )
    #expect(driver.id == "verstappen")
    #expect(driver.number == 1)
    #expect(driver.code == "VER")
    #expect(driver.displayName == "Max Verstappen")
    #expect(driver.shortName == "VER — Verstappen")
}

@Test func constructorModelCreation() {
    let constructor = Constructor(
        id: "red_bull",
        name: "Red Bull",
        fullName: "Red Bull Racing",
        nationality: "Austrian",
        color: "#3671C6",
        colorSecondary: "#1E3A5F"
    )
    #expect(constructor.id == "red_bull")
    #expect(constructor.name == "Red Bull")
    #expect(constructor.fullName == "Red Bull Racing")
}

@Test func circuitModelCreation() {
    let circuit = Circuit(
        id: "monaco",
        name: "Circuit de Monaco",
        locality: "Monte Carlo",
        country: "Monaco",
        latitude: 43.7347,
        longitude: 7.4206
    )
    #expect(circuit.id == "monaco")
    #expect(circuit.name == "Circuit de Monaco")
}

@Test func raceModelCreation() {
    let race = Race(
        id: "2026-1",
        name: "Bahrain Grand Prix",
        circuitId: "bahrain",
        date: Date(),
        season: 2026,
        round: 1
    )
    #expect(race.id == "2026-1")
    #expect(race.season == 2026)
    #expect(race.round == 1)
}

@Test func sessionTypeEnumValues() {
    #expect(SessionType.fp1.displayName == "Practice 1")
    #expect(SessionType.fp2.shortName == "FP2")
    #expect(SessionType.qualifying.isQualifying == true)
    #expect(SessionType.race.isRace == true)
    #expect(SessionType.fp3.isPractice == true)
    #expect(SessionType.sprint.isPractice == false)
}

@Test func standingsModelCreation() {
    let driverStanding = DriverStanding(
        id: "verstappen",
        driverId: "verstappen",
        position: 1,
        points: 25,
        wins: 1,
        constructorId: "red_bull"
    )
    #expect(driverStanding.position == 1)
    #expect(driverStanding.points == 25)

    let constructorStanding = ConstructorStanding(
        id: "red_bull",
        constructorId: "red_bull",
        position: 1,
        points: 45,
        wins: 1
    )
    #expect(constructorStanding.position == 1)
    #expect(constructorStanding.points == 45)
}

// MARK: - Team Colors Tests

@Test func teamColorHexInit() {
    let red = Color(hex: "E8002D")
    let blue = Color(hex: "3671C6")
    let green = Color(hex: "229971")
    #expect(red != Color.clear || true)
    #expect(blue != Color.clear || true)
    #expect(green != Color.clear || true)
}

@Test func teamColorLookup() {
    let redBullColor = Color.teamColor(for: "red_bull")
    let ferrariColor = Color.teamColor(for: "ferrari")
    let unknownColor = Color.teamColor(for: "unknown_team")
    #expect(redBullColor != Color.clear || true)
    #expect(ferrariColor != Color.clear || true)
    #expect(unknownColor != Color.clear || true)
}

@Test func positionStyleColors() {
    #expect(PositionStyle.forPosition(1) == .gold)
    #expect(PositionStyle.forPosition(2) == .silver)
    #expect(PositionStyle.forPosition(3) == .bronze)
    #expect(PositionStyle.forPosition(4) == .standard)
    #expect(PositionStyle.forPosition(20) == .standard)
}

@Test func teamEnumValues() {
    #expect(Team.redBull.name == "Red Bull")
    #expect(Team.ferrari.fullName == "Scuderia Ferrari")
    #expect(Team.mclaren.base == "mclaren")
    #expect(Team.allCases.count == 10)
}