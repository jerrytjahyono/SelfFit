//
//  ContentView.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection: Tab = .home
    @State public var isTabViewActive = true
    
    enum Tab {
        case home
        case history
    }
    
    @Environment(\.modelContext) private var modelContext
    @Query private var plank: [Plank]
//    @Query private var exercises: [Exercise]
    
    var body: some View {
        
        TabView(selection: $selection) {
            ExerciseHome()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            HistoryList()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(Tab.history)
        }
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
