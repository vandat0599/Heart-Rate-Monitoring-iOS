//
//  HeartRateHistory.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 08/04/2021.
//

import Foundation

struct HeartRateHistory: Decodable {
    var id: Int?
    var grapValues: [Double] = []
    var heartRateNumber: Int?
    var label: String?
    var createDate: String?
    var isSubmitted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case grapValues = "grap_values"
        case heartRateNumber = "heart_rate_number"
        case label
        case createDate = "create_date"
        case isSubmitted = "is_submitted"
    }
}
