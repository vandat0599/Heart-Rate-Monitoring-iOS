//
//  TabbarView.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import UIKit
import Lottie

protocol BottomBarViewDelegate: AnyObject {
    func bottomBarViewDelegate(view: BottomBarView, selectedIndex index: Int)
}

class BottomBarView: UIView {
    
    //MARK: - views
    private lazy var itemHistory: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setImage(UIImage(named: "ic-history-tab"), for: .normal)
        view.setImage(UIImage(named: "ic-history-tab"), for: .selected)
        view.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemUser: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setImage(UIImage(named: "ic-user-tab"), for: .normal)
        view.setImage(UIImage(named: "ic-user-tab"), for: .selected)
        view.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemHeartRate: UIControl = {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        view.cornerRadius = 24
        let imageView = UIImageView(image: UIImage(named: "ic-heart-tab"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        view.addSubview(imageView)
        let animationView = AnimationView.init(name: "lottie-heart-wave")
        animationView.isUserInteractionEnabled = false
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 56),
            view.widthAnchor.constraint(equalToConstant: 56),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
        return view
    }()
    
    private lazy var bottomPlaceHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.cornerRadius = 15
        view.crTopLeft  = true
        view.crTopRight = true
        view.crBottomLeft = false
        view.crBottomRight = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: -Init
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    //MARK: - Properties
    weak var delegate: BottomBarViewDelegate?
    var selectedIndex = -1 {
        didSet {
            guard selectedIndex != oldValue else { return }
            itemTapped([itemHistory, itemHeartRate, itemUser][selectedIndex])
        }
    }
    
    //MARK: -Methods
    private func setupView() {
        backgroundColor = .clear
        addSubview(bottomPlaceHolder)
        bottomPlaceHolder.addSubview(itemHistory)
        bottomPlaceHolder.addSubview(itemUser)
        bottomPlaceHolder.addSubview(itemHeartRate)
        
        NSLayoutConstraint.activate([
            bottomPlaceHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomPlaceHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomPlaceHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            itemHeartRate.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemHeartRate.bottomAnchor.constraint(equalTo: bottomPlaceHolder.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            itemHeartRate.topAnchor.constraint(equalTo: bottomPlaceHolder.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            itemHistory.leadingAnchor.constraint(equalTo: bottomPlaceHolder.leadingAnchor),
            itemHistory.heightAnchor.constraint(equalToConstant: 44),
            itemHistory.trailingAnchor.constraint(equalTo: itemHeartRate.leadingAnchor),
            itemHistory.centerYAnchor.constraint(equalTo: itemHeartRate.centerYAnchor),
            
            itemUser.trailingAnchor.constraint(equalTo: bottomPlaceHolder.trailingAnchor),
            itemUser.heightAnchor.constraint(equalToConstant: 44),
            itemUser.leadingAnchor.constraint(equalTo: itemHeartRate.trailingAnchor),
            itemUser.centerYAnchor.constraint(equalTo: itemHeartRate.centerYAnchor),
        ])
    }
    
    // MARK: - actions
    
    @objc private func itemTapped(_ sender: UIControl) {
        print("item tapped")
        if sender == itemHeartRate {
            sender.performSpringAnimation(duration: 0.4, maxScale: 0.9)
        }
        [itemHistory, itemUser].forEach {
            $0.isSelected = $0 == sender
        }
        switch sender {
        case itemHistory:
            selectedIndex = 0
        case itemHeartRate:
            selectedIndex = 1
        case itemUser:
            selectedIndex = 2
        default:
            print("tab default")
        }
    }
}
