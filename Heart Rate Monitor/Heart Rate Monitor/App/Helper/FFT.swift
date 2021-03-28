//
//  FFT.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/21/21.
//

import Foundation
import Accelerate

class FFT {
    
    static func sqrt(_ x: [Double]) -> [Double] {
        var results = [Double](repeating: 0.0, count: x.count)
        vvsqrt(&results, x, [Int32(x.count)])
        return results
    }
    
    static func fft(input: [Double]) -> [Double] {
        guard input.count > 0 else { return [] }
        var real = [Double](input)
        var imaginary = [Double](repeating: 0, count: input.count)
        var splitComplex = DSPDoubleSplitComplex(realp: &real, imagp: &imaginary)
        
        let length = vDSP_Length(floor(log2(Float(input.count))))
        let radix = FFTRadix(kFFTRadix2)
        guard let weights = vDSP_create_fftsetupD(length, radix) else { return [] }
        vDSP_fft_zipD(weights, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
        
        var magnitudes = [Double](repeating: 0, count: input.count)
        vDSP_zvmagsD(&splitComplex, 1, &magnitudes, 1, vDSP_Length(input.count))
        
        var normalizedMagnitudes = [Double](repeating: 0, count: input.count)
        vDSP_vsmulD(FFT.sqrt(magnitudes), 1, [2.0 / Double(input.count)], &normalizedMagnitudes, 1, vDSP_Length(input.count))
        
        vDSP_destroy_fftsetupD(weights)
        
        return normalizedMagnitudes
    }
    
    func fftAnalyzer(frameOfSamples: [Float]) -> [Float] {
        // As above, frameOfSamples = [1.0, 2.0, 3.0, 4.0]
        let frameCount = frameOfSamples.count
        let reals = UnsafeMutableBufferPointer<Float>.allocate(capacity: frameCount)
        defer {reals.deallocate()}
        let imags =  UnsafeMutableBufferPointer<Float>.allocate(capacity: frameCount)
        defer {imags.deallocate()}
        _ = reals.initialize(from: frameOfSamples)
        imags.initialize(repeating: 0.0)
        var complexBuffer = DSPSplitComplex(realp: reals.baseAddress!, imagp: imags.baseAddress!)
        let log2Size = Int(log2(Float(frameCount)))
        guard let fftSetup = vDSP_create_fftsetup(vDSP_Length(log2Size), FFTRadix(kFFTRadix2)) else {
            return []
        }
        defer {vDSP_destroy_fftsetup(fftSetup)}
        // Perform a forward FFT
        vDSP_fft_zip(fftSetup, &complexBuffer, 1, vDSP_Length(log2Size), FFTDirection(FFT_FORWARD))
        let realFloats = Array(reals)
        let imaginaryFloats = Array(imags)
        print(realFloats)
        print(imaginaryFloats)
        return realFloats
    }
    
}
