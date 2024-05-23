//
//  HistoryList.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI

struct HistoryList: View {
//    var histories: [History] = [
//        History(title: "Plank"),
//        History(title: "Leg Raise"),
//        History(title: "Shuttle Run"),
//        History(title: "Leg Raise"),
//    ]
    
    var exercises: [any Exercise] = [
        LegRaise(set: 4, repetition: 4, duration: "08:00", rest: "05:12"),
        Plank(set: 4, repetition: 4, duration: "08:00", rest: "05:12")
    ]
    
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
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
    
}

#Preview {
    HistoryList()
}
