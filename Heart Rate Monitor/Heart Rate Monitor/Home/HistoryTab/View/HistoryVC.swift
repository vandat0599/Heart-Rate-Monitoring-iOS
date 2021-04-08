//
//  HistoryVC.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 07/04/2021.
//

import Charts
import UIKit

class HistoryVC: BaseVC {

    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateTextView: UITextView!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var historyTableView: UITableView!
    
    var listOfRecord = [HeartRateRecord(value: 88, state: .normal, note: "Cooking"),
                        HeartRateRecord(value: 75, state: .normal, note: "Watching movie"),
                        HeartRateRecord(value: 132, state: .active, note: "Running for 44 minutes")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        historyTableView.dataSource = self
        historyTableView.register(RecordTableViewCell.nib, forCellReuseIdentifier: RecordTableViewCell.identifier)
        
        barChartView.backgroundColor = UIColor(named: "backgroundGray")
        barChartView.layer.cornerRadius = 13
        barChartView.clipsToBounds = true
        barChartUpdate()
        
//        timeSegmentedControl.setBackgroundImage(<#T##backgroundImage: UIImage?##UIImage?#>, for: .selected, barMetrics: .default)
        
        
    }
    
    func barChartUpdate() {
        let entry1 = BarChartDataEntry(x: 1.0, y: Double(listOfRecord[0].value!))
        let entry2 = BarChartDataEntry(x: 2.0, y: Double(listOfRecord[1].value!))
        let entry3 = BarChartDataEntry(x: 3.0, y: Double(listOfRecord[2].value!))
        let dataSet = BarChartDataSet(entries: [entry1, entry2, entry3], label: "Widgets Type")
        dataSet.colors = [UIColor(named: "purple")!]
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data

        //All other additions to this function will go here

        //This must stay at end of function
        barChartView.notifyDataSetChanged()
    }

}


extension HistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
        cell.bindData(record: listOfRecord[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
