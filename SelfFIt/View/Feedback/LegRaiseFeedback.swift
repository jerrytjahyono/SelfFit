//
//  LegRaiseFeedback.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI

struct LegRaiseFeedback: View {
    let legRaise: LegRaise
    
    var body: some View {
        NavigationStack{
            List {
                Section(header: Text("Exercise Finished")){
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(legRaise.date.formatted(date: .numeric, time: .omitted))
                    }
                    HStack {
                        Text("Time")
                        Spacer()
                        Text(legRaise.date.formatted(date: .omitted, time: .shortened))
                    }
                }
                Section(header: Text("Record")) {
                    HStack {
                        Text("Sets")
                        Spacer()
                        Text("\(legRaise.set)")
                    }
                    HStack {
                        Text("Repetition")
                        Spacer()
                        Text("\(legRaise.repetition)")
                    }
                    HStack {
                        Text("Duration")
                        Spacer()
                        Text(legRaise.duration)
                    }
                    HStack {
                        Text("Rest")
                        Spacer()
                        Text(legRaise.rest)
                    }
                }
            }
            .navigationTitle(legRaise.displayExercise())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    LegRaiseFeedback(legRaise: LegRaise(set: 4, repetition: 4, duration: "08:00", rest: "05:12"))
//}
