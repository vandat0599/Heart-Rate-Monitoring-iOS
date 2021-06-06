//
//  HistoryVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 20/05/2021.
//

import Foundation
import RxRelay
import RxSwift
import Alamofire

protocol PHistoryVM: AnyObject {
    var historyData: BehaviorRelay<[HeartRateHistory]> { get }
}

class HistoryVM: PHistoryVM {
    var historyData: BehaviorRelay<[HeartRateHistory]>
    var allLabels: [String] = []
    let disposeBag = DisposeBag()
    var data: [HeartRateHistory] = []
    
    init() {
        historyData = BehaviorRelay<[HeartRateHistory]>(value: [])
        reloadLabels()
    }
    
    func reloadData(label: String) {
        data.removeAll()
        // 1. fetch all local history
        // 2. update deleted & submitted
        // 3. fetch remote history
        
        // 1
        var history = LocalDatabaseHandler.shared.getAllHistory()
        historyData.accept(history.filter { (label == "ALL LABELS" ? true : $0.label == label) && $0.isRemoved == false })
        history.sort { (m1, m2) -> Bool in return Int(m1.createDate ?? "0") ?? 0 > Int(m2.createDate ?? "0") ?? 0 }
        data = history
        reloadLabels()
        if UserDefaultHelper.getLogedUser() != nil && (NetworkReachabilityManager()?.isReachable ?? false) == true {
            // 2
            mapServerRate(history, label: label) {[weak self] rates in
                guard let self = self else { return }
                self.data = rates
                self.historyData.accept(rates.filter { (label == "ALL LABELS" ? true : $0.label == label) && $0.isRemoved == false })
                self.reloadLabels()
                // 3
                APIService.shared.getHeartRates()
                    .subscribe {[weak self] (data) in
                        guard let self = self else { return }
                        let localIds = history.map { $0.id }
                        for rate in data {
                            if let index = localIds.firstIndex(of: rate.id) {
                                history[index].remoteId = rate.remoteId
                            } else {
                                history.append(rate)
                                LocalDatabaseHandler.shared.updateHeartRateHistory(heartRateHistory: rate)
                            }
                        }
                        history.sort { (m1, m2) -> Bool in return Int(m1.createDate ?? "0") ?? 0 > Int(m2.createDate ?? "0") ?? 0 }
                        self.data = history
                        self.historyData.accept(history.filter { (label == "ALL LABELS" ? true : $0.label == label) && $0.isRemoved == false })
                        self.reloadLabels()
                    } onError: {(err) in
                        print("err: \(err.localizedDescription)")
                    }
                    .disposed(by: self.disposeBag)
            }
        }
        
    }
    
    func mapServerRate(_ history: [HeartRateHistory], label: String, completion: (([HeartRateHistory]) -> ())?) {
        var historyClone = history
        let unsubmitedRates = history.filter { $0.isSubmitted == false && $0.isRemoved == false }
        let deletedIds = historyClone.filter { $0.isRemoved == true }.map { $0.id ?? 0 }
        
        if !deletedIds.isEmpty {
            APIService.shared.deleteHistoryRates(by: deletedIds)
                .subscribe { (_) in
                    deletedIds.forEach { LocalDatabaseHandler.shared.deleteHistory(id: $0) }
                    print("Deleted: \(deletedIds)")
                } onError: { (err) in
                    print("err: \(err.localizedDescription)")
                }
                .disposed(by: disposeBag)
        }
        
        if !unsubmitedRates.isEmpty {
            APIService.shared.postHeartRate(heartRates: unsubmitedRates)
                .subscribe {[weak self] (data) in
                    guard let self = self else { return }
                    let localIds = history.map { $0.id }
                    for rate in data {
                        if let index = localIds.firstIndex(of: rate.id) {
                            print("update: \(unsubmitedRates)")
                            historyClone[index] = rate
                            LocalDatabaseHandler.shared.updateHeartRateHistory(heartRateHistory: rate)
                        }
                    }
                    completion?(historyClone)
                } onError: { (err) in
                    completion?(historyClone)
                    print("err: \(err)")
                }
                .disposed(by: disposeBag)
        } else {
            completion?(historyClone)
        }
    }
    
    func filterData(with label: String) {
        historyData.accept(data.filter { (label == "ALL LABELS" ? true : $0.label == label) && $0.isRemoved == false })
    }
    
    func reloadLabels() {
        allLabels = Array(Set(data.filter{ $0.isRemoved == false }.map { $0.label ?? "" }))
        allLabels.insert("ALL LABELS", at: 0)
    }
}
