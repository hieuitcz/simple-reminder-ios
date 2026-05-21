import Foundation
import UserNotifications

enum ReminderNotificationManager {
    static func requestAuthorizationIfNeeded() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined:
            do {
                return try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                return false
            }
        case .denied:
            return false
        @unknown default:
            return false
        }
    }

    static func scheduleNotification(for reminder: Reminder) async {
        guard !reminder.isDone, reminder.dueDate > Date() else {
            await cancelNotification(id: reminder.id)
            return
        }

        let granted = await requestAuthorizationIfNeeded()
        guard granted else { return }

        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Nhac nho"
        content.body = reminder.title
        content.sound = .default

        let date = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: reminder.dueDate
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
        } catch {
            // Ignore add errors to keep core reminder flow unaffected.
        }
    }

    static func cancelNotification(id: UUID) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        center.removeDeliveredNotifications(withIdentifiers: [id.uuidString])
    }

    static func syncNotifications(with reminders: [Reminder]) async {
        for reminder in reminders {
            if reminder.isDone || reminder.dueDate <= Date() {
                await cancelNotification(id: reminder.id)
            } else {
                await scheduleNotification(for: reminder)
            }
        }
    }
}
