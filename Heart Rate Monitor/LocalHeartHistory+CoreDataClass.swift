//
//  LocalHeartHistory+CoreDataClass.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 05/06/2021.
//
//

import Foundation
import CoreData

@objc(LocalHeartHistory)
public class LocalHeartHistory: NSManagedObject {
    func fromRemoteHistory(model: HeartRateHistory) {
        self.id = "\(model.id ?? -1)"
        self.grapValues = model.grapValues.map{ String($0) }.joined(separator: ",")
        self.isSubmitted = model.isSubmitted ?? false
        self.heartRateNumber = Int16(model.heartRateNumber ?? 0)
        self.label = model.label
        self.createDate = model.createDate
        self.remoteId = model.remoteId
    }

    func toRemoteHistory() -> HeartRateHistory {
        HeartRateHistory(id: Int(self.id ?? "0"), remoteId: self.remoteId, grapValues: (self.grapValues ?? "").split(separator: ",").map { (Double($0) ?? 0.0) }, heartRateNumber: Int(self.heartRateNumber), label: self.label, createDate: self.createDate, isSubmitted: self.isSubmitted)
    }
}
