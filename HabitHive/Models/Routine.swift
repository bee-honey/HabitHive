//
//  Routine.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 6/30/24.
//

import SwiftData
import Foundation

@Model
class Routine {
    var date: Date
    var habit: Habit?
    var comment: String
    
    init(date: Date, comment: String = "") {
        self.date = date
        self.comment = comment
    }
}
