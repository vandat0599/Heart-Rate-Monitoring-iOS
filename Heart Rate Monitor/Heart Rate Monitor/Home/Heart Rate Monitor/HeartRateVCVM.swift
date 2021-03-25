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
    func handleImage(with buffer: CMSampleBuffer)
    func togglePlay()
}

class HeartRateVCVMImp: HeartRateVCVM {
    
    let disposeBag = DisposeBag()
    var maxProgressSecond = 20
    var timeCounterSubscription: Disposable?
    private var validFrameCounter = 0
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
        let bbf = BBFilter()
        let filted = redmeans.map { bbf.processValue(value: $0) }
        let fft = FFT.fft(input: filted)
        print("filtered: \(filted)")
        print("fft: \(fft.max())")
        
        // hsv for cover camera condition
        let hsv = rgb2hsv(red: redmean, green: greenmean, blue: bluemean)
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
