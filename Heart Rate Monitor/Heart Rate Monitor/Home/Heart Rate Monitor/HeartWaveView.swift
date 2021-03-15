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
    
    func addSingleECG(path: UIBezierPath, checkPoint: inout CGPoint) {
        let epsilon = CGFloat.random(in: -12...12)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 40, y: 0)
        path.addQuadCurve(to: checkPoint, controlPoint: checkPoint + CGPoint(x: -20, y: -38 + epsilon/2))
        checkPoint = checkPoint + CGPoint(x: 10, y: 0)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 10, y: 22)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 10, y: -22 - 140 - 6 * epsilon)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 10, y: +22 + 140 + 50 + 10 * epsilon)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 10, y: -22 - 50 - 4 * epsilon)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 30, y: 0)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 60, y: 0)
        path.addQuadCurve(to: checkPoint, controlPoint: checkPoint + CGPoint(x: -30, y: -50 - 2 * epsilon))
        checkPoint = checkPoint + CGPoint(x: 30, y: 0)
        path.addLine(to: checkPoint)
    }
    
    func ECGDraw(color: UIColor? = .red) {
        ECGShape.removeFromSuperlayer()
        removeShape.removeFromSuperlayer()
        ECGShape.removeAllAnimations()
        removeShape.removeAllAnimations()
        let x = CGFloat(0)
        let y = center.y
        let startingPoint = CGPoint(x: x, y: y)
        let endPoint = CGPoint(x: x + bounds.width, y: y)
        
        let path = UIBezierPath()
        path.move(to: startingPoint)
        var checkPoint = startingPoint+CGPoint(x: 0, y: 0)
        addSingleECG(path: path, checkPoint: &checkPoint, scale: 1)
        addSingleECG(path: path, checkPoint: &checkPoint, scale: 1)
        addSingleECG(path: path, checkPoint: &checkPoint, scale: 1)
        addSingleECG(path: path, checkPoint: &checkPoint, scale: 1)
        path.addLine(to: endPoint)
        ECGShape.path = path.cgPath
        removeShape.path = path.cgPath
        layer.addSublayer(ECGShape)
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = 0
        startAnimation.toValue = 1
        startAnimation.duration = 1
        startAnimation.fillMode = .backwards
        ECGShape.add(startAnimation, forKey: "Draw")
        
        
        let pathRemove = UIBezierPath()
        pathRemove.move(to: startingPoint)
        var checkPoint2 = startingPoint+CGPoint(x: 0, y: 0)
        addSingleECG(path: pathRemove, checkPoint: &checkPoint2, scale: 1)
        addSingleECG(path: pathRemove, checkPoint: &checkPoint2, scale: 1)
        addSingleECG(path: pathRemove, checkPoint: &checkPoint2, scale: 1)
        addSingleECG(path: pathRemove, checkPoint: &checkPoint2, scale: 1)
        pathRemove.addLine(to: endPoint)
        removeShape.path = pathRemove.cgPath
        layer.addSublayer(removeShape)
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = 0
        endAnimation.toValue = 1.0
        endAnimation.duration = 1
        endAnimation.fillMode = .backwards
        endAnimation.beginTime = CACurrentMediaTime() + 0.1
        removeShape.add(endAnimation, forKey: "Remove")
    }
    
    func addSingleECG(path: UIBezierPath, checkPoint: inout CGPoint, scale: Float) {
        let smallSquareWidth = frame.width/20/5
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 4*smallSquareWidth, y: 0)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: -2*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: 2*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: 0)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: smallSquareWidth, y: 2*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: smallSquareWidth, y: -3*5*smallSquareWidth - 2*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: smallSquareWidth, y: 3*5*smallSquareWidth + 8*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: smallSquareWidth, y: -8*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 4*smallSquareWidth, y: 0)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 4*smallSquareWidth, y: -6*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: 6*smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: -smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: smallSquareWidth)
        path.addLine(to: checkPoint)
    }
}
