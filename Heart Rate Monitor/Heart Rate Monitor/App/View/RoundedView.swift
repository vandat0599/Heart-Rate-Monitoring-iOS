//
//  RoundedView.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import UIKit

class RoundedView: UIView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        if frame.width < frame.height {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.height, height: frame.height)
        }
        layer.cornerRadius = frame.height / 2
    }
}
