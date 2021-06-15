//
//  changePasswordWithOTPVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 02/06/2021.
//

import UIKit

class ChangePasswordWithOTPVC: BaseVC {
    
    private lazy var signInButton: FillRoundedButton = {
        let view = FillRoundedButton()
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(named: "pink")
        view.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        view.setTitle("SIGN IN", for: .normal)
        view.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var signUnHeaderView: UIView = {
        let view = UIView()
        let signInLabel = UILabel()
        signInLabel.text = "CHANGE PASSWORD"
        signInLabel.font = .systemFont(ofSize: 24, weight: .bold)
        signInLabel.textColor = .white
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        let signInDescriptionLabel = UILabel()
        signInDescriptionLabel.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        signInDescriptionLabel.attributedText = NSMutableAttributedString(string: "Please enter the OTP code just sent to your email and enter new password", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        signInDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInLabel)
        view.addSubview(signInDescriptionLabel)
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: view.topAnchor),
            signInLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            signInDescriptionLabel.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 15),
            signInDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signInDescriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var otpView: FormInputView = {
        let textField = FormInputView()
        textField.setData(model: FormInputViewModel(
            text: "",
            placeHolder: "OTP Code",
            inputType: .number,
            authenticationType: .csEmpty,
            dataPicker: nil
        ))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordView: FormInputView = {
        let textField = FormInputView()
        textField.setData(model: FormInputViewModel(
            text: "",
            placeHolder: "New Password",
            inputType: .password,
            authenticationType: .csPassword,
            dataPicker: nil
        ))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var confirmPasswordView: FormInputView = {
        let textField = FormInputView()
        textField.setData(model: FormInputViewModel(
            text: "",
            placeHolder: "Confirm New Password",
            inputType: .password,
            authenticationType: .csPassword,
            dataPicker: nil
        ))
        textField.errorLabel.text = "Password do not match, please try again!".localized
        textField.onTextEditing = {[weak self] text in
            if self?.passwordView.text != textField.text {
                textField.forceShowError()
            }
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var stackForm: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var registerButton: UIButton = {
        let view = FillRoundedButton()
        view.setTitle("SUBMIT", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.isEnabled = true
        view.backgroundColor = UIColor(named: "pink")
        view.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let email: String
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [otpView, passwordView, confirmPasswordView].forEach { $0.text = "" }
    }
    
    private func setupView() {
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIColor.init(named: "black-background")
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(signInButton)
        contentView.addSubview(stackForm)
        stackForm.addArrangedSubview(otpView)
        stackForm.addArrangedSubview(passwordView)
        stackForm.addArrangedSubview(confirmPasswordView)
        contentView.addSubview(registerButton)
        contentView.addSubview(signUnHeaderView)
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            signInButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            signUnHeaderView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            signUnHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signUnHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            stackForm.topAnchor.constraint(equalTo: signUnHeaderView.bottomAnchor, constant: 30),
            stackForm.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackForm.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            otpView.widthAnchor.constraint(equalTo: stackForm.widthAnchor),
            passwordView.widthAnchor.constraint(equalTo: stackForm.widthAnchor),
            confirmPasswordView.widthAnchor.constraint(equalTo: stackForm.widthAnchor),
            
            registerButton.topAnchor.constraint(equalTo: stackForm.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    @objc private func signInTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickHereTapped() {
        
    }
    
    @objc private func registerTapped() {
        let inputViews = [otpView, passwordView, confirmPasswordView]
        if inputViews.filter({ $0.isValidationError() }).count == 0 && passwordView.text == confirmPasswordView.text {
            HHud.showHud()
            APIService.shared.changePasswordWithOTP(email: email, password: passwordView.text ?? "", otp: otpView.text ?? "0")
                .subscribe { [weak self] (user) in
                    guard let self = self else { return }
                    HHud.hideHud()
                    UserDefaultHelper.saveCodableObject(user, key: .loggedInAccount)
                    NotificationCenter.default.post(name: AppConstant.AppNotificationName.didLogin, object: nil)
                    self.dismiss(animated: true)
                } onError: { (err) in
                    HHud.hideHud()
                    HAlert.showErrorBottomSheet(self, message: "Something went wrong, please try again!")
                }
                .disposed(by: disposeBag)
        } else {
            inputViews.forEach { $0.showErrorIfNeeded() }
            if passwordView.text != confirmPasswordView.text {
                confirmPasswordView.forceShowError()
            }
        }
    }
}
