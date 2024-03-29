//
//  PulseDetector.swift
//  ffttest
//
//  Created by AlexisPQA on 16/04/2021.
//  Copyright © 2021 Christopher Helf. All rights reserved.
//

import Foundation
import AVFoundation

class HeartRateDetector: NSObject {

    static let Windows_Seconds = 10
    static var beepSoundEffect: AVAudioPlayer?
    
    static func Multiplication (_ a : [Double], _ b : [Double]) -> [Double] {
        var result = [Double]()
        
        for i in 0..<a.count {
            result.append(a[i]*b[i])
        }
        
        return result
    }
    
    static func findPeakElement(_ freqs: [Double], _ threshold: Double) -> ([Double],[Int]){
        var ascending = false
        var peaks = [Double]()
        var index = [Int]()
        var flag = [Bool]()
        var downofPeak = [Int]()
        
        flag.append(ascending)
        if var last = freqs.first {
            freqs.dropFirst().enumerated().forEach {
                if last < $0.element {
                    ascending = true
                    flag.append(ascending)
                    if (flag[flag.count - 2] == false){
                        downofPeak.append($0.offset)
                    }
                    if (downofPeak.count == 2){
                        downofPeak.removeFirst()
                    }
                }
                if $0.element < last && ascending  {
                    ascending = false
                    flag.append(ascending)
                    if (index.count == 0){
                        peaks.append(last)
                        var idx = $0.offset - 1
                        if (freqs[idx] == last){
                            while(freqs[idx] == last){
                                if (freqs[idx-1] != last){
                                    index.append((idx+$0.offset)/2)
                                }
                                idx -= 1
                            }
                        }
                        else{
                            index.append($0.offset)
                        }
                        
                    }
                    else{
                        if (Double($0.offset) - Double(index[index.count - 1]) >= threshold ){
                            peaks.append(last)
                            var idx = $0.offset - 1
                            if (freqs[idx] == last){
                                while(freqs[idx] == last){
                                    if (freqs[idx-1] != last){
                                        index.append((idx+$0.offset)/2)
                                    }
                                    idx -= 1
                                }
                            }
                            else{
                                index.append($0.offset)
                            }
                        }
                    }
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
    // sau đó mỗi lần signal có thêm (fps) frame thì lại gọi hàm
    static func PulseDetector(_ signal: [Double], fps: Int, pulse: [Double]) -> (Double,[Double]) {
        if ( signal.count >= 500){
            print("Captured[\(signal.count): \(signal)")
        }
        var tempCount = 0
        var countValue = 0 // đếm giá trị trùng lặp
        var currenValue = signal[0]
        for i in 0..<signal.count{
            if (signal[i] == 255){
                tempCount += 1
            }
            if(currenValue == signal[i]){
                countValue += 1
                if(countValue > 30){
                    return (-1,[-1])
                }
            }
            else{
                currenValue = signal[i]
                countValue = 0
            }
        }
        if(tempCount >= 10){
            return (-1,[-1])
        }
        var heartBeat = 0.0
        let filter = BBFilter()
        let B = [Double](repeating: 1/10, count: 10)
        let signalFiltered = filter.Filter(signal: signal, denC: B, numC: [1])
        let windowArray = Array(signalFiltered[fps*pulse.count..<signalFiltered.count])
        
        if (windowArray.count != Windows_Seconds*fps){
            print("signal truyền vào phải có \(Windows_Seconds*fps) giá trị thay vì \(signal.count)")
            return (-1,[-1])
        }
        
        let threshold = 10.0
        let (peaks,locs) = findPeakElement(windowArray, threshold)
        var peakCount = Double(peaks.count)
        var grapValue = [Double]()
        if (signal.count == fps*Windows_Seconds){
            grapValue = signalFiltered
            grapValue.removeFirst(30)
        }else{
            grapValue = windowArray
        }
        
        print("peakCount before: \(peakCount)")
        // cablirate
        if locs.isEmpty || (peakCount - 1 == 0) || (Int(peakCount)-1 >= locs.count) {
            return (-1,grapValue)
        }
        let timeP2P :Double = Double(locs[Int(peakCount)-1] - locs[0]) / Double((peakCount - 1))
        let Ex :Double = Double(Windows_Seconds * fps) - (Double(peakCount) * timeP2P)
        if (Ex >= timeP2P) {
            peakCount += 1
        }
        if (Ex >= timeP2P/2) {
            let temp = (timeP2P - Ex) * 60.0/Double((Windows_Seconds * fps))
            peakCount = peakCount - temp
        }
        print("peakCount after: \(peakCount)")
        heartBeat = Double(peakCount) * 60.0 / Double(Windows_Seconds)
        
        
        return (heartBeat,grapValue)
    }
    
    static func playMedicalAudio() {
        guard UserDefaults.standard.bool(forKey: "sound_preference") == true else { return }
        DispatchQueue.global().async {
            guard let beepPath = Bundle.main.path(forResource: "medical.wav", ofType: nil) else { return }
            let beepURL = URL(fileURLWithPath: beepPath)
            do {
                beepSoundEffect = try AVAudioPlayer(contentsOf: beepURL)
                beepSoundEffect?.play()
            } catch {
                return
            }
        }
    }
    
    static func isValidRGB(r: Double, g: Double, b: Double) -> Bool {
        let hsv = rgb2hsv(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b))
        return (hsv.1 > 0.5) && (hsv.2 > 0.1)
    }
}
