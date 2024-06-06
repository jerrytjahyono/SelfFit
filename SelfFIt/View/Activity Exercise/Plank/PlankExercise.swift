//
//  PlankExercise.swift
//  SelfFIt
//
//  Created by Alizaenal Abidin on 24/05/24.
//

import SwiftUI
import AVFAudio
import AVFoundation

struct PlankExercise: View {
    @Environment(\.modelContext) private var context
    @State package var plankData: Plank
    init(plankData: Plank, pushView: @escaping (Plank) -> Void) {
        self.plankData = plankData
        self.pushView = pushView
    }

    
    let pushView: (Plank) -> Void
    @State private var exerciseStatus: ExerciseStatus = .firstTime
    @State private var isFinishedExercise = false
    
    @State private var duration = 0
    @State private var repetition = 0
    @State private var durationRest = 0
    @State private var isBackButtonActive = true
    
    @State private var isTimerRunning = false
    
    @StateObject var cameraService = PlankCameraService()
    private var audioService = PlankAudioService()
    @State private var isPlayingAudio = false

    @StateObject var timerPlank = PlankTimer()
    @State var timer = Timer()
    @State var imageFrame: UIImage?
    
    var watchConnection = WatchConnector()
    
    
    private let overRestTimerQueue = DispatchQueue.init(label: "OversestTimer.service", qos: .utility)
    

    
    var body: some View {

            ZStack {
                if let frame = imageFrame {
                    Image(uiImage: imageFrame!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
                    .frame(minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .onReceive(self.cameraService.$cameraFrame, perform: { currentFrame in
                        self.imageFrame = currentFrame
                    })
                    .onChange(of: frame){
                        if self.cameraService.frameCount % 11 == 0 {
                            
                            if self.exerciseStatus == .finish {
                                exerciseStatus = .finish
                                isFinishedExercise = true
                                timerPlank.finishExercise()
                                finishExerciseDataPrepare()
                            }
                            
                            if exerciseStatus == .firstTime && cameraService.isOnPlankPosition{
                                exerciseStatus = .active
                                // TODO: Turn on the exercise timer
                                self.timerPlank.startExerciseTimer()
                            }
                            
                            if exerciseStatus == .failure && cameraService.isOnPlankPosition{
                                self.cameraService.isOnRest = false
                                exerciseStatus = .active
                                timerPlank.stopFailureTimer()
                                timerPlank.startExerciseTimer()
                            }
                            
                            if exerciseStatus == .overRest && cameraService.isOnPlankPosition {
                                self.cameraService.isOnRest = false
                                exerciseStatus = .active
                                if self.timerPlank.overRestDelay == 0 {
                                    self.plankData.overRestCount += 1
                                }
                                timerPlank.stopOverRestTimer()
                                timerPlank.startExerciseTimer()
                            }
                        }
                    }
                    
                               
                } else {
                    Text("Please wait opening your camera....")
                        .onReceive(self.cameraService.$cameraFrame, perform: { currentFrame in
                            self.imageFrame = currentFrame
                        })
                        .onAppear {
                            watchConnection.sendMessage(["plankStatus" : PlankStatus(condition: .firstTime, duration: self.plankData.plankDuration, restDuration: self.plankData.rest)])
                        }
                    VStack{
                        Button("Active"){
                            print("button active clicked")
                            self.exerciseStatus = .active
                        }
                        Button("Rest"){
                            self.exerciseStatus = .rest
                        }
                        Button("Failure"){
                            self.exerciseStatus = .failure
                        }
                        Button("Finish"){
                            self.exerciseStatus = .finish
                        }
                        Button("Over rest"){
                            self.exerciseStatus = .overRest
                        }
                    }.padding()
                    
                    
                }
                       VStack(alignment: .leading) {
                           Spacer()
                           HStack(){
                                   Button("Stop"){
                                       print("clicked")
                                       finishExerciseDataPrepare()
                                       plankData.calculatePlankScore()
                                       context.insert(plankData)
                                       pushView(plankData)
                                   }
                                       .foregroundStyle(Color(.red).opacity(isTimerRunning ? 0 : 1))
                                        .padding(.vertical,8)
                                        .padding(.horizontal,12)
                                        .background(Color(.red).opacity(0.2))
                                        .clipShape(.buttonBorder)
                                        .disabled(self.exerciseStatus == .firstTime)
                           }
                           .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)
                           
                       }.foregroundColor(.blue)
                       .foregroundColor(.white)
                       
            }
            .onChange(of: self.exerciseStatus, {
                print("onchange called \(self.exerciseStatus)")
                watchConnection.sendMessage(["plankStatus" : PlankStatus(condition: self.exerciseStatus, duration: self.plankData.plankDuration, restDuration: self.plankData.rest)])
            })
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 6){
                        Text("Duration: \(timerPlank.exerciseTimer.convertToMmSs())")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding(.vertical,7)
                            .padding(.horizontal,14)
                            .background(Color(.gray).opacity(0.3))
                            .clipShape(.capsule)
                            .onChange(of: timerPlank.exerciseTimer, perform: exerciseTimerOnChange)
                        
                        Text("Duration Rest: \(timerPlank.restTimer.convertToMmSs())")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding(.vertical,7)
                            .padding(.horizontal,14)
                            .background(Color(.gray).opacity(0.3))
                            .clipShape(.capsule)
                            .onChange(of: timerPlank.restTimer, perform: restTimerOnChange)
                        
                        Text("Repetition: \(repetition)")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding(.vertical,7)
                            .padding(.horizontal,14)
                            .background(Color(.gray).opacity(0.3))
                            .clipShape(.capsule)
                            .onChange(of: repetition, perform: repetitionCountOnChange)
                    }
                }
            }
        }
    
    func exerciseTimerOnChange(_ duration: Int) -> Void {
            // TODO: cek apakah durasi terkini sudah memenuhi durasi yang telah ditentukan plank pada form, jika sudah memenuh durasi plank yang telah ditentukan maka jalankan durasi rest serta tambahkan nilai repitisi
            
            if exerciseStatus != .active {
                return
            }
        
            if self.cameraService.isOnPlankPosition == false {
                exerciseStatus = .failure
                self.plankData.failureCount += 1
                self.timerPlank.stopExerciseTimer()
                self.timerPlank.startFailureTimer()
                return
            }
            
            if duration >= self.plankData.plankDuration {
                exerciseStatus = .rest
                self.cameraService.isOnRest = true
                DispatchQueue.global(qos: .background).async{
                    if let sound = Bundle.main.path(forResource: "time_to_rest", ofType: "wav",inDirectory: "Audios") {
                          do {
                              audioService.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                              print("play audio")
                              audioService.audioPlayer?.play()
                          } catch {
                            print("AVAudioPlayer could not be instantiated.")
                          }
                        } else {
                          print("Audio file could not be found.")
                        }
                }
                self.repetition += 1
                timerPlank.exerciseTimer = 0
                self.timerPlank.stopExerciseTimer()
                self.timerPlank.startRestTimer()
                return
            }
            
    }
    
    func restTimerOnChange(_ duration: Int) -> Void {
        if (self.plankData.rest - duration) == 4 {
            DispatchQueue.global(qos: .background).async{
                if let sound = Bundle.main.path(forResource: "countdown_beep", ofType: "wav",inDirectory: "Audios") {
                      do {
                          audioService.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                          print("play audio")
                          audioService.audioPlayer?.play()
                      } catch {
                        print("AVAudioPlayer could not be instantiated.")
                      }
                    } else {
                      print("Audio file could not be found.")
                    }
            }
        }
        
        // TODO: cek apakah durasi terkini sudah habis jika sudah maka lanjutkan
        if duration >= self.plankData.rest {
            exerciseStatus = .overRest
            self.timerPlank.restTimer = 0
            self.timerPlank.stopRestTimer()
                if exerciseStatus == .overRest {
                    self.timerPlank.startOverRestTimer()
                }
        }
        
    }
    
    
    func repetitionCountOnChange(_ count: Int) -> Void {
        self.plankData.repetitionDone += 1
        
        if count >= self.plankData.repetitionEstimated {
            // TODO: Direct to feedback view and passing the exercise data
            exerciseStatus = .finish
            isFinishedExercise = true
            timerPlank.finishExercise()
            finishExerciseDataPrepare()
            plankData.calculatePlankScore()
            print(plankData)
            context.insert(plankData)
            pushView(plankData)
        }
    }
    
    func finishExerciseDataPrepare() -> Void {
        self.plankData.overRestDuration = self.timerPlank.overRestDuration
        self.plankData.failureDuration = self.timerPlank.failureDuration
        self.plankData.tooLowCount = self.cameraService.tooLowCount
        self.plankData.tooHighCount = self.cameraService.tooHighCount
        self.plankData.totalExerciseDuration = ( self.plankData.plankDuration * self.plankData.repetitionEstimated
        )
        if self.plankData.repetitionDone < self.plankData.repetitionEstimated { 
            self.plankData.totalExerciseDuration  = ( (self.plankData.plankDuration * self.plankData.repetitionDone
              ) + self.timerPlank.exerciseTimer
            )
        }
    }


    }

#Preview {
    PlankExercise(plankData: Plank(repetitionEstimated: 2, repetitionDone: 0, tooHighCount: 0, tooLowCount: 0, overRestCount: 0, overRestDuration: 0, failureCount: 0, failureDuration: 0, plankDuration: 10, rest: 12,score: 78, totalExerciseDuration: 0)){ _ in
        
    }
}


extension Int {
    
    func convertToTimesStr() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
    
    func convertToMmSs() -> String {
        let tempTimes = self.convertToTimesStr()
        var tempMinutes = "\(tempTimes.1)"
        var tempSeconds = "\(tempTimes.2)"
        if tempTimes.1 < 10 {
            tempMinutes = "0\(tempTimes.1)"
        }
        
        if tempTimes.2 < 10 {
            tempSeconds = "0\(tempTimes.2)"
        }
        return "\(tempMinutes):\(tempSeconds)"
    }
}
