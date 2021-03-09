//
//  Double+.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 2/25/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation

extension Double {
    var toTimeString: String {
        let seconds: Int = Int(self.truncatingRemainder(dividingBy: 60.0))
        let minutes: Int = Int(self / 60.0)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
