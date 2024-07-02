//
//  ModalType.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 6/30/24.
//

import Foundation

import SwiftUI
enum ModalType: View, Identifiable, Equatable {
    case newHabit
    case updateHabit(Habit)
    case newRoutine(Habit)
    case updateRoutine(Routine)
    
    var id: String {
        switch self {
        case .newHabit:
            "newHabit"
        case .updateHabit:
            "updateHabit"
        case .newRoutine:
            "newRoutine"
        case .updateRoutine:
            "updateRoutine"
        }
    }
    
    var body: some View {
        switch self {
        case .newHabit:
            HabitFormView(model: HabitFormModel())
        case .updateHabit(let habit):
            HabitFormView(model: HabitFormModel(habit: habit))
        case .newRoutine(let habit):
            RoutineFormView(model: RoutineFormModel(habit: habit))
        case .updateRoutine(let routine):
            RoutineFormView(model: RoutineFormModel(routine: routine))
        }
    }
}
