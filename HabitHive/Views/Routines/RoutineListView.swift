//
//  RoutineListView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/5/24.
//

import SwiftUI

struct RoutineListView: View {
    
    let day: Date
    var routines: [Routine]
    var filteredRoutines: [Routine] = []
    
    init(day: Date, routines: [Routine]) {
        print(day)
        self.day = day
        self.routines = routines
        self.filteredRoutines = routines.filter({ $0.date.startOfDay == day.startOfDay })
    }
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text("Routines")
            List(filteredRoutines) { routine in
    
                HStack {
                    Image(systemName: routine.habit?.icon ?? HabitSymbol.cardio.rawValue)
                        .foregroundStyle(Color(hex: routine.habit?.hexColor ?? "FF0000")!)
                    Text(routine.habit?.name ?? "Deleted Habit")
                }
                
                VStack(alignment: .leading, content: {
                    Text(routine.date.formatted(date: .abbreviated, time: .shortened))
                    Text(routine.comment)
                        .foregroundStyle(.secondary)
                })
            }
            .listStyle(.plain)
//            .listRowBackground(Color.bgcolor)
        })
        .padding(.top)
    }
    
}

#Preview {
    RoutineListView(day: Date.now, routines: [])
        .modelContainer(Habit.preview)
}
