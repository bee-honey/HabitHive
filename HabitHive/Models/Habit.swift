//
//  DailyHabit.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 6/30/24.
//

import Foundation

import UIKit
import SwiftData

enum WeekDay: String, CaseIterable, Codable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
}

@Model class Habit {
    var id: UUID
    var name: String
    var icon: HabitSymbol.RawValue
    var hexColor: String
    var countPerDay: Int
    @Relationship(deleteRule: .cascade)
    var routines: [Routine] = []
    var dailyHabitCount: [DailyHabitCount] = []
    var enabledDays: [WeekDay] = [] // New property to store selected days
    init(id: UUID = UUID(),
         name: String,
         icon: HabitSymbol = .gardening,
         hexColor: String = "FF0000",
         countPerDay: Int = 1,
         enabledDays: [WeekDay] = [ .sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]) {
//         enabledDays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]) {
//         enabledDays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]) {
        self.id = id
        self.name = name
        self.icon = icon.rawValue
        self.hexColor = hexColor
        self.countPerDay = countPerDay
        self.enabledDays = enabledDays
    }
}

extension Habit {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Habit.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        var sampleHabits: [Habit] {
            [
//                Habit(name: "Cardio", icon: .cardio, hexColor: "B33234", countPerDay: 4, enabledDays: ["tuesday", "friday"]),
                Habit(name: "Cardio", icon: .cardio, hexColor: "B33234", countPerDay: 4, enabledDays: [.tuesday, .friday]),
                Habit(name: "Gardening", icon: .gardening, hexColor: "6F223D", countPerDay: 3),
                Habit(name: "Reading", icon: .reading, hexColor: "38571A", countPerDay: 2),
                Habit(name: "Hiking", icon: .hiking, hexColor: "FF3B30", countPerDay: 1),
            ]
        }
        
        let sampleComments = [
            "Feeling fantastic!",
            "Worked up a good sweat.",
            "On cloud nine!",
            "Worn out but satisfied.",
            "Muscles feeling strong!",
            "Embracing the burn.",
            "Empowered and unstoppable.",
            "Ready to take on anything.",
            "Good sore feeling.",
            "Proud of my effort.",
            "Refreshed and revitalized.",
            "Endorphin rush!",
            "Like a fitness warrior!",
            "Glowing with health.",
            "Determined and focused.",
            "Exhausted yet triumphant.",
            "Charged with energy.",
            "Loving the workout high.",
            "Seeing the results.",
            "In champion mode!"
        ]

        sampleHabits.forEach { habit in
            container.mainContext.insert(habit)
            let randomNumber = Int.random(in: 15...50)
            for _ in 1...randomNumber {
                let randomComment = sampleComments[Int.random(in: 0..<sampleComments.count)]
                let newRoutine = Routine(date: Date.now.randomDateWithinLastThreeMonths, comment: randomComment)
                habit.routines.append(newRoutine)
            }
        }
        return container
    }

}
