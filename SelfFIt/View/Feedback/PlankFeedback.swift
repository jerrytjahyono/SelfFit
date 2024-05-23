//
//  PlankFeedback.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI

struct PlankFeedback: View {
    var plank: Plank
    
    var body: some View {
        NavigationStack{
            List {
                Section(header: Text("Exercise Finished")){
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(plank.date.formatted(date: .numeric, time: .omitted))
                    }
                    HStack {
                        Text("Time")
                        Spacer()
                        Text(plank.date.formatted(date: .omitted, time: .shortened))
                    }
                }
                Section(header: Text("Record")) {
                    HStack {
                        Text("Sets")
                        Spacer()
                        Text("\(plank.set)")
                    }
                    HStack {
                        Text("Repetition")
                        Spacer()
                        Text("\(plank.repetition)")
                    }
                    HStack {
                        Text("Duration")
                        Spacer()
                        Text(plank.duration)
                    }
                    HStack {
                        Text("Rest")
                        Spacer()
                        Text(plank.rest)
                    }
                }
            }
            .navigationTitle(plank.displayExercise())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PlankFeedback(plank: Plank(set: 4, repetition: 4, duration: "08:00", rest: "05:12"))
}
