//
//  String+.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
