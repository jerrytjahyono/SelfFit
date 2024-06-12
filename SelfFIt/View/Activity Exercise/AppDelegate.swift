//
//  AppDelegate.swift
//  SelfFIt
//
//  Created by Alizaenal Abidin on 12/06/24.
//

import Foundation
import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {

    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                    }
                }
                UIViewController.attemptRotationToDeviceOrientation()
            } else {
                if orientationLock == .landscape {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension View {
    @ViewBuilder
    func forceRotation(orientation: UIInterfaceOrientationMask) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.onAppear() {
                AppDelegate.orientationLock = orientation
            }
            // Reset orientation to previous setting
            let currentOrientation = AppDelegate.orientationLock
            self.onDisappear() {
                AppDelegate.orientationLock = currentOrientation
            }
        } else {
            self
        }
    }
}
