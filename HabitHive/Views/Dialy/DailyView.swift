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
    @Query private var dailyHabitCounts: [DailyHabitCount]
    @Query private var routines: [Routine]
    @State private var path = NavigationPath()
    @State private var clickedHabits: Set<UUID> = []
    @State private var habitCounts: [UUID: Int] = [:]
    
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
                                let remainingCount = habitCounts[habit.id] ?? habit.countPerDay
                                let isButtonActive = remainingCount > 0
                                Button(action: {
                                    if isButtonActive {
                                        modalType = ModalType.newRoutine(habit, completion: {
                                            let newCount = remainingCount - 1
                                            habitCounts[habit.id] = newCount
                                            updateHabitCount(habit: habit, newCount: newCount)
                                        })
                                    }
                                }) {
                                    VStack {
                                        Image(systemName: habit.icon)
                                            .foregroundStyle(Color(hex: habit.hexColor)!)
                                            .font(.system(size: 30))
                                            .frame(width: 50)
                                            .padding(.bottom, 5)
                                        Spacer()
                                        
                                        Text(habit.name.capitalized)
                                            .font(.body)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                            .frame(maxWidth: .infinity, alignment: Alignment.center)
                                    }
                                    .padding()
                                    .background(Color(isButtonActive ? Color(UIColor.secondarySystemBackground) : Color.clear))
                                    .cornerRadius(isButtonActive ? 10 : 0)
                                    .shadow(radius: isButtonActive ? 5 : 0)
                                    .overlay(alignment: .topLeading) {
                                        if remainingCount > 0 {
                                            Image(systemName: remainingCount < 50 ? "\(remainingCount).circle.fill" : "plus.circle.fill")
                                                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.3))
                                                .imageScale(.medium)
                                                .background(Color(.systemBackground)
                                                    .clipShape(.circle)
                                                )
                                                .offset(x: 5, y: 5)
                                        }
                                    }
//                                    .overlay(alignment: .bottomTrailing)(
//                                        VStack {
//                                            HStack {
//                                                if isButtonActive {
//                                                    ZStack {
//                                                        Circle()
//                                                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
//                                                            .frame(width: 24, height: 24)
//                                                        Text("\(remainingCount)")
//                                                            .foregroundColor(.red)
//                                                            .font(.caption)
//                                                            .bold()
//                                                    }
//                                                    .padding(.leading, 5)
//                                                }
//                                                Spacer()
//                                            }
//                                            
//                                            Spacer()
//                                        }
//                                            .padding([.top, .trailing], 5)
//                                    )
                                    .overlay(
                                        VStack {
                                            HStack {
                                                Spacer()
                                                if remainingCount == 0 {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.green)
                                                }
                                            }
                                            Spacer()
                                        }
                                            .padding([.top, .trailing], 5)
                                    )
                                }
                                .disabled(!isButtonActive)
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
                        .presentationDetents([.height(375)])
                }
            }
            .navigationTitle("Today's Routine")
        }
        .onAppear {
            resetCountsIfNeeded()
            initializeHabitCounts()
        }
    }
    
    private func initializeHabitCounts() {
        let today = Calendar.current.startOfDay(for: Date())
            for habit in habits {
                if let dailyCount = dailyHabitCounts.first(where: { $0.habitID == habit.id && $0.date == today }) {
                    habitCounts[habit.id] = dailyCount.remainingCount
                } else {
                    habitCounts[habit.id] = habit.countPerDay
                }
            }
    }
    
    private func updateHabitCount(habit: Habit, newCount: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        if let dailyCount = dailyHabitCounts.first(where: { $0.habitID == habit.id && $0.date == today }) {
            dailyCount.remainingCount = newCount
        } else {
            let newDailyCount = DailyHabitCount(date: today, habitID: habit.id, remainingCount: newCount)
            modelContext.insert(newDailyCount)
        }
    }
    
    private func resetCountsIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        if let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date {
            if lastResetDate < today {
                habitCounts.removeAll()
                UserDefaults.standard.set(today, forKey: "lastResetDate")
            }
        } else {
            UserDefaults.standard.set(today, forKey: "lastResetDate")
        }
    }
}

#Preview {
    DailyView()
        .modelContainer(Habit.preview)
}
