//
//  Filter.swift
//  Pulse
//
//  Created by Athanasios Papazoglou on 18/7/20.
//  Copyright © 2020 Athanasios Papazoglou. All rights reserved.
//

//  Original credits go to Gurpreet Singh.
//  He created Filter.h & Filter.m on 31/10/2013.
//  Copyright (c) 2015 Pubnub. All rights reserved.
//

import Foundation

private let numberOfZeros: Int = 10
private let numberOfPoles: Int = 10
private let gain: Double = 1.894427025e+01
typealias ComplexDouble = Complex<Double>
/*
 For more information head over to http://www-users.cs.york.ac.uk/~fisher/mkfilter/
 */

class Filter: NSObject {
    var xv = [Double](repeating: 0.0, count: numberOfZeros + 1)
    var yv = [Double](repeating: 0.0, count: numberOfPoles + 1)

    
    
    func FFT(signal: Array<ComplexDouble>)-> Array<ComplexDouble>{
        let n = signal.count
        if n == 1{
            return signal
        }
        
        var even = [ComplexDouble]()
        var odd = even
        for i in 0...n/2{
            even[i] = signal[i*2]
            odd[i] = signal[i*2 + 1]
        }
        let evenFFT = FFT(signal: even)
        let oddFFT = FFT(signal: odd)
        
        var result = [ComplexDouble]()
        for i in 0...n{
            let alpha = -2 * Double(i) * Double.pi / Double(n)
            let wk = Complex(real: cos(alpha), imag: sin(alpha))
            result[i] = evenFFT[i] + wk * oddFFT[i]
            result[i+n/2] = evenFFT[i] - wk * oddFFT[i]
        }
        
        return result
    }
    
    
    func processValue(value: Double) -> Double {
        xv[0] = xv[1]
        xv[1] = xv[2]
        xv[2] = xv[3]
        xv[3] = xv[4]
        xv[4] = xv[5]
        xv[5] = xv[6]
        xv[6] = xv[7]
        xv[7] = xv[8]
        xv[8] = xv[9]
        xv[9] = xv[10]
        xv[10] = value/gain
        
        yv[0] = yv[1]
        yv[1] = yv[2]
        yv[2] = yv[3]
        yv[3] = yv[4]
        yv[4] = yv[5]
        yv[5] = yv[6]
        yv[6] = yv[7]
        yv[7] = yv[8]
        yv[8] = yv[9]
        yv[9] = yv[10]

        yv[10] = (xv[10] - xv[0]) + 5 * (xv[2] - xv[8]) + 10 * (xv[6] - xv[4]) + (-0.0000000000 * yv[0]) + (0.0357796363 * yv[1]) + (-0.1476158522 * yv[2]) + (0.3992561394 * yv[3]) + (-1.1743136181 * yv[4]) + (2.4692165842 * yv[5]) + (-3.3820859632 * yv[6]) + (3.9628972812 * yv[7]) + (-4.3832594900 * yv[8]) + (3.2101976096 * yv[9])

        return yv[10]
    }
}
