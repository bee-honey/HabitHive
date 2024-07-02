//
//  HabitHiveApp.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 6/30/24.
//

import SwiftUI
import SwiftData

@main
struct HabitHiveApp: App {

    var body: some Scene {
        WindowGroup {
            StartTab()
                .modelContainer(for: Habit.self)
        }
    }
}
