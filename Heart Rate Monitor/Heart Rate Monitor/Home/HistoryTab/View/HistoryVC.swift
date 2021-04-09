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
    @IBOutlet weak var historyTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeEditView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var listOfRecord = [HeartRateRecord(value: 88, state: .normal, note: "Cooking"),
                        HeartRateRecord(value: 75, state: .normal, note: "Watching movie"),
                        HeartRateRecord(value: 132, state: .active, note: "Running for 44 minutes")]
    var statePicker = UIPickerView()
    var datePicker = UIDatePicker()
    var date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        historyTableView.dataSource = self
        historyTableView.register(RecordTableViewCell.nib, forCellReuseIdentifier: RecordTableViewCell.identifier)
        historyTableView.separatorColor = view.backgroundColor
        historyTableView.separatorStyle = .singleLine
        historyTableView.allowsSelection = false
        
        heartRateLabel.text = "\(averageHeartRate(forState: .normal))"
        
        stateTextView.delegate = self
        
        statePicker.delegate = self
        statePicker.dataSource = self
        
        barChartView.backgroundColor = UIColor(named: "backgroundGray")
        barChartView.layer.cornerRadius = 13
        barChartView.clipsToBounds = true
        barChartUpdate()
        
        editButton.isHidden = false
        saveButton.isHidden = true
        timeLabel.isHidden = false
        timeEditView.isHidden = true
        
        datePicker.datePickerMode = .date
        datePicker.setDate(date, animated: true)
        datePicker.tintColor = UIColor(named: "purple")
        datePicker.backgroundColor = UIColor(named: "backgroundGray")
        
        dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
        timeLabel.text = dateFormatter.string(from: date)
        
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
    
    func averageHeartRate(forState: HeartRateState) -> Int{
        var sum = 0
        var counter = 0
        for record in listOfRecord {
            if record.state == forState {
                counter += 1
                sum += record.value ?? 0
            }
        }
        return Int(sum/counter)
    }
    
    @IBAction func editButtonTouched(_ sender: Any) {
        editButton.isHidden = true
        saveButton.isHidden = false
        timeLabel.isHidden = true
        timeEditView.isHidden = false
        
        timeEditView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: timeEditView.leadingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: timeEditView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: timeEditView.bottomAnchor).isActive = true
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        editButton.isHidden = false
        saveButton.isHidden = true
        timeLabel.isHidden = false
        timeEditView.isHidden = true
        
        date = datePicker.date
        timeLabel.text = dateFormatter.string(from: date)
    }
}


extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyTableViewHeightConstraint.constant = CGFloat(42 * listOfRecord.count)
        return listOfRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
        cell.bindData(record: listOfRecord[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
}

extension HistoryVC: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.inputView = statePicker
    }
}

extension HistoryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return HeartRateState.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = row == 0 ? "normal" : "active"
        stateTextView.text = "\(state) state"
        heartRateLabel.text = "\(averageHeartRate(forState: HeartRateState(rawValue: state)!))"
    }
}
