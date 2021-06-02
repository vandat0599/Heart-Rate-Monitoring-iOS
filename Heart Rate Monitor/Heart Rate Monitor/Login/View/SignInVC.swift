//
//  ViewController.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/9/21.
//

import UIKit

class SignInVC: BaseVC {
    var window: UIWindow?
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
        let API = APIService.shared
        if (Utils.isValidEmail(emailTextField.text!) == false){
            let alert = UIAlertController(title: "Error", message: "Email is not correct", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
            
        }
        if (Utils.isPasswordValid(passwordTextField.text!) == false){
            let alert = UIAlertController(title: "Password is not secure enough", message: "Make sure your password is at least  8 characters, contain special character and a number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            API.login1(username: emailTextField.text!, password: passwordTextField.text!,completion: { [self] (response) -> Void in
                if (response.data != nil){
                    let vc = UINavigationController(rootViewController: ContainerVC())
                    window = UIWindow(frame: UIScreen.main.bounds)
                    window?.rootViewController = vc
                    window?.makeKeyAndVisible()
                }else{
                    if (response.error_code == 2){
                        let alertOTP = OtpVC()
                        alertOTP.modalTransitionStyle = .crossDissolve
                        alertOTP.titleAlert = "Your account has not been activated"
                        alertOTP.email = emailTextField.text!
                        alertOTP.password = passwordTextField.text!
                        alertOTP.caseOTP = "0"
                        present(alertOTP, animated: true)
                    }else{
                        let alert = UIAlertController(title: "Error", message: response.message!, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            })
        }
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let vc = ForgotpwVC()
        vc.email = emailTextField.text!
        navigationController?.pushViewController(vc, animated: true)
    }
}

