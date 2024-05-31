//
//  Plank.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import Foundation
import SwiftUI

struct Plank: Exercise {
    var id: String = UUID().uuidString
    var date: Date = Date()
//    var repetition: Int
//    var duration: String
//    var rest: String
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
    var imageName: String = ""
    var score: Int
    var totalExerciseDuration : Int
    
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




