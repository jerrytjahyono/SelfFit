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
    }
    func startActiveTimer() -> Void {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { timer in
            self.progressActive += 1
        }
    }
    
    func pauseActiveTimer() -> Void {
        timer.invalidate()
        print(self.progressActive)
    }
    
    func stopActiveTimer() -> Void {
        timer.invalidate()
        progressActive = 0
    }
    
    func startRestTimer() -> Void {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { timer in
            self.progressRest += 1
        }
    }
    
    func stopRestTimer() -> Void {
        timer.invalidate()
        progressRest = 0
    }
    
}
