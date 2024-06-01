//
//  HistoryList.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI
import SwiftData

struct HistoryList: View {
    
    @Environment(\.modelContext) private var context
    
    
    @Query(sort:\Plank.date) private var planks: [Plank]
//    @Query(sort:\LegRaise.date) private var legRaises: [LegRaise]

    private var legRaises = [
        LegRaise(setEstimated: 0, setDone: 0, repetitionEstimated: 0, repetitionDone: 0, upTrackCount: 0, bentCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, legRaiseDuration: 0, rest: 0, score: 0, totalExerciseDuration: 0),
        LegRaise(setEstimated: 0, setDone: 0, repetitionEstimated: 0, repetitionDone: 0, upTrackCount: 0, bentCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, legRaiseDuration: 0, rest: 0, score: 0, totalExerciseDuration: 0)
    ]
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Exercises")){
                    ForEach(mergeAndShort(legraises: legRaises, planks: planks), id: \.id){ history in
                        if history is LegRaise {
                            NavigationLink{
                                LegRaiseFeedback(legRaise: history as! LegRaise)
                            } label : {
                                HistoryRow(exercise: history)
                            }
     
                        } else {
                            NavigationLink{
                                PlankFeedback(plank: history as! Plank)
                            } label : {
                                HistoryRow(exercise: history)
                            }
     
                        }
                   }
                }

            }
            .navigationTitle("History")
            .listStyle(.inset)
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
    func mergeAndShort(legraises: [LegRaise], planks: [Plank]) -> [any Exercise] {
        var allExercises: [any Exercise] = []
           
           allExercises.append(contentsOf: legraises)
           allExercises.append(contentsOf: planks)
           
           return allExercises.sorted { $0.date > $1.date }
    }
}

#Preview {
    HistoryList()
}
