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

class CameraManager: NSObject {
    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice!
    private var videoConnection: AVCaptureConnection?
    private var audioConnection: AVCaptureConnection?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var imageBufferHandler: ImageBufferHandler?
    
    init(cameraType: CameraType, preferredSpec: VideoSpec?, previewContainer: CALayer?) {
        super.init()
        DispatchQueue.global().async { [unowned self] in
            guard let camera = cameraType.captureDevice() else { return }
            videoDevice = camera
            
            // MARK: - Setup Video Format
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
            
            DispatchQueue.main.async {
                // MARK: - Setup preview layer
                if let previewContainer = previewContainer {
                    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.frame = previewContainer.bounds
                    previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.previewLayer = previewLayer
                    previewContainer.insertSublayer(previewLayer, at: 0)
                }
            }
            
            if let preferredSpec = preferredSpec {
                // Update the format with a preferred fps
                try? videoDevice.lockForConfiguration()
                videoDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: preferredSpec.fps!)
                videoDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: preferredSpec.fps!)
                videoDevice.unlockForConfiguration()
            }
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
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    // MARK: - Export buffer from video frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if connection.videoOrientation != .portrait {
            connection.videoOrientation = .portrait
            return
        }
        if let imageBufferHandler = imageBufferHandler {
            imageBufferHandler(sampleBuffer)
        }
    }
}
