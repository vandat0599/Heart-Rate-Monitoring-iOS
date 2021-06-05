//
//  VerifyOTP.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 02/06/2021.
//

import UIKit

final class VerifyOTPSignupVC: BaseVC {
    
    private lazy var signInButton: UIButton = {
        let view = FillRoundedButton()
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(named: "pink")
        view.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        view.setTitle("SIGN IN", for: .normal)
        view.addTarget(self, action: #selector(signIpTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        let signInLabel = UILabel()
        signInLabel.text = "OTP"
        signInLabel.font = .systemFont(ofSize: 24, weight: .bold)
        signInLabel.textColor = .white
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        let signInDescriptionLabel = UILabel()
        signInDescriptionLabel.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        signInDescriptionLabel.attributedText = NSMutableAttributedString(string: "Enter the OTP code just sent to your email", attributes: [
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
            
            signInDescriptionLabel.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 10),
            signInDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signInDescriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emailFormView: FormInputView = {
        let textField = FormInputView()
        textField.setData(model: FormInputViewModel(
            text: "",
            placeHolder: "OTP code",
            inputType: .email,
            authenticationType: .csEmpty,
            dataPicker: nil
        ))
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
    
    private lazy var resetButton: UIButton = {
        let view = FillRoundedButton()
        view.setTitle("VERIFY", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.isEnabled = true
        view.backgroundColor = UIColor(named: "pink")
        view.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
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
    
    private let name: String
    private let username: String
    private let password: String
    
    init(name: String, username: String, password: String) {
        self.name = name
        self.username = username
        self.password = password
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "black-background")
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(signInButton)
        contentView.addSubview(stackForm)
        stackForm.addArrangedSubview(emailFormView)
        contentView.addSubview(resetButton)
        contentView.addSubview(headerView)
        contentView.addSubview(resetButton)
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
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            headerView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            stackForm.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            stackForm.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackForm.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emailFormView.widthAnchor.constraint(equalTo: stackForm.widthAnchor),
            
            resetButton.topAnchor.constraint(equalTo: stackForm.bottomAnchor, constant: 30),
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func signIpTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func resetTapped() {
        let inputViews = [emailFormView]
        if inputViews.filter({ $0.isValidationError() }).count == 0 {
            HHud.showHud()
            print(username, password, emailFormView.text ?? "0")
            APIService.shared.verifyRegister(email: username, password: password, otp: emailFormView.text ?? "0")
                .subscribe {[weak self] (user) in
                    HHud.hideHud()
                    guard let self = self else { return }
                    UserDefaultHelper.saveCodableObject(user, key: .loggedInAccount)
                    NotificationCenter.default.post(name: AppConstant.AppNotificationName.didLogin, object: nil)
                    self.dismiss(animated: true)
                } onError: { (error) in
                    HHud.hideHud()
                    HAlert.showErrorBottomSheet(self, message: "Something went wrong, please try again!")
                }
                .disposed(by: disposeBag)
        } else {
            inputViews.forEach { $0.showErrorIfNeeded() }
        }
    }
}
