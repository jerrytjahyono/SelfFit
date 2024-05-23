//
//  HistoryList.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI

struct HistoryList: View {
    var histories: [History] = [
        History(title: "Plank"),
        History(title: "Leg Raise"),
        History(title: "Shuttle Run"),
        History(title: "Leg Raise"),
    ]
    
    var body: some View {
        NavigationStack{

            List{
                Section(header: Text("Exercises")){
                    ForEach(histories){ history in
                        NavigationLink{
                            HistoryRow(history:history)                    } label:{
                            HistoryRow(history:history)
                        }
                    }
                }

            }
            .navigationTitle("History")
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}

#Preview {
    HistoryList()
}
