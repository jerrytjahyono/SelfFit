//
//  TimerService.swift
//  WatchSelfFit Watch App
//
//  Created by Alizaenal Abidin on 06/06/24.
//

import Foundation

class TimerService: ObservableObject {
    @Published var progressActive: Int = 0
    @Published var progressRest: Int = 0
    
    var timer = Timer()
    
    func idle() -> Void {
        timer.invalidate()
        progressRest = 0
        progressActive = 0
        print("tersangka idel")
    }
    func startActiveTimer() -> Void {
        print("start active timer")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { timer in
            self.progressActive += 1
        }
    }
    
    func pauseActiveTimer() -> Void {
        print("pause cok")
        timer.invalidate()
        print(self.progressActive)
    }
    
    func stopActiveTimer() -> Void {
        print("stop active timer")
        timer.invalidate()
        progressActive = 0
        print("tersangka stop")
    }
    
    func startRestTimer() -> Void {
        print("start test timer")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { timer in
            self.progressRest += 1
        }
    }
    
    func stopRestTimer() -> Void {
        print("stop rest timer")
        timer.invalidate()
        progressRest = 0
    }
    
}
