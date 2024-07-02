//
//  CalendarHeaderView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//

import SwiftUI
import SwiftData

struct CalendarHeaderView: View {
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    @Query private var routines: [Routine]
    @Query(sort: \Habit.name) private var habits: [Habit]
    @State private var selectedHabit: Habit?
    
    let months = Date.fullMonthNames
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedHabit) {
                    Text("All").tag(nil as Habit?)
                    ForEach(habits) { habit in
                        Text(habit.name).tag(habit as Habit?)
                    }
                }
                .buttonStyle(.borderedProminent)
                HStack {
                    Picker("", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year))
                        }
                    }
                    Picker("", selection: $selectedMonth) {
                        ForEach(months.indices, id: \.self) { index in
                            Text(months[index]).tag(index + 1)
                            
                        }
                    }
                }
                .buttonStyle(.bordered)
                CalendarView(date: monthDate, selectedHabit: selectedHabit)
                Spacer()
            }
            .navigationTitle("Tallies")
        }
        .onAppear {
            years = Array(Set(routines.map{ $0.date.yearInt }.sorted()))
        }
        .onChange(of: selectedYear) {
            updateDate()
        }
        .onChange(of: selectedMonth) {
            updateDate()
        }
        
    }
    
    func updateDate() {
        monthDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
}

#Preview {
    CalendarHeaderView()
        .modelContainer(Habit.preview)
}
