//
//  SettingVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 22/05/2021.
//

import UIKit
import InAppSettingsKit

class SettingVC: IASKAppSettingsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBar()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        navigationItem.rightBarButtonItem = nil
        view.backgroundColor = UIColor(named: "black-background")
        showDoneButton = false
        showCreditsFooter = false
        NotificationCenter.default.addObserver(self, selector: #selector(settingDidChange(notification:)), name: Notification.Name.IASKSettingChanged, object: nil)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(named: "black-background")!), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = UIColor(named: "black-background")
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func settingDidChange(notification: Notification?) {
        print("settingDidChange")
        print(UserDefaults.standard.bool(forKey: "flash_preference"))
    }
}
