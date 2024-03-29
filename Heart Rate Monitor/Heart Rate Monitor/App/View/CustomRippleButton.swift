//
//  CustomRippleButton.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 14/04/2021.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class CustomRippleButton: UIButton {
    
    @IBInspectable open var ripplePercent: Float = 0.8 {
        didSet {
            setupRippleView()
        }
    }
    
    @IBInspectable open var rippleColor: UIColor = UIColor(white: 0.2, alpha: 0.2) {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }
    
    @IBInspectable open var rippleBackgroundColor: UIColor = .clear {
        didSet {
            rippleBackgroundView.backgroundColor = rippleBackgroundColor
        }
    }
    
    @IBInspectable open var buttonCornerRadius: Float = 0 {
        didSet{
            layer.cornerRadius = CGFloat(buttonCornerRadius)
        }
    }
    
    @IBInspectable open var buttonScaleOnAnimate: CGFloat = 0.95
    
    @IBInspectable open var rippleAnimationDuration: TimeInterval = 0.4
    
    @IBInspectable open var rippleOverBounds: Bool = false
    @IBInspectable open var shadowRippleRadius: Float = 0
    @IBInspectable open var shadowRippleEnable: Bool = false
    @IBInspectable open var trackTouchLocation: Bool = false
    
    let rippleView = UIView()
    let rippleBackgroundView = UIView()
    
    fileprivate var tempShadowRadius: CGFloat = 0
    fileprivate var tempShadowOpacity: Float = 0
    fileprivate var touchCenterLocation: CGPoint?
    
    fileprivate var rippleMask: CAShapeLayer? {
        get {
            if !rippleOverBounds {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds,
                    cornerRadius: layer.cornerRadius).cgPath
                return maskLayer
            } else {
                return nil
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup() {
        setupRippleView()
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.addSubview(rippleView)
        rippleBackgroundView.alpha = 0
        addSubview(rippleBackgroundView)
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
    }
    
    fileprivate func setupRippleView() {
        let size: CGFloat = bounds.width * CGFloat(ripplePercent)
        let x: CGFloat = (bounds.width/2) - (size/2)
        let y: CGFloat = (bounds.height/2) - (size/2)
        let corner: CGFloat = size/2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRect(x: x, y: y, width: size, height: size)
        rippleView.layer.cornerRadius = corner
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if trackTouchLocation {
            touchCenterLocation = touch.location(in: self)
        } else {
            touchCenterLocation = nil
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
            }, completion: nil)
        
        rippleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        
        UIView.animate(withDuration: rippleAnimationDuration, delay: 0, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.allowUserInteraction],
            animations: {
                self.transform = CGAffineTransform(scaleX: self.buttonScaleOnAnimate, y: self.buttonScaleOnAnimate)
                self.rippleView.transform = CGAffineTransform.identity
            }, completion: nil)
        
        if shadowRippleEnable {
            tempShadowRadius = layer.shadowRadius
            tempShadowOpacity = layer.shadowOpacity
            
            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnim.toValue = shadowRippleRadius
            
            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnim.toValue = 1
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = rippleAnimationDuration
            groupAnim.fillMode = CAMediaTimingFillMode.forwards
            groupAnim.isRemovedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            layer.add(groupAnim, forKey:"shadow")
        }
        return super.beginTracking(touch, with: event)
    }
    
    override open func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        animateToNormal()
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        animateToNormal()
    }
    
    fileprivate func animateToNormal() {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
            }, completion: {(success: Bool) -> () in
                UIView.animate(withDuration: self.rippleAnimationDuration, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.transform = .identity
                    self.rippleBackgroundView.alpha = 0
                    }, completion: nil)
        })
        
        
        UIView.animate(withDuration: rippleAnimationDuration + 0.5, delay: 0,
            options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
            animations: {
                self.rippleView.transform = CGAffineTransform.identity
                
                let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
                shadowAnim.toValue = self.tempShadowRadius
                
                let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
                opacityAnim.toValue = self.tempShadowOpacity
                
                let groupAnim = CAAnimationGroup()
                groupAnim.duration = self.rippleAnimationDuration
                groupAnim.fillMode = CAMediaTimingFillMode.forwards
                groupAnim.isRemovedOnCompletion = false
                groupAnim.animations = [shadowAnim, opacityAnim]
                
                self.layer.add(groupAnim, forKey:"shadowBack")
            }, completion: nil)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        setupRippleView()
        if let knownTouchCenterLocation = touchCenterLocation {
            rippleView.center = knownTouchCenterLocation
        }
        
        rippleBackgroundView.layer.frame = bounds
        rippleBackgroundView.layer.mask = rippleMask
    }
}
