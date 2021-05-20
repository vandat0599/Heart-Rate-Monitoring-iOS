//
//  PersistenceManager.swift
//  5MinTub
//
//  Created by Đạt on 2/14/20.
//  Copyright © 2020 Đạt. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager{
    private init() {}
    static var shared = PersistenceManager()
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HeartRate")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("saved successful")
            } catch {
                let nserror = error as NSError
                print("saved error \(nserror)")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
