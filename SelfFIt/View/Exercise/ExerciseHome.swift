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
                    ExerciseRow(title: "Plank", image: "")
                } label:{
                    ExerciseRow(title: "Plank", image: "")
                }
                NavigationLink{
                    ExerciseRow(title: "Leg Raise", image: "")
                } label:{
                    ExerciseRow(title: "Leg Raise", image: "")
                }
                NavigationLink{
                    ExerciseRow(title: "Shuttle Run", image: "")
                } label:{
                    ExerciseRow(title: "Shuttle Run", image: "")
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
