//
//  HelpVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 22/05/2021.
//

import UIKit

class HelpVC: BaseVC {
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var title1Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "How to measure my heart rate?"
        view.textColor = .white
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var info1Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left
        view.attributedText = NSMutableAttributedString(string: "Please cover the camera lightly with your index finger and stay still." as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var calmImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "img-finger-camera"))
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var title2Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "WARNING"
        view.textColor = .white
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var info2Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left
        view.attributedText = NSMutableAttributedString(string: "In some devices flash can get very hot 🔥, please avoid touching it. You can turn off the flash in the Settings, but make sure you are in a well-lit environment.\n" as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var title3Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "I think my heart rate measures are not correct, what can I do?"
        view.textColor = .white
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var info3Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left
        view.attributedText = NSMutableAttributedString(string: "The level of accuracy can vary from device to device, but please try to stay still and cover the whole camera with your index finger. You may set the measurement Sensitivity to Hight in Settings. In this case, depends on the device and background light the app may take longer to measure your heart rate.\n" as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var title4Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "How do I know that the app shows a correct heart rate?"
        view.textColor = .white
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var info4Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left
        view.attributedText = NSMutableAttributedString(string: "You can test the app by checking your pulse in your wrist or neck. You can count the number of pulses for 30 seconds and multiply by 2. You can also use any other device that you have. Either way, please make sure you have rested for 5 minutes before measurements.\n" as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var title5Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Why the app shows a heart rate for red objects?"
        view.textColor = .white
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var info5Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left
        view.attributedText = NSMutableAttributedString(string: "We use red colour to start the measurement to save phone's battery life. If you found that the app shos a number for red objects, set the measurement Sensitivity to Hight in Settings. But note that in this mode, the app needs a longer time to measure your heart rate." as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var title6Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "What is the privacy policy of the app?"
        view.textColor = .white
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var info6Label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left
        view.attributedText = NSMutableAttributedString(string: "We do not record or receive any personal data including images, fingerprints and heart rates. All data are saved on your phone and the app is completely private.\n\n" as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(named: "black-background")
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(title1Label)
        contentView.addSubview(info1Label)
        contentView.addSubview(calmImageView)
        contentView.addSubview(title2Label)
        contentView.addSubview(info2Label)
        contentView.addSubview(title3Label)
        contentView.addSubview(info3Label)
        contentView.addSubview(title4Label)
        contentView.addSubview(info4Label)
        contentView.addSubview(title5Label)
        contentView.addSubview(info5Label)
        contentView.addSubview(title6Label)
        contentView.addSubview(info6Label)
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
            
            title1Label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            title1Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title1Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            info1Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            info1Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            info1Label.topAnchor.constraint(equalTo: title1Label.bottomAnchor, constant: 20),
            
            calmImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            calmImageView.topAnchor.constraint(equalTo: info1Label.bottomAnchor, constant: 36),
            calmImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            calmImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            title2Label.topAnchor.constraint(equalTo: calmImageView.bottomAnchor, constant: 36),
            title2Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title2Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            info2Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            info2Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            info2Label.topAnchor.constraint(equalTo: title2Label.bottomAnchor, constant: 20),
            
            title3Label.topAnchor.constraint(equalTo: info2Label.bottomAnchor, constant: 20),
            title3Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title3Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            info3Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            info3Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            info3Label.topAnchor.constraint(equalTo: title3Label.bottomAnchor, constant: 20),
            
            title4Label.topAnchor.constraint(equalTo: info3Label.bottomAnchor, constant: 20),
            title4Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title4Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            info4Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            info4Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            info4Label.topAnchor.constraint(equalTo: title4Label.bottomAnchor, constant: 20),
            
            title5Label.topAnchor.constraint(equalTo: info4Label.bottomAnchor, constant: 20),
            title5Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title5Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            info5Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            info5Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            info5Label.topAnchor.constraint(equalTo: title5Label.bottomAnchor, constant: 20),
            
            title6Label.topAnchor.constraint(equalTo: info5Label.bottomAnchor, constant: 20),
            title6Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title6Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            info6Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            info6Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            info6Label.topAnchor.constraint(equalTo: title6Label.bottomAnchor, constant: 20),
            info6Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
        ])
    }
    
    @objc private func okButtonTapped() {
        dismiss(animated: true)
    }
    
}

