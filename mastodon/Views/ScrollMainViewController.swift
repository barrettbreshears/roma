//
//  ScrollMainViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 13/06/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class ScrollMainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var scrollView = UIScrollView()
    var viewControllers: [UIViewController] = [] {
        didSet {
            for viewController in viewControllers {
                self.addChild(viewController)
                let vcv = viewController.view
                vcv!.layer.cornerRadius = 20
                vcv!.layer.masksToBounds = true
                self.scrollView.addSubview(vcv!)
                viewController.didMove(toParent: self)
            }
        }
    }
    
    @objc func leftAr() {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func rightAr() {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentSize.width - self.scrollView.bounds.size.width, y: 0), animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.leftAr), name: NSNotification.Name(rawValue: "leftAr"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.rightAr), name: NSNotification.Name(rawValue: "rightAr"), object: nil)
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1
        self.scrollView.isScrollEnabled = true
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.view = (self.scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width: CGFloat = 380
        
        self.scrollView.contentSize = CGSize(width: (CGFloat(width * CGFloat(viewControllers.count))) + (CGFloat(25 * CGFloat(viewControllers.count))), height: CGFloat(self.view.bounds.height))
        
        var idx: Int = 0
        var widthOffset: CGFloat = 0
        for viewController in viewControllers {
            self.scrollView.touchesShouldCancel(in: viewController.view)
            viewController.view.frame = CGRect(x: widthOffset, y: 25, width: width, height: self.view.bounds.height - 50)
            widthOffset += viewController.view.frame.size.width + 25
            idx += 1
        }
    }
}
