//
//  WatchToIOS.swift
//  WatchSelfFit Watch App
//
//  Created by MacBook Pro on 05/06/24.
//

import Foundation

import WatchConnectivity

class WatchToIOS: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    @Published var receivedMessage = ""
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
        
        
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]){
        DispatchQueue.main.async {
            self.receivedMessage = message["Message"] as? String ?? ""
            print("Received message > " + self.receivedMessage)
            UserDefaults.standard.set(self.receivedMessage, forKey: "message")
        }
    }
    
}
