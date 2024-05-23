//
//  PlankFeedback.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI

struct PlankFeedback: View {
    
    var body: some View {
        NavigationStack{
            List {
                Section(header: Text("Exercise Finished")){
                    HStack {
                        Text("Date")
                        Spacer()
                        Text("2/2/2020")
                    }
                    HStack {
                        Text("Time")
                        Spacer()
                        Text("12:12")
                    }
                }
                Section(header: Text("Record")) {
                    HStack {
                        Text("Sets")
                        Spacer()
                        Text("2")
                    }
                    HStack {
                        Text("Duration")
                        Spacer()
                        Text("02:12")
                    }
                    HStack {
                        Text("Duration")
                        Spacer()
                        Text("02:12")
                    }
                    HStack {
                        Text("Calories Burned")
                        Spacer()
                        Text("2")
                    }
                }
            }
            .navigationTitle("Plank")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PlankFeedback()
}
