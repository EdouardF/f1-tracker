import Foundation
import SwiftData

// MARK: - TTL Configuration
enum CacheTTL {
    case standings    // 1 hour
    case schedule     // 24 hours
    case sessionResult // 5 min during race weekend, 24h otherwise
    case liveData     // No cache (real-time)

    var seconds: TimeInterval {
        switch self {
        case .standings: return 3600
        case .schedule: return 86400
        case .sessionResult: return 86400
        case .liveData: return 0
        }
    }
}

// MARK: - Cache Entry
@Model
final class CacheEntry {
    @Attribute(.unique) var key: String
    var data: Data
    var cachedAt: Date
    var expiresAt: Date
    var ttl: TimeInterval

    init(key: String, data: Data, ttl: TimeInterval = CacheTTL.standings.seconds) {
        self.key = key
        self.data = data
        self.cachedAt = Date()
        self.ttl = ttl
        self.expiresAt = Date().addingTimeInterval(ttl)
    }

    var isExpired: Bool {
        Date() > expiresAt
    }
}

// MARK: - Cache Service
@MainActor
final class CacheService: @unchecked Sendable {
    static let shared = CacheService()

    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    private init() {
        do {
            let schema = Schema([CacheEntry.self])
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
            self.modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Failed to create CacheService ModelContainer: \(error)")
        }
    }

    // MARK: - Save
    func save<T: Codable>(_ object: T, forKey key: String, ttl: CacheTTL = .standings) throws {
        let data = try JSONEncoder().encode(object)
        let expiresAt = Date().addingTimeInterval(ttl.seconds)

        // Delete existing entry if present
        if let existing = fetchEntry(forKey: key) {
            modelContext.delete(existing)
        }

        let entry = CacheEntry(key: key, data: data, ttl: ttl.seconds)
        entry.expiresAt = expiresAt
        modelContext.insert(entry)

        try modelContext.save()
    }

    // MARK: - Load
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let entry = fetchEntry(forKey: key), !entry.isExpired else {
            // Clean up expired entry
            if let expired = fetchEntry(forKey: key) {
                modelContext.delete(expired)
                try? modelContext.save()
            }
            return nil
        }

        return try JSONDecoder().decode(type, from: entry.data)
    }

    // MARK: - Load or Fetch (Offline-First)
    func loadOrFetch<T: Codable>(
        _ type: T.Type,
        forKey key: String,
        ttl: CacheTTL = .standings,
        fetch: @Sendable () async throws -> T
    ) async throws -> T {
        // Try cache first
        if let cached = try load(type, forKey: key) {
            return cached
        }

        // Fetch from network
        do {
            let result = try await fetch()
            try save(result, forKey: key, ttl: ttl)
            return result
        } catch {
            // Network failed — try expired cache as fallback
            if let expiredEntry = fetchEntry(forKey: key) {
                if let fallback = try? JSONDecoder().decode(type, from: expiredEntry.data) {
                    return fallback
                }
            }
            throw error
        }
    }

    // MARK: - Invalidate
    func invalidate(forKey key: String) throws {
        if let entry = fetchEntry(forKey: key) {
            modelContext.delete(entry)
            try modelContext.save()
        }
    }

    func invalidateAll() throws {
        let descriptor = FetchDescriptor<CacheEntry>()
        let entries = try modelContext.fetch(descriptor)
        for entry in entries {
            modelContext.delete(entry)
        }
        try modelContext.save()
    }

    func invalidateExpired() throws {
        let now = Date()
        let descriptor = FetchDescriptor<CacheEntry>(
            predicate: #Predicate { $0.expiresAt < now }
        )
        let expired = try modelContext.fetch(descriptor)
        for entry in expired {
            modelContext.delete(entry)
        }
        try modelContext.save()
    }

    // MARK: - Private
    private func fetchEntry(forKey key: String) -> CacheEntry? {
        let descriptor = FetchDescriptor<CacheEntry>(
            predicate: #Predicate { $0.key == key }
        )
        return try? modelContext.fetch(descriptor).first
    }
}

// MARK: - Cache Keys
enum CacheKey {
    static func drivers(season: Int) -> String { "drivers-\(season)" }
    static func constructors(season: Int) -> String { "constructors-\(season)" }
    static func driverStandings(season: Int) -> String { "driver-standings-\(season)" }
    static func constructorStandings(season: Int) -> String { "constructor-standings-\(season)" }
    static func races(season: Int) -> String { "races-\(season)" }
    static func raceResults(season: Int, round: Int) -> String { "results-\(season)-\(round)" }
    static func currentSchedule() -> String { "current-schedule" }

    // OpenF1
    static func meetings(year: Int) -> String { "meetings-\(year)" }
    static func sessions(meetingKey: Int) -> String { "sessions-\(meetingKey)" }
    static func sessionResults(sessionKey: Int) -> String { "session-results-\(sessionKey)" }
    static func startingGrid(sessionKey: Int) -> String { "starting-grid-\(sessionKey)" }
    static func laps(sessionKey: Int) -> String { "laps-\(sessionKey)" }
    static func weather(sessionKey: Int) -> String { "weather-\(sessionKey)" }
}