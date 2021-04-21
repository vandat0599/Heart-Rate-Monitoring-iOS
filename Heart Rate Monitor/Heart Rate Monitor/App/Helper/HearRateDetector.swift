//
//  PulseDetector.swift
//  ffttest
//
//  Created by AlexisPQA on 16/04/2021.
//  Copyright © 2021 Christopher Helf. All rights reserved.
//

import Foundation
let Windows_Seconds = 6
class HeartRateDetector: NSObject {
    
    static func findPeakElement(_ freqs: [Double]) -> ([Double],[Int]){
        var ascending = false
        var peaks: [Double] = []
        var index = [Int]()
        if var last = freqs.first {
            freqs.dropFirst().enumerated().forEach {
                if last < $0.element {
                    ascending = true
                }
                if $0.element < last && ascending  {
                    ascending = false
                    peaks.append(last)
                    index.append($0.offset)
                }
                last = $0.element
            }
        }
        return (peaks,index)
    }
    
    // remove high freq, bring edges to zero
    static func hann(_ windowsLength: Int ) -> [Double] {
        var result = [Double]()
        
        for i in 0..<windowsLength {
            result.append((0.5 * (1 -  cos(2 * Double.pi * Double(i) / Double(windowsLength - 1)))))
        }
        
        return result
    }

}
