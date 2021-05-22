//
//  Gender.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 08/04/2021.
//

import Foundation

enum Gender: Int, Decodable {
    case undefined = 0
    case male = 1
    case female = 2
    
    var description: String {
        switch self {
        case .male: return "Male"
        case .female   : return "Female"
        default: return "Undefined"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case undefined
        case male
        case female
    }
}
