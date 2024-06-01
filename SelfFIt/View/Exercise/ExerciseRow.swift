//
//  ExerciseRow.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI

struct ExerciseRow: View {
    let title: String
    let image: String
    
    var body: some View {
        HStack{
            Image(image)
                .resizable()
                .frame(width: 50, height: 50)
                .background(.blue)
                .cornerRadius(10)
            Text(title)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

//#Preview {
//    ExerciseRow()
//}
