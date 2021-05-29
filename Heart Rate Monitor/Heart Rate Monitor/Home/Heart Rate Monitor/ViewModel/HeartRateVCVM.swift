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
    var maxProgressSecond: Int { get set }
    var shouldSaveHeartWaves: Bool { get set }
    var isPlaying: BehaviorRelay<Bool> { get }
    var isMeasuring: BehaviorRelay<Bool> { get }
    var heartRateTrackNumber: BehaviorRelay<Int> { get }
    var heartRateProgress: BehaviorRelay<Float> { get }
    var isHeartRateValid: BehaviorRelay<Bool> { get }
    var timeupTrigger: PublishRelay<Bool> { get }
    var capturedRedmean: [Double] { get }
    var grapValues: BehaviorRelay<[Double]> { get }
    func handleImage(with buffer: CMSampleBuffer, fps: Int)
    func getAverageHeartRate() -> Int
    func togglePlay()
    func resetAllData()
}

class HeartRateVCVMImp: HeartRateVCVM {
    
    
    let disposeBag = DisposeBag()
    
    var isPlaying: BehaviorRelay<Bool>
    var heartRateTrackNumber: BehaviorRelay<Int>
    var heartRateProgress: BehaviorRelay<Float>
    var isMeasuring: BehaviorRelay<Bool>
    var isHeartRateValid: BehaviorRelay<Bool>
    var timeupTrigger: PublishRelay<Bool>
    var grapValues: BehaviorRelay<[Double]>
    
    var capturedRedmean: [Double] = []
    private var pulses: [Double] = []
    var timer: Timer?
    var maxProgressSecond = 20
    var value = 0
    var shouldSaveHeartWaves = true
    
    init() {
        isPlaying = BehaviorRelay<Bool>(value: false)
        isMeasuring = BehaviorRelay<Bool>(value: false)
        isHeartRateValid = BehaviorRelay<Bool>(value: false)
        heartRateTrackNumber = BehaviorRelay<Int>(value: 0)
        heartRateProgress = BehaviorRelay<Float>(value: 0.0)
        timeupTrigger = PublishRelay<Bool>()
        grapValues = BehaviorRelay<[Double]>(value: Array.init(repeating: 220, count: 100))
        capturedRedmean = []
    }
    
    func togglePlay() {
        resetAllData()
        isPlaying.accept(!isPlaying.value)
    }
    
    func resetAllData() {
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
        if HeartRateDetector.isValidRGB(r: Double(redmean), g: Double(greenmean), b: Double(bluemean)) {
            if !isMeasuring.value && isPlaying.value {
                startMeasurement()
                isMeasuring.accept(true)
            }
            capturedRedmean.append(Double(redmean))
            if capturedRedmean.count >= HeartRateDetector.Windows_Seconds*fps && capturedRedmean.count%fps == 0 {
                let windowArray = Array(capturedRedmean[fps*pulses.count..<capturedRedmean.count])
                let heartRate = HeartRateDetector.PulseDetector(capturedRedmean, fps: fps, pulses: pulses)
                pulses.append(heartRate)
                grapValues.accept(windowArray)
            }
        } else {
            resetAllData()
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
        value += 1
        let progress = Float(value)/Float(maxProgressSecond)
        timeupTrigger.accept(progress >= 1)
        isHeartRateValid.accept(pulses.count > 0)
        heartRateProgress.accept(progress)
        heartRateTrackNumber.accept(getAverageHeartRate())
        print("inputs: \(capturedRedmean.count)")
        if progress >= 1 {
            print("invalidate")
            self.timer?.invalidate()
            self.timer = nil
            self.value = 0
        }
    }
    
    func getAverageHeartRate() -> Int {
        return pulses.count > 0 ? Int(pulses.reduce(0.0, +)/Double(pulses.count)) : 0
    }
}
