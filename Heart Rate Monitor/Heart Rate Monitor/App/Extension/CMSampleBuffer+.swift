//
//  CMSampleBuffer+.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 28/04/2021.
//

import UIKit
import AVFoundation

extension CMSampleBuffer {
    var meanRGB: (meanRed: Double, meanGreen: Double, meanBlue: Double) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(self) else { return (0, 0, 0) }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)

        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)!
        let byteBuffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        var reds: [Int] = []
        var greens: [Int] = []
        var blues: [Int] = []
        for j in 0..<height {
            for i in 0..<width {
                let index = (j * width + i) * 4
                let b = byteBuffer[index] // blue
                let g = byteBuffer[index+1] // green
                let r = byteBuffer[index+2] // red
                reds.append(Int(r))
                greens.append(Int(g))
                blues.append(Int(b))
            }
        }
        let redmean = Double(reds.reduce(0, +))/Double(reds.count)
        let greenmean = Double(greens.reduce(0, +))/Double(greens.count)
        let bluemean = Double(blues.reduce(0, +))/Double(blues.count)
        return (redmean, greenmean, bluemean)
    }
}
