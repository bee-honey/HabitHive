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
    init(name: String, icon: HabitSymbol = .mixedCardio, hexColor: String = "FF0000") {
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
                Habit(name: "Jogging", icon: .run, hexColor: "B33234"),
                Habit(name: "Swimming", icon: .poolSwim, hexColor: "6F223D"),
                Habit(name: "Biking", icon: .outdoorCycle, hexColor: "38571A"),
                Habit(name: "Elliptical", icon: .elliptical, hexColor: "FF3B30"),
            ]
        }
        
        let sampleComments =  [
            "Energized and alive!",
            "Sweaty but satisfied.",
            "On top of the world!",
            "Exhausted but accomplished.",
            "Muscles are singing!",
            "Feeling the burn in a good way.",
            "Empowered and strong.",
            "Ready to conquer the day.",
            "A good kind of soreness.",
            "Proud of the effort.",
            "Revitalized and refreshed.",
            "Endorphins pumping!",
            "Like a fitness superhero!",
            "Beaming with post-workout glow.",
            "Unstoppable and determined.",
            "Tired but triumphant.",
            "Fuelled with positive vibes.",
            "In love with the post-workout high.",
            "Feeling the progress.",
            "Champion mode activated!"
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
