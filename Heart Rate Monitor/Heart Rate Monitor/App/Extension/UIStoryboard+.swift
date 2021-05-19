//
//  UIStoryboard+.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 18/05/2021.
//

import UIKit

extension UIStoryboard {
    
    static var home: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
    
    func viewController<T: UIViewController>(_ viewControllerType: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: viewControllerType.className) as! T
    }
}
