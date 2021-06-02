//
//  HeartRateHistory.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 08/04/2021.
//

import Foundation

struct HeartRateHistory: Codable {
    var id: Int?
    var remoteId: String?
    var grapValues: [Double] = []
    var heartRateNumber: Int?
    var label: String?
    var createDate: String?
    var isSubmitted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "local_id"
        case remoteId = "_id"
        case grapValues
        case heartRateNumber
        case label
        case createDate
        case isSubmitted
    }
}
