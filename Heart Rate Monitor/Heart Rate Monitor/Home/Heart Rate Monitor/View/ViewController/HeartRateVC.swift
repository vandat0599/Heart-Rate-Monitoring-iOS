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
import HGCircularSlider

class HeartRateVC: BaseVC, ChartViewDelegate {
    
    private lazy var heartRateTrackLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.isHidden = true
        view.isUserInteractionEnabled = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        view.attributedText = NSMutableAttributedString(string: "--" as String, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bpmLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.isUserInteractionEnabled = false
        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.text = "BPM"
        view.textColor = UIColor(named: "white-holder")!
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = false
        view.alpha = 1
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressView: CircularSlider = {
        let view = CircularSlider()
        view.minimumValue = 0
        view.maximumValue = 1
        view.endPointValue = 0
        view.diskFillColor = .clear
        view.diskColor = .clear
        view.endThumbTintColor = .clear
        view.endThumbStrokeColor = .clear
        view.endThumbStrokeHighlightedColor = .clear
        view.thumbRadius = 3
        view.trackFillColor = .white
        view.trackColor = UIColor(named: "white-holder")!
        view.lineWidth = 3
        view.backtrackLineWidth = 3
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var playView: CustomRippleControl = {
        let view = CustomRippleControl()
        view.isHidden = false
        view.alpha = 1
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView()
        view.isHidden = false
        view.delegate = self
        view.chartDescription?.enabled = false
        view.dragEnabled = false
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = true
        view.autoScaleMinMaxEnabled = false
        view.leftAxis.axisMaximum = 260
        view.leftAxis.axisMinimum = 0
        view.rightAxis.enabled = false
        view.leftAxis.enabled = false
        view.legend.enabled = false
        view.xAxis.enabled = false
        view.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        view.highlightPerTapEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tapToStartLabel: UILabel = {
        let view = UILabel()
        view.isHidden = false
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        view.text = "TAP HERE TO START"
        view.textAlignment = .center
        view.backgroundColor = .clear
        view.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var heartImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic-heart"))
        view.backgroundColor = .clear
        view.tintColor = UIColor(named: "black-background")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var fireImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic-fire"))
        view.backgroundColor = .clear
        view.isHidden = true
        view.tintColor = UIColor(named: "white-holder")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avgLabelView: BeatLabelView = {
        let view = BeatLabelView()
        view.valueLabel.text = "--"
        view.typeLabel.text = "AVG"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var minLabelView: BeatLabelView = {
        let view = BeatLabelView()
        view.valueLabel.text = "--"
        view.typeLabel.text = "MIN"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var maxLabelView: BeatLabelView = {
        let view = BeatLabelView()
        view.valueLabel.text = "--"
        view.typeLabel.text = "MAX"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
            
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
        updateBottomHeartRateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "black-background")!
        view.addSubview(playView)
        view.addSubview(chartView)
        playView.addSubview(progressView)
        playView.addSubview(cameraView)
        playView.addSubview(heartImageView)
        playView.addSubview(fireImageView)
        playView.addSubview(heartRateTrackLabel)
        playView.addSubview(tapToStartLabel)
        playView.addSubview(bpmLabel)
        view.addSubview(avgLabelView)
        view.addSubview(minLabelView)
        view.addSubview(maxLabelView)
        NSLayoutConstraint.activate([
            playView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            playView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            playView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            playView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 40),
            
            progressView.leadingAnchor.constraint(equalTo: playView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: playView.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: playView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: playView.bottomAnchor),
            
            tapToStartLabel.leadingAnchor.constraint(equalTo: playView.leadingAnchor, constant: 24),
            tapToStartLabel.trailingAnchor.constraint(equalTo: playView.trailingAnchor, constant: -24),
            tapToStartLabel.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
            
            bpmLabel.bottomAnchor.constraint(equalTo: heartRateTrackLabel.topAnchor),
            bpmLabel.leadingAnchor.constraint(equalTo: heartRateTrackLabel.trailingAnchor),
            
            cameraView.topAnchor.constraint(equalTo: tapToStartLabel.bottomAnchor, constant: 20),
            cameraView.widthAnchor.constraint(equalTo: playView.widthAnchor, multiplier: 0.1),
            cameraView.heightAnchor.constraint(equalTo: playView.widthAnchor, multiplier: 0.1),
            cameraView.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            
            heartImageView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            heartImageView.widthAnchor.constraint(equalTo: cameraView.widthAnchor),
            heartImageView.heightAnchor.constraint(equalTo: cameraView.heightAnchor),
            
            fireImageView.topAnchor.constraint(equalTo: playView.topAnchor, constant: 24),
            fireImageView.widthAnchor.constraint(equalTo: playView.widthAnchor, multiplier: 0.1),
            fireImageView.heightAnchor.constraint(equalTo: playView.widthAnchor, multiplier: 0.1),
            fireImageView.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            
            heartRateTrackLabel.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            heartRateTrackLabel.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
            
            minLabelView.centerYAnchor.constraint(equalTo: chartView.centerYAnchor, constant: 20),
            minLabelView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            minLabelView.heightAnchor.constraint(equalTo: chartView.heightAnchor, multiplier: 0.5),
            minLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            avgLabelView.centerYAnchor.constraint(equalTo: chartView.centerYAnchor, constant: 20),
            avgLabelView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            avgLabelView.heightAnchor.constraint(equalTo: chartView.heightAnchor, multiplier: 0.5),
            avgLabelView.trailingAnchor.constraint(equalTo: minLabelView.leadingAnchor),
            
            maxLabelView.centerYAnchor.constraint(equalTo: chartView.centerYAnchor, constant: 20),
            maxLabelView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            maxLabelView.heightAnchor.constraint(equalTo: chartView.heightAnchor, multiplier: 0.5),
            maxLabelView.leadingAnchor.constraint(equalTo: minLabelView.trailingAnchor),
        ])
        reloadChartData(value: Array.init(repeating: 220, count: 100))
        view.layoutIfNeeded()
        cameraView.layer.cornerRadius = cameraView.frame.height/2
        initVideoCapture()
        bindViews()
        NotificationCenter.default.addObserver(self, selector: #selector(menuButtonTapped), name: AppConstant.AppNotificationName.menuButtonTapped, object: nil)
    }
    
    private func bindViews() {
        viewModel?.isPlaying
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[weak self] (value) in
                guard let self = self else { return }
                self.toggleTorch(status: value)
                self.tapToStartLabel.isHidden = value
                self.heartRateTrackLabel.isHidden = !value
                self.fireImageView.isHidden = !value
                self.bpmLabel.isHidden = !value
            })
            .disposed(by: disposeBag)
        
        viewModel?.heartRateTrackNumber
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: { [weak self] (value) in
                guard let self = self else { return }
                let beat = Int(value/2)
                self.heartRateTrackLabel.text = "\(value == 0 ? "--" : "\(beat)")"
                self.fireImageView.tintColor = beat < 60 ? UIColor(named: "white-holder") : beat <= 100 ? UIColor(named: "green-1") : UIColor(named: "red-1")
            })
            .disposed(by: disposeBag)
        
        playView.rx.controlEvent(.touchUpInside)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind {[unowned self] in
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                guard CameraType.back.captureDevice() != nil else {
                    HAlert.showErrorBottomSheet(self, message: "Something wrong with your phone's camera, please try again!!")
                    return
                }
                self.viewModel?.togglePlay()
            }
            .disposed(by: disposeBag)
        
        viewModel?.heartRateProgress
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (value) in
                if value == 0 {
                    self.progressView.endPointValue = 0
                } else {
                    self.progressView.endPointValue = CGFloat(value)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.isMeasuring
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[unowned self] (value) in
                self.playView.isUserInteractionEnabled = !value
            })
            .disposed(by: disposeBag)
        
        viewModel?.isHeartRateValid
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (value) in
                if !value {
                    self.heartRateTrackLabel.text = "--"
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.timeupTrigger
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[unowned self] (value) in
                guard value else { return }
                let vc = ResultBottomSheetVC(heartRate: self.viewModel.heartRateTrackNumber.value/2, grapsValues: self.viewModel.grapValues.value)
                vc.canDismissOnSwipeDown = false
                vc.canDismissOnTouchOutSide = false
                self.present(vc, animated: true) {[weak self] in
                    guard let self = self else { return }
                    self.viewModel.togglePlay()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.grapValues
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[unowned self] (value) in
                self.reloadChartData(value: value)
            })
            .disposed(by: disposeBag)
        
        Observable.of(LocalDatabaseHandler.shared.didInsertHistory, LocalDatabaseHandler.shared.didUpdateHistory, LocalDatabaseHandler.shared.didDeleteHistory).merge()
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind { [weak self] (_) in
                guard let self = self else { return }
                self.updateBottomHeartRateViews()
            }
            .disposed(by: disposeBag)
    }
    
    func updateBottomHeartRateViews() {
        DispatchQueue.global().async {
            let heartRateNumber = LocalDatabaseHandler.shared.getAllHistory().map { $0.heartRateNumber ?? 0 }
            guard heartRateNumber.count > 0 else { return }
            let min = Int(heartRateNumber.min() ?? 0)
            let max = Int(heartRateNumber.max() ?? 0)
            let avg = Int(heartRateNumber.reduce(0, +)/heartRateNumber.count)
            DispatchQueue.main.async {
                self.minLabelView.valueLabel.text = min == 0 ? "--" : "\(min)"
                self.maxLabelView.valueLabel.text = max == 0 ? "--" : "\(max)"
                self.avgLabelView.valueLabel.text = avg == 0 ? "--" : "\(avg)"
            }
        }
    }
    
    @objc private func menuButtonTapped() {
        if viewModel.isPlaying.value == true {
            viewModel.togglePlay()
        }
    }
    
    func reloadChartData(value: [Double]) {
        let yValues = (0..<value.count).map { (i) -> ChartDataEntry in
            let val = value[i]
            return ChartDataEntry(x: Double(i), y: val)
        }
        let dataSet = LineChartDataSet(entries: yValues, label: "Graph value")
        dataSet.axisDependency = .left
        dataSet.setColor(UIColor(named: "pink")!)
        dataSet.lineWidth = 1
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.fillColor = UIColor(named: "pink")!
        dataSet.fillAlpha = 1.0
        dataSet.drawFilledEnabled = true
        let data: LineChartData = LineChartData.init(dataSets: [dataSet])
        chartView.data = data
        chartView.notifyDataSetChanged()
    }
    
    // MARK: - Frames Capture Methods
    func initVideoCapture() {
        CameraManager.shared.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.viewModel.handleImage(with: imageBuffer, fps: Int(CameraManager.shared.spec?.fps ?? 30))
        }
        
        if CameraManager.shared.previewLayer != nil {
            cameraView.layer.insertSublayer(CameraManager.shared.previewLayer!, at: 0)
        }
        
        CameraManager.shared.previewPlayerAvailable = { [weak self] in
            DispatchQueue.main.async {
                self?.cameraView.layer.insertSublayer(CameraManager.shared.previewLayer!, at: 0)
            }
        }
    }

    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        print("toggleTorch: \(status)")
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if status {
                try device.setTorchModeOn(level: 0.1)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
}
