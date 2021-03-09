//
//  UICollectionView+.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func register(cellType: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }

    func registerClass(cellType: UICollectionViewCell.Type) {
        let className = cellType.className
        register(cellType, forCellWithReuseIdentifier: className)
    }
    
    func register(reusableViewType: UICollectionReusableView.Type,
                  ofKind kind: String = UICollectionView.elementKindSectionHeader,
                  bundle: Bundle? = nil) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }

    func registerClass(reusableViewType: UICollectionReusableView.Type,
                       ofKind kind: String = UICollectionView.elementKindSectionHeader) {
        let className = reusableViewType.className
        register(reusableViewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                      for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type,
                                                          for indexPath: IndexPath,
                                                          ofKind kind: String = UICollectionView.elementKindSectionHeader) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    // use this method at the first load to fadein the collection view, its will make the ui smoother
    func reloadData(completion: @escaping () -> ()) {
        self.alpha = 0.0
        UIView.animate(withDuration: 0, animations: {[weak self] in
            guard let self = self else { return }
            self.reloadData()
        }) {[weak self] (_) in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.5, animations: {[weak self] in
                guard let self = self else { return }
                self.alpha = 1.0
            }) { (_) in
                completion()
            }
        }
    }
    
    var currentIndexPath: IndexPath? {
        get {
            let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            return indexPathForItem(at: visiblePoint)
        }
    }
}
