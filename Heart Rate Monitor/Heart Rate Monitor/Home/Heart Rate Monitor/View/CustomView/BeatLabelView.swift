//
//  BeatView.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 19/05/2021.
//

import UIKit

class BeatLabelView: ViewWithXib {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
