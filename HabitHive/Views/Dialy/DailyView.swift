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
    @State private var habitCounts: [Habit.ID: Int] = [:]
    
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
                                            habitCounts[habit.id] = remainingCount - 1
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
                                    .overlay(
                                        VStack {
                                            HStack {
                                                if isButtonActive {
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                                                            .frame(width: 24, height: 24)
                                                        Text("\(remainingCount)")
                                                            .foregroundColor(.red)
                                                            .font(.caption)
                                                            .bold()
                                                    }
                                                    .padding(.leading, 5)
                                                }
                                                Spacer()
                                            }
                                            
                                            Spacer()
                                        }
                                            .padding([.top, .trailing], 5)
                                    )
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
                        .presentationDetents([.height(450)])
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
        for habit in habits {
            if habitCounts[habit.id] == nil {
                habitCounts[habit.id] = habit.countPerDay
            }
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
