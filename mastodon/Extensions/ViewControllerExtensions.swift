//
//  ViewControllerExtensions.swift
//  mastodon
//
//  Created by Barrett Breshears on 8/6/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
}
