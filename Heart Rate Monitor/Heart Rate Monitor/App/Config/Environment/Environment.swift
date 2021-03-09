//
//  Environment.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/9/21.
//

import Foundation

enum Plist: String {
    case baseUrl
    case logEnabled
}

struct Environment {
    static func configuration(key: Plist) -> String {
        if let infoDict = Bundle.main.infoDictionary {
            return infoDict[key.rawValue] as? String ?? ""
        } else {
            fatalError("Unable to locate plist file")
        }
    }
}
