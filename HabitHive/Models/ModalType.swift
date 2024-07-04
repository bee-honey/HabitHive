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
    case newRoutine(Habit, completion: () -> Void)
    case updateRoutine(Routine, completion: () -> Void)
    
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
        case .newRoutine(let habit, let completion):
            RoutineFormView(model: RoutineFormModel(habit: habit), completion: completion)
        case .updateRoutine(let routine, let completion):
            RoutineFormView(model: RoutineFormModel(routine: routine), completion: completion)
        }
    }
    
    static func ==(lhs: ModalType, rhs: ModalType) -> Bool {
            switch (lhs, rhs) {
            case (.newHabit, .newHabit):
                return true
            case (.updateHabit(let habit1), .updateHabit(let habit2)):
                return habit1.id == habit2.id
            case (.newRoutine(let habit1, _), .newRoutine(let habit2, _)):
                return habit1.id == habit2.id
            case (.updateRoutine(let routine1, _), .updateRoutine(let routine2, _)):
                return routine1.id == routine2.id
            default:
                return false
            }
        }
}
