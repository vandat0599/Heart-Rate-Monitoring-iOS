//
//  UITableView+.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerWithClassName(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    func registerClassWithClassName(cellType: UITableViewCell.Type) {
        let className = cellType.className
        register(cellType, forCellReuseIdentifier: className)
    }
    
    func registerWithClassName(reusableViewType: UITableViewHeaderFooterView.Type,
                  bundle: Bundle? = nil) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func registerClassWithClassName(reusableViewType: UITableViewHeaderFooterView.Type) {
        let className = reusableViewType.className
        register(reusableViewType, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func dequeueReusableCellWithClassName<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
    func dequeueReusableViewWithClassName<T: UITableViewHeaderFooterView>(with type: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: type.className) as! T
    }
    
    func hasRowAt(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
}
