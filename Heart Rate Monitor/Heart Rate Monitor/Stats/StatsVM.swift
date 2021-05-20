//
//  StatsVM.swift
//  Heart Rate Monitor
//
//  Created by Thành Nguyên on 20/05/2021.
//

import UIKit

protocol StatsVMEvents: AnyObject {
    func loadedData()
}

class StatsVM {
    weak var delegate: StatsVMEvents?
    
    init(delegate: StatsVMEvents) {
        self.delegate = delegate
    }
}
