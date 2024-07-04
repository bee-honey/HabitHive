//
//  RoutineListView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//

import SwiftUI
import SwiftData

struct RoutineListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var modalType: ModalType?
    var habit: Habit
    
    var body: some View {
        @Bindable var habit = habit
        Group {
            if habit.routines.isEmpty {
                ContentUnavailableView("Create your first \(habit.name) workout by tapping on the \(Image(systemName: "plus.circle.fill")) button at the top.", systemImage: "\(habit.icon)")
            } else {
                List(habit.routines.sorted(
                    using: KeyPathComparator(
                        \Routine.date,
                         order: .reverse
                    ))
                ) { routine in
                    HStack {
                        Image(systemName: habit.icon)
                            .foregroundStyle(Color(hex: habit.hexColor)!)
                        VStack(alignment: .leading, content: {
                            Text(routine.date.formatted(date: .abbreviated, time: .shortened))
                            Text(routine.comment).foregroundStyle(.secondary)
                        })
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = habit.routines.firstIndex(where: { $0.id == routine.id }) {
                                habit.routines.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                    }
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            if let index = habit.routines.firstIndex(where: { $0.id == routine.id }) {
                                modalType = ModalType.updateRoutine(habit.routines[index], completion: {})
                            }
                        }, label: {
                            Label("Edit", systemImage: "pencil")
                        })
                    }
                    
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(Image(systemName: habit.icon)) \(habit.name)")
                    .font(.title)
                    .foregroundStyle(Color(hex: habit.hexColor)!)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    modalType = .newRoutine(habit, completion: {})
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(item: $modalType) { sheet in
                    sheet
                        .presentationDetents([.height(300)])
                }
                
            }
        }
    }
}

#Preview {
    let container = Habit.preview
    var fetchDescriptor = FetchDescriptor<Habit>()
    fetchDescriptor.sortBy = [SortDescriptor(\.name)]
    let habit = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack {
        RoutineListView(habit: habit)
    }
    .modelContainer(Habit.preview)
}
