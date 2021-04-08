//
//  User.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 21/03/2021.
//

import Foundation

struct User: Decodable {
    var id: String?
    var account: Account?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case account
        case name
        case email
        case phoneNumber = "phone_number"
        case address
    }
}
