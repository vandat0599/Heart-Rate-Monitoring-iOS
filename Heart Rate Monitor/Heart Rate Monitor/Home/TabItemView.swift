//
//  TabItemView.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import UIKit

class TabItemView: CustomRippleControl {
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 12)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private var normalColor: UIColor!
    private var selectedColor: UIColor!
    
    private func setupView() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 10),
            iconImageView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -10),
            
            titleLabel.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
        ])
    }
    
    func config(iconName: String, title: String, normalColor: UIColor, selectedColor: UIColor) {
        iconImageView.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = title
        self.normalColor = normalColor
        self.selectedColor = selectedColor
    }
    
    override var isSelected: Bool {
        didSet {
            iconImageView.tintColor = isSelected ? selectedColor : normalColor
            titleLabel.textColor = isSelected ? selectedColor : normalColor
        }
    }
}
