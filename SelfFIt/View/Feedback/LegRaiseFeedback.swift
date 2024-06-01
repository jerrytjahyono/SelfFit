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
        List {
            Section(header: Text("Exercise Finished")){
                HStack {
                    Text("Score")
                    Spacer()
                    if (legRaise.score < 51){
                        Text("\(legRaise.score)")
                            .foregroundStyle(.red)
                    }
                    else{
                        Text("\(legRaise.score)")
                    }
                }
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
                    Text("Total Duration")
                    Spacer()
                    Text("\(legRaise.totalExerciseDuration)")
                }
                HStack {
                    Text("Sets Estimated")
                    Spacer()
                    Text("\(legRaise.setEstimated)")
                }
                HStack {
                    Text("Sets Done")
                    Spacer()
                    Text("\(legRaise.setDone)")
                }
                HStack {
                    Text("Repetition Estimated")
                    Spacer()
                    Text("\(legRaise.repetitionEstimated)")
                }
                HStack {
                    Text("Repetition Done")
                    Spacer()
                    Text("\(legRaise.repetitionDone)")
                }
                HStack {
                    Text("Up Track Count")
                    Spacer()
                    Text("\(legRaise.upTrackCount)")
                }
                HStack {
                    Text("Bent Count")
                    Spacer()
                    Text("\(legRaise.bentCount)")
                }
                HStack {
                    Text("Over Rest Count")
                    Spacer()
                    Text("\(legRaise.overRestCount)")
                }
//                HStack {
//                    Text("Over Rest Duration")
//                    Spacer()
//                    Text(legRaise.overRestDuration.convertToMmSs())
//                }
                HStack {
                    Text("Failure Count")
                    Spacer()
                    Text("\(legRaise.failureCount)")
                }
//                HStack {
//                    Text("Failure Duration")
//                    Spacer()
//                    Text(legRaise.failureDuration.convertToMmSs())
//                }
//                HStack {
//                    Text("Leg Raise Duration")
//                    Spacer()
//                    Text(legRaise.legRaiseDuration.convertToMmSs())
//                }
//                HStack {
//                    Text("Rest")
//                    Spacer()
//                    Text(legRaise.rest.convertToMmSs())
//                }
            }
        }
        .navigationTitle(legRaise.displayExercise())
        .navigationBarTitleDisplayMode(.inline)
    }
}


//#Preview {
//    LegRaiseFeedback(legRaise: LegRaise(set: 4, repetition: 4, duration: "08:00", rest: "05:12", score: 0))
//}

