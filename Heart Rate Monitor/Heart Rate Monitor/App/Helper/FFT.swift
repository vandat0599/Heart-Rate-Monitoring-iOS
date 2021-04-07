//
//  FFT.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/21/21.
//

import Foundation
import Accelerate

class FFT {
    static func fftAnalyzer(frameOfSamples: [Double]) -> [Double] {
        let frameCount = frameOfSamples.count
        let reals = UnsafeMutableBufferPointer<Double>.allocate(capacity: frameCount)
        defer {reals.deallocate()}
        let imags =  UnsafeMutableBufferPointer<Double>.allocate(capacity: frameCount)
        defer {imags.deallocate()}
        _ = reals.initialize(from: frameOfSamples)
        imags.initialize(repeating: 0.0)
        var complexBuffer = DSPDoubleSplitComplex(realp: reals.baseAddress!, imagp: imags.baseAddress!)
        let log2Size = Int(log2(Double(frameCount)))
        guard let fftSetup = vDSP_create_fftsetup(vDSP_Length(log2Size), FFTRadix(kFFTRadix2)) else {
            return []
        }
        defer {vDSP_destroy_fftsetup(fftSetup)}
        // Perform a forward FFT
        vDSP_fft_zipD(fftSetup, &complexBuffer, 1, vDSP_Length(log2Size), FFTDirection(FFT_FORWARD))
        let realDoubles = Array(reals)
        let imaginaryDoubles = Array(imags)
        return Range(0...realDoubles.count-1).map { Double(sqrt(pow(realDoubles[$0], 2) + pow(imaginaryDoubles[$0], 2))) }
    }
}
