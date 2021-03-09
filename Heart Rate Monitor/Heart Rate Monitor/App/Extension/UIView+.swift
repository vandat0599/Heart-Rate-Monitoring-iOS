//
//  UIView.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var crTopLeft: Bool {
        get {
            self.layer.maskedCorners.contains(.layerMinXMinYCorner)
        }
        set {
            if newValue {
                self.layer.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                self.layer.maskedCorners.remove(.layerMinXMinYCorner)
            }
        }
    }
    
    var crTopRight: Bool {
        get {
            self.layer.maskedCorners.contains(.layerMaxXMinYCorner)
        }
        set {
            if newValue {
                self.layer.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                self.layer.maskedCorners.remove(.layerMaxXMinYCorner)
            }
        }
    }
    
    var crBottomLeft: Bool {
        get {
            self.layer.maskedCorners.contains(.layerMinXMaxYCorner)
        }
        set {
            if newValue {
                self.layer.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                self.layer.maskedCorners.remove(.layerMinXMaxYCorner)
            }
        }
    }
    
    var crBottomRight: Bool {
        get {
            self.layer.maskedCorners.contains(.layerMaxXMaxYCorner)
        }
        set {
            if newValue {
                self.layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                self.layer.maskedCorners.remove(.layerMaxXMaxYCorner)
            }
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    var shadowColor: UIColor?{
        
        get{
            if let color = layer.shadowColor{
                return UIColor(cgColor: color)
            }
            return nil
        }
        set{
            if let color = newValue{
                layer.shadowColor = color.cgColor
            }else{
                layer.shadowColor = nil
            }
        }
    }
    
    var shadowOffset: CGSize{
        get{
            return layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
        }
    }
    
    var shadowOpacity: Float{
        get{
            return layer.shadowOpacity
        }
        set{
            layer.shadowOpacity = newValue
            clipsToBounds = false
            layer.masksToBounds = false
        }
    }
    
    var shadowRadius: CGFloat{
        get{
            return layer.shadowRadius
        }
        set{
            layer.shadowRadius = newValue
        }
    }
    
    func performSpringAnimation(duration: Double, maxScale: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.init(scaleX: maxScale, y: maxScale)
            //reducing the size
            UIView.animate(withDuration: duration, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { (flag) in
            }
        }) { (flag) in
            
        }
    }
    
    func fitIn(parentView: UIView, padding: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: padding)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: -padding)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: padding)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: -padding)
        parentView.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
}


