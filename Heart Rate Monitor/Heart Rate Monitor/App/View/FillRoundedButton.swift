//
//  FillRoundedButton.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/16/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class FillRoundedButton: CustomRippleButton {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        if frame.width < frame.height {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.height, height: frame.height)
        }
        layer.cornerRadius = frame.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
        
    private func setupView() {
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .disabled)
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
}
