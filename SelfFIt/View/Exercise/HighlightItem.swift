//
//  HighlightItem.swift
//  SelfFIt
//
//  Created by MacBook Pro on 24/05/24.
//

import SwiftUI

struct HighlightItem: View {
    
    var exercise: any Exercise
    
    var body: some View {
        ZStack(alignment: .topLeading){
            HighlightBackground(exercise: exercise)
            
            VStack(alignment: .leading){
                Text(exercise.displayExercise())
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundStyle(.white)
                Text(exercise.formattedDate())
                    .font(.caption)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(exercise.score)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .frame(width: 250, height: 150)
        .cornerRadius(10)
        .padding(.leading, 15)
    }
}

//#Preview {
//    Group{
//        HighlightItem(exercise: LegRaise(set: 4, repetition: 4, duration: "08:00", rest: "05:12", score: 0))
//        HighlightItem(exercise: Plank(repetitionEstimated: 4, repetitionDone: 4, tooHighCount: 3, tooLowCount: 2, overRestCount: 3, overRestDuration: 5000, failureCount: 4, failureDuration: 3000, plankDuration: 9000, rest: 3000,score: 84,totalExerciseDuration: 0))
//    }
//}
