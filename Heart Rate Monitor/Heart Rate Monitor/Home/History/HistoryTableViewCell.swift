//
//  HistoryTableViewCell.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 20/05/2021.
//

import UIKit
import Charts

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var heartRateNumberLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var submitView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        // line chart view
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = true
        chartView.autoScaleMinMaxEnabled = true
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.enabled = false
        chartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.highlightPerTapEnabled = false
        chartView.noDataText = ""
    }
    
    func setData(model: HeartRateHistory) {
        heartRateNumberLabel.text = (model.heartRateNumber ?? 0) == 0 ? "--" : "\(model.heartRateNumber ?? 0)"
        noteLabel.text = model.label
        timeLabel.text = Date().fromTimeMilli(timeMilli: model.createDate ?? "").dateAndTimetoString()
        setupChartData(values: model.grapValues)
        submitView.backgroundColor = UIColor(named: (model.isSubmitted ?? false) ? "success" : "red-1")!
    }
    
    private func setupChartData(values: [Double]) {
        let yValues = (0..<values.count).map { (i) -> ChartDataEntry in
            let val = values[i]
            return ChartDataEntry(x: Double(i), y: val)
        }
        let dataSet = LineChartDataSet(entries: yValues, label: "Graph value")
        dataSet.axisDependency = .left
        dataSet.setColor(UIColor(named: "white-holder")!)
        dataSet.lineWidth = 1
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.fillColor = UIColor(named: "pink")!
        dataSet.fillAlpha = 1.0
        dataSet.drawFilledEnabled = false
        let data: LineChartData = LineChartData.init(dataSets: [dataSet])
        chartView.data = data
        chartView.notifyDataSetChanged()
    }
    
}
