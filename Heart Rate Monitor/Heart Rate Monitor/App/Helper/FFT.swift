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
    
    
}
