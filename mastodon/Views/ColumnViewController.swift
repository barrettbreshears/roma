//
//  ColumnViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 07/06/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class ColumnViewController: UIViewController {
    
    var viewControllers: [UIViewController] = [] {
        didSet {
            for viewController in viewControllers {
                self.addChild(viewController)
                self.view.addSubview(viewController.view)
                viewController.didMove(toParent: self)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let firstViewWidth: CGFloat = 80
        let width: CGFloat = (self.view.bounds.width - firstViewWidth)/3
        var widthOffset: CGFloat = 0
        var count = 0
        for viewController in viewControllers {
            if count == 0 {
                viewController.view.frame = CGRect(x: 0, y: 0, width: firstViewWidth, height: self.view.bounds.height)
                count += 1
            } else {
                viewController.view.frame = CGRect(x: firstViewWidth + widthOffset + 0.6, y: 0, width: width, height: self.view.bounds.height)
                widthOffset += width + 0.6
                count += 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
    }
}
