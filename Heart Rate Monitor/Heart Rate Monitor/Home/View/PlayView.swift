//
//  PlayView.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import UIKit
import RxSwift
import RxCocoa

class PlayView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
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
    
    private lazy var cameraView: RoundedView = {
        let view = RoundedView()
        view.backgroundColor = .red
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: PlayViewVM? {
        didSet {
            bindViews()
        }
    }
    
    private func setupView() {
        addSubview(backgroundImage)
        addSubview(playIconImageView)
        addSubview(cameraView)
        addSubview(heartRateTrackLabel)
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            playIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            playIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            playIconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            playIconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            
            cameraView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cameraView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cameraView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            cameraView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            heartRateTrackLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            heartRateTrackLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func bindViews() {
        _ = viewModel?.isPlaying.subscribe(onNext: {[weak self] (value) in
            guard let self = self else { return }
            self.cameraView.isHidden = !value
            self.heartRateTrackLabel.isHidden = !value
            self.playIconImageView.isHidden = value
            UIView.animate(withDuration: 0.4) {
                self.cameraView.alpha = !value ? 0.0 : 1.0
                self.heartRateTrackLabel.alpha = !value ? 0.0 : 1.0
                self.playIconImageView.alpha = value ? 0.0 : 1.0
            }

        })
        
        viewModel?.heartRateTrackNumber
            .map {
                if $0 == 0 {
                    return "--\nbpm"
                } else {
                    return "\($0)\nbpm"
                }
            }
            .bind(to: heartRateTrackLabel.rx.text)
            .disposed(by: disposeBag)
        
        rx.controlEvent(.touchUpInside)
            .bind {[weak self] in
                self?.viewModel?.togglePlay()
            }
            .disposed(by: disposeBag)
    }
}
