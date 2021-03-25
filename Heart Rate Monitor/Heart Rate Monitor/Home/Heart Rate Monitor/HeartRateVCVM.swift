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
import ComplexModule

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
    func handleImage(with buffer: CMSampleBuffer)
    func togglePlay()
}

class HeartRateVCVMImp: HeartRateVCVM {
    
    let disposeBag = DisposeBag()
    var maxProgressSecond = 20
    var timeCounterSubscription: Disposable?
    private var validFrameCounter = 0
    private var hueFilter = Filter()
    private var pulseDetector = PulseDetector()
    private var inputs: [CGFloat] = []
    private var redmeans: [Double] = []
    
    init() {
        isPlaying = BehaviorRelay<Bool>(value: false)
        isMeasuring = BehaviorRelay<Bool>(value: false)
        touchStatus = BehaviorRelay<Bool>(value: false)
        isHeartRateValid = BehaviorRelay<Bool>(value: false)
        heartRateTrackNumber = BehaviorRelay<Int>(value: 0)
        heartRateProgress = BehaviorRelay<Float>(value: 0.0)
        warningText = BehaviorRelay<String>(value: AppString.heartRateMonitor)
        guideCoverCameraText = BehaviorRelay<String>(value: AppString.heartRateGuides)
    }
    
    var isPlaying: BehaviorRelay<Bool>
    var heartRateTrackNumber: BehaviorRelay<Int>
    var heartRateProgress: BehaviorRelay<Float>
    var warningText: BehaviorRelay<String>
    var guideCoverCameraText: BehaviorRelay<String>
    var isMeasuring: BehaviorRelay<Bool>
    var touchStatus: BehaviorRelay<Bool>
    var isHeartRateValid: BehaviorRelay<Bool>
    
    func togglePlay() {
        isPlaying.accept(!isPlaying.value)
        if !isPlaying.value {
            resetAllData()
        }
    }
    
    private func resetAllData() {
        isMeasuring.accept(false)
        touchStatus.accept(false)
        isHeartRateValid.accept(false)
        heartRateTrackNumber.accept(0)
        heartRateProgress.accept(0.0)
        warningText.accept(AppString.heartRateMonitor)
        guideCoverCameraText.accept(AppString.heartRateGuides)
    }
    
    private func resetMesuringData() {
        heartRateTrackNumber.accept(0)
        heartRateProgress.accept(0.0)
        isMeasuring.accept(false)
        isHeartRateValid.accept(false)
        guideCoverCameraText.accept(AppString.heartRateGuides)
    }
    
    func handleImage(with buffer: CMSampleBuffer) {
        var redmean:CGFloat = 0.0
        var greenmean:CGFloat = 0.0
        var bluemean:CGFloat = 0.0
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
        
        let extent = cameraImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let averageFilter = CIFilter(name: "CIAreaAverage",
                                     parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
        let outputImage = averageFilter.outputImage!
        
        let ctx = CIContext(options:nil)
        let cgImage = ctx.createCGImage(outputImage, from:outputImage.extent)!
        
        let rawData:NSData = cgImage.dataProvider!.data!
        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
        let bytes = UnsafeBufferPointer<UInt8>(start:pixels, count:rawData.length)
        var BGRA_index = 0
        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
            switch BGRA_index {
            case 0:
                bluemean = CGFloat (pixel)
            case 1:
                greenmean = CGFloat (pixel)
            case 2:
                redmean = CGFloat (pixel)
            case 3:
                break
            default:
                break
            }
            BGRA_index += 1
        }
        redmeans.append(Double(redmean))
        let fft = FFT.fft(input: redmeans)
//        print(redmeans)
        let hsv = rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
        print(hsv.0)
    }
    
    private func startMeasurement() {
        timeCounterSubscription = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (value) in
                self.touchStatus.accept(true)
                let average = self.pulseDetector.getAverage()
                let pulse = 60.0/average
                DispatchQueue.main.async {
                    self.isHeartRateValid.accept(!(pulse == -60))
                    self.heartRateProgress.accept(Float(value)*100/Float(maxProgressSecond)/100)
                    self.heartRateTrackNumber.accept(pulse == -60 ? 0 : lroundf(pulse))
                }
            })
    }
}
