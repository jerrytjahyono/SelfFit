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
                        Text("Score")
                        Spacer()
                        if (plank.score<51){
                            Text("\(plank.score)")
                                .foregroundStyle(.red)
                        }
                        else{
                            Text("\(plank.score)")
                        }
                    }
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
                        Text("Repetition Estimated")
                        Spacer()
                        Text("\(plank.repetitionEstimated)")
                    }
                    HStack {
                        Text("Repetition Done")
                        Spacer()
                        Text("\(plank.repetitionDone)")
                    }
                    HStack {
                        Text("Too High Count")
                        Spacer()
                        Text("\(plank.tooHighCount)")
                    }
                    HStack {
                        Text("Too Low Count")
                        Spacer()
                        Text("\(plank.tooLowCount)")
                    }
                    HStack {
                        Text("Over Rest Count")
                        Spacer()
                        Text("\(plank.overRestCount)")
                    }
                    HStack {
                        Text("Over Rest Duration")
                        Spacer()
                        Text(plank.formattedTime(time: plank.overRestDuration))
                    }
                    HStack {
                        Text("Failure Count")
                        Spacer()
                        Text("\(plank.failureCount)")
                    }
                    HStack {
                        Text("Failure Duration")
                        Spacer()
                        Text(plank.formattedTime(time: plank.failureDuration))
                    }
                    HStack {
                        Text("Plank Duration")
                        Spacer()
                        Text(plank.formattedTime(time: plank.plankDuration))
                    }
                    HStack {
                        Text("Rest")
                        Spacer()
                        Text(plank.formattedTime(time: plank.rest))
                    }
                }
            }
            .navigationTitle(plank.displayExercise())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PlankFeedback(plank: Plank(repetitionEstimated: 4, repetitionDone: 4, tooHighCount: 3, tooLowCount: 2, overRestCount: 3, overRestDuration: Date(), failureCount: 4, failureDuration: Date(), plankDuration: Date(), rest: Date(),score: 84))
}
