//
//  UIFont+.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

extension UIFont {
    enum MFont: String {
        case spartanBlack = "Spartan-Black"
    }
    
    convenience init(_ name: MFont, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}
