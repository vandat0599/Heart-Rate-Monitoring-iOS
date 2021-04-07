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
    private lazy var itemHistory: TabItemView = {
        let view = TabItemView()
        view.backgroundColor = .clear
        view.config(iconName: "ic-history-tab", title: "History", normalColor: .lightGray, selectedColor: UIColor(named: "black-white")!)
        view.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemUser: TabItemView = {
        let view = TabItemView()
        view.backgroundColor = .clear
        view.config(iconName: "ic-user-tab", title: "Profile", normalColor: .lightGray, selectedColor: UIColor(named: "black-white")!)
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
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 56),
            view.widthAnchor.constraint(equalToConstant: 56),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
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
        backgroundColor = .white
        clipsToBounds = true
        cornerRadius = 15
        crTopLeft  = true
        crTopRight = true
        crBottomLeft = false
        crBottomRight = false
        addSubview(itemHistory)
        addSubview(itemUser)
        addSubview(itemHeartRate)
        
        NSLayoutConstraint.activate([
            itemHeartRate.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemHeartRate.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            itemHeartRate.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            
            itemHistory.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemHistory.trailingAnchor.constraint(equalTo: itemHeartRate.leadingAnchor),
            itemHistory.centerYAnchor.constraint(equalTo: itemHeartRate.centerYAnchor),
            
            itemUser.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemUser.leadingAnchor.constraint(equalTo: itemHeartRate.trailingAnchor),
            itemUser.centerYAnchor.constraint(equalTo: itemHeartRate.centerYAnchor),
        ])
    }
    
    // MARK: - actions
    
    @objc private func itemTapped(_ sender: UIControl) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if sender == itemHeartRate {
            sender.performSpringAnimation(duration: 0.4, maxScale: 0.95)
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
        delegate?.bottomBarViewDelegate(view: self, selectedIndex: selectedIndex)
    }
}
