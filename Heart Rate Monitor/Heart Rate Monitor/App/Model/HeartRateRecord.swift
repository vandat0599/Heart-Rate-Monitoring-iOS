//
//  HeartRateRecord.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 07/04/2021.
//

import Foundation

enum HeartRateState: String, Decodable {
    case normal = "normal"
    case active = "active"
    
    enum CodingKeys: String, CodingKey {
        case normal
        case active
    }
}

struct HeartRateRecord: Decodable {
    var value: Int?
    var state: HeartRateState = .normal
    var note: String?
    
    enum CodingKeys: String, CodingKey {
        case value
        case state
        case note
    }
}
