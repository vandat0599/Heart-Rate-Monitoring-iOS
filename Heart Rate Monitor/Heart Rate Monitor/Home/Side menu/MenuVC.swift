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
    weak var delegate: MenuVCDelegate!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let loggedAccount = UserDefaultHelper.getLogedUser()
        if loggedAccount == nil {
            loginButton.setImage(UIImage(named: "ic-login"), for: .normal)
            loginButton.setTitle("Login", for: .normal)
        } else {
            loginButton.setImage(UIImage(named: "ic-logout"), for: .normal)
            loginButton.setTitle("Logout", for: .normal)
        }
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
    }
    
    override func didLogout() {
        super.didLogout()
        loginButton.setImage(UIImage(named: "ic-login"), for: .normal)
        loginButton.setTitle("Login", for: .normal)
    }
}
