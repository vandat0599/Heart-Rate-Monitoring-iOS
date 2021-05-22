//
//  GuideVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 22/05/2021.
//

import UIKit

class GuideVC: BaseVC {
    
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
        view.attributedText = NSMutableAttributedString(string: "Please put your index finger on the camera and stay still.\n" as String, attributes: [
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
    
    private lazy var okButton: CustomRippleButton = {
        let view = CustomRippleButton()
        view.setTitle("OK", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(named: "pink")
        view.clipsToBounds = true
        view.buttonScaleOnAnimate = 0.97
        view.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
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
        contentView.addSubview(info2Label)
        contentView.addSubview(okButton)
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
            
            info2Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            info2Label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            info2Label.topAnchor.constraint(equalTo: calmImageView.bottomAnchor, constant: 36),
            
            okButton.topAnchor.constraint(equalTo: info2Label.bottomAnchor, constant: 20),
            okButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            okButton.heightAnchor.constraint(equalToConstant: 44),
            okButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            okButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36),
        ])
        view.layoutIfNeeded()
        okButton.cornerRadius = okButton.frame.height/2
        view.layoutIfNeeded()
    }
    
    @objc private func okButtonTapped() {
        dismiss(animated: true)
    }
    
}
