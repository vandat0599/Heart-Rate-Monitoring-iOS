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
    var heartRateResultNumber: BehaviorRelay<Int> { get }
}

class HeartRateResultVMImp: HeartRateResultVM {
    
    var heartRateResultNumber: BehaviorRelay<Int>
    
    init(heartRateNumber: Int) {
        heartRateResultNumber = BehaviorRelay<Int>(value: heartRateNumber)
    }
}
