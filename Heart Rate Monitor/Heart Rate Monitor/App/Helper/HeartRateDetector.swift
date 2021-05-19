//
//  PulseDetector.swift
//  ffttest
//
//  Created by AlexisPQA on 16/04/2021.
//  Copyright © 2021 Christopher Helf. All rights reserved.
//

import Foundation

class HeartRateDetector: NSObject {

    static let Windows_Seconds = 6
    
    static func Multiplication (_ a : [Double], _ b : [Double]) -> [Double] {
        var result = [Double]()
        
        for i in 0..<a.count {
            result.append(a[i]*b[i])
        }
        
        return result
    }
    
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
                    var idx = $0.offset - 1
                    while(freqs[idx] == last){
                        if (freqs[idx-1] != last){
                            peaks.append(freqs[idx])
                            index.append(idx)
                        }
                        idx -= 1
                    }
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
    // Làm mượt đỉnh
    static func SmoothingPeak (y:[Double],_ bpm: Double, _ fps: Int) -> Double {
        let freq_resolution = 1.0/Double(Windows_Seconds)
        let lowfreq = bpm / 60 - 0.5 * freq_resolution
        let freq_incre = 1.0/60.0
        var freqs = [Double]()
        for i in 0..<10 {
            freqs.append(Double(i)*freq_incre + lowfreq)
        }
        
        var power = [Double]()
        for i in 0..<10 {
            var real = 0.0
            var ima = 0.0
            for j in 0..<(Windows_Seconds*fps) {
                let phi = 2 * Double.pi * freqs[i] * (Double(j)/Double(fps))
                real += y[j] * cos(phi)
                ima += y[j] * sin(phi)
            }
            power.append(Double(real*real + ima*ima))
        }
        
        let maxPeak = power.max()!
        let indexOfMax = power.firstIndex(of: maxPeak)
        
        let bpm_Smoothing = 60 * freqs[indexOfMax!]
        
        return bpm_Smoothing
        
    }
    // truyền vào func mỗi khi đạt đủ 180 frames (tương đương với 6s)
    // sau đó mỗi lần signal có thêm 15 frame thì lại gọi hàm
    static func PulseDetector(_ signal: [Double],fps: Int) -> Double {
        if (signal.count != Windows_Seconds*fps){
            print("signal truyền vào phải có \(Windows_Seconds*fps) giá trị thay vì \(signal.count)")
            return -1
        }
        var heartBeat = 0.0
        
        let filter = BBFilter()
        
        //let (denC, numC) = filter.butter(order: 2, lowFreq: 2/45, highFreq: 23/90)
        let B = [Double](repeating: 1/20, count: 20)
        let y = filter.Filter(signal: signal, denC: B, numC: [1]) // 0 -> 255
        let (peaks,locs) = findPeakElement(y)
        var N = peaks.count
        
        // cablirate
        let timeP2P = (locs[N-1] - locs[0]) / (N - 1)
        let Ex = Windows_Seconds * fps - N * timeP2P
        if (Ex >= timeP2P) {
            N += 1
        }
        if (Ex > timeP2P/2) {
            N = N - (timeP2P - Ex) * 60/(Windows_Seconds * fps)
        }
        heartBeat = Double(N) * 60.0 / Double(Windows_Seconds)
        return heartBeat
    }
}
