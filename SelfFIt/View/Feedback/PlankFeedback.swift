//
//  PlankFeedback.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI
import SwiftData

struct PlankFeedback: View {
    var plank: Plank
    
    init(plank: Plank, context: ModelContext) {
        self.plank = plank
        self.plank.score = self.calculatePlankScore(repetitionDone: plank.repetitionDone, repetitionEstimated: plank.repetitionEstimated, failureCount: plank.failureCount, tooHigh: plank.tooHighCount, tooLow: plank.tooLowCount)
    }
    
    init(plank: Plank) {
        self.plank = plank
        self.plank.score = self.calculatePlankScore(repetitionDone: plank.repetitionDone, repetitionEstimated: plank.repetitionEstimated, failureCount: plank.failureCount, tooHigh: plank.tooHighCount, tooLow: plank.tooLowCount)
    }

    
    
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
                        Text("Total Duration")
                        Spacer()
                        Text("\(plank.totalExerciseDuration)")
                    }
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
                        Text(plank.overRestDuration.convertToMmSs())
                    }
                    HStack {
                        Text("Failure Count")
                        Spacer()
                        Text("\(plank.failureCount)")
                    }
                    HStack {
                        Text("Failure Duration")
                        Spacer()
                        Text(plank.failureDuration.convertToMmSs())
                    }
                    HStack {
                        Text("Plank Duration")
                        Spacer()
                        Text(plank.plankDuration.convertToMmSs())
                    }
                    HStack {
                        Text("Rest")
                        Spacer()
                        Text(plank.rest.convertToMmSs())
                    }
                }
            }
            .navigationTitle(plank.displayExercise())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    PlankFeedback(plank: Plank(repetitionEstimated: 4, repetitionDone: 4, tooHighCount: 3, tooLowCount: 2, overRestCount: 3, overRestDuration: 3000, failureCount: 4, failureDuration: 3000, plankDuration: 2000, rest: 1000,score: 84,totalExerciseDuration: 0))
//}

extension PlankFeedback {
    
    func calculatePlankScore(repetitionDone: Int, repetitionEstimated: Int, failureCount: Int, tooHigh: Int, tooLow: Int)->Int{
        
        let penaltyFailure = 5
        let penaltyHigh = 2
        let penaltyLow = 2
        
        var repsScore = (repetitionDone / repetitionEstimated) * 100
        
        var penalty = (failureCount * penaltyFailure) + (tooHigh * penaltyHigh) + (tooLow * penaltyLow)
        
        var score = repsScore - penalty
        
        if score < 0 {
            return 0
        }
        return score
    }
}
