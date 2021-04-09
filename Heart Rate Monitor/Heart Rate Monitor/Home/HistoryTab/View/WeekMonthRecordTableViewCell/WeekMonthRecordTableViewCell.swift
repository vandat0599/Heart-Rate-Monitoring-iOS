//
//  WeekMonthRecordTableViewCell.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 09/04/2021.
//

import UIKit

class WeekMonthRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var normalHeartRateLabel: UILabel!
    @IBOutlet weak var activeHeartRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(date: Date, dateFormatter: DateFormatter, normalHeartRate: Int, activeHeartRate: Int) {
        if dateFormatter.dateFormat == "MMM yyyy" {
            timeLabel.text = "setup dates four times in a month"
        } else {
            timeLabel.text = "setup dates seven times in a week"
        }
        normalHeartRateLabel.text = "\(normalHeartRate)"
        activeHeartRateLabel.text = "\(activeHeartRate)"
        setSelected(false, animated: false)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
