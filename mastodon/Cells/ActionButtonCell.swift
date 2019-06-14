//
//  ActionButtonCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ActionButtonCell: UITableViewCell {
    
    let containerView = UIView(frame: CGRect.zero)
    var replyButton = UIButton()
    var likeButton = UIButton()
    var boostButton = UIButton()
    var shareButton = UIButton()
    var moreButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        replyButton.backgroundColor = Colours.white
        likeButton.backgroundColor = Colours.white
        boostButton.backgroundColor = Colours.white
        shareButton.backgroundColor = Colours.white
        moreButton.backgroundColor = Colours.white
        
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        boostButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        replyButton.layer.cornerRadius = 20
        replyButton.layer.masksToBounds = true
        likeButton.layer.cornerRadius = 20
        likeButton.layer.masksToBounds = true
        boostButton.layer.cornerRadius = 20
        boostButton.layer.masksToBounds = true
        shareButton.layer.cornerRadius = 20
        shareButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = 20
        moreButton.layer.masksToBounds = true
        
        containerView.addSubview(replyButton)
        containerView.addSubview(likeButton)
        containerView.addSubview(boostButton)
        containerView.addSubview(shareButton)
        containerView.addSubview(moreButton)
        
        let horizontalSpacing = 20
        let cornerMargin = 30
        
        let viewsDict = [
            "container" : containerView,
            "reply" : replyButton,
            "like" : likeButton,
            "boost" : boostButton,
            "share" : shareButton,
            "more" : moreButton,
            ]
        
        let metrics = [
            "horizontalSpacing": horizontalSpacing,
            "cornerMargin": cornerMargin
            ]
        
        let verticalCenter = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        let horizontalCenter = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(verticalCenter)
        contentView.addConstraint(horizontalCenter)
        
        
        
        if (UserDefaults.standard.object(forKey: "sworder") == nil) || (UserDefaults.standard.object(forKey: "sworder") as! Int == 0) {
            let horizontalFormat = "H:|-(==cornerMargin)-[reply(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[boost(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
            contentView.addConstraints(horizontalConstraints)
        } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 1) {
            let horizontalFormat = "H:|-(==cornerMargin)-[reply(40)]-horizontalSpacing-[boost(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
            contentView.addConstraints(horizontalConstraints)
        } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 2) {
            let horizontalFormat = "H:|-(==cornerMargin)-[boost(40)]-horizontalSpacing-[reply(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
            contentView.addConstraints(horizontalConstraints)
        } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 3) {
            let horizontalFormat = "H:|-(==cornerMargin)-[boost(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[reply(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
            contentView.addConstraints(horizontalConstraints)
        } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 4) {
            let horizontalFormat = "H:|-(==cornerMargin)-[like(40)]-horizontalSpacing-[reply(40)]-horizontalSpacing-[boost(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
            contentView.addConstraints(horizontalConstraints)
        } else {
            let horizontalFormat = "H:|-(==cornerMargin)-[like(40)]-horizontalSpacing-[boost(40)]-horizontalSpacing-[reply(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
            contentView.addConstraints(horizontalConstraints)
        }
        
        
        
        
        let verticalFormat = "V:|-10-[reply(40)]-12-|"
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints)
        
        let verticalFormat2 = "V:|-10-[like(40)]-12-|"
        let verticalConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat2, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints2)
        
        let verticalFormat3 = "V:|-10-[boost(40)]-12-|"
        let verticalConstraints3 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat3, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints3)
        
        let verticalFormat34 = "V:|-10-[share(40)]-12-|"
        let verticalConstraints34 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat34, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints34)
        
        let verticalFormat4 = "V:|-10-[more(40)]-12-|"
        let verticalConstraints4 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat4, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints4)
        
        let verticalFormat5 = "V:|-0-[container]-0-|"
        let verticalConstraints5 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat5, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mainStatus: Status) {
        replyButton.setImage(UIImage(named: "reply0")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        shareButton.setImage(UIImage(named: "jumptop2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        moreButton.setImage(UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        
        if mainStatus.reblog?.favourited ?? mainStatus.favourited ?? false || StoreStruct.allLikes.contains(mainStatus.reblog?.id ?? mainStatus.id) {
            likeButton.setImage(UIImage(named: "like0")?.maskWithColor(color: Colours.orange), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like0")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        }
        
        if mainStatus.reblog?.reblogged ?? mainStatus.reblogged ?? false || StoreStruct.allBoosts.contains(mainStatus.reblog?.id ?? mainStatus.id) {
            boostButton.setImage(UIImage(named: "boost0")?.maskWithColor(color: Colours.green), for: .normal)
        } else {
            boostButton.setImage(UIImage(named: "boost0")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        }
    }
    
}


class ActionButtonCell2: UITableViewCell {
    
    let containerView = UIView(frame: CGRect.zero)
    var replyButton = UIButton()
    var likeButton = UIButton()
    var shareButton = UIButton()
    var moreButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        replyButton.backgroundColor = Colours.white
        likeButton.backgroundColor = Colours.white
        shareButton.backgroundColor = Colours.white
        moreButton.backgroundColor = Colours.white
        
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        replyButton.layer.cornerRadius = 20
        replyButton.layer.masksToBounds = true
        likeButton.layer.cornerRadius = 20
        likeButton.layer.masksToBounds = true
        shareButton.layer.cornerRadius = 20
        shareButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = 20
        moreButton.layer.masksToBounds = true
        
        containerView.addSubview(replyButton)
        containerView.addSubview(likeButton)
        containerView.addSubview(shareButton)
        containerView.addSubview(moreButton)
        
        let horizontalSpacing = 20
        let cornerMargin = 30
        
        let viewsDict = [
            "container" : containerView,
            "reply" : replyButton,
            "like" : likeButton,
            "share" : shareButton,
            "more" : moreButton,
            ]
        
        let metrics = [
            "horizontalSpacing": horizontalSpacing,
            "cornerMargin": cornerMargin
        ]
        
        let verticalCenter = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        let horizontalCenter = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(verticalCenter)
        contentView.addConstraint(horizontalCenter)
        
        
        let horizontalFormat = "H:|-(==cornerMargin)-[reply(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(horizontalConstraints)
        
        let verticalFormat = "V:|-10-[reply(40)]-12-|"
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints)
        
        let verticalFormat2 = "V:|-10-[like(40)]-12-|"
        let verticalConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat2, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints2)
        
        let verticalFormat34 = "V:|-10-[share(40)]-12-|"
        let verticalConstraints34 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat34, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints34)
        
        let verticalFormat4 = "V:|-10-[more(40)]-12-|"
        let verticalConstraints4 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat4, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints4)
        
        let verticalFormat5 = "V:|-0-[container]-0-|"
        let verticalConstraints5 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat5, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mainStatus: Status) {
        replyButton.setImage(UIImage(named: "direct2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        shareButton.setImage(UIImage(named: "jumptop2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        moreButton.setImage(UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        
        if mainStatus.reblog?.favourited ?? mainStatus.favourited ?? false || StoreStruct.allLikes.contains(mainStatus.reblog?.id ?? mainStatus.id) {
            likeButton.setImage(UIImage(named: "like0")?.maskWithColor(color: Colours.orange), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like0")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        }
    }
    
}
