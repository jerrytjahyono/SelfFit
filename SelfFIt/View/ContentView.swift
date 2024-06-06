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
    
    @State private var watchActivated = false
    @State private var watchMessage = ""
    var watchConnection = WatchConnector()
    
    
    func activateWatch(){
        if self.watchConnection.session.isReachable{
            print("Watch avaliable")
            self.watchActivated = true
        }
        else{
            print("Watch unavaliable")
            self.watchActivated = false
        }
    }
    
    enum Tab {
        case home
        case history
    }
    
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
