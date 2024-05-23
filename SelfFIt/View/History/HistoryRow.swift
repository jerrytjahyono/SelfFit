//
//  HistoryRow.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import SwiftUI

struct HistoryRow: View {

    
    var history: History
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(history.title)
                Text(history.formattedDate())
                    .font(.subheadline)
                    .fontWeight(.thin)
                    
            }
            Spacer()
        }
    }
}

#Preview {
    HistoryRow(history: histories[0])
}
