//
//  TimelineAlerts.swift
//  mastodon
//
//  Created by Barrett Breshears on 7/19/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import SwiftMessages

class NavAlerts {
    static func showError(errorMsg:String? = nil, controller:UIViewController? = nil){
        let error:ErrorAlertView = ErrorAlertView.instanceFromNib()
        error.bodyLabel?.text = "Unable to fetch new data."
        var config = SwiftMessages.defaultConfig
        if let presentationController = controller {
            config.presentationContext = .viewController(presentationController)
        } else {
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        }
        
        SwiftMessages.show(config:config, view: error)
    }
    
    static func showUpToDate(controller:UIViewController? = nil){
        let info:TimelineInfoAlertView = TimelineInfoAlertView.instanceFromNib()
        info.bodyLabel?.text = "Everything is up to date!"
        var config = SwiftMessages.defaultConfig
        if let presentationController = controller {
            config.presentationContext = .viewController(presentationController)
        } else {
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        }
        
        SwiftMessages.show(config:config, view: info)
    }
}
