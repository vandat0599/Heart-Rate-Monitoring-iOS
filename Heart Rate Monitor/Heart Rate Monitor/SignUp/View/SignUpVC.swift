//
//  SignUpVC.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 18/03/2021.
//

import UIKit

class SignUpVC: BaseVC {

    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor(named: "label")?.cgColor
        emailTextField.layer.borderWidth = 1.0
        
        phoneTextField.layer.masksToBounds = true
        phoneTextField.layer.borderColor = UIColor(named: "label")?.cgColor
        phoneTextField.layer.borderWidth = 1.0
        
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor(named: "label")?.cgColor
        passwordTextField.layer.borderWidth = 1.0
        
        confirmPasswordTextField.layer.masksToBounds = true
        confirmPasswordTextField.layer.borderColor = UIColor(named: "label")?.cgColor
        confirmPasswordTextField.layer.borderWidth = 1.0
    }
    
    private func setupView() {
        Gradient.horizontal(signupButton)
    }
}
