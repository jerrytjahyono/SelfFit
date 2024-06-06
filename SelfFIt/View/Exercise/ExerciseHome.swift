//
//  ExerciseHome.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI

struct ExerciseHome: View {
    @State private var path = NavigationPath()
    @State private var watchActivated = false
    @State private var watchMessage = "bujang"
    var watchConnection = WatchConnector()
    
    
//    func activateWatch(){
//        if self.watchConnection.session.isReachable{
//            print("Watch avaliable")
//            self.watchActivated = true
//        }
//        else{
//            print("Watch unavaliable")
//            self.watchActivated = false
//        }
//    }
    
    func sendMessageToWatch(){
        if self.watchConnection.session.isReachable{
            print("Watch avaliable")
            self.watchActivated = true
            self.watchConnection.session.sendMessage(["Message" : String(self.watchMessage)], replyHandler: nil){
                (error) in print("WatchOS ERROR SENDING MESSAGE - " + error.localizedDescription)
            }
        }
        else{
            print("Watch unavaliable")
            self.watchActivated = false
        }
    }
    var body: some View {
        NavigationStack(path: $path){
            Button(action: {
                watchMessage="anjay gaming\(Int.random(in: 1...100))"
            }, label: {
                Text("anjay")
            })
            List{
                Section{
                    HighlightView()
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 10)
                        .listRowSeparator(.hidden)
                }
                .onChange(of: watchMessage){
                    self.sendMessageToWatch()
                }
                Section(header: Text("Exercises").foregroundStyle(.black)){
                    NavigationLink(value: Plank(repetitionEstimated: 0, repetitionDone: 0, tooHighCount: 0, tooLowCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, plankDuration: 0, rest: 0, score: 0, totalExerciseDuration: 0)){
                        ExerciseRow(title: "Plank", image: "PlankIcon")
                    }
                    
                    /// Temporary Disable: for v0.2.0
//                    NavigationLink{
//                        PreparationLegRaisesForm()
//                    } label:{
//                        ExerciseRow(title: "Leg Raise", image: "")
//                    }
                }
            }
            .navigationDestination(for: Plank.self){ plank in
                if path.count == 2 && plank.repetitionEstimated > 0  {
                                    PlankExercise(plankData: plank)
                                    { plankResult in
                                        print("💢path.count")
                                        print(path.count)
                                        path.removeLast(path.count)
                                        print(path.count)
                                        path.append(plankResult)
                                        print(path.count)
                                    }

                                }

                                if path.count < 2 && plank.repetitionEstimated < 1{
                                    PreparationPlankForm(plankData: plank){ formPlank in
                                        path.append(formPlank)

                                    }
                                }

                                if path.count < 2 && plank.repetitionEstimated >= 1{
                                    PlankFeedback(plank: plank)
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
