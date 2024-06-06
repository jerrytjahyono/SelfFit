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
    @Published var plankStatus: PlankStatus?
    
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
            if let messagePlank = message["plankStatus"] as? String {
                print("success retirive message")
                
                guard let plankStatusMessage = messagePlank.decodePlankStatus() else {
                    return
                }
                
                print("success decode message")
                self.plankStatus = plankStatusMessage as PlankStatus
                print("Received message > \((self.plankStatus?.condition == .firstTime))" )
                UserDefaults.standard.set(self.plankStatus?.encodePlankStatus(), forKey: "plankStatus")
            }
            self.receivedMessage = message["Message"] as? String ?? ""
            print("Received message > " + self.receivedMessage)
            UserDefaults.standard.set(self.receivedMessage, forKey: "message")
        }
    }
    
}
