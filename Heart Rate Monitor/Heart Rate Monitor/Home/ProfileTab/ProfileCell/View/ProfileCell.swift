//
//  ProfileCell.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 21/03/2021.
//

import UIKit

class ProfileCell: UIView {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    let nibName = "ProfileCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
