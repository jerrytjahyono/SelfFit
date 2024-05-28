//
//  PlankAudioService.swift
//  SelfFIt
//
//  Created by Alizaenal Abidin on 28/05/24.
//

import Foundation
import AVFAudio
import AVFoundation

enum PlankCondition {
case tooHigh, tooLow, correct
}

class PlankAudioService: ObservableObject {
    package var audioPlayer: AVAudioPlayer?
    
    init() {
        do {
            let sound = Bundle.main.path(forResource: "prepare", ofType: "wav",inDirectory: "Audios")
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }catch {
            print("error when init audio")
        }
    }
    
    func giveFeedback(_ condition: PlankCondition) -> Void {

        let conditionAudio : String = {
            switch condition {
            case .tooHigh:
                return "too_high"
            case .tooLow:
                return "too_low"
            case .correct:
                return "keep_it_up"
            }
        }()
        
        if let sound = Bundle.main.path(forResource: conditionAudio, ofType: "wav",inDirectory: "Audios") {
              do {
                  self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                print("play audio")
                  self.audioPlayer?.play()
              } catch {
                print("AVAudioPlayer could not be instantiated.")
              }
            } else {
              print("Audio file could not be found.")
            }
    }
}
