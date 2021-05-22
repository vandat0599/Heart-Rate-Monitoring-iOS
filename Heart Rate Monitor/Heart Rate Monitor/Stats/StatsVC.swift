//
//  StatsViewController.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 20/05/2021.
//

import UIKit
import Charts

class StatsVC: BaseVC {

    // MARK: - Outlets
    @IBOutlet weak var labelButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var labelPickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minDateLabel: UILabel!
    @IBOutlet weak var maxDateLabel: UILabel!
    
    // MARK: - Properties
    lazy var viewModel = StatsVM(delegate: self)
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Set up
    func setupView() {
        
        viewModel.loadAllLabel()
        viewModel.reloadChart(byLabel: labelButton.titleLabel?.text ?? "ALL LABELS", byMonth: monthButton.isSelected)
        
        labelPickerView.isHidden = true
        labelPickerView.delegate = self
        labelPickerView.dataSource = self
        labelPickerView.tintColor = .white
        
        toolBar.isHidden = true
        toolBar.layer.cornerRadius = 10
        toolBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        toolBar.layer.masksToBounds = true
        
        weekButton.setTitleColor(UIColor.gray, for: .normal)
        weekButton.setTitleColor(UIColor(named: "pink"), for: .selected)
        weekButton.isSelected = true
        
        monthButton.setTitleColor(UIColor.gray, for: .normal)
        monthButton.setTitleColor(UIColor(named: "pink"), for: .selected)
        monthButton.isSelected = false
        
        chartView.notifyDataSetChanged()
        chartView.delegate = self
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.maxVisibleCount = 60
        chartView.doubleTapToZoomEnabled = false
        chartView.isUserInteractionEnabled = false
        
        chartView.xAxis.enabled = true
        chartView.xAxis.gridColor = .clear
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .white
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.labelCount = 4
        chartView.leftAxis.axisMinimum = 40
        chartView.leftAxis.labelTextColor = .white
        chartView.leftAxis.gridColor = .white
        chartView.leftAxis.gridLineDashLengths = [CGFloat](repeating: 1, count: 40)
        chartView.leftAxis.axisLineColor = .clear
        chartView.legend.enabled = false
    }
    
    // MARK: - Action
    @IBAction func labelButtonTapped(_ sender: Any) {
        labelPickerView.isHidden = false
        toolBar.isHidden = false
    }
    @IBAction func cancelToolbarButtonTapped(_ sender: Any) {
        labelPickerView.isHidden = true
        toolBar.isHidden = true
    }
    
    @IBAction func weekMonthButtonsTapped(_ sender: UIButton) {
        if sender.isSelected { return }
        weekButton.isSelected = !weekButton.isSelected
        monthButton.isSelected = !monthButton.isSelected
        viewModel.reloadChart(byLabel: labelButton.titleLabel?.text ?? "ALL LABELS", byMonth: monthButton.isSelected)
    }
}

extension StatsVC: ChartViewDelegate {
    
}

extension StatsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.labelsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.labelsList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let label = viewModel.labelsList[row]
        labelButton.setTitle(label, for: .normal)
        viewModel.reloadChart(byLabel: label, byMonth: monthButton.isSelected)
    }
    
}

extension StatsVC: StatsVMEvents {
    
    func updateMinMaxAvg(min: Int, max: Int, avg: Int, minDate: String, maxDate: String) {
        minLabel.text = min <= 200 ? "\(min)" : "--"
        maxLabel.text = max > -1 ? "\(max)" : "--"
        avgLabel.text = "\(avg)"
        minDateLabel.text = minDate
        maxDateLabel.text = maxDate
    }
    
    func updateChartView(data: BarChartData, xAxisData: [String]) {
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisData)
        chartView.xAxis.granularity = 1
        
        chartView.data = data
    }
    
    func loadedData() {
    }
    
    func loadedLabels() {
        labelPickerView.reloadAllComponents()
    }
    
}
