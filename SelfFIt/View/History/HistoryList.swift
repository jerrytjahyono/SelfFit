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
    private var legRaises = [
    LegRaise(set: 0, repetition: 0, duration: "0", rest: "0", score: 0),
    LegRaise(set: 0, repetition: 0, duration: "0", rest: "0", score: 0),
    LegRaise(set: 0, repetition: 0, duration: "0", rest: "0", score: 0),
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
