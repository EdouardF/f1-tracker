import Foundation
import SwiftData

@Model
final class CacheEntry {
    @Attribute(.unique) var key: String
    var data: Data
    var expirationDate: Date

    init(key: String, data: Data, expirationDate: Date) {
        self.key = key
        self.data = data
        self.expirationDate = expirationDate
    }

    var isExpired: Bool {
        expirationDate < Date()
    }
}

enum CacheTTL {
    case fiveMinutes
    case oneHour
    case twentyFourHours
    case custom(TimeInterval)

    var seconds: TimeInterval {
        switch self {
        case .fiveMinutes: return 300
        case .oneHour: return 3600
        case .twentyFourHours: return 86400
        case .custom(let interval): return interval
        }
    }
}

actor CacheService {
    static let shared = CacheService()

    private let modelContainer: ModelContainer

    private init() {
        let schema = Schema([CacheEntry.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer for CacheService: \(error)")
        }
    }

    // MARK: - Save

    func save<T: Encodable>(key: String, data: T, ttl: CacheTTL = .oneHour) throws {
        let encoded = try JSONEncoder().encode(data)
        let expiration = Date().addingTimeInterval(ttl.seconds)

        let context = ModelContext(modelContainer)

        if let existing = try context.fetch(FetchDescriptor<CacheEntry>(
            predicate: #Predicate { $0.key == key }
        )).first {
            existing.data = encoded
            existing.expirationDate = expiration
        } else {
            let entry = CacheEntry(key: key, data: encoded, expirationDate: expiration)
            context.insert(entry)
        }

        try context.save()
    }

    // MARK: - Load

    func load<T: Decodable>(key: String) throws -> T? {
        let context = ModelContext(modelContainer)

        let descriptor = FetchDescriptor<CacheEntry>(
            predicate: #Predicate { $0.key == key }
        )

        guard let entry = try context.fetch(descriptor).first else {
            return nil
        }

        guard !entry.isExpired else {
            context.delete(entry)
            try context.save()
            return nil
        }

        return try JSONDecoder().decode(T.self, from: entry.data)
    }

    // MARK: - Clear Expired

    func clearExpired() throws {
        let context = ModelContext(modelContainer)
        let now = Date()

        let descriptor = FetchDescriptor<CacheEntry>(
            predicate: #Predicate { $0.expirationDate < now }
        )

        let expired = try context.fetch(descriptor)
        for entry in expired {
            context.delete(entry)
        }

        try context.save()
    }

    // MARK: - Clear All

    func clearAll() throws {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<CacheEntry>()
        let all = try context.fetch(descriptor)
        for entry in all {
            context.delete(entry)
        }
        try context.save()
    }
}