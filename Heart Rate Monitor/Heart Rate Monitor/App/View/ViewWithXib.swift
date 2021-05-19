//
//  ViewWithNib.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 19/05/2021.
//

import UIKit

class ViewWithXib: UIView {
    
    // NOTE: - Set file owner first

    func initUI() {}
    
    private func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        initUI()
    }
    
    private func loadViewFromNib() -> UIView {
        let thisName = String(describing: type(of: self))
        let view = Bundle(for: self.classForCoder).loadNibNamed(thisName, owner: self, options: nil)?.first as! UIView
        return view
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

}
