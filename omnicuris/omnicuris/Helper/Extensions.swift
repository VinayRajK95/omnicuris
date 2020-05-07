//
//  Extensions.swift
//  omnicuris
//
//  Created by Vinay Raj K on 06/05/20.
//  Copyright © 2020 Vinay Raj K. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    public static func createConstraint(format: String, subViewDict: [String: AnyObject]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: subViewDict)
    }
    
}
