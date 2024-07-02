//
//  HabitFormView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//

import SwiftUI
import SwiftData

struct HabitFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var model: HabitFormModel
    @State private var selectingIcon: Bool = false
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
                        Text("Activity color")
                    }
                    .padding(.top)
                    Button(model.updating ? "Update" : "Create") {
                        if model.updating {
                            model.habit?.name = model.name
                            model.habit?.icon = model.icon.rawValue
                            model.habit?.hexColor = model.hexColor.toHex()!
                            
                        } else {
                            let newHabit = Habit(name: model.name, icon: model.icon, hexColor: model.hexColor.toHex()!)
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
    }
}

#Preview {
    HabitFormView(model: HabitFormModel())
        .modelContainer(Habit.preview)
}
