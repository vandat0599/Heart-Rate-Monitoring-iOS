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
    
    init(id: Int?, remoteId: String? = nil, grapValues: [Double]?, heartRateNumber: Int?, label: String?, createDate: String?, isSubmitted: Bool?) {
        self.id = id
        self.grapValues = grapValues ?? []
        self.heartRateNumber = heartRateNumber
        self.label = label
        self.createDate = createDate
        self.isSubmitted = isSubmitted
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "local_id"
        case remoteId = "_id"
        case grapValues
        case heartRateNumber
        case label
        case createDate
        case isSubmitted
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        if let createDate = try? container?.decode(Int.self, forKey: .createDate) {
            self.createDate = "\(createDate)"
        } else {
            self.createDate = "0"
        }
        
        id = try? container?.decode(Int.self, forKey: .id) ?? -1
        remoteId = try? container?.decode(String.self, forKey: .remoteId) ?? "unknown"
        grapValues = (try? container?.decode([Double].self, forKey: .grapValues)) ?? []
        heartRateNumber = try? container?.decode(Int.self, forKey: .heartRateNumber) ?? 0
        label = try? container?.decode(String.self, forKey: .label) ?? ""
        isSubmitted = try? container?.decode(Bool.self, forKey: .isSubmitted) ?? false
    }
}
