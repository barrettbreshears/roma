//
//  FiltersCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 03/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class FiltersCell: SwipeTableViewCell {
    
    var userName = UILabel()
    var toot = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        userName.adjustsFontForContentSizeCategory = true
//        toot.adjustsFontForContentSizeCategory = true
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = Colours.black
        toot.textColor = Colours.grayDark.withAlphaComponent(0.38)
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
        contentView.addSubview(userName)
        contentView.addSubview(toot)
        
        let viewsDict = [
            "name" : userName,
            "episodes" : toot,
            ]
        
        let constraintsName = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[name]-(>=15)-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsName {
            constraint.identifier = "$FiltersCell-Name$"
        }
        contentView.addConstraints(constraintsName)
        
        let constraintsEpisodes = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[episodes]-15-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsEpisodes {
            constraint.identifier = "$FiltersCell-Episodes$"
        }
        contentView.addConstraints(constraintsEpisodes)
        
        let constraintsNameEpisodes = NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[name]-1-[episodes]-18-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsNameEpisodes {
            constraint.identifier = "$FiltersCell-NameEpisodes$"
        }
        contentView.addConstraints(constraintsNameEpisodes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Filters) {
        var x = ""
        status.context.map({
            if x == "" {
                x = "\($0)"
            } else {
                x = "\(x) \($0)"
            }
        })
        
        userName.text = status.phrase
        toot.text = "Filtered in - \(x)"
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
    }
    
}

