//
//  SettingsCellToggle.swift
//  mastodon
//
//  Created by Shihab Mehboob on 25/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class SettingsCellToggle: SwipeTableViewCell {
    
    var profileImageView = UIImageView()
    var userName = UILabel()
    var userTag = UILabel()
    var toot = UILabel()
    var switchView = UISwitch(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileImageView.backgroundColor = Colours.white
        
//        userName.adjustsFontForContentSizeCategory = true
//        userTag.adjustsFontForContentSizeCategory = true
//        toot.adjustsFontForContentSizeCategory = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        switchView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        
        userName.numberOfLines = 0
        userTag.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = Colours.black
        userTag.textColor = Colours.black.withAlphaComponent(0.8)
        toot.textColor = Colours.black.withAlphaComponent(0.5)
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
        //switchView.frame.origin.x = self.view.bounds.width - 70
        //switchView.frame.origin.y = 7
        switchView.setOn(false, animated: true)
        //switchView.tag = indexPath.row
        //switchView.tintColor = Colours.white2
        //switchView.thumbTintColor = Colours.white2
        switchView.onTintColor = Colours.tabSelected
        //switchView.addTarget(self, action: #selector(self.handleToggle), for: .touchUpInside)
        contentView.addSubview(switchView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(toot)
        
        let viewsDict = [
            "image" : profileImageView,
            "name" : userName,
            "artist" : userTag,
            "episodes" : toot,
            "switch" : switchView,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(40)]-13-[name]-(>=10)-[switch(40)]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(40)]-13-[artist]-(>=10)-[switch(40)]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(40)]-13-[episodes]-(>=10)-[switch(40)]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[switch(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[name]-1-[artist]-1-[episodes]-18-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(status: String, status2: String, image: String) {
        userTag.text = status
        toot.text = status2
        profileImageView.image = UIImage(named: image)
        
        profileImageView.isUserInteractionEnabled = false
        
        //.tintColor = Colours.white2
        //switchView.thumbTintColor = Colours.white2
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        switchView.onTintColor = Colours.tabSelected
        
    }
    
}


