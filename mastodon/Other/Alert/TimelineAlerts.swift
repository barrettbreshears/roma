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
        let error:MessageView = try! SwiftMessages.viewFromNib()
        error.configureTheme(.error)
        error.iconLabel?.isHidden = true
        error.button?.isHidden = true
        error.configureContent(title: "Error", body: errorMsg ?? "Unable to fetch statuses at this time")
        var config = SwiftMessages.defaultConfig
        if let presentationController = controller {
            config.presentationContext = .viewController(presentationController)
        } else {
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        }
        
        SwiftMessages.show(config:config, view: error)
    }
    
    static func showUpToDate(controller:UIViewController? = nil){
        let info:MessageView = try! SwiftMessages.viewFromNib()
        info.configureTheme(.info)
        info.iconImageView?.isHidden = true
        info.titleLabel?.isHidden = true
        info.button?.isHidden = true
        info.iconLabel?.isHidden = true
        info.configureContent(title: "Time", body: "Everything is up to date!")
        var config = SwiftMessages.defaultConfig
        if let presentationController = controller {
            config.presentationContext = .viewController(presentationController)
        } else {
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        }
        
        SwiftMessages.show(config:config, view: info)
    }
}
