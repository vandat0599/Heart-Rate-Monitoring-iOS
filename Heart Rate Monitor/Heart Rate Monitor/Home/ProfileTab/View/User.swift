//
//  User.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 21/03/2021.
//

import Foundation

class User {
    var email : String
    var name : String
    var phoneNumber : String
    var gender : Int = 0 // 0: Undefined | 1: Male | 2: Female
    var height : Int // (cm)
    var weight : Int // (kg)
    var age : Int
    var relationships : [String] = [] // List of emails of other accounts in system.
    
    init(email: String, name: String, phoneNumber: String, gender: Int, height: Int, weight: Int, age: Int, relationships: [String]) {
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.height = height
        self.weight = weight
        self.age = age
        self.relationships = relationships
    }
}
