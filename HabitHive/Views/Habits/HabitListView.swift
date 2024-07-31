//
//  DailyHabitListView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 6/30/24.
//
import SwiftUI
import SwiftData

struct `HabitListView`: View {
    @Environment(\.modelContext) private var modelContext
    @State private var modalType: ModalType?
    @Query(sort: \Habit.name) private var habits: [Habit]
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
//                Color.bgcolor
//                    .edgesIgnoringSafeArea(.all)
                //                Group {}
                
                if habits.isEmpty {
                    ContentUnavailableView("Create your first Habit by tapping on the \(Image(systemName: "plus.circle.fill")) button at the top of Daily tab", image: "launchScreen")
                } else {
                    List(habits) { habit in
                        NavigationLink(value: habit){
                            HStack {
                                Image(systemName: habit.icon)
                                    .foregroundStyle(Color(hex: habit.hexColor)!)
                                    .font(.system(size: 30))
                                    .frame(width: 50)
                                Text(habit.name.capitalized)
                                Spacer()
                                Text("^[\(habit.routines.count) routine](inflect: true)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
//                        .listRowBackground(Color.bgcolor)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(habit)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                modalType = .updateHabit(habit)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                }
                
            }
                .navigationTitle("Habits")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(item: $modalType, content: { sheet in
                    sheet
                        .presentationDetents([.height(450)])
                })
                .navigationDestination(for: Habit.self) { habit in
                    RoutinesListView(habit: habit)
                }
                .padding(.top, 10)
            }
        }
    }


#Preview {
    HabitListView()
        .modelContainer(Habit.preview)
}
