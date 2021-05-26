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

    static func PulseDetector(_ signal: [Double],fps: Int,pulseCount : Int) -> (Double,[Double]) {
        var heartBeat = 0.0
        let filter = BBFilter()
        let B = [Double](repeating: 1/20, count: 20)
        var newSignal = [Double]()  // dùng cho vẽ đồ thị
        
        let signalFiltered = filter.Filter(signal: signal, denC: B, numC: [1])
        let windowArray = Array(signalFiltered[fps*pulseCount..<signalFiltered.count])
        
        if (windowArray.count != Windows_Seconds*fps){
            print("signal truyền vào phải có \(Windows_Seconds*fps) giá trị thay vì \(signal.count)")
            return (-1,[0])
        }
       
        let (peaks,locs) = findPeakElement(windowArray)
        var N = peaks.count
        
        // cablirate
        if locs.isEmpty || (N - 1 == 0) || (N-1 >= locs.count) {
            return (-1,[0])
        }
        let timeP2P = (locs[N-1] - locs[0]) / (N - 1)
        let Ex = Windows_Seconds * fps - N * timeP2P
        if (Ex >= timeP2P) {
            N += 1
        }
        if (Ex > timeP2P/2) {
            N = N - (timeP2P - Ex) * 60/(Windows_Seconds * fps)
        }
        heartBeat = Double(N) * 60.0 / Double(Windows_Seconds)
        
        if (signal.count == Windows_Seconds * fps){
            newSignal = signal
        }
        else{
            newSignal = Array(signal[(signalFiltered.count - fps - 1)..<signalFiltered.count])
        }
        return (heartBeat,newSignal)
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
}
