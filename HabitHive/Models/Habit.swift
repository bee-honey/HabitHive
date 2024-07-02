//
//  DailyHabit.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 6/30/24.
//

import Foundation

import UIKit
import SwiftData

@Model class Habit {
    var name: String
    @Relationship(deleteRule: .cascade)
    var icon: HabitSymbol.RawValue
    var hexColor: String
    var routines: [Routine] = []
    init(name: String, icon: HabitSymbol = .gardening, hexColor: String = "FF0000") {
        self.name = name
        self.icon = icon.rawValue
        self.hexColor = hexColor
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
//                Habit(name: "Jogging", icon: .run, hexColor: "B33234"),
//                Habit(name: "Swimming", icon: .poolSwim, hexColor: "6F223D"),
//                Habit(name: "Biking", icon: .outdoorCycle, hexColor: "38571A"),
//                Habit(name: "Elliptical", icon: .elliptical, hexColor: "FF3B30"),
                Habit(name: "Cardio", icon: .cardio, hexColor: "B33234"),
                Habit(name: "Gardening", icon: .gardening, hexColor: "6F223D"),
                Habit(name: "Reading", icon: .reading, hexColor: "38571A"),
                Habit(name: "Hiking", icon: .hiking, hexColor: "FF3B30"),
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