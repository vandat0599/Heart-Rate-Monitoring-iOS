//
//  RelationshipTableViewCell.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 01/04/2021.
//

import UIKit

class RelationshipTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
    
    func bindData(name: String) {
        nameLabel.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
