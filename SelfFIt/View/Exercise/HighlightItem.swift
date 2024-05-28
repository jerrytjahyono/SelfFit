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
                Text("100 cal")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .frame(width: 250, height: 150)
        .cornerRadius(10)
        .padding(.leading, 15)
    }
}

#Preview {
    Group{
        HighlightItem(exercise: LegRaise(set: 4, repetition: 4, duration: "08:00", rest: "05:12"))
        HighlightItem(exercise: Plank(repetition: 4, duration: "08:00", rest: "05:12"))
    }
}
