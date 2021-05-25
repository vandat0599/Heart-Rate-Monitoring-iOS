//
//  ForgotpwVC.swift
//  Heart Rate Monitor
//
//  Created by AlexisPQA on 25/05/2021.
//


import UIKit

class ForgotpwVC : BaseVC, UITextFieldDelegate {
    var window: UIWindow?
    
    var email : String?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        Gradient.horizontal(confirmButton)
        
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor(named: "label")?.cgColor
        emailTextField.layer.borderWidth = 1.0
        
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor(named: "label")?.cgColor
        passwordTextField.layer.borderWidth = 1.0
        
        confirmPasswordTextField.layer.masksToBounds = true
        confirmPasswordTextField.layer.borderColor = UIColor(named: "label")?.cgColor
        confirmPasswordTextField.layer.borderWidth = 1.0
        
        emailTextField.text = email

    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        let API = APIService.shared
        print(emailTextField.text!)
        API.forgotPassword(username: emailTextField.text!) { [self] response in
                if (response.error_code == 4){
                    let alertOTP = OtpVC()
                    alertOTP.modalTransitionStyle = .crossDissolve
                    alertOTP.titleAlert = "OTP reset Password"
                    alertOTP.email = emailTextField.text!
                    alertOTP.password = passwordTextField.text!
                    alertOTP.caseOTP = "1"
                    present(alertOTP, animated: true)
                }else{
                    let alert = UIAlertController(title: "Error", message: response.message!, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
}
