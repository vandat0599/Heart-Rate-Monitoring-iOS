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
        let maxId = getAllHistory().map { ($0.id ?? -1) }.max() ?? -1
        localHeartRate.id = "\(maxId + 1)"
        PersistenceManager.shared.saveContext()
        didInsertHistory.accept(true)
        print("Inserted: \(maxId + 1)")
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
        guard let history = getLocalHeartRateHistoryById(id: id) else {
            print("Delete \(id) failed")
            return
        }
        PersistenceManager.shared.context.delete(history)
        didDeleteHistory.accept(true)
    }
    
    func getAllHistory() -> [HeartRateHistory] {
        let fetchRequest: NSFetchRequest<LocalHeartHistory> = LocalHeartHistory.fetchRequest()
        return ((try? PersistenceManager.shared.context.fetch(fetchRequest)) ?? []).map { $0.toRemoteHistory() }
    }
    
    func getAllLabels() -> [String] {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LocalHeartHistory.fetchRequest()
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["label"]
        let res = try? PersistenceManager.shared.context.fetch(fetchRequest) as? [[String: String]]
        return res?.compactMap { $0["label"] } ?? []
    }
    
    func searchHistoryByLabel(label: String) -> [HeartRateHistory] {
        guard label != "ALL LABELS" else { return getAllHistory() }
        let fetchRequest: NSFetchRequest<LocalHeartHistory> = LocalHeartHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "label == %@", label)
        return ((try? PersistenceManager.shared.context.fetch(fetchRequest)) ?? []).map { $0.toRemoteHistory() }
    }
    
    func getHeartRateHistoryById(id: Int) -> HeartRateHistory? {
        let fetchRequest: NSFetchRequest<LocalHeartHistory> = LocalHeartHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(id)")
        let result = try? PersistenceManager.shared.context.fetch(fetchRequest)
        guard let model = result?.first else { return nil }
        return model.toRemoteHistory()
    }
    
    func getLocalHeartRateHistoryById(id: Int) -> LocalHeartHistory? {
        let fetchRequest: NSFetchRequest<LocalHeartHistory> = LocalHeartHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(id)")
        let result = try? PersistenceManager.shared.context.fetch(fetchRequest)
        guard let model = result?.first else { return nil }
        return model
    }
    
    
}
