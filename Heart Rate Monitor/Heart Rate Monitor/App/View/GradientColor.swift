//
//  File.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 18/03/2021.
//

import UIKit

class Gradient {
    
    private static func setColors() -> CAGradientLayer {
        let gl = CAGradientLayer()
        gl.colors = [UIColor(named: "pink")!.cgColor, UIColor(named: "purple")!.cgColor]
        gl.locations = [0.0 , 1.0]
        return gl
    }
    
    static func horizontal(_ sender: UIButton) {
        let gradient = setColors()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: sender.frame.size.width, height: sender.frame.size.height)
        sender.bringSubviewToFront(sender.imageView!)
        sender.layer.insertSublayer(gradient, at: 0)
    }
    
    static func vertical(_ sender: UIButton) {
        let gradient = setColors()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: sender.frame.size.width, height: sender.frame.size.height)
        sender.bringSubviewToFront(sender.imageView!)
        sender.layer.insertSublayer(gradient, at: 0)
    }
    
    static func diagonal(_ sender: UIButton) {
        let gradient = setColors()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: sender.frame.size.width, height: sender.frame.size.height)
        sender.bringSubviewToFront(sender.imageView!)
        sender.layer.insertSublayer(gradient, at: 0)
    }
}
