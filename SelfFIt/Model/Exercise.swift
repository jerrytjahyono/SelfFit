//
//  Exercise.swift
//  SelfFIt
//
//  Created by MacBook Pro on 23/05/24.
//

import Foundation
import SwiftUI
import SwiftData

protocol Exercise{
    var id: String { get }
    var date: Date { get }
    var imageName: String { get }
    var score: Int { get set }
    var backgroundGradient: Gradient { get }
    
    func displayExercise() -> String
    func formattedDate() -> String
}
