//
//  ConstraintsHelper.swift
//  mastodon
//
//  Created by Saynt on 26/3/21.
//  Copyright © 2021 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class ConstraintsHelper {
    static func constraintsWithIdentifier(identifier: String, withVisualFormat format: String, options opts: NSLayoutConstraint.FormatOptions = [], metrics: [String : Any]?, views: [String : Any]) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: opts, metrics: metrics, views: views)
        for constraint in constraints {
            constraint.identifier = identifier
        }
        return constraints
    }
}
