//
//  HighlightView.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI

struct HighlightView: View {
    
    var exercises: [any Exercise] = [
        LegRaise(set: 4, repetition: 4, duration: "08:00", rest: "05:12"),
        Plank(repetitionEstimated: 4, repetitionDone: 4, tooHighCount: 3, tooLowCount: 2, overRestCount: 3, overRestDuration: Date(), failureCount: 4, failureDuration: Date(), plankDuration: Date(), rest: Date(),score: 84)
    ]
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Highlight")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0){
                    ForEach(exercises, id: \.id) { exercise in
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
}

#Preview {
    HighlightView()
}
