//
//  LottieSheetOneActionVC.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 3/10/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit
import Lottie

class LottieSheetOneActionVC: BottomSheetViewController {
    // MARK: - UI components
    
    private var lottieView: AnimationView
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.text = popupTitle
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.text = popupDescription
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rightActionButton: UIButton = {
        let view = UIButton()
        view.setTitle("OK", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.white, for: .normal)
        view.clipsToBounds = true
        view.cornerRadius = 22
        view.backgroundColor = UIColor(named: "white-holder")
        view.addTarget(self, action: #selector(rightActionTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - data
    let popupTitle: String!
    let popupDescription: String!
    let rightActionTitle: String!
    let rightAction: (() -> Void)?
    
    init(
        lottie: AnimationView,
        closeImage: UIImage,
        title: String,
        description: String,
        rightActionTitle: String,
        rightAction: (() -> Void)?) {
        self.lottieView = lottie
        self.popupTitle = title
        self.popupDescription = description
        self.rightActionTitle = rightActionTitle
        self.rightAction = rightAction
        super.init()
        closeButton.setImage(closeImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    private func setupViewAttribute() {
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 2
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.contentMode = .scaleAspectFit
        lottieView.play()
        lottieView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutViews() {
        super.layoutViews()
        view.backgroundColor = UIColor(named: "black-background")
        contentView.backgroundColor = UIColor(named: "black-background")
        setupViewAttribute()
        contentView.addSubview(closeButton)
        contentView.addSubview(lottieView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(rightActionButton)
        let centerXLine = UIView()
        centerXLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(centerXLine)
        NSLayoutConstraint.activate([

            lottieView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            lottieView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lottieView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),

            titleLabel.topAnchor.constraint(equalTo: lottieView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            centerXLine.widthAnchor.constraint(equalToConstant: 0),
            centerXLine.heightAnchor.constraint(equalToConstant: 0),
            centerXLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            rightActionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            rightActionButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            rightActionButton.heightAnchor.constraint(equalToConstant: 44),
            rightActionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rightActionButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }

    // MARK: - Actions
        
    func showPopup() {
        
    }
    
    func hidePopup() {
        
    }
    
    @objc private func rightActionTapped() {
        dismiss(animated: true) {[weak self] in
            self?.rightAction?()
        }
    }
}
