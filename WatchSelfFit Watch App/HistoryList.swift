////
////  HistoryList.swift
////  WatchSelfFit Watch App
////
////  Created by MacBook Pro on 05/06/24.
////
//
//import SwiftUI
//import SwiftData
//
//struct HistoryList: View {
//    
////    @Query(sort:\Plank.date) private var planks: [Plank]
//    @ObservedObject var watchConnection = WatchToIOS()
//    
//    
//    var body: some View {
//        NavigationSplitView{
//            List{
//                
//                
//                ForEach(getHistories(exercises: watchConnection.receivedMessage), id: \.id) {history in
//                    Text("\(history.score)")
//                }
////
////                NavigationLink {
////                    LegRaiseFeedback()
////                } label: {
////                    HistoryRow()
////                }
////                
////                NavigationLink {
////                    LegRaiseFeedback()
////                } label: {
////                    HistoryRow()
////                }
//            }
//            .navigationTitle("History")
//            .padding(.top)
//        }
//        detail: {
//            Text("Select a History")
//        }
//    }
//    
//    func getHistories(exercises: [any Exercise]?) -> [any Exercise] {
//        guard let exercise = exercises else {
//            return []
//        }
//        return exercise
//    }
//}
//
//#Preview {
//    HistoryList()
//}
