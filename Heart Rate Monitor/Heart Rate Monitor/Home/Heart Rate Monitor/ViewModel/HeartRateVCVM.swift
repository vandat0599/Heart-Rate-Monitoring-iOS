//
//  HeartRateVCVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import AVFoundation

protocol HeartRateVCVM {
    var maxProgressSecond: Int { get }
    var isPlaying: BehaviorRelay<Bool> { get }
    var isMeasuring: BehaviorRelay<Bool> { get }
    var touchStatus: BehaviorRelay<Bool> { get }
    var heartRateTrackNumber: BehaviorRelay<Int> { get }
    var heartRateProgress: BehaviorRelay<Float> { get }
    var warningText: BehaviorRelay<String> { get }
    var isHeartRateValid: BehaviorRelay<Bool> { get }
    var guideCoverCameraText: BehaviorRelay<String> { get }
    var timeupTrigger: PublishRelay<Bool> { get }
    var filteredValueTrigger: PublishRelay<Double> { get }
    var capturedRedmean: [Double] { get }
    func handleImage(with buffer: CMSampleBuffer, fps: Int)
    func togglePlay()
    func resetAllData()
}

class HeartRateVCVMImp: HeartRateVCVM {
    
    
    let disposeBag = DisposeBag()
    
    var isPlaying: BehaviorRelay<Bool>
    var heartRateTrackNumber: BehaviorRelay<Int>
    var heartRateProgress: BehaviorRelay<Float>
    var warningText: BehaviorRelay<String>
    var guideCoverCameraText: BehaviorRelay<String>
    var isMeasuring: BehaviorRelay<Bool>
    var touchStatus: BehaviorRelay<Bool>
    var isHeartRateValid: BehaviorRelay<Bool>
    var timeupTrigger: PublishRelay<Bool>
    var filteredValueTrigger: PublishRelay<Double>
    
    var capturedRedmean: [Double] = []
    private var pulses: [Double] = []
    var timer: Timer?
    let maxProgressSecond = 30
    var value = 0
    
    init() {
        isPlaying = BehaviorRelay<Bool>(value: false)
        isMeasuring = BehaviorRelay<Bool>(value: false)
        isHeartRateValid = BehaviorRelay<Bool>(value: false)
        heartRateTrackNumber = BehaviorRelay<Int>(value: 0)
        heartRateProgress = BehaviorRelay<Float>(value: 0.0)
        warningText = BehaviorRelay<String>(value: AppString.heartRateMonitor)
        guideCoverCameraText = BehaviorRelay<String>(value: AppString.heartRateGuides)
        timeupTrigger = PublishRelay<Bool>()
        filteredValueTrigger = PublishRelay<Double>()
        capturedRedmean = []
        touchStatus = BehaviorRelay<Bool>(value: false)
    }
    
    func togglePlay() {
        isPlaying.accept(!isPlaying.value)
        resetAllData()
    }
    
    func resetAllData() {
        isMeasuring.accept(false)
        isHeartRateValid.accept(false)
        heartRateTrackNumber.accept(0)
        heartRateProgress.accept(0.0)
        warningText.accept(AppString.heartRateMonitor)
        guideCoverCameraText.accept(AppString.heartRateGuides)
        pulses.removeAll()
        capturedRedmean.removeAll()
        timer?.invalidate()
        timer = nil
        value = 0
    }
    
    func handleImage(with buffer: CMSampleBuffer, fps: Int = 30) {
        touchStatus.accept(true)
        let rgb = buffer.meanRGB
        let redmean = rgb.0
        let greenmean = rgb.1
        let bluemean = rgb.2
        let hsv = rgb2hsv(red: CGFloat(redmean), green: CGFloat(greenmean), blue: CGFloat(bluemean))
        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
            // valid red frame -> start measure
            warningText.accept(AppString.keepYourFinger)
            if !isMeasuring.value {
                startMeasurement()
                isMeasuring.accept(true)
            }
            capturedRedmean.append(redmean)
            filteredValueTrigger.accept(Double(hsv.2))
            if capturedRedmean.count >= HeartRateDetector.Windows_Seconds*fps && capturedRedmean.count%15 == 0 {
                let heartRate = HeartRateDetector.PulseDetector(Array(capturedRedmean[15*pulses.count..<capturedRedmean.count]), fps: fps)
                pulses.append(heartRate)
            }
        } else {
            // invalid red frame -> stop measure.
            resetAllData()
        }
    }
    
    private func startMeasurement() {
        DispatchQueue.main.async { [unowned self] in
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    @objc func fireTimer() {
        value += 1
        let progress = Float(value)/Float(maxProgressSecond)
        timeupTrigger.accept(progress >= 1)
        isHeartRateValid.accept(pulses.count > 0)
        heartRateProgress.accept(progress)
        print("inputs: \(capturedRedmean.count)")
        heartRateTrackNumber.accept(pulses.count > 0 ? Int(pulses.reduce(0.0, +)/Double(pulses.count)) : 0)
        if progress >= 1 {
            self.value = 0
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}
