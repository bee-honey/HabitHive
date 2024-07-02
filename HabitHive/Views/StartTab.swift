//
//  StartTab.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//

import SwiftUI
import SwiftData

struct StartTab: View {
    var body: some View {
        TabView {
            HabitListView()
                .tabItem {
                    Label("Habits", systemImage: "figure.mixed.cardio")
                }
            CalendarHeaderView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    StartTab()
        .modelContainer(Habit.preview)
}
