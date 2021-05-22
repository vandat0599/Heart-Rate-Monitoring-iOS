//
//  HError.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 21/04/2021.
//

import Foundation

class HError: Error {
    
    var code: Int?
    var message: String?
    
    init(code: Int?, message: String?) {
        self.code = code
        self.message = message
    }
    
    static var unknown: HError {
        return HError(code: 999, message: NSLocalizedString("Something went wrong, please try again.", comment: ""))
    }
    
    static var permissionDenied: HError {
        HError(code: 999, message: NSLocalizedString("Permission denied", comment: ""))
    }
    
    static var internetConnection: HError {
        return HError(code: URLError.notConnectedToInternet.rawValue, message: NSLocalizedString("You seem to be offline", comment: "Check your Wi-Fi connection or cellular data and try again."))
    }
}
