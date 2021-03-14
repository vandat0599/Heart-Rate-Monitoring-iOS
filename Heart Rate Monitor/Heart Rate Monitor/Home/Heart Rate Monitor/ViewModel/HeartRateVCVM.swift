//
//  HeartRateVCVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import Foundation
import RxSwift
import RxRelay

protocol HeartRateVCVM {
    var isPlaying: BehaviorRelay<Bool> { get }
    var heartRateTrackNumber: BehaviorRelay<Int> { get }
    var heartRateProgress: BehaviorRelay<Float> { get }
    func togglePlay()
}

class HeartRateVCVMImp: HeartRateVCVM {
    
    let disposeBag = DisposeBag()
    let maxProgressSecond = 60
    var timeCounterSubscription: Disposable?
    
    init() {
        isPlaying = BehaviorRelay<Bool>(value: false)
        heartRateTrackNumber = BehaviorRelay<Int>(value: 0)
        heartRateProgress = BehaviorRelay<Float>(value: 0.0)
    }
    
    var isPlaying: BehaviorRelay<Bool>
    var heartRateTrackNumber: BehaviorRelay<Int>
    var heartRateProgress: BehaviorRelay<Float>
    
    func togglePlay() {
        isPlaying.accept(!isPlaying.value)
        if isPlaying.value {
            timeCounterSubscription = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                .subscribe(onNext: { (value) in
                    self.heartRateProgress.accept(Float(value)*100/60)
                })
        } else {
            timeCounterSubscription?.dispose()
            heartRateProgress.accept(0)
            heartRateTrackNumber.accept(0)
        }
    }
}
