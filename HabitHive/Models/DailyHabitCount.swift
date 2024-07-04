//
//  DailyHabitCount.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/3/24.
//

import Foundation
import SwiftData

@Model
class DailyHabitCount {
    var date: Date
    var habitID: UUID
    var remainingCount: Int
    
    init(date: Date = .now, habitID: UUID = UUID(), remainingCount: Int = 1) {
        self.date = date
        self.habitID = habitID
        self.remainingCount = remainingCount
    }
}

extension DailyHabitCount {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: DailyHabitCount.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        // Insert sample data if needed
        return container
    }
}
