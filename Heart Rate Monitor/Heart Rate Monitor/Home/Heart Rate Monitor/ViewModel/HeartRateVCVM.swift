//
//  HeartRateVCVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import Foundation
import RxSwift
import RxRelay
import AVFoundation

protocol HeartRateVCVM {
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
    let maxProgressSecond = 60
    var timeCounterSubscription: Disposable?
    private var validFrameCounter = 0
    private var hueFilter = Filter()
    private var pulseDetector = PulseDetector()
    private var inputs: [CGFloat] = []
    
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
            touchStatus.accept(false)
            timeCounterSubscription?.dispose()
            heartRateProgress.accept(0)
            heartRateTrackNumber.accept(0)
        }
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
        let hsv = rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
        // Do a sanity check to see if a finger is placed over the camera
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
            inputs.append(hsv.0)
            // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
            let filtered = hueFilter.processValue(value: Double(hsv.0))
            if validFrameCounter > 60 {
                _ = pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
            }
        } else {
            DispatchQueue.main.async {
                self.isMeasuring.accept(false)
                self.isHeartRateValid.accept(false)
                self.heartRateProgress.accept(0)
                self.heartRateTrackNumber.accept(0)
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
                print(lroundf(pulse))
                DispatchQueue.main.async {
                    self.isHeartRateValid.accept(!(pulse == -60))
                    self.heartRateProgress.accept(pulse == -60 ? 0 : Float(value)*100/60)
                    self.heartRateTrackNumber.accept(pulse == -60 ? 0 : lroundf(pulse))
                }
            })
    }
}
