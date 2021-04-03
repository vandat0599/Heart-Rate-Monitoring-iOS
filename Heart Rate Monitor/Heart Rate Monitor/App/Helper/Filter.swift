
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
    
    func ComputeLP(order: Int) -> [Double]{
        var numCoeff = [Double](repeating: 0.0, count: order)
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
