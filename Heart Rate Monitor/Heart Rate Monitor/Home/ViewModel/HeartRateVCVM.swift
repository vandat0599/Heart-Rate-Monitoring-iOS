//
//  HeartRateVCVM.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 3/13/21.
//

import Foundation

protocol HeartRateVCVM {
    var playViewVM: PlayViewVM { get }
}

class HeartRateVCVMImp: HeartRateVCVM {
    
    init() {
        playViewVM = PlayViewVMImp()
    }
    
    var playViewVM: PlayViewVM
}
