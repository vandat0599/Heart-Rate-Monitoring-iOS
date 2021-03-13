//
//  PlayViewVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import Foundation

import Foundation
import RxRelay
import RxSwift

protocol PlayViewVM {
    var isPlaying: BehaviorRelay<Bool> { get }
    var heartRateTrackNumber: BehaviorRelay<Int> { get }
    func togglePlay()
}

class PlayViewVMImp: PlayViewVM {
    
    let disposeBag = DisposeBag()
    
    init() {
        isPlaying = BehaviorRelay<Bool>(value: false)
        heartRateTrackNumber = BehaviorRelay<Int>(value: 0)
    }
    
    var isPlaying: BehaviorRelay<Bool>
    var heartRateTrackNumber: BehaviorRelay<Int>
    
    func togglePlay() {
        isPlaying.accept(!isPlaying.value)
        if isPlaying.value {
            _ = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                .subscribe { (value) in
                    self.heartRateTrackNumber.accept(Int.random(in: 60..<100))
                }
                .disposed(by: disposeBag)
        } else {
            heartRateTrackNumber.accept(0)
        }
    }
}
