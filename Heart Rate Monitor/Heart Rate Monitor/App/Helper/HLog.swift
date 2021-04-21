//
//  HLog.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 21/04/2021.
//

import Foundation

final class HLog: NSObject {
    static func log(tag: String? = nil, _ message: Any) {
        guard Environment.configuration(key: .logEnabled) == "true" else { return }
        if let tag = tag {
            print("\(tag): \(message)")
        } else {
            print(message)
        }
    }
}
