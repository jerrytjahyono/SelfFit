//
//  HighlightBackground.swift
//  SelfFIt
//
//  Created by MacBook Pro on 24/05/24.
//

import SwiftUI

struct HighlightBackground: View {
    
    var exercise: any Exercise
    
    var body: some View {
        LinearGradient(
            gradient: exercise.backgroundGradient, startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    HighlightBackground(exercise: LegRaise(set: 4, repetition: 4, duration: "08:00", rest: "05:12"))
//}
