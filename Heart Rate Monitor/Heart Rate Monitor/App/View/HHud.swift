//
//  HHud.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 07/04/2021.
//

import Foundation
import SVProgressHUD

final class HHud: NSObject {
    static func showHud(message: String? = nil) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    static func hideHud() {
        SVProgressHUD.dismiss()
    }
}
