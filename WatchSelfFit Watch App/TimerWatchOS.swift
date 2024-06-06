//
//  TimerWatchOS.swift
//  WatchSelfFit Watch App
//
//  Created by MacBook Pro on 06/06/24.
//

import SwiftUI

struct TimerWatchOS: View {
    @EnvironmentObject var watchConnection : WatchToIOS
    @ObservedObject var timerService = TimerService()

    @State var currentCondition: ExerciseStatus = .firstTime

    var body: some View {
        ZStack {
            withAnimation {
                CircleProgress(progress: progresEstimator())
            }
            VStack {
                Text(watchConnection.plankStatus?.condition == .active || watchConnection.plankStatus?.condition == .failure ? timerService.progressActive.asTimestamp : timerService.progressRest.asTimestamp)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
            }
            .onAppear{
                print("timer inside on appear")
                print(watchConnection.plankStatus?.condition)
                print(watchConnection.plankStatus)
                print(watchConnection)
                self .currentCondition = watchConnection.plankStatus?.condition ?? .firstTime
                if watchConnection.plankStatus?.condition == .active {
                    timerService.startActiveTimer()
                }
                
            }
            .onChange(of: watchConnection.plankStatus?.condition){
                print("watchConnection.plankStatus?.condition")
                print(watchConnection.plankStatus?.condition)
                if watchConnection.plankStatus?.condition == .active {
                    if currentCondition == .failure || currentCondition == .overRest || currentCondition == .firstTime {
                        
                        timerService.startActiveTimer()
                    }else if currentCondition == .rest {
                        timerService.stopRestTimer()
                        timerService.startActiveTimer()
                    }else{
                        timerService.idle()
                    }
                }else if watchConnection.plankStatus?.condition == .rest {
                    if currentCondition == .active {
                        timerService.stopActiveTimer()
                        timerService.startRestTimer()
                    }else {
                        timerService.idle()
                    }
                }else if watchConnection.plankStatus?.condition == .failure {
                    print(timerService.progressActive)
                    print("bujang")
                    timerService.pauseActiveTimer()
                }else if watchConnection.plankStatus?.condition == .overRest{
                    if currentCondition == .rest {
                        timerService.idle()
                    }
                }else {
                    timerService.idle()
                }
                
                self.currentCondition = watchConnection.plankStatus?.condition ?? .firstTime
            }
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor(for: watchConnection.plankStatus?.condition))
    }
    
    func backgroundColor(for condition: ExerciseStatus?) -> Color {
        switch condition {
        case .firstTime, .finish, .none:
            return .accentColor
        case .active:
            return Color("LightGreen")
        case .rest:
            return Color("LightBlue")
        case .overRest, .failure:
            return Color("PastelRed")
        }
    }
    
    func progresEstimator() -> Float {
        if watchConnection.plankStatus?.condition == .active || watchConnection.plankStatus?.condition == .failure  {
            return Float(Float(self.timerService.progressActive) / Float(watchConnection.plankStatus?.duration ?? 0))
        }else if watchConnection.plankStatus?.condition == .rest {
            return Float(Float(self.timerService.progressRest) / Float(watchConnection.plankStatus?.restDuration ?? 0))
        }
        return 0.0
    }
}

#Preview {
    TimerWatchOS()
}

extension Int {
    var asTimestamp: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i:%02i", minute, second)
    }
}
