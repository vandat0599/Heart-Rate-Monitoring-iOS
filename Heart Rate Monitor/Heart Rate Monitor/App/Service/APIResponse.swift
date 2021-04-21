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
    var success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
        case success
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        if let _ = try? container?.decode(String.self, forKey: .data) {
            data = nil
        } else {
            data = try? container?.decode(T.self, forKey: .data)
        }
        errorCode = try? container?.decode(Int.self, forKey: .errorCode) ?? -1
        message = try? container?.decode(String.self, forKey: .message) ?? "unknown"
        success = try? container?.decode(Bool.self, forKey: .success) ?? false
    }
}
