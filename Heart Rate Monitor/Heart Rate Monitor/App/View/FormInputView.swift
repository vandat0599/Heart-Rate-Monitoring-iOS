//
//  FormInputView.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/15/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

struct FormInputViewModel {
    let text: String?
    let placeHolder: String?
    let inputType: FormInputViewType?
    let authenticationType: FormInputValidateType?
    let dataPicker: [String]?
}

protocol FormInputViewDelegate: AnyObject {
    func formInputViewDelegate(view: FormInputView, onTextEditing text: String)
    func formInputViewDelegate(view: FormInputView, onError error: String?)
}

final class FormInputView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - views
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.attributedPlaceholder = NSAttributedString(string: "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ])
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconDown: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic-arrow-down")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconDownTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewHolderTextField: RoundedView = {
        let view = RoundedView()
        view.backgroundColor = UIColor.init(named: "white-holder")
        view.borderWidth = 2
        view.borderColor = .clear
        view.isUserInteractionEnabled = true
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconDownTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.textColor = .systemRed
        view.text = model?.authenticationType?.errorText
        view.font = .systemFont(ofSize: 10, weight: .light)
        view.numberOfLines = 0
        view.setContentHuggingPriority(.defaultHigh - 1, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        return view
    }()
    
    // MARK: - data
    weak var delegate: FormInputViewDelegate?
    var iconDownWidthAnchor: NSLayoutConstraint?
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    var placeHolder: String? {
        set {
            textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ])
        }
        get {
            textField.placeholder
        }
    }
    private var inputType: FormInputViewType? {
        didSet {
            iconDown.isHidden = inputType == .text || inputType == .password || inputType == .email || inputType == .number
            switch inputType {
            case .text:
                break
            case .password:
                textField.isSecureTextEntry = true
            case .email:
                textField.keyboardType = .emailAddress
            case .number:
                textField.keyboardType = .numberPad
            case .stringPicker:
                textField.inputView = pickerView
            case .datePicker:
                textField.inputView = datePicker
                datePicker.datePickerMode = .date
                datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
            case .timePicker:
                textField.inputView = datePicker
                datePicker.datePickerMode = .time
                datePicker.addTarget(self, action: #selector(handleTimePicker), for: .valueChanged)
            case .datetimePicker:
                textField.inputView = datePicker
                datePicker.datePickerMode = .dateAndTime
                datePicker.addTarget(self, action: #selector(handleDateTimePicker), for: .valueChanged)
            case .none:
                break
            }
        }
    }
    var authenticationType: FormInputValidateType = .csEmpty
    private var dataPicker: [String] = []
    var onError: (() -> Void)?
    var onTextEditing: ((String?) -> Void)?
    var model: FormInputViewModel?
    private var errorLabelHeightAnchor: NSLayoutConstraint?
    private var viewHolderBottomAnchor: NSLayoutConstraint?
    private var errorLabelBottomAnchor: NSLayoutConstraint?
    private var isError = true {
        didSet {
            if isError {
                viewHolderBottomAnchor?.isActive = false
                errorLabelHeightAnchor?.isActive = true
            } else {
                errorLabelHeightAnchor?.isActive = false
                viewHolderBottomAnchor?.isActive = true
            }
            UIView.animate(withDuration: 0.2) {
                self.errorLabel.alpha = self.isError ? 1 : 0
                self.viewHolderTextField.borderColor = self.isError ? .systemRed : .clear
                self.layoutIfNeeded()
            }
        }
    }
    var isEnable = true {
        didSet {
            textField.isUserInteractionEnabled = isEnable
            textField.textColor = isEnable ? .white : .systemGray
            iconDown.isUserInteractionEnabled = isEnable
            viewHolderTextField.borderColor = .clear
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(viewHolderTextField)
        viewHolderTextField.addSubview(textField)
        viewHolderTextField.addSubview(iconDown)
        addSubview(errorLabel)
        iconDownWidthAnchor = iconDown.widthAnchor.constraint(equalToConstant: 24)
        viewHolderBottomAnchor = viewHolderTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        errorLabelHeightAnchor = errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        let paddingVertical: CGFloat = 14
        NSLayoutConstraint.activate([
            viewHolderTextField.topAnchor.constraint(equalTo: topAnchor),
            viewHolderTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewHolderTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewHolderBottomAnchor!,
            
            iconDown.trailingAnchor.constraint(equalTo: viewHolderTextField.trailingAnchor, constant: -10),
            iconDown.heightAnchor.constraint(equalToConstant: 24),
            iconDownWidthAnchor!,
            iconDown.centerYAnchor.constraint(equalTo: viewHolderTextField.centerYAnchor),
            
            textField.topAnchor.constraint(equalTo: viewHolderTextField.topAnchor, constant: paddingVertical),
            textField.bottomAnchor.constraint(equalTo: viewHolderTextField.bottomAnchor, constant: -paddingVertical),
            textField.leadingAnchor.constraint(equalTo: viewHolderTextField.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: iconDown.leadingAnchor, constant: -10),
            
            errorLabel.topAnchor.constraint(equalTo: viewHolderTextField.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: viewHolderTextField.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: viewHolderTextField.trailingAnchor, constant: -20),
        ])
    }
    
    func setData(model: FormInputViewModel) {
        self.model = model
        errorLabel.text = model.authenticationType?.errorText
        errorLabel.alpha = 0
        placeHolder = model.placeHolder
        textField.text = model.text
        inputType = model.inputType
        authenticationType = model.authenticationType ?? FormInputValidateType.csEmpty
        dataPicker = model.dataPicker ?? []
        switch model.inputType {
        case .text, .password, .email, .number:
            iconDownWidthAnchor?.constant = 0
        default:
            iconDownWidthAnchor?.constant = 24
        }
    }
    
    func showErrorIfNeeded() {
        isError = !authenticationType.isValid(text: textField.text ?? "")
    }
    
    func forceShowError() {
        isError = true
    }
    
    func isValidationError() -> Bool {
        return isError
    }
    
    @objc private func iconDownTapped() {
        textField.resignFirstResponder()
        textField.becomeFirstResponder()
    }
    
    @objc private func handleTimePicker() {
        let dateText = datePicker.date.toString(format: "HH:mm")
        onTextEditing?(dateText)
        textField.text = dateText
    }
    
    @objc private func handleDatePicker() {
        let dateText = datePicker.date.toString(format: "MMM d, yyyy")
        onTextEditing?(dateText)
        textField.text = dateText
    }
    
    @objc private func handleDateTimePicker() {
        let dateText = datePicker.date.toString(format: "dd/MM/yyyy HH:mm")
        onTextEditing?(dateText)
        textField.text = dateText
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        isError = !authenticationType.isValid(text: textField.text ?? "")
        onTextEditing?(textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isValid = authenticationType.isValid(text: textField.text ?? "")
        isError = !isValid
        if !isValid {
            onError?()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard (textField.text ?? "" ).isEmpty else { return }
        if textField.inputView == pickerView {
            textField.text = dataPicker.first
            textFieldDidEndEditing(textField)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onTextEditing?(dataPicker[row])
        textField.text = dataPicker[row]
    }
}

enum FormInputViewType {
    case text, number, password, email, stringPicker, timePicker, datePicker, datetimePicker
}

enum FormInputValidateType {
    case csUserNameLogin, csPassword, csEmail, csEmpty
    
    var errorText: String {
        get {
            switch self {
            case .csUserNameLogin:
                return "Username must be at least 3 characters".localized
            case .csPassword:
                return "Password must contain at least 6 characters, including uppercase, lowercase and numbers".localized
            case .csEmail:
                return "Email is invalid".localized
            case .csEmpty:
                return "This field is required".localized
            }
        }
    }
    
    func isValid(text: String) -> Bool {
        switch self {
        case .csUserNameLogin:
            let regex = "[A-Za-z0-9._]{3,25}"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
        case .csEmail:
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
        case .csPassword:
            let regex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
        case .csEmpty:
            return !text.isEmpty
        }
    }
}

