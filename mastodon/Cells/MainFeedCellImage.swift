//
//  MainFeedCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class MainFeedCellImage: SwipeTableViewCell {

    var profileImageView = UIButton()
    var profileImageView2 = UIButton()
    var warningB = MultiLineButton()
    var userName = UILabel()
    var userTag = UIButton()
    var date = UILabel()
    var toot = ActiveLabel()
    var mainImageView = UIButton()
    var mainImageViewBG = UIView()
    var moreImage = UIImageView()
    var imageCountTag = UIButton()

    var replyBtn = UIButton()
    var likeBtn = UIButton()
    var boostBtn = UIButton()
    var moreBtn = UIButton()

    var smallImage1 = UIButton()
    var smallImage2 = UIButton()
    var smallImage3 = UIButton()
    var smallImage4 = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.clear
        profileImageView2.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        moreImage.backgroundColor = Colours.clear
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView2.translatesAutoresizingMaskIntoConstraints = false
        warningB.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageViewBG.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        moreImage.translatesAutoresizingMaskIntoConstraints = false

        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 20
            profileImageView2.layer.cornerRadius = 13
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 8
            profileImageView2.layer.cornerRadius = 4
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
            profileImageView2.layer.cornerRadius = 0
        }
        profileImageView.layer.masksToBounds = true
        profileImageView2.layer.masksToBounds = true

        warningB.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        warningB.titleLabel?.textAlignment = .center
        warningB.setTitleColor(Colours.black.withAlphaComponent(0.4), for: .normal)
        warningB.layer.cornerRadius = 7
        warningB.titleLabel?.font = UIFont.boldSystemFont(ofSize: Colours.fontSize3)
        warningB.titleLabel?.numberOfLines = 0
        warningB.layer.masksToBounds = true
        
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
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0
        date.textAlignment = .right
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
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileImageView2)
        contentView.addSubview(mainImageViewBG)
        contentView.addSubview(mainImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        contentView.addSubview(imageCountTag)


        replyBtn.translatesAutoresizingMaskIntoConstraints = false
        replyBtn.setImage(UIImage(named: "reply3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        replyBtn.backgroundColor = Colours.clear
        replyBtn.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.replyBtn.alpha = 0
        } else {
            self.replyBtn.alpha = 1
        }
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        likeBtn.backgroundColor = Colours.clear
        likeBtn.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.likeBtn.alpha = 0
        } else {
            self.likeBtn.alpha = 1
        }
        boostBtn.translatesAutoresizingMaskIntoConstraints = false
        boostBtn.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        boostBtn.backgroundColor = Colours.clear
        boostBtn.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.boostBtn.alpha = 0
        } else {
            self.boostBtn.alpha = 1
        }
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        moreBtn.backgroundColor = Colours.clear
        moreBtn.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.moreBtn.alpha = 0
        } else {
            self.moreBtn.alpha = 1
        }

        contentView.addSubview(replyBtn)
        contentView.addSubview(likeBtn)
        contentView.addSubview(boostBtn)
        contentView.addSubview(moreBtn)


        contentView.addSubview(warningB)

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

        let viewsDict = [
            "image" : profileImageView,
            "image2" : profileImageView2,
            "warning" : warningB,
            "mainImage" : mainImageView,
            "mainImageBG" : mainImageViewBG,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            "countTag" : imageCountTag,
            "replyBtn" : replyBtn,
            "likeBtn" : likeBtn,
            "boostBtn" : boostBtn,
            "moreBtn" : moreBtn,
            ]
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-HorizontalImage40NameArtistMoreDate$", withVisualFormat: "H:|-12-[image(40)]-13-[name]-2-[artist]-(>=5)-[more(16)]-4-[date]-12-|", options: [], metrics: nil, views: viewsDict))
       
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-HorizontalImage226$", withVisualFormat: "H:|-30-[image2(26)]", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-HorizontalImage40Episodes$", withVisualFormat: "H:|-12-[image(40)]-13-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
        
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-HorizontalMainImage$", withVisualFormat: "H:|-65-[mainImage]-12-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-HorizontalMainImageBG$", withVisualFormat: "H:|-73-[mainImageBG]-20-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-VerticalMore$", withVisualFormat: "V:|-18-[more(16)]", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-VerticalDate$", withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-VerticalImage40$", withVisualFormat: "V:|-18-[image(40)]", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-VerticalImage226$", withVisualFormat: "V:|-38-[image2(26)]", options: [], metrics: nil, views: viewsDict))

        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-tootpl-VerticalNameEpisodesMainImage$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImage(200)]-23-|", options: [], metrics: nil, views: viewsDict))
            
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-tootpl-VerticalNameEpisodesMainImageBG$", withVisualFormat: "V:|-14-[name]-2-[episodes]-10-[mainImageBG(200)]-23-|", options: [], metrics: nil, views: viewsDict))
        } else {
            let vMetrics = [
                "actionButtonHeight": 20,
                "mainImageHeight": 200,
                "spacingTop": 14,
                "nameEpsSpacing": 2,
                "epsMainImageSpacing": 10,
                "mainImageActionsSpacing": 25,
                "spacingBottom": 18
            ]
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-no-tootpl-VerticalNameEpisodesMainImageReplyBtn$", withVisualFormat: "V:|-spacingTop-[name]-nameEpsSpacing-[episodes]-epsMainImageSpacing-[mainImage(mainImageHeight)]-mainImageActionsSpacing@999-[replyBtn(actionButtonHeight)]-spacingBottom-|", options: [], metrics: vMetrics, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-no-tootpl-VerticalNameEpisodesMainImageLikeBtn$", withVisualFormat: "V:|-spacingTop-[name]-nameEpsSpacing-[episodes]-epsMainImageSpacing-[mainImage(mainImageHeight)]-mainImageActionsSpacing@999-[likeBtn(actionButtonHeight)]-spacingBottom-|", options: [], metrics: vMetrics, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-no-tootpl-VerticalNameEpisodesMainImageBoostBtn$", withVisualFormat: "V:|-spacingTop-[name]-nameEpsSpacing-[episodes]-epsMainImageSpacing-[mainImage(mainImageHeight)]-mainImageActionsSpacing@999-[boostBtn(actionButtonHeight)]-spacingBottom-|", options: [], metrics: vMetrics, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-no-tootpl-VerticalNameEpisodesMainImageMoreBtn$", withVisualFormat: "V:|-spacingTop-[name]-nameEpsSpacing-[episodes]-epsMainImageSpacing-[mainImage(mainImageHeight)]-mainImageActionsSpacing@999-[moreBtn(actionButtonHeight)]-spacingBottom-|", options: [], metrics: vMetrics, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-no-tootpl-HorizontalReplyBtnLikeBtnBoostBtnMoreBtn$", withVisualFormat: "H:|-65-[replyBtn(36)]-20-[likeBtn(40)]-11-[boostBtn(34)]-24-[moreBtn(20)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        }
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-VerticalArtistEpisodesMainImage$", withVisualFormat: "V:|-14-[artist]-2-[episodes]", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-HorizontalCountTag30$", withVisualFormat: "H:|-5-[countTag(30)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-VerticalCountTag22$", withVisualFormat: "V:|-5-[countTag(22)]", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-HorizontalWarning$", withVisualFormat: "H:|-63-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCellImage-VerticalNameWarning$", withVisualFormat: "V:|-14-[name]-1-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        self.profileImageView.imageView?.image = nil
//        self.profileImageView2.imageView?.image = nil
//        self.mainImageView.imageView?.image = nil
//        self.mainImageView.imageView?.image = UIImage()
//        self.mainImageView.pin_clearImages()
//        self.smallImage1.imageView?.image = nil
//        self.smallImage2.imageView?.image = nil
//        self.smallImage3.imageView?.image = nil
//        self.smallImage4.imageView?.image = nil
    }

    func configure(_ status: Status) {
        
        profileImageView.backgroundColor = Colours.clear
        profileImageView2.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        moreImage.backgroundColor = Colours.clear
        replyBtn.backgroundColor = Colours.clear
        likeBtn.backgroundColor = Colours.clear
        boostBtn.backgroundColor = Colours.clear
        moreBtn.backgroundColor = Colours.clear
        toot.textColor = Colours.black
        
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            self.replyBtn.alpha = 0
            self.likeBtn.alpha = 0
            self.boostBtn.alpha = 0
            self.moreBtn.alpha = 0
        } else {
            self.replyBtn.alpha = 1
            self.likeBtn.alpha = 1
            self.boostBtn.alpha = 1
            self.moreBtn.alpha =  1
        }
        
        replyBtn.setImage(UIImage(named: "reply3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        moreBtn.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        if StoreStruct.allBoosts.contains(status.reblog?.id ?? status.id) || status.reblog?.reblogged ?? status.reblogged ?? false {
            boostBtn.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
        } else {
            boostBtn.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        }
        if StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) || status.reblog?.favourited ?? status.favourited ?? false {
            likeBtn.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
        } else {
            likeBtn.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        }

        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {} else {
            var repc1 = "\(status.reblog?.repliesCount ?? status.repliesCount)"
            if repc1 == "0" {
                repc1 = ""
            }
            var likec1 = "\(status.reblog?.favouritesCount ?? status.favouritesCount)"
            if likec1 == "0" {
                likec1 = ""
            }
            var boostc1 = "\(status.reblog?.reblogsCount ?? status.reblogsCount)"
            if boostc1 == "0" {
                boostc1 = ""
            }
            replyBtn.setTitle(repc1, for: .normal)
            replyBtn.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            replyBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            replyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            replyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            likeBtn.setTitle(likec1, for: .normal)
            likeBtn.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            likeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            likeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            likeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            boostBtn.setTitle(boostc1, for: .normal)
            boostBtn.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            boostBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            boostBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            boostBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }

        if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {

        } else {
            if status.visibility == .direct {
                if UserDefaults.standard.object(forKey: "dmTog") as! Int == 1 {
                    self.contentView.backgroundColor = Colours.cellQuote
                }
                if UserDefaults.standard.object(forKey: "dmTog") as! Int == 2 {
                    self.contentView.backgroundColor = Colours.tabUnselected
                }
                if UserDefaults.standard.object(forKey: "dmTog") as! Int == 3 {
                    self.contentView.backgroundColor = Colours.tabSelected
                }
            } else {
                self.contentView.backgroundColor = Colours.white
            }
        }



        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected



        userName.text = status.reblog?.account.displayName ?? status.account.displayName
        if userName.text == "" {
            userName.text = " "
        }
        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil || UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
            userTag.setTitle("@\(status.reblog?.account.acct ?? status.account.acct)", for: .normal)
        } else {
            userTag.setTitle("@\(status.reblog?.account.username ?? status.account.username)", for: .normal)
        }
        if (UserDefaults.standard.object(forKey: "timerel") == nil) || (UserDefaults.standard.object(forKey: "timerel") as! Int == 0) {
            date.text = status.reblog?.createdAt.toStringWithRelativeTime() ?? status.createdAt.toStringWithRelativeTime()
        } else {
            date.text = status.reblog?.createdAt.toString(dateStyle: .short, timeStyle: .short) ?? status.createdAt.toString(dateStyle: .short, timeStyle: .short)
        }
        
        
        //TODO: did I remove these? Add them back on after figuring out why they don't work
//        let viewsDict = [
//            "warning" : warningB,
//            ]
//        if status.reblog?.content.stripHTML() != nil {
//            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-46-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
//        } else {
//            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-54-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
//        }
        
        
        
        if status.reblog?.content.stripHTML() != nil {
            var theUsernameTag = status.account.displayName
            if (UserDefaults.standard.object(forKey: "boostusern") == nil) || (UserDefaults.standard.object(forKey: "boostusern") as! Int == 0) {
                
            } else {
                theUsernameTag = "@\(status.account.acct)"
            }
            
            if status.reblog!.emojis.isEmpty {
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.content.stripHTML() ?? "")\n\n")
                //Somehow I have to remove the \n\n above when there is no reblog content, or there will be extra spaces between
                //the user+text and the image
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"boost2")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: Int(self.toot.font.lineHeight - 5), height: Int(self.toot.font.lineHeight))
                let attachmentString2 = NSAttributedString(attachment: imageAttachment)
                let completeText2 = NSMutableAttributedString(string: "")
                completeText2.append(attachmentString2)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colours.black, range: NSMakeRange(0, attributedString.length))
                // This seems to be used for some kind of "Quote Tweet", but it's not very developed in Pleroma yet
                // I'm removing the boost author name because it makes no sense as is now to add this.
                // I'm also skipping  adding the text if there's nothing in the completeText2
                // let textAfterIcon2 = NSMutableAttributedString(string: " \(theUsernameTag)", attributes: [NSAttributedString.Key.foregroundColor: Colours.grayDark.withAlphaComponent(0.38)])
                // completeText2.append(textAfterIcon2)
                attributedString.append(completeText2)
                self.toot.attributedText = attributedString
                
                self.reloadInputViews()
            } else {
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.content.stripHTML() ?? "")\n\n", attributes: [NSAttributedString.Key.foregroundColor: Colours.black])
                status.reblog!.emojis.map({
                    let textAttachment = NSTextAttachment()
                    textAttachment.loadImageUsingCache(withUrl: $0.url.absoluteString)
                    textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.toot.font.lineHeight), height: Int(self.toot.font.lineHeight))
                    let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                    while attributedString.mutableString.contains(":\($0.shortcode):") {
                        let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\($0.shortcode):")
                        attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                    }
                })
                
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"boost2")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: Int(self.toot.font.lineHeight - 5), height: Int(self.toot.font.lineHeight))
                let attachmentString2 = NSAttributedString(attachment: imageAttachment)
                let completeText2 = NSMutableAttributedString(string: "")
                completeText2.append(attachmentString2)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colours.black, range: NSMakeRange(0, attributedString.length))
                
                // This seems to be used for some kind of "Quote Tweet", but it's not very developed in Pleroma yet
                // I'm removing the boost author name because it makes no sense as is now to add this.
                // I'm also skipping  adding the text if there's nothing in the completeText2
                // let textAfterIcon2 = NSMutableAttributedString(string: " \(theUsernameTag)", attributes: [NSAttributedString.Key.foregroundColor: Colours.grayDark.withAlphaComponent(0.38)])
                // completeText2.append(textAfterIcon2)
                if completeText2.length > 0 {
                    //Avoid the extra spacing without nuking the functionality
                    attributedString.append(completeText2)
                    self.toot.attributedText = attributedString
                }
                self.reloadInputViews()
            }
            
            if status.reblog?.account.emojis.isEmpty ?? true {
                let completeText = NSMutableAttributedString(string: "")
                let textAfterIcon = NSMutableAttributedString(string: "\(status.reblog?.account.displayName.stripHTML() ?? "")")
                completeText.append(textAfterIcon)
                userName.attributedText = completeText
            } else {
                let completeText = NSMutableAttributedString(string: "")
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.account.displayName.stripHTML() ?? "")")
                (status.reblog?.account.emojis ?? []).map({
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
                completeText.append(attributedString)
                self.userName.attributedText = completeText
                self.reloadInputViews()
            }



            profileImageView2.pin_setPlaceholder(with: UIImage(named: "logo"))
            profileImageView2.pin_updateWithProgress = true
            profileImageView2.pin_setImage(from: URL(string: "\(status.account.avatar)"))
            profileImageView2.layer.masksToBounds = true
            profileImageView2.layer.borderColor = Colours.white.cgColor
            profileImageView2.layer.borderWidth = 2
            profileImageView2.alpha = 1
            if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
                profileImageView2.layer.cornerRadius = 13
            }
            if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
                profileImageView2.layer.cornerRadius = 4
            }
            if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
                profileImageView2.layer.cornerRadius = 0
            }
        } else {



            if status.emojis.isEmpty {
                toot.text = status.content.stripHTML()
            } else {
                let attributedString = NSMutableAttributedString(string: status.content.stripHTML())
                status.emojis.map({
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


            profileImageView2.pin_setPlaceholder(with: UIImage(named: "logo2345"))
            profileImageView2.layer.masksToBounds = true
            profileImageView2.layer.borderColor = UIColor.black.cgColor
            profileImageView2.layer.borderWidth = 1
            profileImageView2.alpha = 0
            if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
                profileImageView2.layer.cornerRadius = 13
            }
            if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
                profileImageView2.layer.cornerRadius = 4
            }
            if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
                profileImageView2.layer.cornerRadius = 0
            }
        }
        profileImageView2.isUserInteractionEnabled = false
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)

        DispatchQueue.global(qos: .userInitiated).async {
        self.profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
        self.profileImageView.pin_updateWithProgress = true
        self.profileImageView.pin_setImage(from: URL(string: "\(status.reblog?.account.avatar ?? status.account.avatar)"))
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
        mainImageView.clipsToBounds = true
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.borderColor = UIColor.black.cgColor
        if (UserDefaults.standard.object(forKey: "imCorner") == nil || UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
            mainImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "imCorner") != nil && UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
            mainImageView.layer.cornerRadius = 0
        }


        self.moreImage.contentMode = .scaleAspectFit
        if (status.reblog?.favourited ?? status.favourited ?? false) && (status.reblog?.reblogged ?? status.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
            StoreStruct.allLikes.append(status.id)
            StoreStruct.allBoosts.append(status.id)
        } else if status.reblog?.reblogged ?? status.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
            StoreStruct.allBoosts.append(status.id)
        } else if (status.reblog?.favourited ?? status.favourited ?? false) || StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) {
            self.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
            StoreStruct.allLikes.append(status.id)
        } else {
            if status.reblog?.poll ?? status.poll != nil {
                self.moreImage.image = UIImage(named: "pollbubble")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
            } else {

            if status.reblog?.visibility ?? status.visibility == .direct {
                self.moreImage.image = UIImage(named: "direct")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
            } else if status.reblog?.visibility ?? status.visibility == .unlisted {
                self.moreImage.image = UIImage(named: "unlisted")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
            } else if status.reblog?.visibility ?? status.visibility == .private {
                self.moreImage.image = UIImage(named: "private")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
            } else {
                self.moreImage.image = nil
            }

            }
        }
        
        StoreStruct.allLikes = StoreStruct.allLikes.removeDuplicates()
        StoreStruct.allBoosts = StoreStruct.allBoosts.removeDuplicates()
            
        
        
        if (UserDefaults.standard.object(forKey: "senseTog") == nil) || (UserDefaults.standard.object(forKey: "senseTog") as! Int == 0) {

            if status.reblog?.sensitive ?? false || status.sensitive ?? false {
                warningB.backgroundColor = Colours.tabUnselected
                
                let z = status.reblog?.spoilerText ?? status.spoilerText
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
        if status.reblog?.mediaAttachments.isEmpty ?? status.mediaAttachments.isEmpty { return }
        if status.reblog?.mediaAttachments[0].type ?? status.mediaAttachments[0].type == .video {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            self.mainImageView.contentMode = .scaleAspectFit
            self.mainImageView.imageView?.contentMode = .scaleAspectFit
//            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
//            }
            imageCountTag.setTitle("\u{25b6}", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.reblog?.mediaAttachments[0].type ?? status.mediaAttachments[0].type == .gifv {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            self.mainImageView.contentMode = .scaleAspectFit
            self.mainImageView.imageView?.contentMode = .scaleAspectFit
//            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
                
//                DispatchQueue.main.async {
//                    self.animatedImageView.frame = self.mainImageView.frame
//                    self.mainImageView.addSubview(self.animatedImageView)
//                    self.animatedImageView.sd_setImage(with: URL(string: "\(status.reblog?.mediaAttachments[0].url ?? status.mediaAttachments[0].url)"))
//                }
                
//            }
            imageCountTag.setTitle("GIF", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count > 1 {
            self.mainImageView.imageView?.image = nil
            self.mainImageView.setImage(nil, for: .normal)
//            self.mainImageView.imageView?.image = UIImage()
            if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count == 2 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (tempWid - 73)/2, height: 200)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
//                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
//                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (tempWid - 73)/2 + 2, y: 0, width: (tempWid - 73)/2, height: 200)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
//                    DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
//                    }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
            } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count == 3 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (tempWid - 73)/2, height: 200)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
//                    DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
//                    }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (tempWid - 73)/2 + 2, y: -2, width: (tempWid - 73)/2, height: 100)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
//                    DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
//                    }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
                
                self.smallImage3.frame = CGRect(x: (tempWid - 73)/2 + 2, y: 102, width: (tempWid - 73)/2, height: 100)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
//                    DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[2].previewURL ?? status.mediaAttachments[2].previewURL)"))
//                    }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
            } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count >= 4 {
                self.smallImage1.frame = CGRect(x: -2, y: -2, width: (tempWid - 73)/2, height: 100)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
//                    DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
//                    }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (tempWid - 73)/2 + 2, y: -2, width: (tempWid - 73)/2, height: 100)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
//                    DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
//                    }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
                
                self.smallImage3.frame = CGRect(x: -2, y: 102, width: (tempWid - 73)/2, height: 100)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
//                    DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[2].previewURL ?? status.mediaAttachments[2].previewURL)"))
//                    }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
                
                self.smallImage4.frame = CGRect(x: (tempWid - 73)/2 + 2, y: 102, width: (tempWid - 73)/2, height: 100)
                self.smallImage4.contentMode = .scaleAspectFill
                self.smallImage4.imageView?.contentMode = .scaleAspectFill
                self.smallImage4.clipsToBounds = true
//                    DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage4.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage4.pin_updateWithProgress = true
                self.smallImage4.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[3].previewURL ?? status.mediaAttachments[3].previewURL)"))
//                    }
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
        } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count > 1 {
            imageCountTag.setTitle("\(status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count)", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
            imageCountTag.bringSubviewToFront(self)
        } else {
            imageCountTag.backgroundColor = Colours.clear
            imageCountTag.alpha = 0
//            DispatchQueue.global(qos: .userInitiated).async {
            self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
            self.mainImageView.pin_updateWithProgress = true
            self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].url ?? status.mediaAttachments[0].url)"))
//            }
        }
    }
    
    func configure0(_ status: Status) {
        self.moreImage.contentMode = .scaleAspectFit
        if (status.reblog?.favourited ?? status.favourited ?? false) && (status.reblog?.reblogged ?? status.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
            StoreStruct.allLikes.append(status.id)
            StoreStruct.allBoosts.append(status.id)
        } else if status.reblog?.reblogged ?? status.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
            StoreStruct.allBoosts.append(status.id)
        } else if (status.reblog?.favourited ?? status.favourited ?? false) || StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) {
            self.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
            StoreStruct.allLikes.append(status.id)
        } else {
            if status.reblog?.poll ?? status.poll != nil {
                self.moreImage.image = UIImage(named: "pollbubble")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
            } else {
                
                if status.reblog?.visibility ?? status.visibility == .direct {
                    self.moreImage.image = UIImage(named: "direct")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
                } else if status.reblog?.visibility ?? status.visibility == .unlisted {
                    self.moreImage.image = UIImage(named: "unlisted")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
                } else if status.reblog?.visibility ?? status.visibility == .private {
                    self.moreImage.image = UIImage(named: "private")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
                } else {
                    self.moreImage.image = nil
                }
                
            }
        }
        
        StoreStruct.allLikes = StoreStruct.allLikes.removeDuplicates()
        StoreStruct.allBoosts = StoreStruct.allBoosts.removeDuplicates()
        
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {} else {
            var repc1 = "\(status.reblog?.repliesCount ?? status.repliesCount)"
            if repc1 == "0" {
                repc1 = ""
            }
            var likec1 = "\(status.reblog?.favouritesCount ?? status.favouritesCount)"
            if likec1 == "0" {
                likec1 = ""
            }
            var boostc1 = "\(status.reblog?.reblogsCount ?? status.reblogsCount)"
            if boostc1 == "0" {
                boostc1 = ""
            }
            replyBtn.setTitle(repc1, for: .normal)
            replyBtn.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            replyBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            replyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            replyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            likeBtn.setTitle(likec1, for: .normal)
            likeBtn.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            likeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            likeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            likeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            boostBtn.setTitle(boostc1, for: .normal)
            boostBtn.setTitleColor(Colours.grayDark.withAlphaComponent(0.21), for: .normal)
            boostBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            boostBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            boostBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
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
