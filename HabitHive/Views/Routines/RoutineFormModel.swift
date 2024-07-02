//
//  RoutineFormModal.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//

import SwiftUI

@Observable
class RoutineFormModel {
    var date: Date = Date.now
    var comment: String = ""
    var habit: Habit?
    var routine: Routine?
    var updating: Bool {
        routine != nil
    }
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    init(routine: Routine) {
        self.routine = routine
        self.habit = routine.habit
        self.date = routine.date
        self.comment = routine.comment
    }
}
