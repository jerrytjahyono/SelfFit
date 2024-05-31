//
//  LegRaise.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import Foundation
import SwiftUI
import SwiftData

class LegRaise: Exercise {
    var id: String = UUID().uuidString
    var date: Date = Date()
    var set: Int
    var repetition: Int
    var duration: String
    var rest: String
    var imageName: String = ""
    var score: Int = 90
    
    init(id: String, date: Date, set: Int, repetition: Int, duration: String, rest: String, imageName: String, score: Int) {
        self.id = id
        self.date = date
        self.set = set
        self.repetition = repetition
        self.duration = duration
        self.rest = rest
        self.imageName = imageName
        self.score = score
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
