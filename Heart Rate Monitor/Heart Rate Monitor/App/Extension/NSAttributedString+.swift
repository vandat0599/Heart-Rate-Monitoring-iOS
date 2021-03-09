//
//  NSAttributedString.swift
//  Spotlight-Core
//
//  Created by Duy Nguyen on 11/9/20.
//  Copyright © 2020 Eliot Han. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func height(withWidth width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
}
