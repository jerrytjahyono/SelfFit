//
//  HistoryList.swift
//  WatchSelfFit Watch App
//
//  Created by MacBook Pro on 05/06/24.
//

import SwiftUI
import SwiftData

struct HistoryList: View {
    
//    @Query(sort:\Plank.date) private var planks: [Plank]
    
    var body: some View {
        NavigationSplitView{
            List{
                NavigationLink {
                    LegRaiseFeedback()
                } label: {
                    HistoryRow()
                }

                NavigationLink {
                    LegRaiseFeedback()
                } label: {
                    HistoryRow()
                }
                
                NavigationLink {
                    LegRaiseFeedback()
                } label: {
                    HistoryRow()
                }
            }
            .navigationTitle("History")
            .padding(.top)
        }
        detail: {
            Text("Select a History")
        }
    }
}

#Preview {
    HistoryList()
}
