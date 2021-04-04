//
//  ListCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 23/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ListCell: SwipeTableViewCell {
    
    var userName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        userName.adjustsFontForContentSizeCategory = true
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.numberOfLines = 0
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            userName.textColor = Colours.grayDark
        default:
            userName.textColor = UIColor.white
        }
        userName.font = UIFont.boldSystemFont(ofSize: 16)
        
        contentView.addSubview(userName)
        
        let viewsDict = [
            "name" : userName,
            ]
        
        let horizontalContstraintsName = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[name]-15-|", options: [], metrics: nil, views: viewsDict)
        for constraint in horizontalContstraintsName {
            constraint.identifier = "$ListCell-HorizontalName$"
        }
        contentView.addConstraints(horizontalContstraintsName)
        
        let verticalConstraintsName = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[name]-16-|", options: [], metrics: nil, views: viewsDict)
        for constraint in horizontalContstraintsName {
            constraint.identifier = "$ListCell-VerticalName$"
        }
        contentView.addConstraints(verticalConstraintsName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: List) {
        userName.text = status.title
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            userName.textColor = Colours.grayDark
        default:
            print("nil")
        }
    }
    
    func configureInstance(instanceName:String){
        userName.text = instanceName
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            userName.textColor = Colours.grayDark
        default:
            print("nil")
        }
    }
    
}



class ListCell2: SwipeTableViewCell {
    
    var userName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.numberOfLines = 0
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            userName.textColor = Colours.grayDark
        default:
            userName.textColor = UIColor.white
        }
        userName.font = UIFont.boldSystemFont(ofSize: 16)
        
        contentView.addSubview(userName)
        
        let viewsDict = [
            "name" : userName,
            ]
        
        let horizontalConstraintsName = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[name]-15-|", options: [], metrics: nil, views: viewsDict)
        for constraint in horizontalConstraintsName {
            constraint.identifier = "$ListCell2-HorizontalName$"
        }
        contentView.addConstraints(horizontalConstraintsName)
        
        let verticalConstraintsName = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[name]-16-|", options: [], metrics: nil, views: viewsDict)
        for constraint in verticalConstraintsName {
            constraint.identifier = "$ListCell2-VerticalName$"
        }
        contentView.addConstraints(verticalConstraintsName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: String) {
        userName.text = status
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            userName.textColor = Colours.grayDark
        default:
            print("nil")
        }
    }
    
}

