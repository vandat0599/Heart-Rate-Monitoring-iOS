//
//  HeartRateRecord.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 07/04/2021.
//

import Foundation

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
