//
//  Plank.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import Foundation

struct Plank: Exercise {
    var id: String = UUID().uuidString
    var date: Date = Date()
    var set: Int
    var repetition: Int
    var duration: String
    var rest: String
    var imageName: String = ""
    
    func displayExercise() -> String {
        return "Plank"
    }
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, HH:mm"
        return dateFormatter.string(from: date)
    }
}


