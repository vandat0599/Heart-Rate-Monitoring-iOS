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
        case spartanBold = "Spartan-Bold"
        case spartanExtraBold = "Spartan-ExtraBold"
        case spartanExtraLight = "Spartan-ExtraLight"
        case spartanLight = "Spartan-Light"
        case spartanMedium = "Spartan-Medium"
        case spartanRegular = "Spartan-Regular"
        case spartanSemiBold = "Spartan-SemiBold"
        case spartanThin = "Spartan-Thin"
    }
    
    convenience init(_ name: MFont, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
}
