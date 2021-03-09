//
//  UIDevice+.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

extension UIDevice {
    
    // link: https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x
    static var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    
    // check the link: https://ios-resolution.com/
    static var isSmallDevice: Bool {
        return UIScreen.main.bounds.height < 812.0
    }
}
