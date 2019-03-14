//
//  PollOptionCellToggle.swift
//  mastodon
//
//  Created by Shihab Mehboob on 05/03/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class PollOptionCellToggle: SwipeTableViewCell {
    
    var userName = UILabel()
    var userTag = UILabel()
    var toot = UILabel()
    var switchView = UISwitch(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        switchView.translatesAutoresizingMaskIntoConstraints = false
        
        userName.numberOfLines = 0
        userTag.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = Colours.black
        userTag.textColor = Colours.black.withAlphaComponent(0.8)
        toot.textColor = Colours.black.withAlphaComponent(0.5)
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        userTag.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
        switchView.setOn(false, animated: true)
        switchView.onTintColor = Colours.tabSelected
        contentView.addSubview(switchView)
        
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(toot)
        
        let viewsDict = [
            "name" : userName,
            "artist" : userTag,
            "episodes" : toot,
            "switch" : switchView,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[name]-(>=10)-[switch(40)]-30-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[artist]-(>=10)-[switch(40)]-30-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[episodes]-(>=10)-[switch(40)]-30-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[switch(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(status: String, status2: String) {
        userTag.text = status
        toot.text = status2
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        userTag.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        switchView.onTintColor = Colours.tabSelected
        
    }
    
}


