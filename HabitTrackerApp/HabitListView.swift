//
//  HabitListView.swift
//  HabitTrackerApp
//
//  Created by Max Seidlitz on 14.11.24.
//

import SwiftUI

import SwiftUI

struct HabitListView: View {
    @State private var habits: [Habit] = []
    @State private var showingAddHabit = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(habits.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(habits[index].name)
                                    .foregroundColor(habits[index].isCompleted ? .gray : .primary)
                                    .strikethrough(habits[index].isCompleted, color: .gray)
                                Spacer()
                                Button(action: {
                                    // Toggle den isCompleted Status
                                    habits[index].isCompleted.toggle()
                                }) {
                                    Image(systemName: habits[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(habits[index].isCompleted ? .green : .gray)
                                }
                            }
                            // Beschreibung des Zeitplans unter dem Namen hinzufügen
                            Text(habits[index].scheduleDescription)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Button(action: {
                    showingAddHabit = true
                }) {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                }
                .padding()
                .sheet(isPresented: $showingAddHabit) {
                    AddHabitView(habits: $habits)
                }
            }
            .navigationTitle("Meine Gewohnheiten")
        }
    }
}
