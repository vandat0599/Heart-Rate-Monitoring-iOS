//
//  CalmTypeSelectionVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 20/05/2021.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa
import AVFoundation
import Charts
import HGCircularSlider

class HeartExserciseVC: BaseVC, UIPickerViewDelegate, UIPickerViewDataSource  {
    
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
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var playView: CustomRippleControl = {
        let view = CustomRippleControl()
        view.isHidden = false
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var heartImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic-heart-large"))
        view.backgroundColor = .clear
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var exTypePickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var startButton: CustomRippleButton = {
        let view = CustomRippleButton()
        view.setTitle("START", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(named: "pink")
        view.clipsToBounds = true
        view.buttonScaleOnAnimate = 0.97
        view.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var guideLabel: UILabel = {
        let view = UILabel()
        view.text = "Please place your finger on camera"
        view.textColor = .white
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textAlignment = .center
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView()
        view.isHidden = true
        view.chartDescription?.enabled = false
        view.dragEnabled = false
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = true
        view.autoScaleMinMaxEnabled = false
        view.tintColor = .white
        view.autoScaleMinMaxEnabled = true
        view.leftAxis.labelTextColor = .white
        view.leftAxis.axisLineColor = .white
        view.tintColor = .white
        view.rightAxis.enabled = false
        view.leftAxis.enabled = true
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        view.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: numberFormatter)
        view.legend.enabled = false
        view.xAxis.enabled = false
        view.xAxis.drawAxisLineEnabled = false
//        view.value
//        view.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        view.highlightPerTapEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewModel: HeartExserciseVM!
    
    init(viewModel: HeartExserciseVM) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "black-background")!
        view.addSubview(playView)
        view.addSubview(exTypePickerView)
        view.addSubview(startButton)
        playView.addSubview(heartImageView)
        playView.addSubview(heartRateTrackLabel)
        view.addSubview(guideLabel)
        view.addSubview(chartView)
        NSLayoutConstraint.activate([
            playView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            playView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            playView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            playView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            heartImageView.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
            heartImageView.widthAnchor.constraint(equalTo: playView.widthAnchor),
            heartImageView.heightAnchor.constraint(equalTo: playView.heightAnchor),
            
            heartRateTrackLabel.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            heartRateTrackLabel.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
            
            exTypePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exTypePickerView.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 0),
            exTypePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exTypePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exTypePickerView.bottomAnchor.constraint(equalTo: startButton.topAnchor),
            
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartView.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            
            guideLabel.centerYAnchor.constraint(equalTo: exTypePickerView.centerYAnchor),
            guideLabel.centerXAnchor.constraint(equalTo: exTypePickerView.centerXAnchor),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startButton.topAnchor.constraint(equalTo: exTypePickerView.bottomAnchor, constant: 0),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 44),
            startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
        view.layoutIfNeeded()
        startButton.cornerRadius = startButton.frame.height/2
        view.layoutIfNeeded()
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
                self.heartRateTrackLabel.isHidden = !value
                self.guideLabel.isHidden = !value
                if !value {
                    self.chartView.isHidden = true
                }
                self.startButton.setTitle(value ? "STOP" : "START", for: .normal)
                self.exTypePickerView.isHidden = value
            })
            .disposed(by: disposeBag)
        
        viewModel?.heartRateTrackNumber
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: { [weak self] (value) in
                guard let self = self else { return }
                let beat = Int(value/2)
                self.heartRateTrackLabel.text = "\(value == 0 ? "" : "\(beat)")"
            })
            .disposed(by: disposeBag)
        
        viewModel?.heartRateProgress
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (value) in
            })
            .disposed(by: disposeBag)
        
        viewModel?.isHeartRateValid
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (value) in
                if !value {
                    self.heartRateTrackLabel.text = ""
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.timeupTrigger
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[unowned self] (value) in
                guard value else { return }
                    //show charts & move guide label
                print(self.viewModel.pulses)
                self.reloadChartData(value: self.viewModel.pulses)
                self.chartView.isHidden = false
                self.guideLabel.isHidden = true
                viewModel.togglePlay()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func startButtonTapped() {
        viewModel.togglePlay()
    }
    
    // MARK: - Frames Capture Methods
    func initVideoCapture() {
        CameraManager.shared.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.viewModel.handleImage(with: imageBuffer, fps: Int(CameraManager.shared.spec?.fps ?? 30))
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
    
    func reloadChartData(value: [Double]) {
        let yValues = (0..<value.count).map { (i) -> ChartDataEntry in
            let val = value[i]
            return ChartDataEntry(x: Double(i), y: val)
        }
        let dataSet = LineChartDataSet(entries: yValues, label: "Graph value")
        dataSet.axisDependency = .left
        dataSet.setColor(UIColor.white)
        dataSet.lineWidth = 2
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawFilledEnabled = false
        dataSet.drawValuesEnabled = false
        let data: LineChartData = LineChartData.init(dataSets: [dataSet])
        chartView.data = data
        chartView.notifyDataSetChanged()
    }
    
    @objc private func menuButtonTapped() {
        if viewModel.isPlaying.value == true {
            viewModel.togglePlay()
        }
    }
    
    // UIPicker Delegate & Datasource
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return viewModel.breathPermins.count
        } else {
            return viewModel.mins.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            return attributedStringPickerView(string: "\(viewModel.breathPermins[row]) breaths/min")
        } else {
            return attributedStringPickerView(string: "\(viewModel.mins[row]) min")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            viewModel.selectedBreathPerminIndex = row
        } else {
            viewModel.selectedMinIndex = row
        }
    }
    
    private func attributedStringPickerView(string: String) -> NSAttributedString {
        NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold),
        ])
    }
}



