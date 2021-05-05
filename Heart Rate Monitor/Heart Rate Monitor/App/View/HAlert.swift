
//
//  HAlert.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 07/04/2021.
//

import UIKit
import Lottie
import Alamofire

class HAlert: UIView {
    
    static func showErrorBottomSheet(_ viewController: UIViewController, message: String, rightAction: (() -> ())? = nil) {
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            showAlertErrorNetwork(viewController)
            return
        }
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        let vc = LottieSheetOneActionVC(
            lottie: AnimationView.init(name: "lottie-error"),
            closeImage: UIImage(named: "ic-close")!,
            title: "Error!",
            description: message,
            rightActionTitle: "OK",
            rightAction: nil)
        vc.canDismissOnSwipeDown = false
        vc.closeButton.isHidden = true
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func showSuccessBottomSheet(_ viewController: UIViewController, message: String, rightAction: (() -> ())? = nil) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        let vc = LottieSheetOneActionVC(
            lottie: AnimationView.init(name: "lottie-success"),
            closeImage: UIImage(named: "ic-close")!,
            title: "Success!",
            description: message,
            rightActionTitle: "OK",
            rightAction: rightAction)
        vc.canDismissOnSwipeDown = false
        vc.closeButton.isHidden = true
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func showAlertErrorNetwork(_ viewController: UIViewController) {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        let vc = LottieSheetViewController(
            lottie: AnimationView.init(name: "lottie-internet-connection"),
            closeImage: UIImage(named: "ic-close")!,
            title: "You seem to be offline",
            description: "Check your Wi-Fi connection or cellular data and try again",
            leftActionTitle: "Retry",
            rightActionTitle: "Settings",
            leftAction: nil) {
            let application = UIApplication.shared
            if let url = URL(string: "App-Prefs:root=WIFI"), application.canOpenURL(url)    {
                application.open(url, options: [:], completionHandler: nil)
            }
        }
        vc.canDismissOnSwipeDown = false
        vc.closeButton.isHidden = true
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func showAlertWithTwoAction(_ viewController: UIViewController, lottieName: String, title: String, message: String, leftTitle: String, rightTitle: String, leftAction: (() -> ())? = nil, rightAction: (() -> ())? = nil) {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        let vc = LottieSheetViewController(
            lottie: AnimationView.init(name: lottieName),
            closeImage: UIImage(named: "ic-close")!,
            title: title,
            description: message,
            leftActionTitle: leftTitle,
            rightActionTitle: rightTitle,
            leftAction: leftAction,
            rightAction: rightAction)
        vc.canDismissOnSwipeDown = false
        vc.closeButton.isHidden = true
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func showBasic(title: String?,
                          message: String?,
                          viewController: UIViewController,
                          handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: handler))
        viewController.present(alert, animated: true)
    }
    
    static func showPopupWithTextField(title: String?,
                                       firstAction: String?,
                                       secondAction: String?,
                                       firstHandler: ((UIAlertAction) -> Void)?,
                                       secondHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "File Name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: firstAction, style: .default, handler: firstHandler))
        alert.addAction(UIAlertAction(title: secondAction, style: .default, handler: secondHandler))
        return alert
    }
    
    static func showTwoActions(title: String?,
                              message: String?,
                              firstAction: String?,
                              secondAction: String?,
                              firstHandler: ((UIAlertAction) -> Void)?,
                              secondHandler: ((UIAlertAction) -> Void)?,
                              viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: firstAction, style: .default, handler: firstHandler))
        alert.addAction(UIAlertAction(title: secondAction, style: .default, handler: secondHandler))
        viewController.present(alert, animated: true)
    }
}
