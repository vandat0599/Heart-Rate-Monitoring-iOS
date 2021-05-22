//
//  CameraManager.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import Foundation
import AVFoundation

enum CameraType: Int {
    case back
    case front
    
    func captureDevice() -> AVCaptureDevice? {
        switch self {
        case .front:
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [], mediaType: AVMediaType.video, position: .front).devices
            print("devices:\(devices)")
            for device in devices where device.position == .front {
                return device
            }
        default:
            break
        }
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return nil }
        return camera
    }
}

struct VideoSpec {
    var fps: Int32?
    var size: CGSize?
}

typealias ImageBufferHandler = ((_ imageBuffer: CMSampleBuffer) -> ())
typealias PreviewPlayerAvailable = (() -> ())

class CameraManager: NSObject {
    
    static let shared = CameraManager(cameraType: .back, preferredSpec: VideoSpec(fps: 30, size: CGSize(width: 100, height: 100)), completion: nil)
    private override init() {}
    
    let captureSession = AVCaptureSession()
    var videoDevice: AVCaptureDevice!
    var videoConnection: AVCaptureConnection?
    var audioConnection: AVCaptureConnection?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var spec: VideoSpec?
    
    var imageBufferHandler: ImageBufferHandler?
    var previewPlayerAvailable: PreviewPlayerAvailable?
    
    init(cameraType: CameraType, preferredSpec: VideoSpec?, completion: (() -> ())?) {
        super.init()
        DispatchQueue.global().async { [unowned self] in
            guard let camera = cameraType.captureDevice() else { return }
            self.spec = preferredSpec
            videoDevice = camera
            
            // MARK: - Setup Video Format
            captureSession.beginConfiguration()
            captureSession.sessionPreset = .low
            
            // MARK: - Setup video device input
            let videoDeviceInput: AVCaptureDeviceInput
            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            } catch let error {
                fatalError("Could not create AVCaptureDeviceInput instance with error: \(error).")
            }
            guard captureSession.canAddInput(videoDeviceInput) else { fatalError() }
            captureSession.addInput(videoDeviceInput)
            
            // MARK: - Setup video output
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            let queue = DispatchQueue(label: "com.covidsense.videosamplequeue")
            videoDataOutput.setSampleBufferDelegate(self, queue: queue)
            guard captureSession.canAddOutput(videoDataOutput) else {
                fatalError()
            }
            captureSession.addOutput(videoDataOutput)
            videoConnection = videoDataOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
            if let preferredSpec = preferredSpec {
                // Update the format with a preferred fps
                try? videoDevice.lockForConfiguration()
                videoDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: preferredSpec.fps!)
                videoDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: preferredSpec.fps!)
                videoDevice.unlockForConfiguration()
            }
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = CGRect(x: 0, y: 0, width: preferredSpec?.size?.width ?? 0, height: preferredSpec?.size?.height ?? 0)
            previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.previewLayer = previewLayer
            if previewLayer != nil {
                print("preview player available")
                previewPlayerAvailable?()
            }
            captureSession.commitConfiguration()
            startCapture()
            completion?()
        }
    }
    
    func startCapture() {
        DispatchQueue.global().async { [unowned self] in
            #if DEBUG
            print(#function + "\(self.classForCoder)/")
            #endif
            if captureSession.isRunning {
                #if DEBUG
                print("Capture Session is already running 🏃‍♂️.")
                #endif
                return
            }
            captureSession.startRunning()
        }
    }
    
    func stopCapture() {
        DispatchQueue.global().async { [unowned self] in
            #if DEBUG
            print(#function + "\(self.classForCoder)/")
            #endif
            if !captureSession.isRunning {
                #if DEBUG
                print("Capture Session has already stopped 🛑.")
                #endif
                return
            }
            captureSession.stopRunning()
        }
    }
    
    func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        print("toggleTorch: \(status)")
        let shouldUseFlash = UserDefaults.standard.bool(forKey: "flash_preference")
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if status && shouldUseFlash {
                try device.setTorchModeOn(level: 0.1)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func updateSensivity(sensivty: AVCaptureSession.Preset) {
        DispatchQueue.global().async {
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = sensivty
            self.captureSession.commitConfiguration()
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        imageBufferHandler?(sampleBuffer)
    }
}
