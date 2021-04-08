//
//  RecordTableViewCell.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 08/04/2021.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var heartBeatLabel: UILabel!
    
    var record: HeartRateRecord?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(record: HeartRateRecord) {
        self.record = record
        stateImageView.image = record.state.rawValue == "active" ? UIImage(named: "ic-active") : UIImage(named: "ic-normal")
        timeLabel.text = record.note
        heartBeatLabel.text = "\(record.value ?? 0)"
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
