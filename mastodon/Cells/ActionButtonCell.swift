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
        
        let viewsDict = [
            "container" : containerView,
            "reply" : replyButton,
            "like" : likeButton,
            "boost" : boostButton,
            "share" : shareButton,
            "more" : moreButton,
            ]
        
        let metrics = [
            "horizontalSpacing": 20,
            "cornerMargin": 30,
            "actionBtnSize": 40,
        ]
        
        let verticalCenter = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        verticalCenter.identifier = "$ActionButtonCell-contentView-verticalCenter$"
        let horizontalCenter = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        horizontalCenter.identifier = "$ActionButtonCell-contentView-horizontalCenter$"
        
        contentView.addConstraint(verticalCenter)
        contentView.addConstraint(horizontalCenter)
        
        
        //TODO: Is there a better way to order this buttons?
        var horizontalConstraints = "H:|-(==cornerMargin)-[reply(actionBtnSize)]-horizontalSpacing-[like(actionBtnSize)]-horizontalSpacing-[boost(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|"
        if (UserDefaults.standard.object(forKey: "sworder")) != nil {
            let swOrder = (UserDefaults.standard.object(forKey: "sworder")) as! Int
            switch(swOrder) {
            case 0:
                horizontalConstraints = "H:|-(==cornerMargin)-[reply(actionBtnSize)]-horizontalSpacing-[like(actionBtnSize)]-horizontalSpacing-[boost(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|"
            case 1:
                horizontalConstraints = "H:|-(==cornerMargin)-[reply(actionBtnSize)]-horizontalSpacing-[boost(actionBtnSize)]-horizontalSpacing-[like(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|"
            case 2:
                horizontalConstraints = "H:|-(==cornerMargin)-[boost(actionBtnSize)]-horizontalSpacing-[reply(actionBtnSize)]-horizontalSpacing-[like(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|"
            case 3:
                horizontalConstraints = "H:|-(==cornerMargin)-[boost(actionBtnSize)]-horizontalSpacing-[like(actionBtnSize)]-horizontalSpacing-[reply(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|"
            case 4:
                horizontalConstraints = "H:|-(==cornerMargin)-[like(actionBtnSize)]-horizontalSpacing-[reply(actionBtnSize)]-horizontalSpacing-[boost(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|"
            default:
                horizontalConstraints = "H:|-(==cornerMargin)-[like(actionBtnSize)]-horizontalSpacing-[boost(actionBtnSize)]-horizontalSpacing-[reply(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|"
            }
        }
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-horizontalConstraint-sworder-ReplyBtn-LikeBtn-BoostBtn-ShareBtn-MoreBtn$", withVisualFormat: horizontalConstraints, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        
        /*
        if (UserDefaults.standard.object(forKey: "sworder") == nil) || (UserDefaults.standard.object(forKey: "sworder") as! Int == 0) {
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-horizontalConstraint-sworder-0-ReplyBtn-LikeBtn-BoostBtn-ShareBtn-MoreBtn$", withVisualFormat: "H:|-(==cornerMargin)-[reply(actionBtnSize)]-horizontalSpacing-[like(actionBtnSize)]-horizontalSpacing-[boost(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|", options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 1) {
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-horizontalConstraint$-sworder-1-ReplyBtn-BoostBtn-LikeBtn-ShareBtn-MoreBtn$", withVisualFormat: "H:|-(==cornerMargin)-[reply(actionBtnSize)]-horizontalSpacing-[boost(actionBtnSize)]-horizontalSpacing-[like(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|", options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 2) {
            let horizontalFormat = "H:|-(==cornerMargin)-[boost(40)]-horizontalSpacing-[reply(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-horizontalConstraint$-sworder-2-BoostBtn-ReplyBtn-LikeBtn-ShareBtn-MoreBtn$", withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 3) {
            let horizontalFormat = "H:|-(==cornerMargin)-[boost(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[reply(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-horizontalConstraint$-sworder-3$", withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 4) {
            let horizontalFormat = "H:|-(==cornerMargin)-[like(40)]-horizontalSpacing-[reply(40)]-horizontalSpacing-[boost(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-horizontalConstraint$-sworder-4$", withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        } else {
            let horizontalFormat = "H:|-(==cornerMargin)-[like(40)]-horizontalSpacing-[boost(40)]-horizontalSpacing-[reply(40)]-horizontalSpacing-[share(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-horizontalConstraint$-sworder-others$", withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        }
        */
        
        let vMetrics = [
            "actionBtnSize": 40,
            "top": 10,
            "bottom": 12
        ]
        
        let verticalFormat = "V:|-top@999-[reply(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-contentView-verticalReplyBtn$", withVisualFormat: verticalFormat, options: .alignAllCenterY, metrics: vMetrics, views: viewsDict))
        
        let verticalFormat2 = "V:|-top@999-[like(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-contentView-verticalLike$", withVisualFormat: verticalFormat2, options: .alignAllCenterY, metrics: vMetrics, views: viewsDict))
        
        let verticalFormat3 = "V:|-top@999-[boost(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-contentView-verticalBoost3$", withVisualFormat: verticalFormat3, options: .alignAllCenterY, metrics: vMetrics, views: viewsDict))
        
        let verticalFormat34 = "V:|-top@999-[share(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-contentView-verticalShare$", withVisualFormat: verticalFormat34, options: .alignAllCenterY, metrics: vMetrics, views: viewsDict))

        let verticalFormat4 = "V:|-top@999-[more(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-contentView-verticalMore$", withVisualFormat: verticalFormat4, options: .alignAllCenterY, metrics: vMetrics, views: viewsDict))
        
        let verticalFormat5 = "V:|-0-[container]-0-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell-contentView-verticalContainer$", withVisualFormat: verticalFormat5, options: .alignAllCenterY, metrics: vMetrics, views: viewsDict))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mainStatus: Status) {
        replyButton.setImage(UIImage(named: "reply0")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        shareButton.setImage(UIImage(named: "share2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
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
        
        let viewsDict = [
            "container" : containerView,
            "reply" : replyButton,
            "like" : likeButton,
            "share" : shareButton,
            "more" : moreButton,
            ]
        
        let metrics = [
            "horizontalSpacing": 20,
            "cornerMargin": 30,
            "actionBtnSize": 40,
            "top": 10,
            "bottom": 12
        ]
        
        let verticalCenter = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        verticalCenter.identifier = "$ActionButtonCell2-contentView-verticalCenter$"
        let horizontalCenter = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        horizontalCenter.identifier = "$ActionButtonCell2-contentView-horizontalCenter$"
        contentView.addConstraint(verticalCenter)
        contentView.addConstraint(horizontalCenter)
        
        
        let horizontalFormat = "H:|-(==cornerMargin)-[reply(actionBtnSize)]-horizontalSpacing-[like(actionBtnSize)]-horizontalSpacing-[share(actionBtnSize)]-horizontalSpacing-[more(actionBtnSize)]-(==cornerMargin)-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell2-contentView-horizontalReplyBtn-LikeBtn-ShareBtn-MoreBtn$", withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        
        let verticalFormat = "V:|-top@999-[reply(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell2-contentView-verticalReplyBtn$", withVisualFormat: verticalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        
        let verticalFormat2 = "V:|-top@999-[like(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell2-contentView-verticalLikeBtn$", withVisualFormat: verticalFormat2, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        
        let verticalFormat34 = "V:|-top@999-[share(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell2-contentView-verticalShareBtn$", withVisualFormat: verticalFormat34, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        
        let verticalFormat4 = "V:|-top@999-[more(actionBtnSize)]-bottom@999-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell2-contentView-verticalMoreBtn$", withVisualFormat: verticalFormat4, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        
        let verticalFormat5 = "V:|-0-[container]-0-|"
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$ActionButtonCell2-contentView-verticalContainer$", withVisualFormat: verticalFormat5, options: .alignAllCenterY, metrics: metrics, views: viewsDict))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mainStatus: Status) {
        replyButton.setImage(UIImage(named: "direct2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        shareButton.setImage(UIImage(named: "share2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        moreButton.setImage(UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        
        if mainStatus.reblog?.favourited ?? mainStatus.favourited ?? false || StoreStruct.allLikes.contains(mainStatus.reblog?.id ?? mainStatus.id) {
            likeButton.setImage(UIImage(named: "like0")?.maskWithColor(color: Colours.orange), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like0")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        }
    }
    
}
