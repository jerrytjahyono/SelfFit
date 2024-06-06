//
//  LegRaiseFeedback.swift
//  WatchSelfFit Watch App
//
//  Created by MacBook Pro on 05/06/24.
//

import SwiftUI

struct LegRaiseFeedback: View {
    var body: some View {
        List {
            Section(header: Text("Exercise Finished")){
                HStack {
                    Text("Score")
                    Spacer()
                    Text("20")
                }
                HStack {
                    Text("Date")
                    Spacer()
                    Text("\(Date().formatted(date: .omitted, time: .shortened))")
                }
                HStack {
                    Text("Date")
                    Spacer()
                    Text("\(Date().formatted(date: .omitted, time: .shortened))")
                }
            }
            Section(header: Text("Record")) {
                HStack {
                    Text("Total Duration")
                    Spacer()
                    Text("\(2)")
                }
                HStack {
                    Text("Sets Estimated")
                    Spacer()
                    Text("\(2)")
                }
                HStack {
                    Text("Sets Done")
                    Spacer()
                    Text("\(2)")
                }
                HStack {
                    Text("Repetition Estimated")
                    Spacer()
                    Text("\(2)")
                }
                HStack {
                    Text("Repetition Done")
                    Spacer()
                    Text("\(2)")
                }
                HStack {
                    Text("Up Track Count")
                    Spacer()
                    Text("\(2)")
                }
                HStack {
                    Text("Bent Count")
                    Spacer()
                    Text("\(2)")
                }
                HStack {
                    Text("Over Rest Count")
                    Spacer()
                    Text("\(2)")
                }
//                HStack {
//                    Text("Over Rest Duration")
//                    Spacer()
//                    Text(legRaise.overRestDuration.convertToMmSs())
//                }
                HStack {
                    Text("Failure Count")
                    Spacer()
                    Text("\(2)")
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
        .navigationTitle("LegRaise")

    }
}

#Preview {
    LegRaiseFeedback()
}
