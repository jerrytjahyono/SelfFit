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
    
    func displayExercise() -> String {
        return "Leg Raise"
    }
    
    func formattedDte() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MM, HH:mm"
        return dateFormatter.string(from: date)
    }
}
