//
//  HistoryList.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI

struct HistoryList: View {
    
    var exercises: [any Exercise] = [
        LegRaise(set: 4, repetition: 4, duration: "08:00", rest: "05:12"),
        Plank(repetitionEstimated: 4, repetitionDone: 4, tooHighCount: 3, tooLowCount: 2, overRestCount: 3, overRestDuration: Date(), failureCount: 4, failureDuration: Date(), plankDuration: Date(), rest: Date(),score: 84)    ]
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Exercises")){
                    ForEach(exercises, id: \.id){ history in
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
    
}

#Preview {
    HistoryList()
}
