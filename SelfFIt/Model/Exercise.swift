//
//  Exercise.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import Foundation

protocol Exercise: Codable, Identifiable, Hashable{
    var id: String { get }
    var date: Date { get }
    var imageName: String { get }
    
    func displayExercise() -> String
    func formattedDte() -> String
}
