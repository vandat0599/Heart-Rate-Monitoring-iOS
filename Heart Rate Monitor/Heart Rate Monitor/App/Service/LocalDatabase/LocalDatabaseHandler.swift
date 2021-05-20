//
//  LocalDatabaseRepo.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 04/04/2021.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import CoreData
import RxRelay
import RxSwift

final class LocalDatabaseHandler {
    private init() {}
    static let shared = LocalDatabaseHandler()
    
    var didInsertHistory = PublishRelay<Bool>()
    var didUpdateHistory = PublishRelay<Bool>()
    var didDeleteHistory = PublishRelay<Bool>()
    
    // MARK: - Playlist
    func insertHistory(heartRateHistory: HeartRateHistory) -> HeartRateHistory? {
        let localHeartRate = LocalHeartHistory(context: PersistenceManager.shared.context)
        localHeartRate.fromRemoteHistory(model: heartRateHistory)
        localHeartRate.id = Int16(getAllHistory().count + 1)
        PersistenceManager.shared.saveContext()
        didInsertHistory.accept(true)
        return localHeartRate.toRemoteHistory()
    }
    
    func updateHeartRateHistory(heartRateHistory: HeartRateHistory) {
        if let savedHistory = self.getLocalHeartRateHistoryById(id: heartRateHistory.id ?? -1) {
            print("found -> update")
            savedHistory.fromRemoteHistory(model: heartRateHistory)
            PersistenceManager.shared.saveContext()
            didUpdateHistory.accept(true)
        } else {
            print("not found -> add")
            _ = insertHistory(heartRateHistory: heartRateHistory)
        }
    }
    
    func deleteHistory(id: Int) {
        let fetchRequest: NSFetchRequest<LocalHeartHistory> = LocalHeartHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let result = try? PersistenceManager.shared.context.fetch(fetchRequest)
        guard let localModel = result?.first else { return }
        PersistenceManager.shared.context.delete(localModel)
        didDeleteHistory.accept(true)
    }
    
    func getAllHistory() -> [HeartRateHistory] {
        let fetchRequest: NSFetchRequest<LocalHeartHistory> = LocalHeartHistory.fetchRequest()
        return ((try? PersistenceManager.shared.context.fetch(fetchRequest)) ?? []).map { $0.toRemoteHistory() }
    }
    
    func getHeartRateHistoryById(id: Int) -> HeartRateHistory? {
        let fetchRequest: NSFetchRequest<LocalHeartHistory> = LocalHeartHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let result = try? PersistenceManager.shared.context.fetch(fetchRequest)
        guard let model = result?.first else { return nil }
        return model.toRemoteHistory()
    }
    
    func getLocalHeartRateHistoryById(id: Int) -> LocalHeartHistory? {
        let fetchRequest: NSFetchRequest<LocalHeartHistory> = LocalHeartHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let result = try? PersistenceManager.shared.context.fetch(fetchRequest)
        guard let model = result?.first else { return nil }
        return model
    }
    
    
}
