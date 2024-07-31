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
            DailyView()
                .tabItem {
                    Label("Routines", systemImage: "person.badge.plus")
                }
            HabitListView()
                .tabItem {
                    Label("View all", systemImage: "list.number")
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
