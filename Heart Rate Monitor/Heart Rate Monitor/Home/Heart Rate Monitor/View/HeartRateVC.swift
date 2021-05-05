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
            NSAttributedString.Key.foregroundColor: UIColor(named: "black-white")!,
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
        let view = UIImageView(image: UIImage(named: "ic-play")?.withRenderingMode(.alwaysTemplate))
        view.tintColor = UIColor(named: "black-white")!
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

    private lazy var playView: CustomRippleControl = {
        let view = CustomRippleControl()
        view.isHidden = false
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
        
    private var playViewTopAnchor: NSLayoutConstraint!
    
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
        navigationItem.title = AppString.heartRateMonitor
        view.backgroundColor = UIColor(named: "white-black")!
        view.addSubview(guideLabel)
        view.addSubview(playView)
        view.addSubview(chartView)
        playView.addSubview(backgroundImage)
        playView.addSubview(progressView)
        playView.addSubview(cameraView)
        playView.addSubview(playIconImageView)
        playView.addSubview(heartRateTrackLabel)
        playViewTopAnchor = playView.topAnchor.constraint(equalTo: centerYView.bottomAnchor, constant: -UIScreen.main.bounds.width*0.2/2)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 20),
            guideLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: playView.topAnchor),
            
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
        ])
        view.layoutIfNeeded()
        initVideoCapture()
        bindViews()
        cameraView.layer.cornerRadius = cameraView.frame.height/2
    }
    
    private func bindViews() {
        viewModel?.isPlaying
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[unowned self] (value) in
                print(value)
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
                    self.cameraManager?.startCapture()
                } else {
                    self.cameraManager?.stopCapture()
                }
                self.toggleTorch(status: value)
                self.navigationItem.title = value ? AppString.keepYourFinger : AppString.heartRateMonitor
            })
            .disposed(by: disposeBag)
        
        viewModel?.heartRateTrackNumber
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { "\($0 == 0 ? "--" : "\($0)")\nbpm" }
            .bind(to: heartRateTrackLabel.rx.text)
            .disposed(by: disposeBag)
        
        playView.rx.controlEvent(.touchUpInside)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind {[unowned self] in
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                guard CameraType.back.captureDevice() != nil else {
                    self.initVideoCapture()
                    HAlert.showErrorBottomSheet(self, message: "Something wrong with your phone's camera, please try again!!")
                    return
                }
                self.viewModel?.togglePlay()
            }
            .disposed(by: disposeBag)
        
        viewModel?.heartRateProgress
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (value) in
                if value == 0 {
                    self.progressView.stop()
                    self.progressView.currentProgress = 0
                } else {
                    self.progressView.play()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.warningText
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (value) in
                self.navigationItem.title = value
            })
            .disposed(by: disposeBag)
        
        viewModel?.guideCoverCameraText
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(to: guideLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.isMeasuring
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[unowned self] (value) in
                if value {
                    self.heartRateTrackLabel.isHidden = false
                    self.chartView.isHidden = false
                    UIView.animate(withDuration: 0.4) {
                        self.chartView.alpha = !value ? 0.0 : 1.0
                    }
                } else {
                    self.heartRateTrackLabel.isHidden = true
                    self.chartView.isHidden = true
                    self.reloadChartData(value: nil)
                }
                self.playView.isUserInteractionEnabled = !value
            })
            .disposed(by: disposeBag)
        
        viewModel?.isHeartRateValid
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (value) in
                if self.viewModel?.isMeasuring.value ?? false {
                    self.guideLabel.isHidden = value
                } else {
                    self.guideLabel.isHidden = false
                }
                if !value {
                    self.heartRateTrackLabel.text = "--\nbpm"
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
                    heartRate: "\(self.viewModel.heartRateTrackNumber.value)",
                    state: .normal,
                    createDate: Date().toString(format: "MM-dd-yyyy HH:mm"))
                let vc = UINavigationController(rootViewController: HeartRateResultVC(viewModel: HeartRateResultVMImp(heartRateRecord: heartRateHistory)))
                self.present(vc, animated: true) {
                    self.viewModel.togglePlay()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.filteredValueTrigger
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[unowned self] (value) in
                if chartView.isHidden == true {
                    chartView.isHidden = false
                }
                self.reloadChartData(value: value)
            })
            .disposed(by: disposeBag)
        
        viewModel?.touchStatus
            .subscribe(onNext: {[unowned self] (value) in
                self.toggleTorch(status: value)
            })
            .disposed(by: disposeBag)
    }
    
    func reloadChartData(value: Double?) {
        guard let value = value else {
            let dataSet = LineChartDataSet(entries: [ChartDataEntry(x: 0, y: 0.8)	])
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
        cameraManager = CameraManager(cameraType: .back, preferredSpec: specs, previewContainer: cameraView.layer)
        cameraManager?.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.viewModel.handleImage(with: imageBuffer, fps: Int(specs.fps ?? 0))
        }
    }

    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }
}
