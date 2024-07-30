//
//  AppBackgroundModifier.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 7/24/24.
//

import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(hex: "#720E7E"))
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func appBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}

