//
//  LegRaise.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class LegRaise: Exercise {
    var id: String
    var date: Date
    var setEstimated: Int
    var setDone: Int
    var repetitionEstimated: Int
    var repetitionDone:Int
    var upTrackCount: Int
    var bentCount: Int
    var overRestCount: Int
    var overRestDuration: Int
    var failureCount: Int
    var failureDuration: Int
    var legRaiseDuration: Int
    var rest: Int
    var imageName: String
    var score: Int
    var totalExerciseDuration : Int
    
    init(setEstimated: Int, setDone: Int, repetitionEstimated: Int, repetitionDone: Int, upTrackCount: Int, bentCount: Int, overRestCount: Int, overRestDuration: Int, failureCount: Int, failureDuration: Int, legRaiseDuration: Int, rest: Int, score: Int, totalExerciseDuration: Int, context: ModelContext) {
        self.id = UUID().uuidString
        self.date = Date()
        self.setEstimated = setEstimated
        self.setDone = setDone
        self.repetitionEstimated = repetitionEstimated
        self.repetitionDone = repetitionDone
        self.upTrackCount = upTrackCount
        self.bentCount = bentCount
        self.overRestCount = overRestCount
        self.overRestDuration = overRestDuration
        self.failureCount = failureCount
        self.failureDuration = failureDuration
        self.legRaiseDuration = legRaiseDuration
        self.rest = rest
        self.imageName = "LegRaiseIcon"
        self.score = score
        self.totalExerciseDuration = totalExerciseDuration
        
        context.insert(self)
    }
    
    init(setEstimated: Int, setDone: Int, repetitionEstimated: Int, repetitionDone: Int, upTrackCount: Int, bentCount: Int, overRestCount: Int, overRestDuration: Int, failureCount: Int, failureDuration: Int, legRaiseDuration: Int, rest: Int, score: Int, totalExerciseDuration: Int) {
        self.id = UUID().uuidString
        self.date = Date()
        self.setEstimated = setEstimated
        self.setDone = setDone
        self.repetitionEstimated = repetitionEstimated
        self.repetitionDone = repetitionDone
        self.upTrackCount = upTrackCount
        self.bentCount = bentCount
        self.overRestCount = overRestCount
        self.overRestDuration = overRestDuration
        self.failureCount = failureCount
        self.failureDuration = failureDuration
        self.legRaiseDuration = legRaiseDuration
        self.rest = rest
        self.imageName = "LegRaiseIcon"
        self.score = score
        self.totalExerciseDuration = totalExerciseDuration
    }
    
    var backgroundGradient: Gradient {
        Gradient(colors: [.blue, Color("lightBlue")])
    }
    
    func displayExercise() -> String {
        return "Leg Raise"
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
}
