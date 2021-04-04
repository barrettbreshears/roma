//
//  NotificationCellImage.swift
//  mastodon
//
//  Created by Shihab Mehboob on 21/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage
import ActiveLabel

class NotificationCellImage: SwipeTableViewCell {

    var profileImageView = UIButton()
    var typeImage = UIButton()
    var userName = UILabel()
    var userTag = UIButton()
    var date = UILabel()
    var toot = ActiveLabel()
    var mainImageView = UIButton()
    var mainImageViewBG = UIView()
    var moreImage = UIImageView()
    var imageCountTag = UIButton()
    var warningB = MultiLineButton()
    
    var rep1 = UIButton()
    var like1 = UIButton()
    var boost1 = UIButton()
    var more1 = UIButton()

    var smallImage1 = UIButton()
    var smallImage2 = UIButton()
    var smallImage3 = UIButton()
    var smallImage4 = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.clear
        typeImage.backgroundColor = Colours.clear
        moreImage.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        
//        userName.adjustsFontForContentSizeCategory = true
//        userTag.titleLabel?.adjustsFontForContentSizeCategory = true
//        date.adjustsFontForContentSizeCategory = true
//        toot.adjustsFontForContentSizeCategory = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        typeImage.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageViewBG.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        moreImage.translatesAutoresizingMaskIntoConstraints = false
        warningB.translatesAutoresizingMaskIntoConstraints = false

        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 20
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 8
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        profileImageView.contentHorizontalAlignment = .fill
        profileImageView.contentVerticalAlignment = .fill
        profileImageView.imageView?.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        typeImage.layer.cornerRadius = 0
        typeImage.layer.masksToBounds = true

        if (UserDefaults.standard.object(forKey: "imCorner") == nil || UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
            mainImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "imCorner") != nil && UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
            mainImageView.layer.cornerRadius = 0
        }
        mainImageView.layer.masksToBounds = true
        mainImageView.backgroundColor = Colours.clear
        mainImageViewBG.layer.cornerRadius = 10
        mainImageViewBG.backgroundColor = Colours.clear
        mainImageViewBG.layer.shadowColor = UIColor.black.cgColor
//        mainImageViewBG.layer.shadowOffset = CGSize(width: 0, height: 7)
        mainImageViewBG.layer.shadowRadius = 10
        mainImageViewBG.layer.shadowOpacity = 0.38
        mainImageViewBG.layer.masksToBounds = false
        
        if (UserDefaults.standard.object(forKey: "depthToggle") == nil) || (UserDefaults.standard.object(forKey: "depthToggle") as! Int == 0) {
            let amount = 10
            let amount2 = 15
            let horizontalEffect = UIInterpolatingMotionEffect(
                keyPath: "layer.shadowOffset.width",
                type: .tiltAlongHorizontalAxis)
            horizontalEffect.minimumRelativeValue = amount2
            horizontalEffect.maximumRelativeValue = -amount2
            let verticalEffect = UIInterpolatingMotionEffect(
                keyPath: "layer.shadowOffset.height",
                type: .tiltAlongVerticalAxis)
            verticalEffect.minimumRelativeValue = amount2
            verticalEffect.maximumRelativeValue = -amount2
            let effectGroup = UIMotionEffectGroup()
            effectGroup.motionEffects = [horizontalEffect, verticalEffect]
            self.mainImageViewBG.addMotionEffect(effectGroup)
            
            let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            horizontal.minimumRelativeValue = -amount
            horizontal.maximumRelativeValue = amount
            let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            vertical.minimumRelativeValue = -amount
            vertical.maximumRelativeValue = amount
            let effectGro = UIMotionEffectGroup()
            effectGro.motionEffects = [horizontal, vertical]
            self.mainImageView.addMotionEffect(effectGro)
            self.mainImageViewBG.addMotionEffect(effectGro)
            //            self.imageCountTag.addMotionEffect(effectGro)
        } else {
            mainImageViewBG.layer.shadowOffset = CGSize(width: 0, height: 7)
        }
        
        
        warningB.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        warningB.titleLabel?.textAlignment = .center
        warningB.setTitleColor(Colours.black.withAlphaComponent(0.4), for: .normal)
        warningB.layer.cornerRadius = 7
        warningB.titleLabel?.font = UIFont.boldSystemFont(ofSize: Colours.fontSize3)
        warningB.titleLabel?.numberOfLines = 0
        warningB.layer.masksToBounds = true
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = warningB.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.isUserInteractionEnabled = false
//        warningB.addSubview(blurEffectView)
//        warningB.sendSubviewToBack(blurEffectView)
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0

        userName.textColor = Colours.black
        userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        date.textColor = Colours.grayDark.withAlphaComponent(0.38)
        toot.textColor = Colours.black
        
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)

        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        userTag.setCompressionResistance(LayoutPriority(rawValue: 498), for: .horizontal)
        userName.setCompressionResistance(LayoutPriority(rawValue: 499), for: .horizontal)
        date.setCompressionResistance(LayoutPriority(rawValue: 501), for: .horizontal)
        
        contentView.addSubview(typeImage)
        contentView.addSubview(profileImageView)
        contentView.addSubview(mainImageViewBG)
        contentView.addSubview(mainImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)

        imageCountTag.backgroundColor = Colours.clear
        imageCountTag.translatesAutoresizingMaskIntoConstraints = false
        imageCountTag.layer.cornerRadius = 7
        imageCountTag.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        imageCountTag.layer.shadowColor = UIColor.black.cgColor
        imageCountTag.layer.shadowOffset = CGSize(width: 0, height: 7)
        imageCountTag.layer.shadowRadius = 10
        imageCountTag.layer.shadowOpacity = 0.22
        imageCountTag.layer.masksToBounds = false
        mainImageView.addSubview(imageCountTag)



        rep1.translatesAutoresizingMaskIntoConstraints = false
        rep1.setImage(UIImage(named: "reply3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        rep1.backgroundColor = Colours.clear
        rep1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.rep1.alpha = 0
        } else {
            self.rep1.alpha = 1
        }
        like1.translatesAutoresizingMaskIntoConstraints = false
        like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        like1.backgroundColor = Colours.clear
        like1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.like1.alpha = 0
        } else {
            self.like1.alpha = 1
        }
        boost1.translatesAutoresizingMaskIntoConstraints = false
        boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        boost1.backgroundColor = Colours.clear
        boost1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.boost1.alpha = 0
        } else {
            self.boost1.alpha = 1
        }
        more1.translatesAutoresizingMaskIntoConstraints = false
        more1.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        more1.backgroundColor = Colours.clear
        more1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.more1.alpha = 0
        } else {
            self.more1.alpha = 0
        }

        contentView.addSubview(rep1)
        contentView.addSubview(like1)
        contentView.addSubview(boost1)
        contentView.addSubview(more1)


        contentView.addSubview(warningB)

        let viewsDict = [
            "image" : profileImageView,
            "type" : typeImage,
            "mainImage" : mainImageView,
            "mainImageBG" : mainImageViewBG,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            "countTag" : imageCountTag,
            "warning" : warningB,
            "rep1" : rep1,
            "like1" : like1,
            "boost1" : boost1,
            "more1" : more1,
            ]
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-HorizontalType40Image40NameArtistMoreDate$", withVisualFormat: "H:|-12-[type(40)]-4-[image(40)]-13-[name]-2-[artist]-(>=5)-[more(16)]-4-[date]-12-|", options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[type(40)]-4-[image(40)]-13-[artist]-(>=5)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-HorizontalType40Image40Episodes$", withVisualFormat: "H:|-12-[type(40)]-4-[image(40)]-13-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-HorizontalMainImage$", withVisualFormat: "H:|-109-[mainImage]-12-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-HorizontalMainImageBG$", withVisualFormat: "H:|-117-[mainImageBG]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-VerticalMore16$", withVisualFormat: "V:|-18-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-VerticalDate$", withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-VerticalImage40$", withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-VerticalType40$", withVisualFormat: "V:|-18-[type(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
            
            
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-tootpl-VerticalNameEpisodesMainImage$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImage(160)]-23-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-tootpl-VerticalNameEpisodesMainImageBG$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImageBG(160)]-23-|", options: [], metrics: nil, views: viewsDict))
        } else {
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-no-tootpl-VerticalNameEpisodesMainImageBG$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImageBG(160)]-23-[rep1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-no-tootpl-VerticalNameEpisodesMainImageRep1$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImage(160)]-23-[rep1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-no-tootpl-VerticalNameEpisodesMainImageLike1$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImage(160)]-23-[like1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-no-tootpl-VerticalNameEpisodesMainImageBoost1$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImage(160)]-23-[boost1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-no-tootpl-VerticalNameEpisodesMainImageMore1$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImage(160)]-23-[more1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-no-tootpl-HorizontalRep1Like1Boost1More1$", withVisualFormat: "H:|-109-[rep1(36)]-20-[like1(40)]-11-[boost1(34)]-24-[more1(20)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        }
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-VerticalArtistEpisodesMainImage$", withVisualFormat: "V:|-12-[artist]-0-[episodes]-10-[mainImage(160)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-HorizontalCountTag30$", withVisualFormat: "H:|-5-[countTag(30)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-VerticalCountTag22$", withVisualFormat: "V:|-5-[countTag(22)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-HorizontalWarning$", withVisualFormat: "H:|-101-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$NotificationCellImage-VerticalNameWarning$", withVisualFormat: "V:|-18-[name]-1-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
    }

    @objc func touchMore(button: UIButton) {
        print("touched more")
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "more"), object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        self.profileImageView.imageView?.image = nil
//        self.mainImageView.imageView?.image = nil
//        self.mainImageView.imageView?.image = UIImage()
//        self.mainImageView.pin_clearImages()
//        self.smallImage1.imageView?.image = nil
//        self.smallImage2.imageView?.image = nil
//        self.smallImage3.imageView?.image = nil
//        self.smallImage4.imageView?.image = nil
    }

    func configure(_ status: Notificationt) {
        
        profileImageView.backgroundColor = Colours.clear
        typeImage.backgroundColor = Colours.clear
        moreImage.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        rep1.backgroundColor = Colours.clear
        like1.backgroundColor = Colours.clear
        boost1.backgroundColor = Colours.clear
        more1.backgroundColor = Colours.clear
        
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            self.rep1.alpha = 0
            self.like1.alpha = 0
            self.boost1.alpha = 0
        } else {
            self.rep1.alpha = 1
            self.like1.alpha = 1
            self.boost1.alpha = 1
        }
        
        rep1.setImage(UIImage(named: "reply3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        more1.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        if StoreStruct.allBoosts.contains(status.status?.reblog?.id ?? status.status?.id ?? "") || status.status?.reblogged ?? false {
            boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
        } else {
            boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        }
        if StoreStruct.allLikes.contains(status.status?.reblog?.id ?? status.status?.id ?? "") || status.status?.favourited ?? false {
            like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
        } else {
            like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        }

        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {} else {
            var repc1 = "\(status.status?.reblog?.repliesCount ?? status.status?.repliesCount ?? 0)"
            if repc1 == "0" {
                repc1 = ""
            }
            var likec1 = "\(status.status?.reblog?.favouritesCount ?? status.status?.favouritesCount ?? 0)"
            if likec1 == "0" {
                likec1 = ""
            }
            var boostc1 = "\(status.status?.reblog?.reblogsCount ?? status.status?.reblogsCount ?? 0)"
            if boostc1 == "0" {
                boostc1 = ""
            }
            rep1.setTitle(repc1, for: .normal)
            rep1.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            rep1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rep1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            rep1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            like1.setTitle(likec1, for: .normal)
            like1.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            like1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            like1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            like1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            boost1.setTitle(boostc1, for: .normal)
            boost1.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            boost1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            boost1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            boost1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }


        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected

        if status.type == .favourite {
            profileImageView.isUserInteractionEnabled = true
            userName.text = "\(status.account.displayName) liked"
            typeImage.setImage(UIImage(named: "like3"), for: .normal)
            //toot.textColor = Colours.black.withAlphaComponent(0.3)
            if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                toot.textColor = Colours.black
                userName.textColor = Colours.black
                userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                date.textColor = Colours.grayDark.withAlphaComponent(0.38)
            } else {
                toot.textColor = Colours.black.withAlphaComponent(0.3)
                userName.textColor = Colours.black.withAlphaComponent(0.3)
                userTag.setTitleColor(Colours.black.withAlphaComponent(0.3), for: .normal)
                date.textColor = Colours.black.withAlphaComponent(0.3)
            }
        }
        if status.type == .reblog {
            profileImageView.isUserInteractionEnabled = true
            userName.text = "\(status.account.displayName) reposted"
            typeImage.setImage(UIImage(named: "boost3"), for: .normal)
            //toot.textColor = Colours.black.withAlphaComponent(0.3)
            if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                toot.textColor = Colours.black
                userName.textColor = Colours.black
                userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                date.textColor = Colours.grayDark.withAlphaComponent(0.38)
            } else {
                toot.textColor = Colours.black.withAlphaComponent(0.3)
                userName.textColor = Colours.black.withAlphaComponent(0.3)
                userTag.setTitleColor(Colours.black.withAlphaComponent(0.3), for: .normal)
                date.textColor = Colours.black.withAlphaComponent(0.3)
            }
        }
        if status.type == .mention {
            profileImageView.isUserInteractionEnabled = true
            toot.textColor = Colours.black
            userName.textColor = Colours.black
            userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
            date.textColor = Colours.grayDark.withAlphaComponent(0.38)
            userName.text = "\(status.account.displayName) mentioned you"
            if status.status?.visibility == .direct {
                typeImage.setImage(UIImage(named: "direct")?.maskWithColor(color: Colours.lightBlue), for: .normal)
            } else if status.status?.visibility == .unlisted {
                typeImage.setImage(UIImage(named: "rep4"), for: .normal)
            } else if status.status?.visibility == .private {
                typeImage.setImage(UIImage(named: "rep5"), for: .normal)
            } else {
                typeImage.setImage(UIImage(named: "reply3"), for: .normal)
            }
        }
        if status.type == .follow {
            profileImageView.isUserInteractionEnabled = false
            userName.text = "\(status.account.displayName) followed you"
            typeImage.setImage(UIImage(named: "follow3")?.maskWithColor(color: Colours.redBright), for: .normal)
            //toot.textColor = Colours.black.withAlphaComponent(0.3)
            if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                toot.textColor = Colours.black
                userName.textColor = Colours.black
                userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                date.textColor = Colours.grayDark.withAlphaComponent(0.38)
            } else {
                toot.textColor = Colours.black.withAlphaComponent(0.3)
                userName.textColor = Colours.black.withAlphaComponent(0.3)
                userTag.setTitleColor(Colours.black.withAlphaComponent(0.3), for: .normal)
                date.textColor = Colours.black.withAlphaComponent(0.3)
            }
        }
        typeImage.layer.masksToBounds = true

        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil || UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
            userTag.setTitle("@\(status.account.acct)", for: .normal)
        } else {
            userTag.setTitle("@\(status.account.username)", for: .normal)
        }

        if (UserDefaults.standard.object(forKey: "timerel") == nil) || (UserDefaults.standard.object(forKey: "timerel") as! Int == 0) {
            date.text = status.createdAt.toStringWithRelativeTime()
        } else {
            date.text = status.createdAt.toString(dateStyle: .short, timeStyle: .short)
        }


//        toot.text = status.status?.content.stripHTML() ?? ""




        if status.status?.emojis.isEmpty ?? true {
            toot.text = status.status?.content.stripHTML() ?? status.account.note.stripHTML()
        } else {
            let attributedString = NSMutableAttributedString(string: status.status?.content.stripHTML() ?? status.account.note.stripHTML())
            (status.status?.emojis)!.map({
                let textAttachment = NSTextAttachment()
                textAttachment.loadImageUsingCache(withUrl: $0.url.absoluteString)
                textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.toot.font.lineHeight), height: Int(self.toot.font.lineHeight))
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                while attributedString.mutableString.contains(":\($0.shortcode):") {
                    let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\($0.shortcode):")
                    attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                }
            })
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colours.black, range: NSMakeRange(0, attributedString.length))
            self.toot.attributedText = attributedString
            self.reloadInputViews()
        }




        if status.account.emojis.isEmpty {
            userName.text = status.account.displayName.stripHTML()
            if userName.text == "" {
                userName.text = " "
            }
        } else {
            let attributedString = NSMutableAttributedString(string: status.account.displayName.stripHTML())
            status.account.emojis.map({
                let textAttachment = NSTextAttachment()
                textAttachment.loadImageUsingCache(withUrl: $0.url.absoluteString)
                textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.userName.font.lineHeight), height: Int(self.userName.font.lineHeight))
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                while attributedString.mutableString.contains(":\($0.shortcode):") {
                    let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\($0.shortcode):")
                    attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                }
            })
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colours.black, range: NSMakeRange(0, attributedString.length))
            self.userName.attributedText = attributedString
            self.reloadInputViews()
        }
        
        
        
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)

        DispatchQueue.global(qos: .userInitiated).async {
        self.profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
        self.profileImageView.pin_updateWithProgress = true
        self.profileImageView.pin_setImage(from: URL(string: "\(status.account.avatar)"))
        }
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 0.2
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 20
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 8
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }

        mainImageView.contentMode = .scaleAspectFill
        mainImageView.imageView?.contentMode = .scaleAspectFill
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.borderColor = UIColor.black.cgColor
        if (UserDefaults.standard.object(forKey: "imCorner") == nil || UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
            mainImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "imCorner") != nil && UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
            mainImageView.layer.cornerRadius = 0
        }
        //mainImageView.layer.borderWidth = 0.2

        if (status.status?.favourited ?? false) && (status.status?.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
            StoreStruct.allLikes.append(status.status?.id ?? "")
            StoreStruct.allBoosts.append(status.status?.id ?? "")
        } else if status.status?.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
            StoreStruct.allBoosts.append(status.status?.id ?? "")
        } else if (status.status?.favourited ?? false) || StoreStruct.allLikes.contains(status.id) {
            self.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
            StoreStruct.allLikes.append(status.status?.id ?? "")
        } else {
            self.moreImage.image = nil
        }
        
        StoreStruct.allLikes = StoreStruct.allLikes.removeDuplicates()
        StoreStruct.allBoosts = StoreStruct.allBoosts.removeDuplicates()
        
        var tempWid: CGFloat = 380
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            tempWid = 380
        default:
            tempWid = UIScreen.main.bounds.width
        }
        
        self.smallImage1.alpha = 0
        self.smallImage2.alpha = 0
        self.smallImage3.alpha = 0
        self.smallImage4.alpha = 0
        imageCountTag.isUserInteractionEnabled = false
        if status.status?.reblog?.mediaAttachments.isEmpty ?? status.status?.mediaAttachments.isEmpty ?? false { return }
        if status.status?.reblog?.mediaAttachments[0].type ?? status.status?.mediaAttachments[0].type == .video {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            self.mainImageView.contentMode = .scaleAspectFit
            self.mainImageView.imageView?.contentMode = .scaleAspectFit
//            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.status?.mediaAttachments[0].previewURL ?? "")"))
//            }
            imageCountTag.setTitle("\u{25b6}", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.status?.reblog?.mediaAttachments[0].type ?? status.status?.mediaAttachments[0].type == .gifv {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            self.mainImageView.contentMode = .scaleAspectFit
            self.mainImageView.imageView?.contentMode = .scaleAspectFit
//            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.status?.mediaAttachments[0].previewURL ?? "")"))
//            }
            imageCountTag.setTitle("GIF", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count ?? 0 > 1 {
            self.mainImageView.imageView?.image = nil
            self.mainImageView.setImage(nil, for: .normal)
//            self.mainImageView.imageView?.image = UIImage()
            if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count == 2 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (tempWid - 117)/2, height: 200)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[0].previewURL ?? status.status?.mediaAttachments[0].previewURL ?? "")"))
//                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (tempWid - 117)/2 + 2, y: 0, width: (tempWid - 117)/2, height: 200)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[1].previewURL ?? status.status?.mediaAttachments[1].previewURL ?? "")"))
//                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
            } else if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count == 3 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (tempWid - 117)/2, height: 200)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[0].previewURL ?? status.status?.mediaAttachments[0].previewURL ?? "")"))
//                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (tempWid - 117)/2 + 2, y: -2, width: (tempWid - 117)/2, height: 80)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[1].previewURL ?? status.status?.mediaAttachments[1].previewURL ?? "")"))
//                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
                
                self.smallImage3.frame = CGRect(x: (tempWid - 117)/2 + 2, y: 82, width: (tempWid - 117)/2, height: 80)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[2].previewURL ?? status.status?.mediaAttachments[2].previewURL ?? "")"))
//                }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
            } else if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count ?? 0 >= 4 {
                self.smallImage1.frame = CGRect(x: -2, y: -2, width: (tempWid - 117)/2, height: 80)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[0].previewURL ?? status.status?.mediaAttachments[0].previewURL ?? "")"))
//                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (tempWid - 117)/2 + 2, y: -2, width: (tempWid - 117)/2, height: 80)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[1].previewURL ?? status.status?.mediaAttachments[1].previewURL ?? "")"))
//                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
                
                self.smallImage3.frame = CGRect(x: -2, y: 82, width: (tempWid - 117)/2, height: 80)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[2].previewURL ?? status.status?.mediaAttachments[2].previewURL ?? "")"))
//                }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
                
                self.smallImage4.frame = CGRect(x: (tempWid - 117)/2 + 2, y: 82, width: (tempWid - 117)/2, height: 80)
                self.smallImage4.contentMode = .scaleAspectFill
                self.smallImage4.imageView?.contentMode = .scaleAspectFill
                self.smallImage4.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage4.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage4.pin_updateWithProgress = true
                self.smallImage4.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[3].previewURL ?? status.status?.mediaAttachments[3].previewURL ?? "")"))
//                }
                self.smallImage4.layer.masksToBounds = true
                self.smallImage4.layer.borderColor = UIColor.black.cgColor
                self.smallImage4.alpha = 1
                self.mainImageView.addSubview(self.smallImage4)
            } else {
                self.smallImage1.alpha = 0
                self.smallImage2.alpha = 0
                self.smallImage3.alpha = 0
                self.smallImage4.alpha = 0
            }
        } else if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count ?? 0 > 1 {
            imageCountTag.setTitle("\(status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count ?? 0)", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
            imageCountTag.bringSubviewToFront(self)
        } else {
            imageCountTag.backgroundColor = Colours.clear
            imageCountTag.alpha = 0
//            DispatchQueue.global(qos: .userInitiated).async {
            self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
            self.mainImageView.pin_updateWithProgress = true
            self.mainImageView.pin_setImage(from: URL(string: "\(status.status?.mediaAttachments[0].url ?? "")"))
//            }
        }



        if (UserDefaults.standard.object(forKey: "senseTog") == nil) || (UserDefaults.standard.object(forKey: "senseTog") as! Int == 0) {

            if status.status?.reblog?.sensitive ?? false || status.status?.sensitive ?? false {
                warningB.backgroundColor = Colours.tabUnselected
                
                let z = status.status?.reblog?.spoilerText ?? status.status?.spoilerText ?? ""
                var zz = "Sensitive Content"
                if z == "" {} else {
                    zz = z
                }
                warningB.setTitle("\(zz)", for: .normal)
                warningB.setTitleColor(Colours.grayDark.withAlphaComponent(0.6), for: .normal)
                warningB.addTarget(self, action: #selector(self.didTouchWarning), for: .touchUpInside)
                warningB.alpha = 1
            } else {
                warningB.backgroundColor = Colours.clear
                warningB.alpha = 0
            }

        } else {
            warningB.backgroundColor = Colours.clear
            warningB.alpha = 0
        }


    }
    
    func configure0(_ status: Notificationt) {
        if (status.status?.favourited ?? false) && (status.status?.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
            StoreStruct.allLikes.append(status.status?.id ?? "")
            StoreStruct.allBoosts.append(status.status?.id ?? "")
        } else if status.status?.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
            StoreStruct.allBoosts.append(status.status?.id ?? "")
        } else if (status.status?.favourited ?? false) || StoreStruct.allLikes.contains(status.id) {
            self.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
            StoreStruct.allLikes.append(status.status?.id ?? "")
        } else {
            self.moreImage.image = nil
        }
        
        StoreStruct.allLikes = StoreStruct.allLikes.removeDuplicates()
        StoreStruct.allBoosts = StoreStruct.allBoosts.removeDuplicates()
        
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {} else {
            var repc1 = "\(status.status?.reblog?.repliesCount ?? status.status?.repliesCount ?? 0)"
            if repc1 == "0" {
                repc1 = ""
            }
            var likec1 = "\(status.status?.reblog?.favouritesCount ?? status.status?.favouritesCount ?? 0)"
            if likec1 == "0" {
                likec1 = ""
            }
            var boostc1 = "\(status.status?.reblog?.reblogsCount ?? status.status?.reblogsCount ?? 0)"
            if boostc1 == "0" {
                boostc1 = ""
            }
            rep1.setTitle(repc1, for: .normal)
            rep1.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            rep1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rep1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            rep1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            like1.setTitle(likec1, for: .normal)
            like1.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            like1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            like1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            like1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            boost1.setTitle(boostc1, for: .normal)
            boost1.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            boost1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            boost1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            boost1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }
    }
    
    @objc func didTouchWarning() {
        warningB.backgroundColor = Colours.clear
        warningB.alpha = 0

        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
    }
}
