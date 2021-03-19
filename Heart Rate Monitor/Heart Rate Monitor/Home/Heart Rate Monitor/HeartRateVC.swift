//
//  HomeVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa
import AVFoundation

class HeartRateVC: BaseVC {
    
    private lazy var guideLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        view.attributedText = NSMutableAttributedString(string: AppString.heartRateGuides as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic-gradient-ball")
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var playIconImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic-play"))
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var heartRateTrackLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.isUserInteractionEnabled = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        view.attributedText = NSMutableAttributedString(string: "--\nbpm" as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressView: AnimationView = {
        let view = AnimationView.init(name: "lottie-progress")
        view.isUserInteractionEnabled = false
        view.animationSpeed = 15/CGFloat(viewModel.maxProgressSecond)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var preparingAnimationView: AnimationView = {
        let view = AnimationView.init(name: "lottie-heart-wave")
        view.loopMode = .loop
        view.backgroundBehavior = .pauseAndRestore
        view.play()
        view.isHidden = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var playView: UIControl = {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var heartWaveView: HeartWaveView = {
        let view = HeartWaveView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var playViewTopAnchor: NSLayoutConstraint!
    
    private var heartRateManager: HeartRateManager!
    private var viewModel: HeartRateVCVM!
    
    init(viewModel: HeartRateVCVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = AppString.heartRateMonitor
        view.backgroundColor = .white
        view.addSubview(guideLabel)
        view.addSubview(playView)
        view.addSubview(heartWaveView)
        playView.addSubview(backgroundImage)
        playView.addSubview(progressView)
        playView.addSubview(cameraView)
        playView.addSubview(playIconImageView)
        playView.addSubview(heartRateTrackLabel)
        playView.addSubview(preparingAnimationView)
        playViewTopAnchor = playView.topAnchor.constraint(equalTo: centerYView.bottomAnchor, constant: -UIScreen.main.bounds.width*0.2/2)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            guideLabel.bottomAnchor.constraint(equalTo: playView.topAnchor, constant: -20),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            heartWaveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heartWaveView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heartWaveView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heartWaveView.bottomAnchor.constraint(equalTo: playView.topAnchor),
            
            playViewTopAnchor,
            playView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            playView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            backgroundImage.leadingAnchor.constraint(equalTo: playView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: playView.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: playView.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: playView.bottomAnchor),
            
            progressView.leadingAnchor.constraint(equalTo: playView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: playView.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: playView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: playView.bottomAnchor),
            
            playIconImageView.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            playIconImageView.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
            playIconImageView.heightAnchor.constraint(equalTo: playView.heightAnchor, multiplier: 0.2),
            playIconImageView.widthAnchor.constraint(equalTo: playView.widthAnchor, multiplier: 0.2),
            
            cameraView.leadingAnchor.constraint(equalTo: playView.leadingAnchor, constant: 20),
            cameraView.trailingAnchor.constraint(equalTo: playView.trailingAnchor, constant: -20),
            cameraView.topAnchor.constraint(equalTo: playView.topAnchor, constant: 20),
            cameraView.bottomAnchor.constraint(equalTo: playView.bottomAnchor, constant: -20),
            
            heartRateTrackLabel.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            heartRateTrackLabel.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
            
            preparingAnimationView.leadingAnchor.constraint(equalTo: playView.leadingAnchor),
            preparingAnimationView.trailingAnchor.constraint(equalTo: playView.trailingAnchor),
            preparingAnimationView.topAnchor.constraint(equalTo: playView.topAnchor),
            preparingAnimationView.bottomAnchor.constraint(equalTo: playView.bottomAnchor),
        ])
        view.layoutIfNeeded()
        initVideoCapture()
        bindViews()
        cameraView.layer.cornerRadius = cameraView.frame.height/2
    }
    
    private func bindViews() {
        _ = viewModel?.isPlaying.subscribe(onNext: {[weak self] (value) in
            guard let self = self else { return }
            self.playViewTopAnchor.constant = value ? 0 : -UIScreen.main.bounds.width*0.2/2
            self.cameraView.isHidden = !value
            self.progressView.isHidden = !value
            self.playIconImageView.isHidden = value
            self.guideLabel.isHidden = !value
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
                self.progressView.alpha = !value ? 0.0 : 1.0
                self.cameraView.alpha = !value ? 0.0 : 1.0
                self.playIconImageView.alpha = value ? 0.0 : 1.0
                self.guideLabel.alpha = !value ? 0.0 : 1.0
            }
            self.progressView.currentProgress = 0
            if value {
                self.heartRateManager.startCapture()
            } else {
                self.heartRateManager.stopCapture()
            }
            self.navigationItem.title = value ? AppString.keepYourFinger : AppString.heartRateMonitor
        })
        
        viewModel?.heartRateTrackNumber
            .map { "\($0 == 0 ? "--" : "\($0)")\nbpm" }
            .bind(to: heartRateTrackLabel.rx.text)
            .disposed(by: disposeBag)
        
        playView.rx.controlEvent(.touchUpInside)
            .bind {[unowned self] in
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.viewModel?.togglePlay()
            }
            .disposed(by: disposeBag)
        
        viewModel?.heartRateProgress
            .subscribe(onNext: {[unowned self] (value) in
                if value == 0 {
                    self.progressView.stop()
                    self.progressView.currentProgress = 0
                } else {
                    self.heartWaveView.ECGDraw(color: .red, heartRateNumber: self.viewModel.heartRateTrackNumber.value)
                    self.progressView.play()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.touchStatus
            .subscribe(onNext: {[unowned self] (value) in
                self.toggleTorch(status: value)
            })
            .disposed(by: disposeBag)
        
        viewModel?.warningText
            .subscribe(onNext: {[unowned self] (value) in
                self.navigationItem.title = value
            })
            .disposed(by: disposeBag)
        
        viewModel?.guideCoverCameraText
            .bind(to: guideLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.isMeasuring
            .bind(onNext: {[unowned self] (value) in
                DispatchQueue.main.async {
                    self.playView.isUserInteractionEnabled = !value
                    if !value {
                        self.heartWaveView.removeAllLayer()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.isHeartRateValid
            .subscribe(onNext: {[unowned self] (value) in
                if self.viewModel?.isMeasuring.value ?? false {
                    self.guideLabel.isHidden = value
                    self.heartWaveView.isHidden = !value
                    self.heartRateTrackLabel.isHidden = !value
                    self.preparingAnimationView.isHidden = value
                    UIView.animate(withDuration: 0.4) {
                        self.heartWaveView.alpha = !value ? 0.0 : 1.0
                        self.heartRateTrackLabel.alpha = !value ? 0.0 : 1.0
                        self.preparingAnimationView.alpha = value ? 0.0 : 1.0
                    }
                } else {
                    self.guideLabel.isHidden = false
                    self.heartWaveView.isHidden = true
                    self.preparingAnimationView.isHidden = true
                    self.heartRateTrackLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Frames Capture Methods
    private func initVideoCapture() {
        let specs = VideoSpec(fps: 30, size: CGSize(width: cameraView.frame.width, height: cameraView.frame.height))
        heartRateManager = HeartRateManager(cameraType: .back, preferredSpec: specs, previewContainer: cameraView.layer)
        heartRateManager.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.viewModel.handleImage(with: imageBuffer)
        }
    }

    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }
}