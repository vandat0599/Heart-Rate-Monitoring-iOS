////
////  FormInputView.swift
////  Heart Rate Monitor
////
////  Created by Dat Van on 20/05/2021.
////
//
//import UIKit
//
//protocol FormInputViewDelegate: AnyObject {
//    func formInputViewDelegate(view: FormInputView, onTextEditing text: String)
//    func formInputViewDelegate(view: FormInputView, onError error: String?)
//}
//
//final class FormInputView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
//
//    // MARK: - views
//
//    lazy var textField: UITextField = {
//        let view = UITextField()
//        view.font = UIFont(.spartanRegular, size: MDimensions.FontSize.Form.input)
//        view.textColor = UIColor.init(named: "black-white")
//        view.attributedPlaceholder = NSAttributedString(string: "", attributes: [
//            NSAttributedString.Key.foregroundColor: UIColor.init(named: "text-black-gray")!,
//            NSAttributedString.Key.font: UIFont(.spartanRegular, size: MDimensions.FontSize.Form.input)
//        ])
//        view.autocapitalizationType = .none
//        view.autocorrectionType = .no
//        view.delegate = self
//        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var iconDown: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: "ic-arrow-down")?.withRenderingMode(.alwaysTemplate)
//        view.tintColor = UIColor.init(named: "text-black-gray")
//        view.contentMode = .scaleAspectFit
//        view.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(iconDownTapped))
//        view.addGestureRecognizer(tap)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var viewHolderTextField: RoundedView = {
//        let view = RoundedView()
//        view.backgroundColor = UIColor.init(named: "form-background")
//        view.borderWidth = 2
//        view.borderColor = .clear
//        view.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(iconDownTapped))
//        view.addGestureRecognizer(tap)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var pickerView: UIPickerView = {
//        let view = UIPickerView()
//        view.dataSource = self
//        view.delegate = self
//        return view
//    }()
//    private lazy var datePicker: UIDatePicker = {
//        let view = UIDatePicker()
//        if #available(iOS 13.4, *) {
//            view.preferredDatePickerStyle = .wheels
//        }
//        return view
//    }()
//
//    // MARK: - data
//    weak var delegate: FormInputViewDelegate?
//    var iconDownWidthAnchor: NSLayoutConstraint?
//    var text: String? {
//        get {
//            textField.text
//        }
//        set {
//            textField.text = newValue
//        }
//    }
//    var placeHolder: String? {
//        set {
//            textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [
//                NSAttributedString.Key.foregroundColor: UIColor.init(named: "text-black-gray")!,
//                NSAttributedString.Key.font: UIFont(.spartanRegular, size: MDimensions.FontSize.Form.input)
//            ])
//        }
//        get {
//            textField.placeholder
//        }
//    }
//    private var inputType: FormInputViewType? {
//        didSet {
//            iconDown.isHidden = inputType == .text || inputType == .password || inputType == .email || inputType == .number
//            switch inputType {
//            case .text:
//                break
//            case .password:
//                textField.isSecureTextEntry = true
//            case .email:
//                textField.keyboardType = .emailAddress
//            case .number:
//                textField.keyboardType = .numberPad
//            case .stringPicker:
//                textField.inputView = pickerView
//            case .datePicker:
//                textField.inputView = datePicker
//                datePicker.datePickerMode = .date
//                datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
//            case .timePicker:
//                textField.inputView = datePicker
//                datePicker.datePickerMode = .time
//                datePicker.addTarget(self, action: #selector(handleTimePicker), for: .valueChanged)
//            case .datetimePicker:
//                textField.inputView = datePicker
//                datePicker.datePickerMode = .dateAndTime
//                datePicker.addTarget(self, action: #selector(handleDateTimePicker), for: .valueChanged)
//            case .none:
//                break
//            }
//        }
//    }
//    var authenticationType: FormInputValidateType = .csEmpty
//    private var dataPicker: [String] = []
//    var onError: (() -> Void)?
//    var onTextEditing: ((String?) -> Void)?
//    private var isError = true {
//        didSet {
//            viewHolderTextField.borderColor = isError ? UIColor.init(named: "red") : .clear
//        }
//    }
//    var isEnable = true {
//        didSet {
//            textField.isUserInteractionEnabled = isEnable
//            textField.textColor = isEnable ? UIColor.black : UIColor.init(named: "text-black-gray")
//            iconDown.isUserInteractionEnabled = isEnable
//            viewHolderTextField.borderColor = .clear
//        }
//    }
//
//    // MARK: - init
//    override init(frame: CGRect) {
//      super.init(frame: frame)
//      setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//
//    private func setupView() {
//        backgroundColor = .clear
//        addSubview(viewHolderTextField)
//        viewHolderTextField.addSubview(textField)
//        viewHolderTextField.addSubview(iconDown)
//        iconDownWidthAnchor = iconDown.widthAnchor.constraint(equalToConstant: 24)
//        let paddingVertical = 15*MDimensions.Common.deviceSizeRatio.height
//        NSLayoutConstraint.activate([
//            viewHolderTextField.topAnchor.constraint(equalTo: topAnchor),
//            viewHolderTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
//            viewHolderTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
//            viewHolderTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            iconDown.trailingAnchor.constraint(equalTo: viewHolderTextField.trailingAnchor, constant: -10),
//            iconDown.heightAnchor.constraint(equalToConstant: 24),
//            iconDownWidthAnchor!,
//            iconDown.centerYAnchor.constraint(equalTo: viewHolderTextField.centerYAnchor),
//
//            textField.topAnchor.constraint(equalTo: viewHolderTextField.topAnchor, constant: paddingVertical),
//            textField.bottomAnchor.constraint(equalTo: viewHolderTextField.bottomAnchor, constant: -paddingVertical),
//            textField.leadingAnchor.constraint(equalTo: viewHolderTextField.leadingAnchor, constant: 20),
//            textField.trailingAnchor.constraint(equalTo: iconDown.leadingAnchor, constant: -10),
//        ])
//    }
//
//    func setData(model: FormInputViewModel) {
//        placeHolder = model.placeHolder
//        textField.text = model.text
//        inputType = model.inputType
//        authenticationType = model.authenticationType ?? FormInputValidateType.csEmpty
//        dataPicker = model.dataPicker ?? []
//        switch model.inputType {
//        case .text, .password, .email, .number:
//            iconDownWidthAnchor?.constant = 0
//        default:
//            iconDownWidthAnchor?.constant = 24
//        }
//    }
//
//    func showErrorIfNeeded() {
//        isError = !authenticationType.isValid(text: textField.text ?? "")
//    }
//
//    func forceShowError() {
//        isError = true
//    }
//
//    func isValidationError() -> Bool {
//        return isError
//    }
//
//    @objc private func iconDownTapped() {
//        textField.resignFirstResponder()
//        textField.becomeFirstResponder()
//    }
//
//    @objc private func handleTimePicker() {
//        let dateText = datePicker.date.toString(format: "HH:mm")
//        onTextEditing?(dateText)
//        textField.text = dateText
//    }
//
//    @objc private func handleDatePicker() {
//        let dateText = datePicker.date.toString(format: "MMM d, yyyy")
//        onTextEditing?(dateText)
//        textField.text = dateText
//    }
//
//    @objc private func handleDateTimePicker() {
//        let dateText = datePicker.date.toString(format: "dd/MM/yyyy HH:mm")
//        onTextEditing?(dateText)
//        textField.text = dateText
//    }
//
//    @objc private func textFieldDidChange(_ textField: UITextField) {
//        isError = !authenticationType.isValid(text: textField.text ?? "")
//        onTextEditing?(textField.text)
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        let isValid = authenticationType.isValid(text: textField.text ?? "")
//        isError = !isValid
//        if !isValid {
//            onError?()
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        guard (textField.text ?? "" ).isEmpty else { return }
//        if textField.inputView == pickerView {
//            textField.text = dataPicker.first
//            textFieldDidEndEditing(textField)
//        }
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return dataPicker.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return dataPicker[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        onTextEditing?(dataPicker[row])
//        textField.text = dataPicker[row]
//    }
//}
//
//enum FormInputViewType {
//    case text, number, password, email, stringPicker, timePicker, datePicker, datetimePicker
//}
//
//enum FormInputValidateType {
//    case csUserNameLogin, csPassword, csEmail, csEmpty
//
//    var errorText: String {
//        get {
//            switch self {
//            case .csUserNameLogin:
//                return "Username must be at least 3 characters".localized
//            case .csPassword:
//                return "Password must be at least 6 characters".localized
//            case .csEmail:
//                return "Email is invalid".localized
//            case .csEmpty:
//                return "Please fill in all of the fields".localized
//            }
//        }
//    }
//
//    func isValid(text: String) -> Bool {
//        switch self {
//        case .csUserNameLogin:
//            let regex = "[A-Za-z0-9._]{3,25}"
//            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
//        case .csEmail:
//            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
//        case .csPassword:
//            let regex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}"
//            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
//        case .csEmpty:
//            return !text.isEmpty
//        }
//    }
//}
