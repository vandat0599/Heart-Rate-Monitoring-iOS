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
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(named: "black-background")
        showDoneButton = false
        
        
    }
}
