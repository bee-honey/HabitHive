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
            ZStack {
                //                Color.bgcolor
                //                    .edgesIgnoringSafeArea(.all) // Ensure the color covers the entire screen
                Group {
                    
                    if habits.isEmpty {
                        ContentUnavailableView("Create your first Habit by tapping on the \(Image(systemName: "plus.circle.fill")) button at the top.", image: "launchScreen")
                    } else {
                        ScrollView() {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(habits) { habit in
                                    let today = Calendar.current.component(.weekday, from: Date())
                                    let todayIndex = today - 1 // Sunday = 1, Monday = 2, ..., Saturday = 7 in Calendar, WeekDay starts from 0
                                    let todayWeekDay = WeekDay.allCases[todayIndex]
                                    
                                    if habit.enabledDays.contains(todayWeekDay) {
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
                                                //                                                .foregroundColor(isButtonActive ? .primary : .white)
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(2)
                                                    .frame(maxWidth: .infinity, alignment: Alignment.center)
                                            }
                                            .padding()
                                            .background(Color(isButtonActive ? Color(UIColor.white) : Color(red: 0.97, green: 0.97, blue: 0.97)))
//                                            .cornerRadius(isButtonActive ? 10 : 5 )
                                            .cornerRadius(10)
                                            .shadow(radius: isButtonActive ? 5 : 0)
                                            .overlay(alignment: .topLeading) {
                                                if remainingCount > 0 {
                                                    Image(systemName: remainingCount < 50 ? "\(remainingCount).circle.fill" : "plus.circle.fill")
                                                        .foregroundColor(Color(red: 1, green: 0.1, blue: 0.2))
                                                        .imageScale(.medium)
                                                        .background(Color(.systemBackground)
                                                            .clipShape(.circle)
                                                        )
                                                        .offset(x: 5, y: 5)
                                                } else {
                                                    VStack {
                                                        HStack {
                                                            if remainingCount == 0 {
                                                                Image(systemName: "checkmark.circle.fill")
                                                                    .foregroundColor(.green)
                                                                    .offset(x: 5, y: 5)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .disabled(!isButtonActive)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                    }
                }
                .toolbar {
                    Button {
                        modalType = .newHabit
                    } label: {
                        Image(systemName: "plus.circle.fill")
                        //                            .foregroundColor(.white)
                    }
                    .sheet(item: $modalType) { sheet in
                        sheet
                            .presentationDetents([.height(375)])
                    }
                }
                .navigationTitle("Today's Routine")
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                resetCountsIfNeeded()
                initializeHabitCounts()
            }
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
