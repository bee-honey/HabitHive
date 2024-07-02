//
//  RoutineFormView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//

import SwiftUI
import SwiftData

struct RoutineFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var model: RoutineFormModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                LabeledContent {
                    DatePicker("", selection: $model.date)
                } label: {
                    Text("Date/Time")
                }
                
                LabeledContent {
                    TextField("How did it go?", text: $model.comment, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .frame(minHeight: 60)
                } label: {
                    Text("Comment")
                }
                
                Button(model.updating ? "Update" : "Create") {
                    if model.updating {
                        model.routine?.date = model.date
                        model.routine?.comment = model.comment
                    } else {
                        let newRoutine = Routine(date: model.date, comment: model.comment)
                        model.habit?.routines.append(newRoutine)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top)
                Spacer()
            }
            .padding()
            .navigationTitle(model.updating ? "Update" : "Create")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let container = Habit.preview
    var fetchDescriptor = FetchDescriptor<Habit>()
    fetchDescriptor.sortBy = [SortDescriptor(\.name)]
    let habit = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack {
        RoutineFormView(model: RoutineFormModel(habit: habit))
    }
    .modelContainer(Habit.preview)
}
