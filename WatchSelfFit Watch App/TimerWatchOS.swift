//
//  TimerWatchOS.swift
//  WatchSelfFit Watch App
//
//  Created by MacBook Pro on 06/06/24.
//

import SwiftUI

struct TimerWatchOS: View {
    @ObservedObject var watchConnection = WatchToIOS()
    var secondsToCompletion = 1000
    var progress: Float = 0.9


    var body: some View {
        ZStack {
            withAnimation {
                CircleProgress(progress: progress)
            }
            VStack {
                Text(secondsToCompletion.asTimestamp)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
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
