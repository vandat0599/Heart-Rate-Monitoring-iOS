//
//  OTP.swift
//  Heart Rate Monitor
//
//  Created by AlexisPQA on 23/05/2021.
//

import UIKit

class OtpVC : BaseVC, UITextFieldDelegate {
    var window: UIWindow?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var otpStackView: UIStackView!
    @IBOutlet weak var otp1TextField: UITextField!
    @IBOutlet weak var otp2TextField: UITextField!
    @IBOutlet weak var otp3TextField: UITextField!
    @IBOutlet weak var otp4TextField: UITextField!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    var titleAlert: String?
    var email : String?
    var password: String?
    var otpCode : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        otp1TextField.backgroundColor = UIColor.clear
        otp2TextField.backgroundColor = UIColor.clear
        otp3TextField.backgroundColor = UIColor.clear
        otp4TextField.backgroundColor = UIColor.clear
        
        
        addBottomBorder(textField: otp1TextField)
        addBottomBorder(textField: otp2TextField)
        addBottomBorder(textField: otp3TextField)
        addBottomBorder(textField: otp4TextField)
        
        resendOTPButton.layer.masksToBounds = true
        resendOTPButton.layer.cornerRadius = 10
        Gradient.horizontal(resendOTPButton)
        
        titleLabel.text = titleAlert
        
        otp1TextField.delegate = self
        otp2TextField.delegate = self
        otp3TextField.delegate = self
        otp4TextField.delegate = self
        
        otp1TextField.becomeFirstResponder()
    }
    
    func addBottomBorder(textField : UITextField){
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 1.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 2.0)
        textField.layer.addSublayer(layer)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1) && (string.count > 0){
            if textField == otp1TextField {
                otp2TextField.becomeFirstResponder()
            }
            if textField == otp2TextField {
                otp3TextField.becomeFirstResponder()
            }
            if textField == otp3TextField {
                otp4TextField.becomeFirstResponder()
            }
            if textField == otp4TextField {
                otp4TextField.becomeFirstResponder()
            }
            textField.text = string
            return false
        }
        else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == otp1TextField {
                otp1TextField.becomeFirstResponder()
            }
            if textField == otp2TextField {
                otp1TextField.becomeFirstResponder()
            }
            if textField == otp3TextField {
                otp2TextField.becomeFirstResponder()
            }
            if textField == otp4TextField {
                otp3TextField.becomeFirstResponder()
            }
            textField.text = ""
            return false
        }else if ((textField.text?.count)! >= 1 ){
            textField.text = string
            return false
        }
        
        return true
    }

    func handleOTP() {
        let API = APIService.shared
        
        API.authOtpCode(username: email!,password: password!,otpCode: otpCode!) {[self] response in
            
            if (response.data != nil ){
                let vc = UINavigationController(rootViewController: ContainerVC())
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }else{
                let alert = UIAlertController(title: "Error", message: response.message!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                    otp1TextField.text = ""
                    otp2TextField.text = ""
                    otp3TextField.text = ""
                    otp4TextField.text = ""
                    
                    otp1TextField.becomeFirstResponder()
                }))
                self.present(alert, animated: true,completion: nil)
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField == otp4TextField){
            if ((textField.text?.count)! > 0 ){
                otpCode = otp1TextField.text! + otp2TextField.text! + otp3TextField.text! + otp4TextField.text!
                handleOTP()
            }
        }
    }
    @IBAction func resendOTPTapped(_ sender: Any) {
        let API = APIService.shared
        
        API.resendOtpCode(username: email!) {[self] response in
            let alert = UIAlertController(title: "Error", message: response.message!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                otp1TextField.text = ""
                otp2TextField.text = ""
                otp3TextField.text = ""
                otp4TextField.text = ""
                
                otp1TextField.becomeFirstResponder()
            }))
            self.present(alert, animated: true,completion: nil)
        }
    }
}
