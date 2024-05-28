//
//  LegRaise.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import Foundation
import SwiftUI

struct LegRaise: Exercise {
    var id: String = UUID().uuidString
    var date: Date = Date()
    var set: Int
    var repetition: Int
    var duration: String
    var rest: String
    var imageName: String = ""
    var score: Int = 90
    
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
