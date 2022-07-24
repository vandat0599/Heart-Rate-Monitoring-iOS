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
        
        /*
         1. fetch all local history without removed history
            - fetch all local history without removed history
            - show history
         2. map local history to server
            - get unsubmit history
                + post unsubmit history to server and wait for completion
            - get deleted history
                + post deleted history
         
         3. fetch remote history
            - fetch remote history
            - update labels
         */
        
        // 1
        var history = LocalDatabaseHandler.shared.getAllHistory()
        history.sort { (m1, m2) -> Bool in return (Int(m1.createDate ?? "0") ?? 0) > (Int(m2.createDate ?? "0") ?? 0) }
        historyData.accept(history.filter { (label == "ALL LABELS" ? true : $0.label == label) && ($0.isRemoved ?? false) == false })
        data = history
        reloadLabels()
        if UserDefaultHelper.getLogedUser() != nil && (NetworkReachabilityManager()?.isReachable ?? false) == true {
            // 2
            mapServerRate(history, label: label) {[weak self] rates in
                guard let self = self else { return }
                self.data = rates
                self.data.sort { (m1, m2) -> Bool in return (Int(m1.createDate ?? "0") ?? 0) > (Int(m2.createDate ?? "0") ?? 0) }
                self.historyData.accept(rates.filter { (label == "ALL LABELS" ? true : $0.label == label) && ($0.isRemoved ?? false) == false })
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
                        history.sort { (m1, m2) -> Bool in return (Int(m1.createDate ?? "0") ?? 0) > (Int(m2.createDate ?? "0") ?? 0) }
                        self.data = history
                        self.historyData.accept(history.filter { (label == "ALL LABELS" ? true : $0.label == label) && ($0.isRemoved ?? false) == false })
                        self.reloadLabels()
                        // update labels
                        history.filter { $0.isLabelUpdated == true && ($0.isRemoved ?? false) == false }.forEach {
                            var tmpModel = $0
                            APIService.shared.updateHistoryLabel(remoteId: $0.remoteId ?? "", label: $0.label ?? "")
                                .subscribe { (rate) in
                                    tmpModel.isLabelUpdated = false
                                    LocalDatabaseHandler.shared.updateHeartRateHistory(heartRateHistory: tmpModel)
                                    print("updated: \(String(describing: tmpModel.label))")
                                } onError: { (err) in
                                    print("err: \(err.localizedDescription)")
                                }
                                .disposed(by: self.disposeBag)

                        }
                    } onError: {(err) in
                        print("err: \(err.localizedDescription)")
                    }
                    .disposed(by: self.disposeBag)
            }
        }
        
    }
    
    func mapServerRate(_ history: [HeartRateHistory], label: String, completion: (([HeartRateHistory]) -> ())?) {
        var historyClone = history
        let unsubmitedRates = history.filter { $0.isSubmitted == false && ($0.isRemoved ?? false) == false }
        let deletedIds = historyClone.filter { ($0.isRemoved ?? false) == true }.map { $0.id ?? 0 }
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
                .subscribe { (data) in
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
        data.sort { (m1, m2) -> Bool in return (Int(m1.createDate ?? "0") ?? 0) > (Int(m2.createDate ?? "0") ?? 0) }
        historyData.accept(data.filter { (label == "ALL LABELS" ? true : $0.label == label) && ($0.isRemoved ?? false) == false })
    }
    
    func reloadLabels() {
        allLabels = Array(Set(data.filter{ ($0.isRemoved ?? false) == false }.map { $0.label ?? "" }))
        allLabels.insert("ALL LABELS", at: 0)
    }
}
