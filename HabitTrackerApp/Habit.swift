//
//  Habit.swift
//  HabitTrackerApp
//
//  Created by Max Seidlitz on 14.11.24.
//

import Foundation

struct Habit: Identifiable {
    var id = UUID()
    var name: String
    var frequency: Frequency
    var reminderTime: Date
    var weekdays: [String] = []
    var isCompleted: Bool = false
    
    // Berechnete Eigenschaft zur Beschreibung des Zeitplans einer Habit
    var scheduleDescription: String {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let timeString = timeFormatter.string(from: reminderTime)
            
            switch frequency {
            case .daily:
                return "Täglich um \(timeString)"
            case .weekly:
                let days = weekdays.joined(separator: ", ")
                return "Wöchentlich am \(days) um \(timeString)"
            }
        }
}

enum Frequency {
    case daily, weekly
}
