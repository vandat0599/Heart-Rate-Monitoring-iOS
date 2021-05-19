//
//  CMSampleBuffer+.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 28/04/2021.
//

import UIKit
import AVFoundation

extension CMSampleBuffer {
    var meanRGB: (meanRed: CGFloat, meanGreen: CGFloat, meanBlue: CGFloat) {
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(self)
        let inputImage = CIImage(cvPixelBuffer: pixelBuffer!)
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return (0, 0, 0) }
        guard let outputImage = filter.outputImage else { return (0, 0, 0) }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return (CGFloat(bitmap[0]), CGFloat(bitmap[1]), CGFloat(bitmap[2]))
    }
}
