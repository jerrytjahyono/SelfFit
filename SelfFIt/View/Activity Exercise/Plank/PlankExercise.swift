//
//  PlankExercise.swift
//  SelfFIt
//
//  Created by Alizaenal Abidin on 24/05/24.
//

import SwiftUI

struct PlankExercise: View {
    @State private var duration = "00:00"
    @State private var durationRest = "00:00"
    @State private var repetition = 0
    @State private var isBackButtonActive = true
    
    @State private var progressTime = 236
    @State private var isTimerRunning = false
    
//    @StateObject var cameraService = PlankCameraService()
    @State private var timer: Timer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                       Image("PlankDummy")
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
                           .frame(minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                           .edgesIgnoringSafeArea(.all)
                       VStack(alignment: .leading) {
                           Spacer()
                           HStack(){
                               Button{
                                   if !isTimerRunning {
                                       timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in progressTime += 1
                                       })
                                   }
                                   
                               } label: {
                                   Text("Pause")
                                       .foregroundStyle(Color(.blue).opacity(isTimerRunning ? 1 : 0.5))
                                       .padding(.vertical,8)
                                       .padding(.horizontal,12)
                                       .background(Color(.blue).opacity(0.2))
                                       .buttonStyle(.bordered)
                                       .clipShape(.buttonBorder)
                               }.disabled(!isTimerRunning)
                               
                               NavigationLink{
                                   ExerciseHome()
                               }label: {
                                    Text("Stop")
                                       .foregroundStyle(Color(.red).opacity(isTimerRunning ? 1 : 0.5))
                                        .padding(.vertical,8)
                                        .padding(.horizontal,12)
                                        .background(Color(.red).opacity(0.2))
                                        .buttonStyle(.bordered)
                                        .clipShape(.buttonBorder)
                               }.disabled(!isTimerRunning)
                           }
                           .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
                           
                       }.foregroundColor(.blue)
                       .foregroundColor(.white)
                       
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 6){
                        Text("Duration: \(duration)")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding(.vertical,7)
                            .padding(.horizontal,14)
                            .background(Color(.gray).opacity(0.3))
                            .clipShape(.capsule)
                        Text("Duration Rest: \(durationRest)")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding(.vertical,7)
                            .padding(.horizontal,14)
                            .background(Color(.gray).opacity(0.3))
                            .clipShape(.capsule)
                        Text("Repetition: \(repetition)")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding(.vertical,7)
                            .padding(.horizontal,14)
                            .background(Color(.gray).opacity(0.3))
                            .clipShape(.capsule)
                            
                    }
                }
            }
            
        }
        }
    }

#Preview {
    PlankExercise()
}
