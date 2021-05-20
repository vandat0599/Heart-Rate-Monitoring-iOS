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
    
    init() {
        historyData = BehaviorRelay<[HeartRateHistory]>(value: [])
    }
    
    func reloadData() {
        var history = LocalDatabaseHandler.shared.getAllHistory()
        history.reverse()
        historyData.accept(history)
    }
    
    func reloadLabels() {
        let history = LocalDatabaseHandler.shared.getAllHistory()
        allLabels = Array(Set(history.map { $0.label ?? "" }))
        allLabels.insert("ALL LABELS", at: 0)
    }
    
    func searchHistoryByLabel(label: String) {
        var history = LocalDatabaseHandler.shared.searchHistoryByLabel(label: label)
        history.reverse()
        historyData.accept(history)
    }
}
