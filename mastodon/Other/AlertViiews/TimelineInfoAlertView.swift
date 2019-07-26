//
//  InfoAlertView.swift
//  mastodon
//
//  Created by Barrett Breshears on 7/22/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit
import SwiftMessages

class TimelineInfoAlertView: MessageView {
    
    class func instanceFromNib() -> TimelineInfoAlertView {
        return UINib(nibName: "TimelineInfoAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TimelineInfoAlertView
    }
    
}
