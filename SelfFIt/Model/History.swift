//
//  History.swift
//  SelfFIt
//
//  Created by jerry tri tjahyono on 23/05/24.
//

import Foundation

struct History: Hashable, Codable, Identifiable{
    var id: String = UUID().uuidString
    var title: String
    var date: Date = Date()
    
    func formattedDate() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM,HH:mm"
            return dateFormatter.string(from: date)
        }
}


let histories: [History] = [
    History(title: "Plank"),
    History(title: "Leg Raise"),
    History(title: "Shuttle Run"),
    History(title: "Leg Raise"),
]
