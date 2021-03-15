//
//  HeartWaveView.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/14/21.
//

import UIKit

class HeartWaveView: UIView {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    let ECGShape = CAShapeLayer()
    var removeShape = CAShapeLayer()
    var currentPath: UIBezierPath!
    var newPath: UIBezierPath!
    
    private func setupView() {
        ECGShape.strokeColor = UIColor.red.cgColor
        ECGShape.fillColor = UIColor.clear.cgColor
        ECGShape.lineWidth = 2
        ECGShape.lineJoin = .round
        ECGShape.lineCap = .round
        removeShape.strokeColor = UIColor.red.cgColor
        removeShape.fillColor = UIColor.clear.cgColor
        removeShape.lineWidth = 2
        removeShape.lineJoin = .round
        removeShape.lineCap = .round
    }
    
    func ECGDraw(color: UIColor? = .red, heartRateNumber: Int) {
        // ref: https://www.youtube.com/watch?v=S3jtQehfZsw
        guard heartRateNumber > 0 else { return }
        let numberOfSmallSquarePerEdge: CGFloat = 1500/CGFloat(heartRateNumber)
        let numberOfECGEdge = frame.width/numberOfSmallSquarePerEdge/4
        let widthScale: CGFloat = numberOfSmallSquarePerEdge*4/5/5
        ECGShape.removeFromSuperlayer()
        removeShape.removeFromSuperlayer()
        ECGShape.removeAllAnimations()
        removeShape.removeAllAnimations()
        let x = CGFloat(0)
        let y = center.y
        let startingPoint = CGPoint(x: x, y: y)
        let endPoint = CGPoint(x: x + bounds.width, y: y)
        
        // current path
        if newPath != nil {
            let startAnimation = CABasicAnimation(keyPath: "strokeStart")
            startAnimation.fromValue = 0
            startAnimation.toValue = 1
            startAnimation.duration = 1
            startAnimation.fillMode = .backwards
            ECGShape.path = newPath.cgPath
            layer.addSublayer(ECGShape)
            ECGShape.add(startAnimation, forKey: "Draw")
        }
        
        // new path
        newPath = UIBezierPath()
        newPath.move(to: startingPoint)
        var checkPoint2 = startingPoint + CGPoint(x: 0, y: 0)
        if numberOfECGEdge > 0 {
            for _ in 0..<Int(numberOfECGEdge) {
                addSingleECG(path: newPath, checkPoint: &checkPoint2, scale: widthScale)
            }
        }
        newPath.addLine(to: endPoint)
        removeShape.path = newPath.cgPath
        layer.addSublayer(removeShape)
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = 0
        endAnimation.toValue = 1
        endAnimation.duration = 1
        endAnimation.fillMode = .backwards
        endAnimation.beginTime = CACurrentMediaTime() + 0.05
        removeShape.add(endAnimation, forKey: "Remove")
    }
    
    func addSingleECG(path: UIBezierPath, checkPoint: inout CGPoint, scale: CGFloat = 1.0) {
        let smallSquareWidth = scale
        let smallSquareHeight = (frame.width/20/5)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 4*smallSquareWidth, y: 0)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 1*smallSquareWidth, y: -2*smallSquareHeight)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: 2*smallSquareHeight)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: 0)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: smallSquareWidth, y: 2*smallSquareHeight)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: smallSquareWidth, y: -3*5*smallSquareHeight - 2*smallSquareHeight)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: smallSquareWidth, y: 3*5*smallSquareHeight + 8*smallSquareHeight)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: smallSquareWidth, y: -8*smallSquareHeight)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 4*smallSquareWidth, y: 0)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: -6*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: 6*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: -smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: smallSquareWidth)
        path.addLine(to: checkPoint)
    }
}
