//
//  HabitIconSelectionView.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/1/24.
//
import SwiftUI

struct HabitIconSelectionView: View {
    @Binding var selectingIcon: Bool
    @Binding var selectedIcon: HabitSymbol
    let columns = [GridItem(.adaptive(minimum: 40))]
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 10)
                        .frame(width: 300, height: 420 )
                        .overlay(
                            VStack {
                                ScrollView(showsIndicators: true) {
                                    LazyVGrid(columns: columns, spacing: 28) {
                                        ForEach(HabitSymbol.allCases, id: \.self) { symbol in
                                            Button {
                                                selectedIcon = symbol
                                                withAnimation {
                                                    selectingIcon = false
                                                }
                                            } label : {
                                                Image(systemName: symbol.rawValue)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 30)
                                                    .tint(selectedIcon == symbol ? .red : .blue)
                                                    .scaleEffect(selectedIcon == symbol ? 1.5: 1)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .padding()
                                Spacer()
                            })
                }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State private var selectedIcon:HabitSymbol = .mixedCardio
        var body: some View {
            HabitIconSelectionView(selectingIcon: .constant(true), selectedIcon: $selectedIcon)
        }
    }
    return Preview()
}
