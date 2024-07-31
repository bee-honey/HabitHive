//
//  HabitFormView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//

import SwiftUI

struct HabitFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var model: HabitFormModel
    @State private var selectingIcon: Bool = false
    @State private var selectedDays: [Bool] = Array(repeating: false, count: 7)
//    @State private var countPerDay: Int = 1
    let daySymbols = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            NavigationStack {
                VStack(spacing: 20) {
                    LabeledContent {
                        TextField("Name", text: $model.name)
                            .textFieldStyle(.roundedBorder)
                    } label: {
                        Text("Name")
                    }
                    
                    LabeledContent {
                        HStack {
                            ForEach(0..<daySymbols.count, id: \.self) { index in
                                Button(action: {
                                    selectedDays[index].toggle()
                                    model.selectedDays[index] = selectedDays[index]
                                }) {
                                    Text(daySymbols[index])
                                        .font(.system(size: 16))
                                        .foregroundColor(selectedDays[safe: index] ?? false ? .white : .black)
                                        .frame(width: 30, height: 30)
                                        .background(selectedDays[safe: index] ?? false ? Color.blue : Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(PlainButtonStyle()) // Ensures the button doesn't have default padding
                            }
                        }
                    } label: {
                        Text("Days")
                    }
                    
                    
                    LabeledContent {
                        Picker("Times per day", selection: $model.countPerDay) {
                            ForEach(1..<25) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(.menu)
                    } label: {
                        Text("Times per day")
                    }
                    
                    LabeledContent {
                        Button {
                            selectingIcon.toggle()
                        } label: {
                            Image(systemName: model.icon.rawValue)
                        }
                    } label: {
                        Text("Icon")
                    }
                    
                    LabeledContent {
                        ColorPicker("", selection: $model.hexColor, supportsOpacity: false)
                    } label: {
                        Text("Task color")
                    }
                    .padding(.top)
                    
                    Button(model.updating ? "Update" : "Create") {
                        let enabledDays: [WeekDay] = selectedDays.enumerated().compactMap { index, isSelected in
                            isSelected ? WeekDay.allCases[index] : nil
                        }
                        if model.updating {
                            if let habit = model.habit {
                                habit.name = model.name
                                habit.icon = model.icon.rawValue
                                habit.hexColor = model.hexColor.toHex()!
                                habit.countPerDay = model.countPerDay
                                habit.enabledDays = enabledDays
                                print("\(model.countPerDay) and \(habit.countPerDay)")
                            }
                        } else {
                            let newHabit = Habit(
                                name: model.name,
                                icon: model.icon,
                                hexColor: model.hexColor.toHex()!,
                                countPerDay: model.countPerDay,
                                enabledDays: enabledDays
                            )
                            modelContext.insert(newHabit)
                        }
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                    .buttonStyle(.borderedProminent)
                    .disabled(model.disabled)
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle(model.updating ? "Edit Habit" : "New Habit")
                .navigationBarTitleDisplayMode(.inline)
            }
            if selectingIcon {
                HabitIconSelectionView(selectingIcon: $selectingIcon, selectedIcon: $model.icon)
                    .zIndex(1.0)
            }
        }
        .onAppear {
            // Initialize selectedDays from model's data
            if model.updating, let habit = model.habit {
                selectedDays = WeekDay.allCases.map { weekDay in
                    habit.enabledDays.contains(weekDay)
                }
                
                model.countPerDay = habit.countPerDay
            }
            
            
        }
    }
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    HabitFormView(model: HabitFormModel())
        .modelContainer(Habit.preview)
}
