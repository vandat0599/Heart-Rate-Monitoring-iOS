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
    
    var breathPermins = [7, 6, 5]
    var mins = [1, 2, 3, 4, 5]
    
    
    
    private var cameraManager: CameraManager?
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
            
            startButton.topAnchor.constraint(equalTo: exTypePickerView.bottomAnchor, constant: 0),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 44),
            startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
        view.layoutIfNeeded()
        startButton.cornerRadius = startButton.frame.height/2
        view.layoutIfNeeded()
        bindViews()
    }
    
    private func bindViews() {
        
    }
    
    @objc private func startButtonTapped() {
        
    }
    
    // MARK: - Frames Capture Methods
    private func initVideoCapture() {
        let specs = VideoSpec(fps: 30, size: CGSize.zero)
        cameraManager = CameraManager(cameraType: .back, preferredSpec: specs, previewContainer: nil, completion: {[weak self] in
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
    
    // UIPicker Delegate & Datasource
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return breathPermins.count
        } else {
            return mins.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            return attributedStringPickerView(string: "\(breathPermins[row]) breaths/min")
        } else {
            return attributedStringPickerView(string: "\(mins[row]) min")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected row: \(row)")
    }
    
    private func attributedStringPickerView(string: String) -> NSAttributedString {
        NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold),
        ])
    }
}



