//
//  EditHistoryVC.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 20/05/2021.
//

import UIKit
import Charts
import MaterialComponents

class EditHistoryBottoSheetVC: BottomSheetViewController {
    // MARK: - UI components
    
    private lazy var bpmLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.isUserInteractionEnabled = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.text = "BPM"
        view.textColor = UIColor(named: "white-holder")!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var heartRateNumberLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.text = (heartRateHistory.heartRateNumber ?? 0) == 0 ? "--" : "\(heartRateHistory.heartRateNumber ?? 0)"
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView()
        view.isHidden = false
        view.chartDescription?.enabled = false
        view.dragEnabled = false
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = true
        view.autoScaleMinMaxEnabled = true
        view.rightAxis.enabled = false
        view.leftAxis.enabled = false
        view.legend.enabled = false
        view.xAxis.enabled = false
        view.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        view.highlightPerTapEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leftActionButton: UIButton = {
        let view = UIButton()
        view.setTitle("DELETE", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(UIColor(named: "pink"), for: .normal)
        view.clipsToBounds = true
        view.cornerRadius = 22
        view.backgroundColor = .clear
        view.borderColor = UIColor(named: "white-holder")
        view.borderWidth = 1
        view.addTarget(self, action: #selector(leftActionTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightActionButton: UIButton = {
        let view = UIButton()
        view.setTitle("UPDATE", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.white, for: .normal)
        view.clipsToBounds = true
        view.cornerRadius = 22
        view.backgroundColor = UIColor(named: "white-holder")
        view.addTarget(self, action: #selector(rightActionTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelTextField: MDCFilledTextField = {
        let view = MDCFilledTextField()
        view.placeholder = "LABEL"
        view.backgroundColor = .clear
        view.textColor = .white
        view.tintColor = .white
        view.attributedPlaceholder = NSAttributedString(string: "LABEL", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        let aa = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        aa.backgroundColor = .clear
        aa.addSubview(labelImageView)
        labelImageView.center = aa.center
        view.leadingView = aa
        view.leadingViewMode = .always
        view.toolbarPlaceholder = "Label"
        view.setUnderlineColor(.white, for: .normal)
        view.setUnderlineColor(.white, for: .editing)
        view.setFilledBackgroundColor(.clear, for: .normal)
        view.setFilledBackgroundColor(.clear, for: .editing)
        view.setTextColor(.white, for: .normal)
        view.setTextColor(.white, for: .editing)
        view.setFloatingLabelColor(.white, for: .normal)
        view.setFloatingLabelColor(.white, for: .editing)
        view.text = heartRateHistory.label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 18, height: 18)))
        view.image = UIImage(named: "ic-label")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        return view
    }()
    
    // MARK: - data
    private var heartRateHistory: HeartRateHistory
    let leftAction: (() -> Void)?
    let rightAction: ((String) -> Void)?
    
    init(heartRateHistory: HeartRateHistory, leftAction: (() -> Void)? = nil, rightAction: ((String) -> Void)? = nil) {
        self.heartRateHistory = heartRateHistory
        self.leftAction = leftAction
        self.rightAction = rightAction
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    override func layoutViews() {
        super.layoutViews()
        view.backgroundColor = UIColor(named: "black-background")
        contentView.backgroundColor = UIColor(named: "black-background")
        closeButton.isHidden = false
        closeButton.tintColor = .white
        contentView.addSubview(leftActionButton)
        contentView.addSubview(rightActionButton)
        let centerXLine = UIView()
        centerXLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(centerXLine)
        contentView.addSubview(heartRateNumberLabel)
        contentView.addSubview(bpmLabel)
        contentView.addSubview(labelTextField)
        contentView.addSubview(chartView)
        NSLayoutConstraint.activate([
            
            bpmLabel.bottomAnchor.constraint(equalTo: heartRateNumberLabel.topAnchor),
            bpmLabel.leadingAnchor.constraint(equalTo: heartRateNumberLabel.trailingAnchor),

            heartRateNumberLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            heartRateNumberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            chartView.topAnchor.constraint(equalTo: heartRateNumberLabel.bottomAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            
            labelTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            labelTextField.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),

            centerXLine.widthAnchor.constraint(equalToConstant: 0),
            centerXLine.heightAnchor.constraint(equalToConstant: 0),
            centerXLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            leftActionButton.topAnchor.constraint(equalTo: labelTextField.bottomAnchor, constant: 40),
            leftActionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            leftActionButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            leftActionButton.trailingAnchor.constraint(equalTo: centerXLine.leadingAnchor, constant: -10),
            leftActionButton.heightAnchor.constraint(equalToConstant: 44),

            rightActionButton.topAnchor.constraint(equalTo: leftActionButton.topAnchor),
            rightActionButton.leadingAnchor.constraint(equalTo: centerXLine.trailingAnchor, constant: 10),
            rightActionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rightActionButton.bottomAnchor.constraint(equalTo: leftActionButton.bottomAnchor),
        ])
        reloadChartData(value: heartRateHistory.grapValues)
    }
    
    func reloadChartData(value: [Double]) {
        let yValues = (0..<value.count).map { (i) -> ChartDataEntry in
            let val = value[i]
            return ChartDataEntry(x: Double(i), y: val)
        }
        let dataSet = LineChartDataSet(entries: yValues, label: "Graph value")
        dataSet.axisDependency = .left
        dataSet.setColor(UIColor(named: "white-holder")!)
        dataSet.lineWidth = 1
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawFilledEnabled = false
        let data: LineChartData = LineChartData.init(dataSets: [dataSet])
        chartView.data = data
        chartView.notifyDataSetChanged()
    }

    // MARK: - Actions
    
    @objc private func leftActionTapped() {
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            var rate = self.heartRateHistory
            rate.isRemoved = true
            LocalDatabaseHandler.shared.updateHeartRateHistory(heartRateHistory: rate)
            self.leftAction?()
        }
    }
    
    @objc private func rightActionTapped() {
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            self.heartRateHistory.label = self.labelTextField.text
            self.heartRateHistory.isLabelUpdated = true
            LocalDatabaseHandler.shared.updateHeartRateHistory(heartRateHistory: self.heartRateHistory)
            self.rightAction?(self.labelTextField.text ?? "")
        }
    }
}

