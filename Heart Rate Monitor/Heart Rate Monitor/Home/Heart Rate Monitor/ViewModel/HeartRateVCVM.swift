//
//  HeartRateVCVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import UIKit
import RxSwift
import RxRelay
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
    var filtedValues: [Double] { get }
    func handleImage(with buffer: CMSampleBuffer)
    func togglePlay()
    func resetAllData()
}

class HeartRateVCVMImp: HeartRateVCVM {
    
    let disposeBag = DisposeBag()
    var maxProgressSecond = 50
    var timeCounterSubscription: Disposable?
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
    var filtedValues: [Double]
    private var validFrameCounter = 0
    private var pulseDetector = PulseDetector()
    private var inputs: [Double] = []
    private var redmeans: [Double] = []
    private let hueFilter = BBFilter()
    
    init() {
        isPlaying = BehaviorRelay<Bool>(value: false)
        isMeasuring = BehaviorRelay<Bool>(value: false)
        touchStatus = BehaviorRelay<Bool>(value: false)
        isHeartRateValid = BehaviorRelay<Bool>(value: false)
        heartRateTrackNumber = BehaviorRelay<Int>(value: 0)
        heartRateProgress = BehaviorRelay<Float>(value: 0.0)
        warningText = BehaviorRelay<String>(value: AppString.heartRateMonitor)
        guideCoverCameraText = BehaviorRelay<String>(value: AppString.heartRateGuides)
        timeupTrigger = PublishRelay<Bool>()
        filtedValues = []
        filteredValueTrigger = PublishRelay<Double>()
    }
    
    func togglePlay() {
        isPlaying.accept(!isPlaying.value)
        if !isPlaying.value {
            resetAllData()
        }
    }
    
    func resetAllData() {
        filtedValues = []
        validFrameCounter = 0
        timeCounterSubscription?.dispose()
        pulseDetector.reset()
        isMeasuring.accept(false)
        touchStatus.accept(false)
        isHeartRateValid.accept(false)
        heartRateTrackNumber.accept(0)
        heartRateProgress.accept(0.0)
        warningText.accept(AppString.heartRateMonitor)
        guideCoverCameraText.accept(AppString.heartRateGuides)
        pulses.removeAll()
        inputs.removeAll()
    }
    
    private func resetMesuringData() {
        filtedValues = []
        heartRateTrackNumber.accept(0)
        heartRateProgress.accept(0.0)
        isMeasuring.accept(false)
        isHeartRateValid.accept(false)
        guideCoverCameraText.accept(AppString.heartRateGuides)
        pulses.removeAll()
        inputs.removeAll()
    }
    
    var pulses: [Int] = []
    
    func handleImage(with buffer: CMSampleBuffer) {
        // B1: Video signal acquisition -> camera frame
        touchStatus.accept(true)
        let imageBuffer = CMSampleBufferGetImageBuffer(buffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)!
        let byteBuffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        var reds: [Int] = []
        var greens: [Int] = []
        var blues: [Int] = []
        for j in 0..<height {
            for i in 0..<width {
                let index = (j * width + i) * 4
                let b = byteBuffer[index] // blue
                let g = byteBuffer[index+1] // green
                let r = byteBuffer[index+2] // red
                reds.append(Int(r))
                greens.append(Int(g))
                blues.append(Int(b))
            }
        }
        let redmean = Double(reds.reduce(0, +))/Double(reds.count)
        let greenmean = Double(greens.reduce(0, +))/Double(greens.count)
        let bluemean = Double(blues.reduce(0, +))/Double(blues.count)
        inputs.append(redmean)
        
        // B3: Band-pass filtering: BPM_L = 40 & BPM_H = 230 -> filtered mean of red color
        
        // B4:
        
        // hsv for cover camera condition
        let hsv = rgb2hsv(red: CGFloat(redmean), green: CGFloat(greenmean), blue: CGFloat(bluemean))
        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
            DispatchQueue.main.async {
                self.warningText.accept(AppString.keepYourFinger)
            }
            touchStatus.accept(true)
            if !isMeasuring.value {
                startMeasurement()
                isMeasuring.accept(true)
            }
            validFrameCounter += 1
            // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
            
            if inputs.count >= 180 && (inputs.count-180)%15 == 0 {
                let heartRate = HeartRateDetector.PulseDetector(Array(inputs[15*pulses.count..<inputs.count]), fps: 30)
                pulses.append(heartRate)
                print("heartRate: \(pulses.reduce(0,+)/pulses.count) - \(inputs.count)")
            }
            
            var filtered = hueFilter.processValue(value: Double(hsv.0))
            filtered = filtered <= -1 ? 0 : filtered
            filtered = filtered >= 1 ? 0 : filtered
            filtedValues.append(filtered)
            filteredValueTrigger.accept(filtered)
            if validFrameCounter > 60 {
                _ = pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
            }
        } else {
            DispatchQueue.main.async {
                self.resetMesuringData()
            }
            validFrameCounter = 0
            timeCounterSubscription?.dispose()
            pulseDetector.reset()
        }
    }
    
    private func startMeasurement() {
        timeCounterSubscription = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (value) in
                self.touchStatus.accept(true)
                let average = self.pulseDetector.getAverage()
                let pulse = 60.0/average
                let heartRateProgress = Float(value)/Float(maxProgressSecond)
                timeupTrigger.accept(heartRateProgress >= 1)
                DispatchQueue.main.async {
                    self.isHeartRateValid.accept(!(pulse == -60))
                    self.heartRateProgress.accept(heartRateProgress)
                    self.heartRateTrackNumber.accept(pulse == -60 ? 0 : lroundf(pulse))
                }
            })
    }
}
