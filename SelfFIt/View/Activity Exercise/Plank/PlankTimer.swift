//
//  PlankTimer.swift
//  SelfFIt
//
//  Created by Alizaenal Abidin on 31/05/24.
//

import Foundation

class PlankTimer: ObservableObject {
    @Published var exerciseTimer = 0
    @Published var restTimer = 0
    @Published var overRestDuration = 0
    @Published var failureDuration = 0
    
    var timer = Timer()
    
    
    func startExerciseTimer() -> Void {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.exerciseTimer += 1
        }
    }
    
    func stopExerciseTimer() -> Void {
        print("stopp caled")
        timer.invalidate()
    }
    
    func startRestTimer() -> Void {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.restTimer += 1
        }
    }
    
    func stopRestTimer() -> Void {
        timer.invalidate()
    }
    
    
    func startOverRestTimer() -> Void {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.overRestDuration += 1
        }
    }
    
    func stopOverRestTimer() -> Void {
        timer.invalidate()
    }
    
    func startFailureTimer() -> Void {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.failureDuration += 1
        }
    }
    
    func stopFailureTimer() -> Void {
        timer.invalidate()
    }
    
    func finishExercise() -> Void {
        timer.invalidate()
    }
}
