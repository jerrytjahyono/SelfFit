//
//  Plank.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Plank: Exercise {
    var id: String
    var date: Date
    var repetitionEstimated: Int
    var repetitionDone: Int
    var tooHighCount: Int
    var tooLowCount: Int
    var overRestCount: Int
    var overRestDuration: Int
    var failureCount: Int
    var failureDuration: Int
    var plankDuration: Int
    var rest: Int
    var imageName: String
    var score: Int
    var totalExerciseDuration : Int
    
    
    init(repetitionEstimated: Int, repetitionDone: Int, tooHighCount: Int, tooLowCount: Int, overRestCount: Int, overRestDuration: Int, failureCount: Int, failureDuration: Int, plankDuration: Int, rest: Int, score: Int, totalExerciseDuration: Int, context: ModelContext) {
        self.id = UUID().uuidString
        self.date = Date()
        self.repetitionEstimated = repetitionEstimated
        self.repetitionDone = repetitionDone
        self.tooHighCount = tooHighCount
        self.tooLowCount = tooLowCount
        self.overRestCount = overRestCount
        self.overRestDuration = overRestDuration
        self.failureCount = failureCount
        self.failureDuration = failureDuration
        self.plankDuration = plankDuration
        self.rest = rest
        self.imageName = "PlankIcon"
        self.score = score
        self.totalExerciseDuration = totalExerciseDuration
        
        context.insert(self)
    }
    init(repetitionEstimated: Int, repetitionDone: Int, tooHighCount: Int, tooLowCount: Int, overRestCount: Int, overRestDuration: Int, failureCount: Int, failureDuration: Int, plankDuration: Int, rest: Int, score: Int, totalExerciseDuration: Int) {
        self.id = UUID().uuidString
        self.date = Date()
        self.repetitionEstimated = repetitionEstimated
        self.repetitionDone = repetitionDone
        self.tooHighCount = tooHighCount
        self.tooLowCount = tooLowCount
        self.overRestCount = overRestCount
        self.overRestDuration = overRestDuration
        self.failureCount = failureCount
        self.failureDuration = failureDuration
        self.plankDuration = plankDuration
        self.rest = rest
        self.imageName = "PlankIcon"
        self.score = score
        self.totalExerciseDuration = totalExerciseDuration
    }
    
    var backgroundGradient: Gradient {
        Gradient(colors: [.red, Color("pastelPink")])
    }
    
    func displayExercise() -> String {
        return "Plank"
    }
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, HH:mm"
        return dateFormatter.string(from: date)
    }
    func formattedTime(time:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        return dateFormatter.string(from: time)
    }
    
}




