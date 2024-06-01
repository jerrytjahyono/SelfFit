//
//  ExerciseHome.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI

struct ExerciseHome: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            List{
                Section{
                    HighlightView()
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 10)
                        .listRowSeparator(.hidden)
                }
                Section(header: Text("Exercises").foregroundStyle(.black)){
                    NavigationLink(value: Plank(repetitionEstimated: 0, repetitionDone: 0, tooHighCount: 0, tooLowCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, plankDuration: 0, rest: 0, score: 0, totalExerciseDuration: 0)){
                        ExerciseRow(title: "Plank", image: "")
                    }
                    NavigationLink{
                        PreparationLegRaisesForm()
                    } label:{
                        ExerciseRow(title: "Leg Raise", image: "")
                    }
                }
            }
            .navigationDestination(for: Plank.self){ plank in
                if path.count == 2 && plank.repetitionEstimated > 0  {
                                    PlankExercise(plankData: plank)
                                    { plankResult in
                                        path.removeLast(path.count)
                                        path.append(plankResult)
                                    }
                                        .onAppear{
                                            print(plank.repetitionEstimated)
                                            print("🦠\(path.count)")
                                            print("🦠\(path.count)")
                                            print("🦠\(path.count)")
                                            print("🦠\(path.count)")
                                            print("🦠\(path.count)")
                                            print("🦠\(path.count)")
                                        }

                                }

                                if path.count < 2 && plank.repetitionEstimated < 1{
                                    PreparationPlankForm(plankData: plank){ formPlank in
                                        path.append(formPlank)

                                    }
                                        .onAppear{
                                            print(plank.repetitionEstimated)
                                        print("coook \(path.count)")
                                    }

                                }

                                if path.count < 2 && plank.repetitionEstimated > 1{
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
