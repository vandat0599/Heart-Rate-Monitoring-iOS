//
//  CheckBox.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/14/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

protocol CheckBoxDelegate: AnyObject {
    func checkBoxDelegate(view: CheckBox, onValueChanged newValue: Bool)
    func checkBoxDelegate(view: CheckBox, onTextTapped gesture: UITapGestureRecognizer)
}

final class CheckBox: UIControl {
    
    //MARK: -Init methods
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    //MARK: -Views
    lazy var iconHolder: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.init(named: "white-holder")
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    lazy var iconAnimate: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic-tick")?.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFit
        view.tintColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 12)
        view.textColor = .white
        view.text = "Sample Text label"
        view.numberOfLines = 0
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //MARK: -Properties
    private var heightAnChorIconAnimate: NSLayoutConstraint!
    private var widthAnchorIconAnimate: NSLayoutConstraint!
    weak var delegate: CheckBoxDelegate?
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(iconHolder)
        addSubview(iconAnimate)
        addSubview(textLabel)
        heightAnChorIconAnimate = iconAnimate.heightAnchor.constraint(equalToConstant: 0)
        widthAnchorIconAnimate = iconAnimate.widthAnchor.constraint(equalToConstant: 0)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconHolder.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconHolder.topAnchor.constraint(equalTo: textLabel.topAnchor, constant: -2),
            iconHolder.heightAnchor.constraint(equalToConstant: 20),
            iconHolder.widthAnchor.constraint(equalToConstant: 20),
            
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.leadingAnchor.constraint(equalTo: iconHolder.trailingAnchor, constant: 10),
            
            iconAnimate.centerYAnchor.constraint(equalTo: iconHolder.centerYAnchor),
            iconAnimate.centerXAnchor.constraint(equalTo: iconHolder.centerXAnchor),
            heightAnChorIconAnimate,
            widthAnchorIconAnimate,
        ])
    }
    
    @objc private func labelTapped(gesture: UITapGestureRecognizer) {
        delegate?.checkBoxDelegate(view: self, onTextTapped: gesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isSelected.toggle()
    }
    
    override var isSelected: Bool {
        didSet{
            delegate?.checkBoxDelegate(view: self, onValueChanged: isSelected)
            if isSelected {
                heightAnChorIconAnimate.constant = 14
                widthAnchorIconAnimate.constant = 14
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.iconAnimate.alpha = 1
                    self.layoutIfNeeded()
                }, completion: nil)
            } else {
                heightAnChorIconAnimate.constant = 1
                widthAnchorIconAnimate.constant = 1
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.iconAnimate.alpha = 0
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
}

