//
//  HistoryRow.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI

struct HistoryRow: View {

    
    var exercise: any Exercise
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(exercise.displayExercise())
                Text(exercise.formattedDate())
                    .font(.subheadline)
                    .fontWeight(.thin)
                    
            }
            Spacer()
        }
    }
}

//#Preview {
//    HistoryRow(history: histories[0])
//}
