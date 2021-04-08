//
//  HeartRateWarning.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 08/04/2021.
//

import Foundation

struct HeartRateWarning: Decodable {
    var id: String?
    var user: User?
    var message: String?
    var createDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case message
        case createDate = "create_date"
    }
}
