//
//  StatsVM.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 20/05/2021.
//

import UIKit
import Charts

protocol StatsVMEvents: AnyObject {
    func loadedData()
    func loadedLabels()
    func updateMinMaxAvg(min: Int, max: Int, avg: Int, minDate: String, maxDate: String)
    func updateChartView(data: BarChartData, xAxisData: [String])
}

class StatsVM {
    weak var delegate: StatsVMEvents?
    
    var labelsList = [String]()
    var historyList = [HeartRateHistory]()
    
    init(delegate: StatsVMEvents) {
        self.delegate = delegate
    }
    
    func loadAllLabel() {
        historyList = LocalDatabaseHandler.shared.getAllHistory().filter{ ($0.isRemoved ?? false) == false }
        labelsList = Array(Set(historyList.map { $0.label ?? "" }))
        labelsList.insert("ALL LABELS", at: 0)
        
//        labelsList = LocalDatabaseHandler.shared.getAllLabels()
        delegate?.loadedLabels()
    }
    
    func reloadChart(byLabel label: String, byMonth: Bool) {
        // This'll reload by week if isMonth = false
        print("CHART RELOAD: LABEL: \(label) _ DURATION: \(byMonth ? "MONTH" : "WEEK")")
        
        
        // Get list of history by filters
        historyList = LocalDatabaseHandler.shared.searchHistoryByLabel(label: label)
//        filtedHistoryList = filtedHistoryList.map { $0.createDate }
//        print(filtedHistoryList)
//        timeLabel.text = Date().fromTimeMilli(timeMilli: model.createDate ?? "").dateAndTimetoString()
        var startDate = Date()
        var endDate = Date()
        
        if byMonth {
            startDate = startDate.startOfMonth()
            endDate = endDate.endOfMonth()
        } else { // filter by week
            while startDate.getHumanReadableDayString() != "Sunday" { startDate = startDate.previousDate() }
            while endDate.getHumanReadableDayString() != "Saturday" { endDate = endDate.nextDate() }
        }
        
        // Filter histories in time required
        historyList = historyList.filter { (Date().fromTimeMilli(timeMilli: $0.createDate ?? "0") >= startDate) && (Date().fromTimeMilli(timeMilli: $0.createDate ?? "0") <= endDate)}
        
        reloadChartData(startDate: startDate, endDate: endDate)
        reloadMinMaxAvgHeartRate()
    }
    
    func reloadChartData(startDate: Date, endDate: Date) {
        var date = startDate
        var recordList = [Int]() // BPM
        var amountList = [Int]() // How many histories a day
        var dateList = [String]() // The String of day
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = .current
        
        while date <= endDate {
            recordList.append(0)
            amountList.append(0)
            dateList.append(formatter.string(from: date))
            print(dateList[dateList.count - 1])
            date = date.nextDate()
        }
        
        for history in historyList {
            var i = 0
            while formatter.string(from: Date().fromTimeMilli(timeMilli: history.createDate ?? "")) != dateList[i] {
                i += 1
            }
            recordList[i] += history.heartRateNumber ?? 0
            amountList[i] += 1
        }
        
        
        var entriesList = [BarChartDataEntry]()
        
        for i in 0..<recordList.count {
            recordList[i] = amountList[i] > 0 ? recordList[i] / amountList[i] : 0
            entriesList.append(BarChartDataEntry(x: Double(i + 1), y: Double(recordList[i])))
        }
        
        let dataSet = BarChartDataSet(entries: entriesList)
        dataSet.colors = [UIColor(named: "pink") ??  .white]
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = recordList.count < 8 ? 0.4 : 0.3
        data.setDrawValues(false)
        for i in 0..<dateList.count {
            dateList[i] = "\(dateList[i].dropLast(5))"
        }
        dateList.insert("", at: 0)

        delegate?.updateChartView(data: data, xAxisData: dateList)
    }
    
    func reloadMinMaxAvgHeartRate() {
        if historyList.isEmpty { return }
        
        var min = 300
        var max = -1
        var sum = 0
        var minDate = ""
        var maxDate = ""
        
        for record in historyList {
            let heartRate = record.heartRateNumber ?? 0
            sum += heartRate
            if (heartRate < min) {
                min = heartRate
                minDate = record.createDate ?? ""
            }
            if (heartRate > max){
                max = heartRate
                maxDate = record.createDate ?? ""
            }
        }
        
        delegate?.updateMinMaxAvg(  min: min,
                                    max: max,
                                    avg: sum / historyList.count,
                                    minDate: Date().fromTimeMilli(timeMilli: minDate).dateAndTimetoString(),
                                    maxDate: Date().fromTimeMilli(timeMilli: maxDate).dateAndTimetoString())
    }
}
