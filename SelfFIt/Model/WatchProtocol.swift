//
//  WatchProtocol.swift
//  SelfFIt
//
//  Created by MacBook Pro on 06/06/24.
//

import Foundation



struct PlankStatus: Encodable, Decodable {
    var condition : ExerciseStatus
    var duration : Int
    var restDuration : Int
}


extension PlankStatus {
    func encodePlankStatus() -> String? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to encode PlankStatus: \(error)")
            return nil
        }
    }
}

extension String {
    func decodePlankStatus() -> PlankStatus? {
        let decoder = JSONDecoder()
        do {
            guard let data = self.data(using: .utf8) else {
                return nil
            }
            let plankStatus = try decoder.decode(PlankStatus.self, from: data)
            return plankStatus
        } catch {
            print("Failed to decode PlankStatus: \(error)")
            return nil
        }
    }
}
