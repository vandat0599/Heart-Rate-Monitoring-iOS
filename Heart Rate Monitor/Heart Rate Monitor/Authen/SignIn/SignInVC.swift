//
//  SignInVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Vo on 6/2/21.
//

import UIKit

final class SignInVC: BaseVC {
    
    private lazy var signUpButton: FillRoundedButton = {
        let view = FillRoundedButton()
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(named: "pink")
        view.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        view.setTitle("SIGN UP", for: .normal)
        view.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var legalLabel: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        view.titleLabel?.numberOfLines = 0
        view.titleLabel?.font = .systemFont(ofSize: 10)
        view.setTitleColor(.white, for: .normal)
        func makeAttributedTextTitle(subText1: String, subText2: String) -> NSAttributedString {
            let fullText = "\(subText1) \(subText2)"
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            paragraphStyle.alignment = .center
            let normalAttribute = NSMutableAttributedString(string: fullText as String, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ])
            let customAttribute = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            ] as [NSAttributedString.Key : Any]
            normalAttribute.addAttributes(customAttribute as [NSAttributedString.Key : Any], range: NSString(string: fullText).range(of: subText2))
            return normalAttribute
        }
        view.setAttributedTitle(makeAttributedTextTitle(subText1: "By creating an account you are agreeing to the Terms of Service.\n", subText2: "Terms of use | Privacy Policy"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var signInHeaderView: UIView = {
        let view = UIView()
        let signInLabel = UILabel()
        signInLabel.text = "SIGN IN"
        signInLabel.font = .systemFont(ofSize: 24, weight: .bold)
        signInLabel.textColor = .white
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        let signInDescriptionLabel = UILabel()
        signInDescriptionLabel.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        signInDescriptionLabel.attributedText = NSMutableAttributedString(string: "Sign in with your email. If you don’t remember your email or password?", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        signInDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let clickHereButton = CustomRippleButton()
        clickHereButton.setTitle("Click here.", for: .normal)
        clickHereButton.setTitleColor(.systemRed, for: .normal)
        clickHereButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        clickHereButton.addTarget(self, action: #selector(clickHereTapped), for: .touchUpInside)
        clickHereButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInLabel)
        view.addSubview(signInDescriptionLabel)
        view.addSubview(clickHereButton)
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: view.topAnchor),
            signInLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            signInDescriptionLabel.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 15),
            signInDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            clickHereButton.topAnchor.constraint(equalTo: signInDescriptionLabel.bottomAnchor, constant: 10),
            clickHereButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            clickHereButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var usernameView: FormInputView = {
        let textField = FormInputView()
        textField.setData(model: FormInputViewModel(
            text: "",
            placeHolder: "Username",
            inputType: .email,
            authenticationType: .csEmail,
            dataPicker: nil
        ))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordView: FormInputView = {
        let textField = FormInputView()
        textField.setData(model: FormInputViewModel(
            text: "",
            placeHolder: "Password",
            inputType: .password,
            authenticationType: .csPassword,
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
    
    private lazy var loginButton: FillRoundedButton = {
        let view = FillRoundedButton()
        view.setTitle("LOGIN", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.backgroundColor = UIColor(named: "pink")
        view.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.init(named: "black-background")
        view.addSubview(scrollView)
        view.addSubview(legalLabel)
        scrollView.addSubview(contentView)
        contentView.addSubview(signUpButton)
        contentView.addSubview(stackForm)
        stackForm.addArrangedSubview(usernameView)
        stackForm.addArrangedSubview(passwordView)
        contentView.addSubview(loginButton)
        contentView.addSubview(signInHeaderView)
        NSLayoutConstraint.activate([
            
            legalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            legalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            legalLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: legalLabel.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            signInHeaderView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            signInHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signInHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            stackForm.topAnchor.constraint(equalTo: signInHeaderView.bottomAnchor, constant: 20),
            stackForm.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackForm.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            usernameView.widthAnchor.constraint(equalTo: stackForm.widthAnchor),
            passwordView.widthAnchor.constraint(equalTo: stackForm.widthAnchor),
            
            loginButton.topAnchor.constraint(equalTo: stackForm.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
        view.layoutIfNeeded()
    }
    
    @objc private func signUpTapped() {
        let vc = SignUpVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func clickHereTapped() {
        let vc = ResetPasswordVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginTapped() {
        let inputViews = [usernameView, passwordView]
        if inputViews.filter({ $0.isValidationError() }).count == 0 {
            HHud.showHud()
            APIService.shared.login(username: usernameView.text ?? "", password: passwordView.text ?? "")
                .subscribe {[weak self] (user) in
                    HHud.hideHud()
                    guard let self = self else { return }
                    UserDefaultHelper.saveCodableObject(user, key: .loggedInAccount)
                    NotificationCenter.default.post(name: AppConstant.AppNotificationName.didLogin, object: nil)
                    self.dismiss(animated: true)
                } onError: { (error) in
                    HHud.hideHud()
                    HAlert.showErrorBottomSheet(self, message: "Your email/password is incorect or something went wrong, please try again!")
                }
                .disposed(by: disposeBag)
        } else {
            inputViews.forEach { $0.showErrorIfNeeded() }
        }
    }
    
    @objc private func privacyTapped() {
        let vc = UINavigationController(rootViewController: PrivacyVC())
        present(vc, animated: true)
    }
}
