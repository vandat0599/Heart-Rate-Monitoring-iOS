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
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
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
        case .notDetermined, .restricted, .denied:
            return nil
        @unknown default:
            return nil
        }
    }
}

struct VideoSpec {
    var fps: Int32?
    var size: CGSize?
}

typealias ImageBufferHandler = ((_ imageBuffer: CMSampleBuffer) -> ())
typealias PreviewPlayerAvailable = (() -> ())

class CameraManager: NSObject {
    
    static var shared = CameraManager()
    private override init() {}
    
    let captureSession = AVCaptureSession()
    var videoDevice: AVCaptureDevice!
    var videoConnection: AVCaptureConnection?
    var audioConnection: AVCaptureConnection?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var spec: VideoSpec?
    
    var imageBufferHandler: ImageBufferHandler?
    var previewPlayerAvailable: PreviewPlayerAvailable?
    
    func reloadCamera(cameraType: CameraType, preferredSpec: VideoSpec?, completion: (() -> ())?) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let camera = cameraType.captureDevice() else { return }
            self.spec = preferredSpec
            self.videoDevice = camera
            
            // MARK: - Setup Video Format
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = .low
            
            // MARK: - Setup video device input
            let videoDeviceInput: AVCaptureDeviceInput
            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: self.videoDevice)
                guard self.captureSession.canAddInput(videoDeviceInput) else { fatalError() }
                self.captureSession.addInput(videoDeviceInput)
            } catch let error {
                print("Could not create AVCaptureDeviceInput instance with error: \(error).")
            }
            
            // MARK: - Setup video output
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            let queue = DispatchQueue(label: "com.covidsense.videosamplequeue")
            videoDataOutput.setSampleBufferDelegate(self, queue: queue)
            guard self.captureSession.canAddOutput(videoDataOutput) else {
                fatalError()
            }
            self.captureSession.addOutput(videoDataOutput)
            self.videoConnection = videoDataOutput.connection(with: .video)
            self.videoConnection?.videoOrientation = .portrait
            if let preferredSpec = preferredSpec {
                // Update the format with a preferred fps
                try? self.videoDevice.lockForConfiguration()
                self.videoDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: preferredSpec.fps!)
                self.videoDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: preferredSpec.fps!)
                self.videoDevice.unlockForConfiguration()
            }
            let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            previewLayer.frame = CGRect(x: 0, y: 0, width: preferredSpec?.size?.width ?? 0, height: preferredSpec?.size?.height ?? 0)
            previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.previewLayer = previewLayer
            if previewLayer != nil {
                print("preview player available")
                self.previewPlayerAvailable?()
            }
            self.captureSession.commitConfiguration()
            self.startCapture()
            completion?()
        }
    }
    
    func startCapture() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            #if DEBUG
            print(#function + "\(self.classForCoder)/")
            #endif
            if self.captureSession.isRunning {
                #if DEBUG
                print("Capture Session is already running 🏃‍♂️.")
                #endif
                return
            }
            self.captureSession.startRunning()
        }
    }
    
    func stopCapture() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            #if DEBUG
            print(#function + "\(self.classForCoder)/")
            #endif
            if !self.captureSession.isRunning {
                #if DEBUG
                print("Capture Session has already stopped 🛑.")
                #endif
                return
            }
            self.captureSession.stopRunning()
        }
    }
    
    func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        print("toggleTorch: \(status)")
        let shouldUseFlash = UserDefaults.standard.bool(forKey: "flash_preference")
        print("setting torch: \(shouldUseFlash)")
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
    
    static func reloadCaptureSession() {
        if CameraManager.shared.previewLayer == nil {
            print("camera nil ok setup camera")
            CameraManager.shared.reloadCamera(cameraType: .back, preferredSpec: VideoSpec(fps: 30, size: CGSize(width: 100, height: 100)), completion: nil)
        } else {
            print("camera ok")
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        imageBufferHandler?(sampleBuffer)
    }
}
