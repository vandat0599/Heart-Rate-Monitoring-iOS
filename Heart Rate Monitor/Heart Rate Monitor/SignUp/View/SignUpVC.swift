//
//  SignUpVC.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 18/03/2021.
//

import UIKit

class SignUpVC: BaseVC {
    var window: UIWindow?
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
    @IBAction func signupTapped(_ sender: Any) {
        let valid = Utils.checkValidateField(email: emailTextField.text, password: passwordTextField.text, passwordConf: confirmPasswordTextField.text, phoneNum: phoneTextField.text)
        switch (valid) {
            
        case 1:
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case 2:
            let alert = UIAlertController(title: "Error", message: "Email is not correct", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case 3:
            let alert = UIAlertController(title: "Password is not secure enough", message: "Make sure your password is at least  8 characters, contain special character and a number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case 4:
            let alert = UIAlertController(title: "Error", message: "Make sure your password & confirm password match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        default:
            let API = APIService.shared
    
                API.register1(username: emailTextField.text!, password: passwordTextField.text!,phoneNumber: phoneTextField.text!,completion: { [self] (response) -> Void in
                    if (response.error_code == 2){
                        
                        let alertOTP = OtpVC()
                        alertOTP.modalTransitionStyle = .crossDissolve
                        alertOTP.titleAlert = "Enter OTP to active your account"
                        alertOTP.email = emailTextField.text!
                        alertOTP.password = passwordTextField.text!
                        present(alertOTP, animated: true)
                        
                    }else{
                        let alert = UIAlertController(title: "Error", message: response.message!, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    }
                )
            break;
        }
    }
}
