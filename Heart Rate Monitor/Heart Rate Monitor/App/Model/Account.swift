//
//  Account.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 08/04/2021.
//

import Foundation

struct Account: Decodable {
    var id: String?
    var username: String?
    var password: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case password
    }
}
