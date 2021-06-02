//
//  ContainerVC.swift
//  FlashCloud
//
//  Created by Đạt on 4/24/20.
//  Copyright © 2020 Dat. All rights reserved.
//

import UIKit
import Lottie
import InAppSettingsKit
import Messages
import AVFoundation

class ContainerVC: BaseVC, MenuVCDelegate, MFMailComposeViewControllerDelegate {
    //MARK: - Properties
    var isSHowingMenu = false
    private var showingVC: UINavigationController!
    private var vcArray: [UINavigationController] = []
    
    
    private lazy var measureVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: HeartRateVC(viewModel: HeartRateVCVMImp()))
        return vc
    }()
    
    private lazy var statVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: StatsVC())
        return vc
    }()
    
    private lazy var historyVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: HistoryVC1(viewModel: HistoryVM()))
        return vc
    }()
    
    private lazy var calmSelectionVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: HeartExserciseVC(viewModel: HeartExserciseVM()))
        return vc
    }()
    
    private lazy var settingVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: SettingVC())
        return vc
    }()
    
    private lazy var helpVC: UINavigationController = {
        let vc = UINavigationController(rootViewController: HelpVC())
        return vc
    }()
    
    private lazy var menuVC: MenuVC = {
        let menuVC = MenuVC()
        menuVC.delegate = self
        return menuVC
    }()
    
    private lazy var lottieMenu: AnimationView = {
        let view = AnimationView.init(name: "lottie-menu")
        view.currentProgress = 0
        view.animationSpeed = 4
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var menuControl: UIControl = {
        let control = UIControl(frame: CGRect(x: -12, y: 0, width: 44, height: 44))
        control.addSubview(lottieMenu)
        lottieMenu.frame = CGRect(x: control.center.x, y: control.center.y, width: control.bounds.width*0.5, height: control.bounds.height*0.5)
        lottieMenu.center = control.center
        control.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        return control
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tapView: UIControl = {
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        view.center = self.view.center
        view.addTarget(self, action: #selector(holderViewTapped), for: .touchUpInside)
        return view
    }()
    
    // MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        vcArray = [
            measureVC,
            statVC,
            historyVC,
            calmSelectionVC,
            settingVC,
            helpVC,
        ]
        showingVC = vcArray[0]
        display(showingVC)
        let appDefaults = (settingVC.topViewController as? SettingVC)?.settingsReader?.gatherDefaultsLimited(toEditableFields: true) ?? [:]
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuControl)
        view.insertSubview(menuVC.view, at: 0)
        menuVC.view.fitIn(parentView: view, padding: 0)
        addChild(menuVC)
        menuVC.didMove(toParent: self)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    //MARK: - setup
    
    private func display(_ child: UIViewController) {
        addChild(child)
        child.view.frame = containerView.bounds
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    private func hide(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    private func cycleVC(from oldVC: UIViewController, to newVC: UIViewController) {
        oldVC.willMove(toParent: nil)
        addChild(newVC)
        newVC.view.frame = containerView.bounds
        transition(from: oldVC, to: newVC, duration: 0.2, options: .transitionCrossDissolve, animations: {
        }, completion: { finished in
            oldVC.removeFromParent()
            newVC.didMove(toParent: self)
        })
    }
    
    private func showMenuVC(show: Bool, completion: (() -> Void)?) {
        if show {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.containerView.frame.origin.x = self.containerView.frame.width*0.6
                self.menuVC.view.transform = .identity
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.containerView.transform = .identity
                self.containerView.frame.origin.x = 0
            }, completion: {(_) in
                completion?()
            })
        }
    }
    
    @objc private func menuTapped() {
        toggleMenu()
    }
    
    @objc private func holderViewTapped() {
        toggleMenu()
    }
    
    func toggleMenu() {
        isSHowingMenu.toggle()
        if isSHowingMenu {
            lottieMenu.play(toProgress: 1)
            containerView.addSubview(tapView)
        } else {
            lottieMenu.play(toProgress: 0)
            tapView.removeFromSuperview()
        }
        showMenuVC(show: isSHowingMenu, completion: nil)
    }
    
    func onButtonCloseTapped() {
        toggleMenu()
    }
    
    func onItemTapped(index: Int) {
        UISelectionFeedbackGenerator().selectionChanged()
        if index > vcArray.count {
            toggleMenu()
            if index == 7 {
                openMailBox()
            } else if index == 8 {
                let loggedInAccount = UserDefaultHelper.getLogedUser()
                guard loggedInAccount != nil else {
                    let loginVC = UINavigationController(rootViewController: SignInVC())
                    present(loginVC, animated: true)
                    return
                }
                
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                let vc = LottieSheetViewController(
                    lottie: AnimationView.init(name: "lottie-warning"),
                    closeImage: UIImage(named: "ic-close")!,
                    title: "Warning!",
                    description: "If you log out of your account, your heart rate data will no longer be synced to our server!",
                    leftActionTitle: "CANCEL",
                    rightActionTitle: "LOGOUT",
                    leftAction: nil) {
                    UserDefaultHelper.remove(key: .loggedInAccount, async: true)
                    NotificationCenter.default.post(name: AppConstant.AppNotificationName.didLogout, object: nil)
                }
                vc.canDismissOnSwipeDown = true
                vc.closeButton.isHidden = true
                vc.canDismissOnTouchOutSide = true
                present(vc, animated: true, completion: nil)
            }
            return
        }
        guard index <= vcArray.count, showingVC != vcArray[index - 1] else {
            toggleMenu()
            return
        }
        NotificationCenter.default.post(name: AppConstant.AppNotificationName.menuButtonTapped, object: nil)
        toggleMenu()
        cycleVC(from: showingVC, to: vcArray[index - 1])
        showingVC = vcArray[index - 1]
        (showingVC.topViewController as? HeartRateVC)?.initVideoCapture()
        (showingVC.topViewController as? HeartExserciseVC)?.initVideoCapture()
    }
    
    func openMailBox() {
        let recipientEmail = "doantotnghiep.fit@gmail.com"
        let subject = "Heart Rate Monitor 2021 Feedback"
        let body = ""
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
        
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
