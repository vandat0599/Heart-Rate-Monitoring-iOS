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
    
    private func setupView() {
        ECGShape.fillColor = UIColor.clear.cgColor
        layer.addSublayer(ECGShape)
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
    
    func ECGDraw() {
        let x = CGFloat(0)
        let y = center.y
        let startingPoint = CGPoint(x: x, y: y)
        let endPoint = CGPoint(x: x + bounds.width, y: y)
        let path = UIBezierPath()
        path.move(to: startingPoint)
        
        // Logic of Drawing
        var checkPoint = startingPoint + CGPoint(x: 20, y: 0)
        
        addSingleECG(path: path, checkPoint: &checkPoint, scale: 1)
        addSingleECG(path: path, checkPoint: &checkPoint, scale: 1)
        addSingleECG(path: path, checkPoint: &checkPoint, scale: 1)
        addSingleECG(path: path, checkPoint: &checkPoint, scale: 1)
        path.addLine(to: endPoint)
        
        ECGShape.strokeColor = UIColor.red.cgColor
        ECGShape.path = path.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        ECGShape.add(animation, forKey: "line")
    }
    
    func addSingleECG(path: UIBezierPath, checkPoint: inout CGPoint, scale: Float) {
        let smallSquareWidth = frame.width/20/5
        path.addLine(to: checkPoint) // 0 0
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
        checkPoint = checkPoint + CGPoint(x: 3*smallSquareWidth, y: -smallSquareWidth)
        path.addLine(to: checkPoint)
        checkPoint = checkPoint + CGPoint(x: 2*smallSquareWidth, y: smallSquareWidth)
        path.addLine(to: checkPoint)
    }
    
    
}
