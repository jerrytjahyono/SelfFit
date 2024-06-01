//
//  PreparationPlankForm.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI

struct PreparationPlankForm: View {
    @State var plankData: Plank
    let pushNextView : (Plank) -> Void
    
    @State private var repetition: Int = 0
    // state for duration
    @State private var durationMinutes: Int = 0
    @State private var durationSeconds: Int = 0
    @State private var showDurationPicker: Bool = false
    // state for rest
    @State private var restMinutes: Int = 0
    @State private var restSeconds: Int = 0
    @State private var showRestPicker: Bool = false
  
    
    var body: some View {
        List{
            HStack {
                Text("Repition")
                Spacer()
                Text("\(repetition)")
                   .padding(.horizontal, 4)
                Stepper("", value: $repetition, in: 0...100)
                   .labelsHidden()
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Duration")
                    Spacer()
                    Text(String(format: "%02d:%02d", durationMinutes, durationSeconds))
                        .padding(.horizontal)
                }
                .onTapGesture {
                    showDurationPicker.toggle()
                }
                .padding(.vertical)
                if showDurationPicker {
                    HStack {
                        VStack {
                            Text("Minutes")
                                .font(.body)
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                            
                            Picker("Minutes", selection: $durationMinutes) {
                                ForEach(0..<60) { minute in
                                    Text("\(minute)")
                                }
                            }
                        }
                        
                        VStack {
                            Text("Seconds")
                                .font(.body)
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                            Picker("Seconds", selection: $durationSeconds) {
                                ForEach(0..<60) { second in
                                    Text("\(second)")
                                }
                            }
                        }
                        
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Rest")
                    Spacer()
                    Text(String(format: "%02d:%02d", restMinutes, restSeconds))
                        .padding(.horizontal)
                    
                }
                .onTapGesture {
                    showRestPicker.toggle()
                }
                .padding(.vertical)
                if showRestPicker {
                    HStack {
                        VStack {
                            Text("Minutes")
                                .font(.body)
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                            Picker("Minutes", selection: $restMinutes) {
                                ForEach(0..<60) { minute in
                                    Text("\(minute)")
                                }
                            }
                        }
                        
                        VStack {
                            Text("Seconds")
                                .font(.body)
                                .fontWeight(.light)
                                .foregroundColor(Color.gray)
                            Picker("Seconds", selection: $restSeconds) {
                                ForEach(0..<60) { second in
                                    Text("\(second)")
                                }
                                
                            }
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            
        }
        .navigationTitle("Plank")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (repetition != 0 && durationMinutes+durationSeconds != 0 && restMinutes+restSeconds != 0){
                    Button("Next"){
                        pushNextView(Plank(repetitionEstimated: repetition, repetitionDone: 0, tooHighCount: 0, tooLowCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, plankDuration: ( (durationMinutes * 60 ) + durationSeconds), rest: ((restMinutes * 60 ) + restSeconds), score: 0, totalExerciseDuration: 0))

                    }
                }
            }
        }
    }
}

#Preview {
    PreparationPlankForm(plankData: Plank(repetitionEstimated: 0, repetitionDone: 0, tooHighCount: 0, tooLowCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, plankDuration: 0, rest: 0, score: 0, totalExerciseDuration: 0)){ _ in
        
    }
}
