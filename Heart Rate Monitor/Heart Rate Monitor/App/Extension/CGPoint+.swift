//
//  CGPoint+.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/14/21.
//

import UIKit

extension CGPoint {
    static func + (p1: CGPoint, p2: CGPoint) -> CGPoint {
        let p = CGPoint(x: p1.x + p2.x, y: p1.y + p2.y)
        return p
    }
}
