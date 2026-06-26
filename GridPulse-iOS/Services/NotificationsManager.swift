import Foundation
import UserNotifications

@MainActor
final class NotificationsManager: @unchecked Sendable {
    static let shared = NotificationsManager()

    private let center = UNUserNotificationCenter.current()

    private init() {}

    // MARK: - Request Permission
    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification authorization failed: \(error)")
            return false
        }
    }

    // MARK: - Schedule Race Reminder
    func scheduleRaceReminder(for race: Race, minutesBefore: Int = 30) async {
        let content = UNMutableNotificationContent()
        content.title = "🏎️ \(race.name) Starting Soon"
        content.body = "Race starts in \(minutesBefore) minutes — \(race.circuitId.replacingOccurrences(of: "_", with: " ").capitalized)"
        content.sound = .default

        let triggerDate = race.date.addingTimeInterval(-Double(minutesBefore * 60))
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "race-\(race.id)", content: content, trigger: trigger)

        do {
            try await center.add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }

    // MARK: - Cancel Race Reminder
    func cancelRaceReminder(for race: Race) {
        center.removePendingNotificationRequests(withIdentifiers: ["race-\(race.id)"])
    }

    // MARK: - Cancel All Reminders
    func cancelAllReminders() {
        center.removeAllPendingNotificationRequests()
    }

    // MARK: - Schedule All Races
    func scheduleAllRaceReminders(for races: [Race], minutesBefore: Int = 30) async {
        for race in races {
            if race.date > Date() {
                await scheduleRaceReminder(for: race, minutesBefore: minutesBefore)
            }
        }
    }
}