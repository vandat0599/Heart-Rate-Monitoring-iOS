//
//  LocalHeartHistory+CoreDataProperties.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 20/05/2021.
//
//

import Foundation
import CoreData


extension LocalHeartHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalHeartHistory> {
        return NSFetchRequest<LocalHeartHistory>(entityName: "LocalHeartHistory")
    }

    @NSManaged public var createDate: String?
    @NSManaged public var grapValues: String?
    @NSManaged public var heartRateNumber: Int16
    @NSManaged public var id: String?
    @NSManaged public var isSubmitted: Bool
    @NSManaged public var label: String?

}