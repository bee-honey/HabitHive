//
//  ContentView.swift
//  Custom Calendar
//
//  Created by Naveen Keerthy on 6/30/24.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    let date: Date
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days:[Date] = []
//    let days = 1..<32
    
    let selectedHabit: Habit?
    @Query private var routines: [Routine]
    @State private var counts = [Int : Int]()
    
    init(date: Date, selectedHabit: Habit?) {
        self.date = date
        self.selectedHabit = selectedHabit
        let endOfMonthAdjustment = Calendar.current.date(byAdding: .day, value: -1, to: date.endOfMonth)!
        let predicate = #Predicate<Routine>{$0.date >= date.startOfMonth && $0.date <= endOfMonthAdjustment}
        _routines = Query(filter: predicate, sort: \Routine.date)
    }
    
    var body: some View {
        let color = selectedHabit == nil ? .blue : Color(hex: selectedHabit!.hexColor)!
        VStack {
            
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns) {
                
                ForEach(days, id: \.self) { day in
                    
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Text("\(day.formatted(.dateTime.day()))")
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        Date.now.startOfDay == day.startOfDay ? .red.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3) :
                                                color.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3))
                            )
                            .overlay(alignment: .bottomTrailing) {
                                if let count = counts[day.dayInt] {
                                    Image(systemName: count < 50 ? "\(count).circle.fill" : "plus.circle.fill")
                                        .foregroundColor(.secondary)
                                        .imageScale(.medium)
                                        .background(Color(.systemBackground)
                                            .clipShape(.circle)
                                        )
                                        .offset(x: 5, y: 5)
                                }
                            }
                    }
                }
                
            }
        }
        .padding()
        .onAppear(perform: {
            days = date.calendarDisplayDays
            setupCounts()
        })
        .onChange(of: date) {
            days = date.calendarDisplayDays
            setupCounts()
        }
        .onChange(of: selectedHabit) {
            setupCounts()
        }
    }
    
    func setupCounts() {
        var filteredRoutines = routines
        if let selectedHabit {
            filteredRoutines = routines.filter{$0.habit == selectedHabit}
        }
        let mappedItems = filteredRoutines.map { ($0.date.dayInt, 1) }
        counts = Dictionary(mappedItems, uniquingKeysWith: +)
    }
}

#Preview {
    CalendarView(date: Date.now, selectedHabit: nil)
        .modelContainer(Habit.preview)
}
