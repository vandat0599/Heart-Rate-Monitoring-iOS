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
    var heartRateRecord: BehaviorRelay<HeartRateRecord> { get }
}

class HeartRateResultVMImp: HeartRateResultVM {
    
    var heartRateRecord: BehaviorRelay<HeartRateRecord>
    
    init(heartRateRecord: HeartRateRecord) {
        self.heartRateRecord = BehaviorRelay<HeartRateRecord>(value: heartRateRecord)
    }
}
