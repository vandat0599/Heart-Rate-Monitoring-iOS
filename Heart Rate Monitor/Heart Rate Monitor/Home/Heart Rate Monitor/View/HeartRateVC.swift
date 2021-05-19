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
    
    private lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = false
        view.alpha = 0
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
        view.thumbRadius = 4
        view.trackFillColor = .white
        view.trackColor = UIColor(named: "white-holder")!
        view.lineWidth = 4
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var playView: CustomRippleControl = {
        let view = CustomRippleControl()
        view.isHidden = false
        view.alpha = 0
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView()
        view.isHidden = false
        view.delegate = self
        view.chartDescription?.enabled = false
        view.dragEnabled = true
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = true
        view.autoScaleMinMaxEnabled = true
        view.rightAxis.enabled = false
        view.leftAxis.enabled = false
        view.legend.enabled = false
        view.xAxis.enabled = false
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
            
    private var cameraManager: CameraManager?
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
        view.backgroundColor = UIColor(named: "black-background")!
        view.addSubview(playView)
        view.addSubview(chartView)
        playView.addSubview(progressView)
        playView.addSubview(cameraView)
        playView.addSubview(heartRateTrackLabel)
        playView.addSubview(tapToStartLabel)
        NSLayoutConstraint.activate([
            
            playView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            playView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            playView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            playView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 20),
            
            progressView.leadingAnchor.constraint(equalTo: playView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: playView.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: playView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: playView.bottomAnchor),
            
            cameraView.leadingAnchor.constraint(equalTo: playView.leadingAnchor, constant: 10),
            cameraView.trailingAnchor.constraint(equalTo: playView.trailingAnchor, constant: -10),
            cameraView.topAnchor.constraint(equalTo: playView.topAnchor, constant: 10),
            cameraView.bottomAnchor.constraint(equalTo: playView.bottomAnchor, constant: -10),
            
            tapToStartLabel.leadingAnchor.constraint(equalTo: playView.leadingAnchor, constant: 24),
            tapToStartLabel.trailingAnchor.constraint(equalTo: playView.trailingAnchor, constant: -24),
            tapToStartLabel.topAnchor.constraint(equalTo: playView.topAnchor, constant: 24),
            tapToStartLabel.bottomAnchor.constraint(equalTo: playView.bottomAnchor, constant: -24),
            
            heartRateTrackLabel.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            heartRateTrackLabel.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
        ])
        view.layoutIfNeeded()
        cameraView.layer.cornerRadius = cameraView.frame.height/2
        initVideoCapture()
        bindViews()
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
                if value {
                    UIView.animate(withDuration: 1) {
                        self.cameraView.alpha = 1
                    }
                } else {
                    self.cameraView.alpha = 0
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.heartRateTrackNumber
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { "\($0 == 0 ? "--" : "\(Int($0/2))")" }
            .bind(to: heartRateTrackLabel.rx.text)
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
                if !value {
                    self.reloadChartData(value: nil)
                }
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
                let heartRateHistory = HeartRateHistory(
                    healthInfo:
                        HealthInfo(
                            height: "170",
                            weight: "59",
                            age: "95",
                            gender: .male,
                            createDate: Date().toString(format: "MM-dd-yyyy HH:mm")),
                    heartRate: "\(Int(self.viewModel.heartRateTrackNumber.value/2))",
                    state: .normal,
                    createDate: Date().toString(format: "MM-dd-yyyy HH:mm"))
                
                let vc = UINavigationController(rootViewController: HeartRateResultVC(viewModel: HeartRateResultVMImp(heartRateRecord: heartRateHistory)))
                self.present(vc, animated: true) {[weak self] in
                    guard let self = self else { return }
                    self.viewModel.togglePlay()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.filteredValueTrigger
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[unowned self] (value) in
                self.reloadChartData(value: value)
            })
            .disposed(by: disposeBag)
    }
    
    func reloadChartData(value: Double?) {
        guard let value = value else {
            let dataSet = LineChartDataSet(entries: [ChartDataEntry(x: 0, y: 0.8)    ])
            dataSet.axisDependency = .left
            dataSet.setColor(.red)
            dataSet.lineWidth = 2
            dataSet.drawCirclesEnabled = false
            dataSet.drawCircleHoleEnabled = false
            let lineChartData: LineChartData = LineChartData.init(dataSets: [dataSet])
            lineChartData.setValueTextColor(.clear)
            chartView.data = lineChartData
            chartView.notifyDataSetChanged()
            chartView.moveViewToX(0)
            return
        }
        if viewModel.capturedRedmean.count > 100 {
            chartView.setVisibleXRange(minXRange: 1, maxXRange: 100)
        }
        chartView.data?.addEntry(ChartDataEntry(x: Double(viewModel.capturedRedmean.count), y: value), dataSetIndex: 0)
        chartView.notifyDataSetChanged()
        chartView.moveViewToX(Double(viewModel.capturedRedmean.count))
    }
    
    // MARK: - Frames Capture Methods
    private func initVideoCapture() {
        let specs = VideoSpec(fps: 30, size: CGSize(width: cameraView.frame.width, height: cameraView.frame.height))
        cameraManager = CameraManager(cameraType: .back, preferredSpec: specs, previewContainer: cameraView.layer, completion: {[weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    self.playView.alpha = 1
                }
            }
        })
        cameraManager?.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.viewModel.handleImage(with: imageBuffer, fps: Int(specs.fps ?? 0))
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
