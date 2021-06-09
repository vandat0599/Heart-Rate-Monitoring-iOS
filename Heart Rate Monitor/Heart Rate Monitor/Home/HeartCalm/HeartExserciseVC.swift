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
    
    private lazy var resultHeartRateLabel: UILabel = {
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

    private lazy var playView: UIView = {
        let view = UIView()
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
        view.font = .systemFont(ofSize: 18, weight: .medium)
        view.textAlignment = .center
        view.isHidden = true
        view.numberOfLines = 0
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
        view.highlightPerTapEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var welldoneLabel: UILabel = {
        let view = UILabel()
        view.text = "Well Done!"
        view.font = .systemFont(ofSize: 24, weight: .medium)
        view.textColor = .white
        view.textAlignment = .center
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var infoButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage(named: "ic-info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        view.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: -12)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let openCount = (UserDefaultHelper.get(key: .openCalmCount) as? Int) ?? 0
        if openCount == 0 {
            let vc = CalmInfoVC()
            present(vc, animated: true)
        }
        UserDefaultHelper.save(value: openCount + 1, key: .openCalmCount)
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        view.backgroundColor = UIColor(named: "black-background")!
        view.addSubview(playView)
        view.addSubview(exTypePickerView)
        view.addSubview(startButton)
        playView.addSubview(heartImageView)
        playView.addSubview(heartRateTrackLabel)
        playView.addSubview(resultHeartRateLabel)
        view.addSubview(guideLabel)
        view.addSubview(welldoneLabel)
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
            
            resultHeartRateLabel.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            resultHeartRateLabel.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
            
            exTypePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exTypePickerView.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 0),
            exTypePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exTypePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exTypePickerView.bottomAnchor.constraint(equalTo: startButton.topAnchor),
            
            welldoneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welldoneLabel.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 20),
            
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartView.topAnchor.constraint(equalTo: welldoneLabel.bottomAnchor, constant: 20),
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
                CameraManager.shared.toggleTorch(status: value)
                self.heartRateTrackLabel.isHidden = !value
                self.guideLabel.isHidden = !value
                self.chartView.isHidden = true
                self.welldoneLabel.isHidden = true
                self.startButton.setTitle(value ? "STOP" : "START", for: .normal)
                self.exTypePickerView.isHidden = value
                self.guideLabel.text = "Please place your finger on camera"
                self.resultHeartRateLabel.isHidden = true
                UIView.animate(withDuration: 0.2) {
                    self.playView.transform = .identity
                    self.guideLabel.alpha = 1
                }
                UIApplication.shared.isIdleTimerDisabled = value
            })
            .disposed(by: disposeBag)
        
        viewModel?.heartRateTrackNumber
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: { [weak self] (value) in
                guard let self = self else { return }
                self.heartRateTrackLabel.text = "\(value == 0 ? "" : "\(value)")"
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
            .bind(onNext: {[unowned self] (value, rate) in
                guard value else { return }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.reloadChartData(value: self.viewModel.pulses)
                self.chartView.isHidden = false
                self.welldoneLabel.isHidden = false
                self.guideLabel.isHidden = true
                viewModel.resetAllData()
                CameraManager.shared.toggleTorch(status: false)
                self.startButton.setTitle("START", for: .normal)
                self.resultHeartRateLabel.isHidden = false
                self.resultHeartRateLabel.text = "\(rate)"
                UIView.animate(withDuration: 0.2) {
                    self.playView.transform = .identity
                    self.guideLabel.alpha = 1
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.breathinTrigger
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[weak self] (value) in
                guard let self = self else { return }
                self.guideLabel.text = "Breath in..."
                UIView.animate(withDuration: value) {
                    self.playView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    self.guideLabel.alpha = 1
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.breathoutTrigger
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[weak self] (value) in
                guard let self = self else { return }
                self.guideLabel.text = "Breath out..."
                UIView.animate(withDuration: value) {
                    self.playView.transform = .identity
                    self.guideLabel.alpha = 0.3
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.resetDataTrigger
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .bind(onNext: {[weak self] (value) in
                guard let self = self else { return }
                if value == true {
                    self.guideLabel.text = "Please place your finger on camera"
                    print("resetDataTrigger")
                    UIView.animate(withDuration: 0.2) {
                        self.playView.transform = .identity
                        self.guideLabel.alpha = 1
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func settingDidChange(notification: Notification?) {
        super.settingDidChange(notification: notification)
        viewModel.shouldSaveHeartWaves = UserDefaults.standard.bool(forKey: "heartwaves_preference")
    }
    
    override func resetSettings() {
        super.resetSettings()
        viewModel.shouldSaveHeartWaves = UserDefaults.standard.bool(forKey: "heartwaves_preference")
    }
    
    @objc private func infoButtonTapped() {
        let vc = CalmInfoVC()
        present(vc, animated: true)
    }
    
    @objc private func startButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        viewModel.resetAllData()
        if startButton.titleLabel?.text == "STOP" {
            viewModel.isPlaying.accept(false)
        } else {
            viewModel.isPlaying.accept(true)
        }
    }
    
    // MARK: - Frames Capture Methods
    func initVideoCapture() {
        CameraManager.shared.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.viewModel.handleImage(with: imageBuffer, fps: Int(CameraManager.shared.spec?.fps ?? 30))
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
        viewModel.breathPerMaxSecond = viewModel.mins[viewModel.selectedMinIndex]*60/viewModel.breathPermins[viewModel.selectedBreathPerminIndex]
        print(viewModel.breathPerMaxSecond)
    }
    
    private func attributedStringPickerView(string: String) -> NSAttributedString {
        NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold),
        ])
    }
}



