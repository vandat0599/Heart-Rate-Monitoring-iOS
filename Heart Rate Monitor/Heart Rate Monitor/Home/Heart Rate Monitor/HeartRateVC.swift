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
import Charts

class HeartRateVC: BaseVC, ChartViewDelegate {
    
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
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView()
        view.delegate = self
        view.chartDescription?.enabled = false
        view.dragEnabled = true
        view.setScaleEnabled(true)
        view.pinchZoomEnabled = true
        let l = view.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = view.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = view.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 11)
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let rightAxis = view.rightAxis
        rightAxis.labelFont = .systemFont(ofSize: 11)
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 900
        rightAxis.axisMinimum = -200
        rightAxis.granularityEnabled = false
        
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
        view.addSubview(chartView)
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
            
            chartView.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 20),
            chartView.heightAnchor.constraint(equalToConstant: 200),
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
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
//        initVideoCapture()
//        bindViews()
        setDataCount(21, range: 30)
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
    
    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let mult = range / 2
            let val = Double(arc4random_uniform(mult) + 50)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 450)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let yVals3 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 500)
            return ChartDataEntry(x: Double(i), y: val)
        }

        let set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.setCircleColor(.white)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        let set2 = LineChartDataSet(entries: yVals2, label: "DataSet 2")
        set2.axisDependency = .right
        set2.setColor(.red)
        set2.setCircleColor(.white)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 65/255
        set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.drawCircleHoleEnabled = false

        let set3 = LineChartDataSet(entries: yVals3, label: "DataSet 3")
        set3.axisDependency = .right
        set3.setColor(.yellow)
        set3.setCircleColor(.white)
        set3.lineWidth = 2
        set3.circleRadius = 3
        set3.fillAlpha = 65/255
        set3.fillColor = UIColor.yellow.withAlphaComponent(200/255)
        set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set3.drawCircleHoleEnabled = false
        
        let data: LineChartData = LineChartData.init(dataSets: [set1, set2, set3])
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9))
        
        chartView.data = data
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
