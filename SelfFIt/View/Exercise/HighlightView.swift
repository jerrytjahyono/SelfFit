//
//  HighlightView.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI
import SwiftData

struct HighlightView: View {
    
    @Query(sort:\Plank.date) private var planks: [Plank]
//    @Query(sort:\LegRaise.date) private var legRaises: [LegRaise]

    private var legRaises = [
    LegRaise(setEstimated: 0, setDone: 0, repetitionEstimated: 0, repetitionDone: 0, upTrackCount: 0, bentCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, legRaiseDuration: 0, rest: 0, score: 0, totalExerciseDuration: 0),
    LegRaise(setEstimated: 0, setDone: 0, repetitionEstimated: 0, repetitionDone: 0, upTrackCount: 0, bentCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, legRaiseDuration: 0, rest: 0, score: 0, totalExerciseDuration: 0)
    ]
    
    var exercises: [any Exercise] = [
        Plank(repetitionEstimated: 4, repetitionDone: 4, tooHighCount: 3, tooLowCount: 2, overRestCount: 3, overRestDuration: 3500, failureCount: 4, failureDuration: 7000, plankDuration: 53300, rest: 1200,score: 84,totalExerciseDuration: 0)
    ]
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Highlight")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0){
                    ForEach(mergeAndShort(legraises: legRaises, planks: planks), id: \.id){ exercise in
                        if exercise is LegRaise {
                            NavigationLink{
                                LegRaiseFeedback(legRaise: exercise as! LegRaise)
                            } label : {
                                HighlightItem(exercise: exercise)
                            }
                        } else {
                            NavigationLink{
                                PlankFeedback(plank: exercise as! Plank)
                            } label : {
                                HighlightItem(exercise: exercise)                         
                            }
                        }
                    }
                }
            }
//            .frame(height: 185)
        }
    }
    func mergeAndShort(legraises: [LegRaise], planks: [Plank]) -> [any Exercise] {
        var allExercises: [any Exercise] = []
           
           allExercises.append(contentsOf: legraises)
           allExercises.append(contentsOf: planks)
           
           return allExercises.sorted { $0.date > $1.date }
    }
}

#Preview {
    HighlightView()
}
