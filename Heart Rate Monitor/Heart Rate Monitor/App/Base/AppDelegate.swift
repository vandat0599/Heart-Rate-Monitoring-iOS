//
//  AppDelegate.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/9/21.
//

import UIKit
import IQKeyboardManagerSwift
import Accelerate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let rootViewController: UIViewController = {
        return UINavigationController(rootViewController: HomeContainerVC())
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
//        let fft = FFT()
//
//        let n = 512 // Should be power of two for the FFT
//        let frequency1 = 4.0
//        let phase1 = 0.0
//        let amplitude1 = 8.0
//        let seconds = 2.0
//        let fps = Double(n)/seconds
//
//        let sineWave = (0..<n).map {
//            amplitude1 * sin(2.0 * .pi / fps * Double($0) * frequency1 + phase1)
//        }
//
//        fft.calculate(sineWave, fps: fps)
        
        return true
    }
}

