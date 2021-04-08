//
//  HeartRateStateView.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 07/04/2021.
//

import UIKit

class HeartRateStateView: UINibView {
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    var isSelected: Bool = false {
        didSet {
            if !isSelected {
                UIView.animate(withDuration: 0.5) {
                    self.backgroundImageView.image = UIImage(color: .white)
                    self.titlelabel.textColor = .lightGray
                    self.iconImageView.tintColor = .lightGray
                    self.borderWidth = 1
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.backgroundImageView.image = UIImage(named: "img-gradient-bg-1")
                    self.titlelabel.textColor = .white
                    self.iconImageView.tintColor = .white
                    self.borderWidth = 0
                }
            }
        }
    }
    
    private func setupView() {
        borderColor = .lightGray
    }
}
