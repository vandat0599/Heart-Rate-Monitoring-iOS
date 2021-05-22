
import Foundation

private let numberOfZeros: Int = 10
private let numberOfPoles: Int = 10
private let gain: Double = 1.894427025e+01
typealias ComplexDouble = Complex<Double>
/*
 For more information head over to http://www-users.cs.york.ac.uk/~fisher/mkfilter/
 */

class BBFilter: NSObject {
    var xv = [Double](repeating: 0.0, count: numberOfZeros + 1)
    var yv = [Double](repeating: 0.0, count: numberOfPoles + 1)
    
    func DFT(signal : [Double]) -> [Double]{
        var result = [Double]()
        let n = signal.count
        for k in 0..<n {
            var sum = Complex(0, 0)
            for i in 0..<n {
                sum = sum + Complex.exp(Complex(0, -2 * Double.pi*(Double(i)*Double(k)/Double(n))))*signal[i]
            }
            result.append(sum.abs)
        }
        return result
    }
    
    func ComputeLP(order: Int) -> [Double]{
        var numCoeff = [Double](repeating: 0.0, count: order + 1)
        numCoeff[0] = 1
        numCoeff[1] = Double(order)
        let n = order/2
        if (n>=2){
            for i in 2...n {
                let value = Double((order - i + 1)) * numCoeff[i-1]/Double(i)
                numCoeff[i] = value
                numCoeff[order - i] = numCoeff[i]
            }
            
        }
        numCoeff[order - 1] = Double(order)
        numCoeff[order] = 1
        return numCoeff
    }
    
    func computeHP(order : Int) -> [Double]{
            var numCoeff = [Double]()
            
            numCoeff = ComputeLP(order: order)
            for i in 0...order {
                if (i % 2 != 0) {
                    numCoeff[i] = numCoeff[i] * -1
                }
            }
            return numCoeff
        }
    
    func Multiply(order: Int, firstCoeff : [Double], secondCoeff: [Double])-> [Double]{
            var result = [Double](repeating: 0.0, count: 4 * order)
            result[0] = firstCoeff[0]
            result[1] = firstCoeff[1]
            result[2] = secondCoeff[0]
            result[3] = secondCoeff[1]
            
            for i in 1..<order {
                result[2 * (2 * i + 1)] += secondCoeff[2 * i] * result[2 * (2 * i - 1)] - secondCoeff[2 * i + 1] * result[2 * (2 * i - 1) + 1]
                result[2 * (2 * i + 1) + 1] += secondCoeff[2 * i] * result[2 * (2 * i - 1) + 1] + secondCoeff[2 * i + 1] * result[2 * (2 * i - 1)]
                
                for j in (2...2*i).reversed() {
                    result[2*j] += firstCoeff[2*i] * result[2*(j - 1)] - firstCoeff[2*i+1] * result[2*(j-1)+1] + secondCoeff[2*i] * result[2*(j-2)] - secondCoeff[2*i+1] * result[2*(j-2)+1]
                    result[2*j+1] += firstCoeff[2*i] * result[2*(j - 1)+1] + firstCoeff[2*i+1] * result[2*(j-1)] + secondCoeff[2*i] * result[2*(j-2)+1] + secondCoeff[2*i+1] * result[2*(j-2)]
                }
                
                result[2] += firstCoeff[2*i] * result[0] - firstCoeff[2*i+1]*result[1] + secondCoeff[2*i]
                result[3] += firstCoeff[2*i] * result[1] + firstCoeff[2*i+1]*result[0] + secondCoeff[2*i+1]
                result[0] += firstCoeff[2*i]
                result[1] += firstCoeff[2*i+1]
                
            }
            
            return result
        }
    
    func ComputeDenCCoeff (order: Int, lowFreq:Double, highFreq: Double)->[Double]{
            
            var result = [Double]()
            let cp : Double = cos(Double.pi * (highFreq + lowFreq)/2.0)
            let theta : Double = Double.pi * (highFreq - lowFreq)/2.0
            let st : Double = sin(theta)
            let ct : Double = cos(theta)
            let s2t : Double = 2.0*st*ct
            let c2t : Double = 2*ct*ct - 1.0
            var rCoeff = [Double](repeating: 0.0, count: 2*order)
            var tCoeff = [Double](repeating: 0.0, count: 2*order)
            
            for i in 0..<order {
                let  poleAngle : Double = Double.pi * Double((2*i+1))/Double(2*order)
                let sinPoleAngle : Double = sin(poleAngle)
                let cosPoleAngle : Double = cos(poleAngle)
                let a : Double = 1.0 + s2t*sinPoleAngle
                rCoeff[2*i] = c2t/a
                rCoeff[2*i+1] = s2t*cosPoleAngle/a
                tCoeff[2*i] = -2.0*cp*(ct+st*sinPoleAngle)/a
                tCoeff[2*i+1] = -2.0*cp*st*cosPoleAngle/a
                
            }
            
            result = Multiply(order: order, firstCoeff: tCoeff, secondCoeff: rCoeff)
            result[1] = result[0]
            result[0] = 1.0
            
            for i in 3...2*order {
                result[i] = result[2*i-2]
            }
            
            return result
    }
    func ComputeNumCoeff(order: Int, lowFreq: Double, highFreq: Double, DenC: [Double])->[Double]{
            var numCoeff = [Double](repeating: 0.0, count: 2 * order + 1)
        
            var numbers = [Int]()
            let length = order * 2 + 1
            for i in 0..<length {
                numbers.append(i)
            }
            
            let TCoeffs = computeHP(order: order)
            for i in 0..<order{
                numCoeff[2*i] = TCoeffs[i]
                numCoeff[2*i+1] = 0.0
            }
            
            numCoeff[2*order] = TCoeffs[order]
            var cp = [Double]()
            cp.append(2*2.0*tan(Double.pi * lowFreq/2.0))
            cp.append(2*2.0*tan(Double.pi * highFreq/2.0))
            
            let temp = sqrt(cp[0]*cp[1])
            let centerFreq = 2 * atan2(temp, 4)
            
            let result = ComplexDouble(-1, 0)
            var normalizedKernel = [ComplexDouble](repeating: ComplexDouble(0, 0), count: length)
            for i in 0..<length {
                normalizedKernel[i] = Complex.exp(-1 * Complex.sqrt(result)*centerFreq*Double(numbers[i]))
            }
            
            var b: Double = 0
            var den: Double = 0
            
            for i in 0..<length {
                b += (normalizedKernel[i] * numCoeff[i]).real
                den += (normalizedKernel[i]*DenC[i]).real;
            }
            for i in 0..<length {
                numCoeff[i] = (numCoeff[i]*den)/b
            }
            
            return numCoeff
    }
    
    func butter(order: Int, lowFreq: Double, highFreq: Double)-> ([Double],[Double]){
        let denC = ComputeDenCCoeff(order: order, lowFreq: lowFreq, highFreq: highFreq)
        let numC = ComputeNumCoeff(order: order, lowFreq: lowFreq, highFreq: highFreq, DenC: denC)
        return (denC , numC)
    }
    
    func Filter (signal: [Double], denC: [Double], numC: [Double] )-> [Double]{
        let length = signal.count
        var result = [Double](repeating: 0.0, count: signal.count)
        if (numC[0] == 1) {
            let N = denC.count
            for i in 0..<length {
                var temp = 0.0
                for j in 0..<N{
                    if (i-j >= 0){
                        temp += signal[i-j]
                    }
                    
                }
                temp = temp / Double(N)
                result[i] = temp
            }
            return result
        }
        
        result[0] = numC[0] * signal[0]
        
        for i in 1..<length {
            for j in 0..<numC.count {
                if (i-j >= 0){
                    result[i] += numC[j]*signal[i-j]
                }
                
                
            }
            for j in 0..<denC.count{
                if(i-j-1 >= 0){
                    if (j+1 < numC.count){
                        result[i] += -denC[j+1]*result[i-j-1]
                    }
                }
            }
        }
        
        return result
    }
    
}
