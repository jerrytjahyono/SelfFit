//
//  WatchConnector.swift
//  SelfFIt
//
//  Created by MacBook Pro on 05/06/24.
//

import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate {
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        
        
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sendMessage(_ message: [String : Any]) -> Void {
        guard self.session.isReachable else {
                return
        }
        
        print("recive data from iphone")
        if let plankStatus = message["plankStatus"] as? PlankStatus {
            guard let plankStatusMessage = plankStatus.encodePlankStatus() else {
                return
            }
            print("success data message")
            print(plankStatusMessage)
            
            self.session.sendMessage(["plankStatus" : plankStatusMessage], replyHandler: nil){(error) in print("WatchOS ERROR SENDING MESSAGE - " + error.localizedDescription)
                
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

}
