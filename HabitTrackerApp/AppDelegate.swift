//
//  AppDelegate.swift
//  HabitTrackerApp
//
//  Created by Max Seidlitz on 14.11.24.
//

import UIKit
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Anfrage für Benachrichtigungsberechtigungen
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Erlaubnis Fehler: \(error.localizedDescription)")
            }
        }
        
        // Setze den Delegate für Benachrichtigungen
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // Funktion zum Empfangen und Anzeigen von Benachrichtigungen im Vordergrund
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

func scheduleNotification(for habit: Habit) {
    let content = UNMutableNotificationContent()
    content.title = "Hey!"
    content.body = "Denk daran, heute deine Gewohnheiten zu checken."
    content.sound = .default

    let reminderTime = Calendar.current.date(byAdding: .minute, value: -30, to: habit.reminderTime) ?? habit.reminderTime
    var trigger: UNNotificationTrigger

    if habit.frequency == .daily {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    } else {
        let dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: reminderTime)
        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }

    let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

