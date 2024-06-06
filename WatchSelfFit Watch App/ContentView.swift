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
        Text("Waiting for you to start exercise")
        Text(watchConnection.receivedMessage)
        
        VStack{
            if watchConnection != nil {
                Text("Go start your plank")
                Text("\(watchConnection.plankStatus?.duration)")
            }
        }.background(watchConnection.plankStatus?.condition == .firstTime ? .blue : .red)
//        HistoryList()
    }
}

#Preview {
    ContentView()
}
