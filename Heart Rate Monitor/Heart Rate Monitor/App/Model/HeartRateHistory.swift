//
//  HeartRateHistory.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 08/04/2021.
//

import Foundation

struct HeartRateHistory: Decodable {
    var id: String?
    var healthInfo: HealthInfo?
    var heartRate: String?
    var state: HeartRateState?
    var note: String?
    var createDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case healthInfo = "health_info"
        case heartRate = "heart_rate"
        case state
        case note
        case createDate = "create_date"
    }
}
