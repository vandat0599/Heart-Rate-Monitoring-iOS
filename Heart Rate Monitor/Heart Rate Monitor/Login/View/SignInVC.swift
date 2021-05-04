//
//  ViewController.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/9/21.
//

import UIKit

class SignInVC: BaseVC {
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "background")
        Gradient.horizontal(signupButton)
        Gradient.diagonal(loginButton)
        
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor(named: "purple")?.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor(named: "purple")?.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    @IBAction func signupTapped(_ sender: Any) {
        let vc = SignUpVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
    }
}

