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
    var maxProgressSecond = 20
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
//    private var pulseDetector = PulseDetector()
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
//        pulseDetector.reset()
        isMeasuring.accept(false)
        touchStatus.accept(false)
        isHeartRateValid.accept(false)
        heartRateTrackNumber.accept(0)
        heartRateProgress.accept(0.0)
        warningText.accept(AppString.heartRateMonitor)
        guideCoverCameraText.accept(AppString.heartRateGuides)
    }
    
    private func resetMesuringData() {
        filtedValues = []
        heartRateTrackNumber.accept(0)
        heartRateProgress.accept(0.0)
        isMeasuring.accept(false)
        isHeartRateValid.accept(false)
        guideCoverCameraText.accept(AppString.heartRateGuides)
    }
    
    func handleImage(with buffer: CMSampleBuffer) {
        // B1: Video signal acquisition -> camera frame
        touchStatus.accept(true)
        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
        let extentVector = CIVector(x: cameraImage.extent.origin.x, y: cameraImage.extent.origin.y, z: cameraImage.extent.size.width, w: cameraImage.extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: extentVector])
        guard let outputImage = filter?.outputImage else { return }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        // B2: Brightness signal computation -> mean of red color
        let redmean = CGFloat(bitmap[0])
        let greenmean = CGFloat(bitmap[1])
        let bluemean = CGFloat(bitmap[2])
        redmeans.append(Double(redmean))
        // B3: Band-pass filtering: BPM_L = 40 & BPM_H = 230 -> filtered mean of red color
        
        // B4:
        
        // hsv for cover camera condition
        let hsv = rgb2hsv(red: redmean, green: greenmean, blue: bluemean)
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
            inputs.append(Double(hsv.0))
            // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
//            var filtered = hueFilter.processValue(value: Double(hsv.0))
//            filtered = filtered <= -1 ? 0 : filtered
//            filtered = filtered >= 1 ? 0 : filtered
//            filtedValues.append(filtered)
//            filteredValueTrigger.accept(filtered)
//            if validFrameCounter > 60 {
//                _ = pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
//            }
        } else {
            DispatchQueue.main.async {
                self.resetMesuringData()
            }
            validFrameCounter = 0
            timeCounterSubscription?.dispose()
//            pulseDetector.reset()
        }
    }
    
    private func startMeasurement() {
        timeCounterSubscription = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (value) in
                self.touchStatus.accept(true)
                
                let filter = BBFilter()
                let (denC, numC) = filter.butter(order: 2, lowFreq: 2/45, highFreq: 23/90)
                var y = filter.Filter(signal: inputs, denC: denC, numC: numC)
                let r = filter.DFT(signal: y)
                print(r)
                
//                let average = self.pulseDetector.getAverage()
//                let pulse = 60.0/average
//                let heartRateProgress = Float(value)/Float(maxProgressSecond)
                
//                timeupTrigger.accept(heartRateProgress >= 1)
//                DispatchQueue.main.async {
//                    self.isHeartRateValid.accept(!(pulse == -60))
//                    self.heartRateProgress.accept(heartRateProgress)
//                    self.heartRateTrackNumber.accept(pulse == -60 ? 0 : lroundf(pulse))
//                }
            })
    }
}
