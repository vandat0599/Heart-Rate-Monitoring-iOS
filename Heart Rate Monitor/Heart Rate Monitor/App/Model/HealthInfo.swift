//
//  HealthInfo.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 08/04/2021.
//

import Foundation

struct HealthInfo: Decodable {
    var id: String?
    var height: String?
    var weight: String?
    var age: String?
    var gender: Gender?
    var createDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case height
        case weight
        case age
        case gender
        case createDate = "create_date"
    }
}
