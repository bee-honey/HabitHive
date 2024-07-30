//
//  HabitHiveApp.swift
//  HabitHive
//
//  Created by Naveen Keerthy on 6/30/24.
//

import SwiftUI
import SwiftData

@main
struct HabitHiveApp: App {
    
//    init() {
//            let tabBarAppearance = UITabBarAppearance()
//            tabBarAppearance.configureWithOpaqueBackground()
//        tabBarAppearance.backgroundColor = .bgcolor // Set background color if needed
//            UITabBar.appearance().standardAppearance = tabBarAppearance
//            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//            UITabBar.appearance().tintColor = .white // Set the selected item color to white
//            UITabBar.appearance().unselectedItemTintColor = .red // Set the unselected item color, if needed
//        }
    
    init() {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
//            tabBarAppearance.backgroundColor = .bgcolor // Background color if needed
//            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
//            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .systemGray
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

    var body: some Scene {
        WindowGroup {
            StartTab()
                .modelContainer(for: Habit.self)
        }
    }
}
