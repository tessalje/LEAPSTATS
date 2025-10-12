//
//  notificationData.swift
//  notifications
//
//  Created by Tessa on 21/7/25.
//

import Foundation
import SwiftUI
import UserNotifications

struct NotificationRecord: Identifiable, Codable {
    let id = UUID()
    let title: String
    let body: String
    let timestamp: Date
    let isDelivered: Bool
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: timestamp)
    }
}

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var notifications: [NotificationRecord] = []
    @Published var isAuthorized = false
    @Published var isTimerActive = false
    
    private var timer: Timer?
    private let userDefaults = UserDefaults.standard
    private let notificationsKey = "SavedNotifications"
    private let welcomeNotificationSentKey = "WelcomeNotificationSent"
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        loadNotifications()
        checkAuthorizationStatus()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.welcomenotification()
        }
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if granted {
                    print("Notification permission granted")
                    self.welcomenotification()
                } else {
                    print("Notification permission denied")
                }
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func startPeriodicNotifications() {
        guard isAuthorized else {
            requestPermission()
            return
        }
        
        isTimerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in // 300 seconds = 5 minutes
            self.sendNotification()
        }
        
        // Send first notification immediately
        sendNotification()
    }
    
    func stopPeriodicNotifications() {
        timer?.invalidate()
        timer = nil
        isTimerActive = false
        
        // Cancel pending notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleTermlyNotification(id: String, title: String, body: String, month: Int, day: Int, hour: Int, minute: Int) {
        guard isAuthorized else {
            requestPermission()
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification [\(id)]: \(error)")
            } else {
                print("Notification [\(id)] scheduled")
            }
        }
    }
    
    func allTermlyNotifications() {
        scheduleTermlyNotification(
            id: "term1-notification",
            title: "Catch up on your LEAPS",
            body: "Term 1 is starting! Check what areas are lacking now.",
            month: 1, day: 2, hour: 8, minute: 0
        )
        scheduleTermlyNotification(
            id: "term2-notification",
            title: "Mid-Year LEAPS Check-In",
            body: "Term 2 begins! See what progress you've made.",
            month: 3, day: 18, hour: 8, minute: 0
        )
        scheduleTermlyNotification(
            id: "term3-notification",
            title: "Start of Term 3!",
            body: "Welcome back! Update your LEAPS portfolio for the new term.",
            month: 6, day: 24, hour: 8, minute: 0
        )
        scheduleTermlyNotification(
            id: "term4-notification",
            title: "Final Term Reminder",
            body: "Term 4 is here! Finalise your achievements for the year.",
            month: 9, day: 9, hour: 8, minute: 0
        )
    }

    
    private func welcomenotification() {
        let hasWelcomeBeenSent = userDefaults.bool(forKey: welcomeNotificationSentKey)
        
        guard !hasWelcomeBeenSent && isAuthorized else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Welcome to LEAPSTATS! 🎉"
        content.body = "Thank you for using LEAPSTATS. Start tracking your LEAPS points now!"
        content.sound = .default
        
        // Send immediately (1 second delay to ensure proper delivery)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "welcome-notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                let record = NotificationRecord(
                    title: content.title,
                    body: content.body,
                    timestamp: Date(),
                    isDelivered: error == nil
                )
                self.addNotification(record)
                
                if error == nil {
                    self.userDefaults.set(true, forKey: self.welcomeNotificationSentKey)
                    print("notification sent successfully")
                } else {
                    print("Error sending welcome notification: \(error!)")
                }
            }
        }
    }

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Periodic Reminder"
        content.body = "This is your 5-minute notification! Time: \(Date().formatted(date: .omitted, time: .shortened))"
        content.sound = .default
        content.badge = NSNumber(value: notifications.count + 1)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                let record = NotificationRecord(
                    title: content.title,
                    body: content.body,
                    timestamp: Date(),
                    isDelivered: error == nil
                )
                self.addNotification(record)
                
                if let error = error {
                    print("Error sending notification: \(error)")
                }
            }
        }
    }
    
    private func addNotification(_ notification: NotificationRecord) {
        notifications.insert(notification, at: 0) // Add to beginning for newest first
        saveNotifications()
    }
    
    private func saveNotifications() {
        if let encoded = try? JSONEncoder().encode(notifications) {
            userDefaults.set(encoded, forKey: notificationsKey)
        }
    }
    
    private func loadNotifications() {
        if let data = userDefaults.data(forKey: notificationsKey),
           let decoded = try? JSONDecoder().decode([NotificationRecord].self, from: data) {
            notifications = decoded
        }
    }
    
    func clearAllNotifications() {
        notifications.removeAll()
        saveNotifications()
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
