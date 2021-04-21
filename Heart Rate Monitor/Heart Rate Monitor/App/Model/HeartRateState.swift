//
//  HeartRateState.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 08/04/2021.
//

import Foundation

enum HeartRateState: String, Decodable, CaseIterable {
    case normal = "normal"
    case active = "active"
    
    enum CodingKeys: String, CodingKey {
        case normal
        case active
    }
}
