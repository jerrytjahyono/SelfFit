//
//  ExerciseHome.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI

struct ExerciseHome: View {
    
    
    
    var body: some View {
        NavigationStack{
            List{
                HighlightView()
                
                NavigationLink{
                    PreparationPlankForm()
                } label:{
                    ExerciseRow(title: "Plank", image: "")
                }
                NavigationLink{
                    PreparationLegRaisesForm()
                } label:{
                    ExerciseRow(title: "Leg Raise", image: "")
                }
            }
            .navigationTitle("Home")
            .listStyle(.inset)
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}

#Preview {
    ExerciseHome()
}
