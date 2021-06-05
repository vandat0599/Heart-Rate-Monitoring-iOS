//
//  HistoryVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 20/05/2021.
//

import Foundation
import RxRelay
import RxSwift

protocol PHistoryVM: AnyObject {
    var historyData: BehaviorRelay<[HeartRateHistory]> { get }
}

class HistoryVM: PHistoryVM {
    var historyData: BehaviorRelay<[HeartRateHistory]>
    var allLabels: [String] = []
    let disposeBag = DisposeBag()
    
    init() {
        historyData = BehaviorRelay<[HeartRateHistory]>(value: [])
    }
    
    func reloadData(label: String) {
        var history = LocalDatabaseHandler.shared.searchHistoryByLabel(label: label)
        history.sort { (m1, m2) -> Bool in return Int(m1.createDate ?? "0") ?? 0 > Int(m2.createDate ?? "0") ?? 0 }
        historyData.accept(history)
        reloadLabels()
        if UserDefaultHelper.getLogedUser() != nil {
            APIService.shared.getHeartRates()
                .subscribe {[weak self] (data) in
                    guard let self = self else { return }
                    let localIds = history.map { $0.id }
                    for rate in data {
                        if localIds.firstIndex(of: rate.id) == nil {
                            history.append(rate)
                            LocalDatabaseHandler.shared.updateHeartRateHistory(heartRateHistory: rate)
                        }
                    }
                    history.sort { (m1, m2) -> Bool in return Int(m1.createDate ?? "0") ?? 0 > Int(m2.createDate ?? "0") ?? 0 }
                    self.historyData.accept(history)
                    self.reloadLabels()
                    self.updateUnsubmittedRates(history)
                } onError: {[weak self] (err) in
                    self?.updateUnsubmittedRates(history)
                    print("err: \(err.localizedDescription)")
                }
                .disposed(by: disposeBag)
        }
    }
    
    func updateUnsubmittedRates(_ history: [HeartRateHistory]) {
        var historyClone = history
        let unsubmitedRates = history.filter { $0.isSubmitted == false }
        guard !unsubmitedRates.isEmpty else { return }
        APIService.shared.postHeartRate(heartRates: unsubmitedRates)
            .subscribe {[weak self] (data) in
                guard let self = self else { return }
                let localIds = history.map { $0.id }
                for rate in data {
                    if let index = localIds.firstIndex(of: rate.id) {
                        print("update: \(index)")
                        historyClone[index] = rate
                        LocalDatabaseHandler.shared.updateHeartRateHistory(heartRateHistory: rate)
                    }
                }
                self.historyData.accept(historyClone)
                self.reloadLabels()
            } onError: { (err) in
                print("err: \(err)")
            }
            .disposed(by: disposeBag)
    }
    
    func reloadLabels() {
        let history = LocalDatabaseHandler.shared.getAllHistory()
        allLabels = Array(Set(history.map { $0.label ?? "" }))
        allLabels.insert("ALL LABELS", at: 0)
    }
}
