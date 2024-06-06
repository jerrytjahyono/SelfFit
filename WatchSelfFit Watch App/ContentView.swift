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
    private var timer = Timer()

    var body: some View {
        if watchConnection.plankStatus?.condition == .firstTime {
            Text("Please take a plank position")
        }
        else if watchConnection.plankStatus?.condition == .finish {
            Text("Please check your phone to see feedback")
        }
        else if watchConnection.plankStatus?.condition == nil {
            Text("Waiting for you to start exercise...")
        }
        else{
            TimerWatchOS()
        }
    }
}

#Preview {
    ContentView()
}
