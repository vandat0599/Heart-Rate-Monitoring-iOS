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
    
    // truyền vào func mỗi khi đạt đủ 180 frames (tương đương với 6s)
    // sau đó mỗi lần signal có thêm 15 frame thì lại gọi hàm
    static func PulseDetector(_ signal: [Double],fps: Int) ->Int {
        if (signal.count != 180){
            print("signal truyền vào phải có 180 giá trị thay vì \(signal.count)")
            return -1
        }
        var heartBeat = 0
        
        let filter = BBFilter()
        
        let (denC, numC) = filter.butter(order: 2, lowFreq: 2/45, highFreq: 23/90)
        var y = filter.Filter(signal: signal, denC: denC, numC: numC)
        y = Multiplication(y, hann(Windows_Seconds*fps + 1))
        
        let gain = filter.DFT(signal: y)
        let index_range = Array(5...25)
        //trueGain : nơi thực sự có tần số chứa giá trị nhịp tim
        let trueGain = gain.enumerated().filter() {
            $0.offset >= 5 && $0.offset <= 25
        }.map(){
            $0.element
        }
        
        let (peaks,indexs) = findPeakElement(trueGain)
        let maxPeak = peaks.max()!
        let indexOfMaxPeak = peaks.firstIndex(of: maxPeak)!
        let maxFreqIndx = index_range[indexs[indexOfMaxPeak]]
        let temp  = Double(maxFreqIndx) * Double(fps) / Double(Windows_Seconds * fps + 1)
        let bpm = Double(temp*60)
        heartBeat = SmoothingPeak(y: y, bpm, fps)
        
        return heartBeat
    }

}
