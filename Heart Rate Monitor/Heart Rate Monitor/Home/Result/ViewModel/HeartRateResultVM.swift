//
//  HeartRateResultVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 31/03/2021.
//

import Foundation
import RxRelay
import RxSwift

protocol HeartRateResultVM {
    var heartRateRecord: BehaviorRelay<HeartRateHistory> { get }
}

class HeartRateResultVMImp: HeartRateResultVM {
    
    var heartRateRecord: BehaviorRelay<HeartRateHistory>
    
    init(heartRateRecord: HeartRateHistory) {
        self.heartRateRecord = BehaviorRelay<HeartRateHistory>(value: heartRateRecord)
    }
}
