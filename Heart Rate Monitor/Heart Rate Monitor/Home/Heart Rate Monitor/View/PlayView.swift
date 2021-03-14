////
////  PlayView.swift
////  Heart Rate Monitor
////
////  Created by Dat Van on 3/13/21.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import Lottie
//import AVFoundation
//
//class PlayView: UIControl {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//
//    private lazy var backgroundImage: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: "ic-gradient-ball")
//        view.contentMode = .scaleAspectFit
//        view.isUserInteractionEnabled = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var playIconImageView: UIImageView = {
//        let view = UIImageView(image: UIImage(named: "ic-play"))
//        view.contentMode = .scaleAspectFit
//        view.isUserInteractionEnabled = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var heartRateTrackLabel: UILabel = {
//        let view = UILabel()
//        view.textAlignment = .center
//        view.numberOfLines = 0
//        view.isUserInteractionEnabled = false
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 5
//        paragraphStyle.alignment = .center
//        view.attributedText = NSMutableAttributedString(string: "--\nbpm" as String, attributes: [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
//            NSAttributedString.Key.foregroundColor: UIColor.white,
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
//        ])
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var cameraView: RoundedView = {
//        let view = RoundedView()
//        view.backgroundColor = .red
//        view.layer.masksToBounds = true
//        view.isUserInteractionEnabled = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private lazy var progressView: AnimationView = {
//        let view = AnimationView.init(name: "lottie-progress")
//        view.isUserInteractionEnabled = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let disposeBag = DisposeBag()
//    var viewModel: PlayViewVM? {
//        didSet {
//            bindViews()
//        }
//    }
//
//    private var validFrameCounter = 0
//    private var heartRateManager: HeartRateManager!
//    private var hueFilter = Filter()
//    private var pulseDetector = PulseDetector()
//    private var inputs: [CGFloat] = []
//    private var measurementStartedFlag = false
//    private var timer = Timer()
//
//    private func setupView() {
//        addSubview(backgroundImage)
//        addSubview(progressView)
//        addSubview(playIconImageView)
//        addSubview(cameraView)
//        addSubview(heartRateTrackLabel)
//        NSLayoutConstraint.activate([
//            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
//            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
//            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
//            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            progressView.topAnchor.constraint(equalTo: topAnchor),
//            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            playIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            playIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            playIconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
//            playIconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
//
////            cameraView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
////            cameraView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
////            cameraView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
////            cameraView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
//            cameraView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
//            cameraView.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
//            cameraView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            cameraView.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//            heartRateTrackLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            heartRateTrackLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//        ])
//        layoutIfNeeded()
//        print(cameraView.bounds)
//        print(cameraView.frame)
//        initVideoCapture()
//    }
//
//    private func bindViews() {
//        _ = viewModel?.isPlaying.subscribe(onNext: {[weak self] (value) in
//            guard let self = self else { return }
//            self.cameraView.isHidden = !value
//            self.heartRateTrackLabel.isHidden = !value
//            self.progressView.isHidden = !value
//            self.playIconImageView.isHidden = value
//            UIView.animate(withDuration: 0.4) {
//                self.progressView.alpha = !value ? 0.0 : 1.0
//                self.cameraView.alpha = !value ? 0.0 : 1.0
//                self.heartRateTrackLabel.alpha = !value ? 0.0 : 1.0
//                self.playIconImageView.alpha = value ? 0.0 : 1.0
//            }
//            self.progressView.currentProgress = 0
//            if value {
//                self.initCaptureSession()
//            } else {
//                self.deinitCaptureSession()
//            }
//        })
//
//        viewModel?.heartRateTrackNumber
//            .map { "\($0 == 0 ? "--" : "\($0)")\nbpm" }
//            .bind(to: heartRateTrackLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        rx.controlEvent(.touchUpInside)
//            .bind {[weak self] in
//                self?.viewModel?.togglePlay()
//            }
//            .disposed(by: disposeBag)
//
//        viewModel?.heartRateProgress
//            .subscribe(onNext: {[weak self] (value) in
//                self?.progressView.play(toProgress: AnimationProgressTime(value))
//            })
//            .disposed(by: disposeBag)
//    }
//
//    // MARK: - Frames Capture Methods
//    private func initVideoCapture() {
//        let specs = VideoSpec(fps: 30, size: CGSize(width: cameraView.frame.width, height: cameraView.frame.height))
//        heartRateManager = HeartRateManager(cameraType: .back, preferredSpec: specs, previewContainer: cameraView.layer)
//        heartRateManager.imageBufferHandler = { [unowned self] (imageBuffer) in
//            self.handle(buffer: imageBuffer)
//        }
//    }
//
//    // MARK: - AVCaptureSession Helpers
//    private func initCaptureSession() {
//        heartRateManager.startCapture()
//    }
//
//    private func deinitCaptureSession() {
//        heartRateManager.stopCapture()
//        toggleTorch(status: false)
//    }
//
//    private func toggleTorch(status: Bool) {
//        guard let device = AVCaptureDevice.default(for: .video) else { return }
//        device.toggleTorch(on: status)
//    }
//
//    // MARK: - Measurement
//    private func startMeasurement() {
//        DispatchQueue.main.async {
//            self.toggleTorch(status: true)
//            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
//                guard let self = self else { return }
//                let average = self.pulseDetector.getAverage()
//                let pulse = 60.0/average
//                if pulse == -60 {
//                    UIView.animate(withDuration: 0.2, animations: {
////                        self.pulseLabel.alpha = 0
//                    }) { (finished) in
////                        self.pulseLabel.isHidden = finished
//                    }
//                } else {
//                    UIView.animate(withDuration: 0.2, animations: {
////                        self.pulseLabel.alpha = 1.0
//                    }) { (_) in
////                        self.pulseLabel.isHidden = false
//                        self.heartRateTrackLabel.text = "\(lroundf(pulse))\nbpm"
//                        print(lroundf(pulse))
//                    }
//                }
//            })
//        }
//    }
//
//    fileprivate func handle(buffer: CMSampleBuffer) {
//        var redmean:CGFloat = 0.0;
//        var greenmean:CGFloat = 0.0;
//        var bluemean:CGFloat = 0.0;
//
//        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
//        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
//
//        let extent = cameraImage.extent
//        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
//        let averageFilter = CIFilter(name: "CIAreaAverage",
//                              parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
//        let outputImage = averageFilter.outputImage!
//
//        let ctx = CIContext(options:nil)
//        let cgImage = ctx.createCGImage(outputImage, from:outputImage.extent)!
//
//        let rawData:NSData = cgImage.dataProvider!.data!
//        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
//        let bytes = UnsafeBufferPointer<UInt8>(start:pixels, count:rawData.length)
//        var BGRA_index = 0
//        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
//            switch BGRA_index {
//            case 0:
//                bluemean = CGFloat (pixel)
//            case 1:
//                greenmean = CGFloat (pixel)
//            case 2:
//                redmean = CGFloat (pixel)
//            case 3:
//                break
//            default:
//                break
//            }
//            BGRA_index += 1
//        }
//
//        let hsv = rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
//        // Do a sanity check to see if a finger is placed over the camera
//        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
//            DispatchQueue.main.async {
////                self.thresholdLabel.text = "Hold your index finger ☝️ still."
//                self.toggleTorch(status: true)
//                if !self.measurementStartedFlag {
//                    self.startMeasurement()
//                    self.measurementStartedFlag = true
//                }
//            }
//            validFrameCounter += 1
//            inputs.append(hsv.0)
//            // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
//            let filtered = hueFilter.processValue(value: Double(hsv.0))
//            if validFrameCounter > 60 {
//                self.pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
//            }
//        } else {
//            validFrameCounter = 0
//            measurementStartedFlag = false
//            pulseDetector.reset()
//            DispatchQueue.main.async {
////                self.thresholdLabel.text = "Cover the back camera until the image turns red 🟥"
//            }
//        }
//    }
//}
