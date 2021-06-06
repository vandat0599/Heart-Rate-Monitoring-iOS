//
//  AppDelegate.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/9/21.
//

import UIKit
import IQKeyboardManagerSwift
import Accelerate
import UserNotifications
import InAppSettingsKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var deviceToken: String?
    let globalDisposebag = DisposeBag()
    let rootViewController: UIViewController = {
        return UINavigationController(rootViewController: ContainerVC())
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceManager.shared.saveContext()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        PersistenceManager.shared.saveContext()
    }
    
    // MARK: - other
}

