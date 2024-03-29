//
//  BaseVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/9/21.
//

import UIKit
import RxSwift

class BaseVC: UIViewController {
        
    //MARK: -Properties
    @IBAction func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    var hideStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
    
    lazy var centerXView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var centerYView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSettings()
    }
    
    private func setupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin), name: AppConstant.AppNotificationName.didLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: AppConstant.AppNotificationName.didLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingDidChange(notification:)), name: Notification.Name.IASKSettingChanged, object: nil)
        view.addSubview(centerXView)
        view.addSubview(centerYView)
        NSLayoutConstraint.activate([
            centerXView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerXView.heightAnchor.constraint(equalToConstant: 1),
            centerXView.widthAnchor.constraint(equalToConstant: 0),
            
            centerYView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -HomeContainerVC.bottomInsetHeight),
            centerYView.heightAnchor.constraint(equalToConstant: 0),
            centerYView.widthAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = ""
    }
    
    @objc func settingDidChange(notification: Notification?) {
        let sensivity = UserDefaults.standard.integer(forKey: "sensitivity_preference")
        if sensivity == 0 {
            CameraManager.shared.updateSensivity(sensivty: .low)
        } else {
            CameraManager.shared.updateSensivity(sensivty: .high)
        }
    }
    
    @objc func resetSettings() { }
    
    @objc func didLogin() {
        
    }
    
    @objc func didLogout() {
        
    }
}
