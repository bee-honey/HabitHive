//
//  HabitFormModel.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//

import SwiftUI

@Observable
class HabitFormModel {
    var name = ""
    var icon: HabitSymbol = .mixedCardio
    var hexColor: Color = .red
    
    var habit: Habit?
    
    var updating: Bool { habit != nil }
    
    init() {}
    
    init(habit: Habit) {
        self.habit = habit
        self.name = habit.name
        self.icon = HabitSymbol(rawValue: habit.icon) ?? .mixedCardio
        self.hexColor = Color(hex: habit.hexColor)!
    }
    
    var disabled: Bool {
        name.isEmpty
    }
}
