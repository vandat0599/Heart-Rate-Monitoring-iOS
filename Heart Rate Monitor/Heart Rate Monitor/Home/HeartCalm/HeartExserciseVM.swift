//
//  CalmSelectionVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 21/05/2021.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import AVFoundation

protocol PHeartExserciseVM {
    var maxProgressSecond: Int { get }
    var isPlaying: BehaviorRelay<Bool> { get }
    var isMeasuring: BehaviorRelay<Bool> { get }
    var heartRateTrackNumber: BehaviorRelay<Int> { get }
    var heartRateProgress: BehaviorRelay<Float> { get }
    var isHeartRateValid: BehaviorRelay<Bool> { get }
    var timeupTrigger: PublishRelay<Bool> { get }
    var capturedRedmean: [Double] { get }
    var breathinTrigger: PublishRelay<Double> { get }
    var breathoutTrigger: PublishRelay<Double> { get }
    var resetDataTrigger: BehaviorRelay<Bool> { get }
    func handleImage(with buffer: CMSampleBuffer, fps: Int)
    func togglePlay()
    func resetAllData()
}

class HeartExserciseVM: PHeartExserciseVM {

    let disposeBag = DisposeBag()
    
    var isPlaying: BehaviorRelay<Bool>
    var heartRateTrackNumber: BehaviorRelay<Int>
    var heartRateProgress: BehaviorRelay<Float>
    var isMeasuring: BehaviorRelay<Bool>
    var isHeartRateValid: BehaviorRelay<Bool>
    var timeupTrigger: PublishRelay<Bool>
    var breathinTrigger: PublishRelay<Double>
    var breathoutTrigger: PublishRelay<Double>
    var resetDataTrigger: BehaviorRelay<Bool>
    
    var capturedRedmean: [Double] = []
    var pulses: [Double] = []
    var timer: Timer?
    var maxProgressSecond = 20
    var value = 0
    var breathPermins = [7, 6, 5]
    var mins = [1, 2, 3, 4, 5]
    var selectedBreathPerminIndex = 0
    var selectedMinIndex = 0
    var breathPerMaxSecond = 0
    var shouldSaveHeartWaves = true
    
    init() {
        isPlaying = BehaviorRelay<Bool>(value: false)
        isMeasuring = BehaviorRelay<Bool>(value: false)
        isHeartRateValid = BehaviorRelay<Bool>(value: false)
        heartRateTrackNumber = BehaviorRelay<Int>(value: 0)
        heartRateProgress = BehaviorRelay<Float>(value: 0.0)
        timeupTrigger = PublishRelay<Bool>()
        breathinTrigger = PublishRelay<Double>()
        breathoutTrigger = PublishRelay<Double>()
        resetDataTrigger = BehaviorRelay<Bool>(value: false)
        capturedRedmean = []
        maxProgressSecond = mins[selectedMinIndex]*60
        breathPerMaxSecond = mins[selectedMinIndex]*60/breathPermins[selectedBreathPerminIndex]
    }
    
    func togglePlay() {
        resetAllData()
        isPlaying.accept(!isPlaying.value)
    }
    
    func resetAllData() {
        resetDataTrigger.accept(true)
        isMeasuring.accept(false)
        isHeartRateValid.accept(false)
        heartRateTrackNumber.accept(0)
        heartRateProgress.accept(0.0)
        pulses.removeAll()
        capturedRedmean.removeAll()
        timer?.invalidate()
        timer = nil
        value = 0
    }
    
    func handleImage(with buffer: CMSampleBuffer, fps: Int = 30) {
        let rgb = buffer.meanRGB
        let redmean = rgb.0
        let greenmean = rgb.1
        let bluemean = rgb.2
        if  HeartRateDetector.isValidRGB(r: Double(redmean), g: Double(greenmean), b: Double(bluemean)) {
            resetDataTrigger.accept(false)
            if !isMeasuring.value && isPlaying.value {
                print("Start measure")
                startMeasurement()
                isMeasuring.accept(true)
            }
            capturedRedmean.append(Double(redmean))
            if capturedRedmean.count >= HeartRateDetector.Windows_Seconds*fps && capturedRedmean.count%fps == 0 {
                let heartRate = HeartRateDetector.PulseDetector(capturedRedmean, fps: fps, pulse: pulses)
                pulses.append((heartRate == -1 ? (pulses.last ?? 80) : heartRate))
            }
        } else {
            if resetDataTrigger.value == false {
                resetAllData()
            }
        }
    }
    
    private func startMeasurement() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
            self.timer?.fire()
        }
    }
    
    @objc func fireTimer() {
        if isHeartRateValid.value == true {
            HeartRateDetector.playMedicalAudio()
        }
        if Int(value%breathPerMaxSecond) == 0 {
            breathinTrigger.accept(Double(breathPerMaxSecond/2))
        } else if Int(value%breathPerMaxSecond) == Int(breathPerMaxSecond/2) {
            breathoutTrigger.accept(Double(breathPerMaxSecond/2))
        }
        value += 1
        let progress = Float(value)/Float(maxProgressSecond)
        timeupTrigger.accept(progress >= 1)
        isHeartRateValid.accept(pulses.count > 0)
        heartRateProgress.accept(progress)
        heartRateTrackNumber.accept(pulses.count > 0 ? Int(pulses.reduce(0.0, +)/Double(pulses.count)) : 0)
        print("inputs: \(capturedRedmean.count)")
        if progress >= 1 {
            print("invalidate")
            self.timer?.invalidate()
            self.timer = nil
            self.value = 0
        }
    }
}

