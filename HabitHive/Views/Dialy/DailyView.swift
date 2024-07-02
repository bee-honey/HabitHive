//
//  DailyView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/2/24.
//

import SwiftUI
import SwiftData

struct DailyView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var modalType: ModalType?
    @Query(sort: \Habit.name) private var habits: [Habit]
    @State private var path = NavigationPath()
    @State private var clickedHabits: Set<Habit.ID> = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if habits.isEmpty {
                    ContentUnavailableView("Create your first Habit by tapping on the \(Image(systemName: "plus.circle.fill")) button at the top.", image: "launchScreen")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(habits) { habit in
                                Button(action: {
                                    clickedHabits.insert(habit.id)
                                }) {
                                    VStack {
                                        Image(systemName: habit.icon)
                                            .foregroundStyle(Color(hex: habit.hexColor)!)
                                            .font(.system(size: 30))
                                            .frame(width: 50)
                                        Text(habit.name.capitalized)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .overlay(
                                        VStack {
                                            HStack {
                                                Spacer()
                                                if clickedHabits.contains(habit.id) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.green)
                                                }
                                            }
                                            Spacer()
                                        }
                                            .padding([.top, .trailing], 5)
                                    )
                                }
                                .disabled(clickedHabits.contains(habit.id))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .toolbar {
                Button {
                    modalType = .newHabit
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(item: $modalType) { sheet in
                    sheet
                        .presentationDetents([.height(450)])
                }
            }
            .navigationTitle("Daily Record")
        }
    }
}

#Preview {
    DailyView()
        .modelContainer(Habit.preview)
}
