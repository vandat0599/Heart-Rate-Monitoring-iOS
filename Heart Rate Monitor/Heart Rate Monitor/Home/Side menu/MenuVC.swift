//
//  MenuVC.swift
//  FlashCloud
//
//  Created by Đạt on 4/24/20.
//  Copyright © 2020 Dat. All rights reserved.
//

import UIKit

protocol MenuVCDelegate: AnyObject {
    func onButtonCloseTapped()
    func onItemTapped(index: Int)
}

class MenuVC: BaseVC {
    //MARK: - Properties
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userEmailButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    weak var delegate: MenuVCDelegate!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let loggedAccount = UserDefaultHelper.getLogedUser()
        if let account = loggedAccount {
            loginButton.setImage(UIImage(named: "ic-logout"), for: .normal)
            loginButton.setTitle("Logout", for: .normal)
            userEmailButton.isHidden = false
            userEmailButton.setTitle("Hi, \(account.name ?? "unknow")", for: .normal)
        } else {
            loginButton.setImage(UIImage(named: "ic-login"), for: .normal)
            loginButton.setTitle("Login", for: .normal)
            userEmailButton.isHidden = true
        }
        scrollView.alwaysBounceVertical = true
        userEmailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        userEmailButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        userEmailButton.sizeToFit()
    }

    //MARK: -Actions
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.delegate.onButtonCloseTapped()
    }
    
    @IBAction func itemTapped(_ sender: UIButton) {
        self.delegate.onItemTapped(index: sender.tag)
    }
    
    override func didLogin() {
        super.didLogin()
        loginButton.setImage(UIImage(named: "ic-logout"), for: .normal)
        loginButton.setTitle("Logout", for: .normal)
        if let account = UserDefaultHelper.getLogedUser() {
            userEmailButton.isHidden = false
            userEmailButton.setTitle("Hi, \(account.name ?? "unknow")", for: .normal)
        } else {
            userEmailButton.isHidden = true
            userEmailButton.setTitle("", for: .normal)
        }
    }
    
    override func didLogout() {
        super.didLogout()
        loginButton.setImage(UIImage(named: "ic-login"), for: .normal)
        loginButton.setTitle("Login", for: .normal)
        userEmailButton.isHidden = true
        userEmailButton.setTitle("", for: .normal)
    }
}
