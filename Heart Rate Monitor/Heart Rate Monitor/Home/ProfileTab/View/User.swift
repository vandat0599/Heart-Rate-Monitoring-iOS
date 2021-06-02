//
//  User.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 21/03/2021.
//

import Foundation

struct User: Codable {
    var id: String?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var address: String?
    var createAt: String?
    var updateAt: String?
    var isActive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case phoneNumber
        case address
        case createAt
        case updateAt
        case isActive
    }
}
