//
//  PreparationLegRaisesForm.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import SwiftUI

struct PreparationLegRaisesForm: View {
    @State private var repetition: Int = 0
    @State private var set: Int = 0
    
    // state for rest
    @State private var restMinutes: Int = 0
    @State private var restSeconds: Int = 0
    @State private var showRestPicker: Bool = false
    
  
    
    var body: some View {
        NavigationStack{
            VStack (alignment: .center) {
                
                HStack {
                    Text("Repition")
                    Spacer()
                    Text("\(repetition)")
                        .padding(.horizontal, 4)
                    Stepper("", value: $repetition, in: 0...100)
                        .labelsHidden()
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Divider()
                
                HStack {
                    Text("Set")
                    Spacer()
                    Text("\(set)")
                        .padding(.horizontal, 4)
                    Stepper("", value: $set, in: 0...100)
                        .labelsHidden()
                }
                .padding(.horizontal, 20)
                
                Divider()
                
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
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Plank")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start") {
                        // Masuk ke Exercise view
                    }
                }
            }
        }
    }
}

#Preview {
    PreparationLegRaisesForm()
}
