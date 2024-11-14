//
//  AddHabitView.swift
//  HabitTrackerApp
//
//  Created by Max Seidlitz on 14.11.24.
//

import SwiftUI
import UserNotifications

struct AddHabitView: View {
    @Binding var habits: [Habit]
    @State private var name: String = ""
    @State private var frequency: Frequency = .daily
    @State private var reminderTime = Date()
    @State private var selectedWeekdays: [String] = []
    @Environment(\.presentationMode) var presentationMode

    // Variablen für Error Handling
    @State private var showingError = false
    @State private var errorMessage = ""

    let weekdays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]

    var body: some View {
        Form {
            Section(header: Text("Name der Gewohnheit")) {
                TextField("Gewohnheitsname", text: $name)
            }
            
            Section(header: Text("Häufigkeit")) {
                Picker("Häufigkeit", selection: $frequency) {
                    Text("Täglich").tag(Frequency.daily)
                    Text("Wöchentlich").tag(Frequency.weekly)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            if frequency == .daily {
                Section(header: Text("Erinnerungszeit")) {
                    DatePicker("Zeit", selection: $reminderTime, displayedComponents: .hourAndMinute)
                }
            } else if frequency == .weekly {
                Section(header: Text("Erinnerungszeit")) {
                    DatePicker("Zeit", selection: $reminderTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Wochentage")) {
                    ForEach(weekdays, id: \.self) { day in
                        Toggle(day, isOn: Binding(
                            get: { selectedWeekdays.contains(day) },
                            set: { isSelected in
                                if isSelected {
                                    selectedWeekdays.append(day)
                                } else {
                                    selectedWeekdays.removeAll { $0 == day }
                                }
                            }
                        ))
                    }
                }
            }
            
            Button("Speichern") {
                // Überprüfen, ob der Name leer ist
                if name.isEmpty {
                    errorMessage = "Bitte gib einen Namen für die Gewohnheit ein."
                    showingError = true
                } else {
                    // Gewohnheit hinzufügen und Benachrichtigung planen
                    let newHabit = Habit(name: name, frequency: frequency, reminderTime: reminderTime, weekdays: selectedWeekdays)
                    habits.append(newHabit)
                    scheduleNotification(for: newHabit)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Neue Gewohnheit")
        .alert(isPresented: $showingError) {
            Alert(title: Text("Fehler"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Funktion zur Planung der Benachrichtigung
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
}
