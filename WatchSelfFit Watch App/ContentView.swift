//
//  ContentView.swift
//  WatchSelfFit Watch App
//
//  Created by MacBook Pro on 05/06/24.
//

import SwiftUI
//import WatchConnectivity

struct ContentView: View {

    @ObservedObject var watchConnection = WatchToIOS()
    
    var body: some View {
        HistoryList()
    }
}

#Preview {
    ContentView()
}
