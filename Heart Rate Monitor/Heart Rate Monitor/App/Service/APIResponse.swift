//
//  APIResponse.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 21/04/2021.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    var data: T?
    var errorCode: Int?
    var message: String?
    var status: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        if let model = try? container?.decode(T.self, forKey: .data) {
            data = model
        } else {
            data = nil
        }
        errorCode = try? container?.decode(Int.self, forKey: .errorCode) ?? -1
        message = try? container?.decode(String.self, forKey: .message) ?? "unknown"
        status = try? container?.decode(Int.self, forKey: .status) ?? 0
    }
}

struct UserResponse: Codable {
    var user: User?
    var token: String?
}
