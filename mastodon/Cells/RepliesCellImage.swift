//
//  RepliesCellImage.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class RepliesCellImage: SwipeTableViewCell {

    var profileImageView = UIButton()
    var userName = UILabel()
    var userTag = UIButton()
    var date = UILabel()
    var toot = ActiveLabel()
    var mainImageView = UIButton()
    var mainImageViewBG = UIView()
    var moreImage = UIImageView()
    var imageCountTag = UIButton()

    var smallImage1 = UIButton()
    var smallImage2 = UIButton()
    var smallImage3 = UIButton()
    var smallImage4 = UIButton()
    var warningB = MultiLineButton()
    var indi = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.clear
        moreImage.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        
        indi.backgroundColor = Colours.tabSelected
        indi.layer.cornerRadius = 1
        
//        userName.adjustsFontForContentSizeCategory = true
//        userTag.titleLabel?.adjustsFontForContentSizeCategory = true
//        date.adjustsFontForContentSizeCategory = true
//        toot.adjustsFontForContentSizeCategory = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageViewBG.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        moreImage.translatesAutoresizingMaskIntoConstraints = false
        warningB.translatesAutoresizingMaskIntoConstraints = false
        indi.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0
        
        warningB.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        warningB.titleLabel?.textAlignment = .center
        warningB.setTitleColor(Colours.black.withAlphaComponent(0.4), for: .normal)
        warningB.layer.cornerRadius = 7
        warningB.titleLabel?.font = UIFont.boldSystemFont(ofSize: Colours.fontSize3)
        warningB.titleLabel?.numberOfLines = 0
        warningB.layer.masksToBounds = true
        
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
        contentView.addSubview(mainImageViewBG)
        contentView.addSubview(mainImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        contentView.addSubview(warningB)
        contentView.addSubview(indi)
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure2(_ replyDepth: Int) {
        //        let contentViewFrame = self.contentView.frame
        //        let insetContentViewFrame = contentViewFrame.inset(by: UIEdgeInsets(top: 0, left: -CGFloat(replyDepth), bottom: 0, right: 0))
        //        self.contentView.bounds = insetContentViewFrame
        
//        let depth = replyDepth/30
//        if depth == 0 {
//            self.indi.backgroundColor = Colours.tabSelected
//            self.indi2.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//            self.indi3.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//            self.indi4.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//            self.indi5.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//        } else if depth == 1 {
//            self.indi.backgroundColor = Colours.tabSelected
//            self.indi2.backgroundColor = Colours.tabSelected
//            self.indi3.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//            self.indi4.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//            self.indi5.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//        } else if depth == 2 {
//            self.indi.backgroundColor = Colours.tabSelected
//            self.indi2.backgroundColor = Colours.tabSelected
//            self.indi3.backgroundColor = Colours.tabSelected
//            self.indi4.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//            self.indi5.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//        } else if depth == 3 {
//            self.indi.backgroundColor = Colours.tabSelected
//            self.indi2.backgroundColor = Colours.tabSelected
//            self.indi3.backgroundColor = Colours.tabSelected
//            self.indi4.backgroundColor = Colours.tabSelected
//            self.indi5.backgroundColor = Colours.grayDark.withAlphaComponent(0.21)
//        } else {
//            self.indi.backgroundColor = Colours.tabSelected
//            self.indi2.backgroundColor = Colours.tabSelected
//            self.indi3.backgroundColor = Colours.tabSelected
//            self.indi4.backgroundColor = Colours.tabSelected
//            self.indi5.backgroundColor = Colours.tabSelected
//        }
        
        let viewsDict = [
            "image" : profileImageView,
            "mainImage" : mainImageView,
            "mainImageBG" : mainImageViewBG,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            "countTag" : imageCountTag,
            "warning" : warningB,
            "indi" : indi,
        ]
        
        var repdep = replyDepth
        if (UserDefaults.standard.object(forKey: "indent1") == nil) || (UserDefaults.standard.object(forKey: "indent1") as! Int == 0) {
            
        } else {
            repdep = 0
        }
        
        let metrics = [
            "first": 29 + repdep,
            "second": 10 + repdep,
            "third": 61 + repdep,
            "fourth": 63 + repdep,
            "fifth": 73 + repdep,
        ]
        
//        contentView.constraints.map({
//            contentView.removeConstraint($0)
//        })
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-HorizontalFirstIndi$", withVisualFormat: "H:|-first-[indi(2)]", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-second-[image(40)]-13-[name]-2-[artist]-(>=5)-[more(16)]-4-[date]-12-|", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-HorizontalSecondImage40Episodes$", withVisualFormat: "H:|-second-[image(40)]-13-[episodes]-12-|", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-HorizontalFourthMainImage$", withVisualFormat: "H:|-fourth-[mainImage]-12-|", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-HorizontalFifthMainImageBG$", withVisualFormat: "H:|-fifth-[mainImageBG]-20-|", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-HorizontalCountTag$", withVisualFormat: "H:|-5-[countTag(30)]-(>=12)-|", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-HorizontalThirdWarning$", withVisualFormat: "H:|-third-[warning]-9-|", options: [], metrics: metrics, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalIndi$", withVisualFormat: "V:|-64-[indi(>=0)]-16-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalMore$", withVisualFormat: "V:|-18-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalDate$", withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalArtist$", withVisualFormat: "V:|-12-[artist]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalImage40$", withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalNameEpisodesMainImage$", withVisualFormat: "V:|-18-[name]-1-[episodes]-10-[mainImage(210)]-23-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalNameEpisodesMainImageBG$", withVisualFormat: "V:|-18-[name]-1-[episodes]-10-[mainImageBG(210)]-23-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalCountTag22", withVisualFormat: "V:|-5-[countTag(22)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCellImage-VerticalNameWarning$", withVisualFormat: "V:|-18-[name]-1-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
        
//        contentView.layoutSubviews()
    }
    
    func configure(_ status: Status) {

        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        warningB.backgroundColor = Colours.clear
        
        userName.text = status.account.displayName
        if userName.text == "" {
            userName.text = " "
        }
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
//        DispatchQueue.global(qos: .userInitiated).async {
        self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
        self.mainImageView.pin_updateWithProgress = true
//        }
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.borderColor = UIColor.black.cgColor
        if (UserDefaults.standard.object(forKey: "imCorner") == nil || UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
            mainImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "imCorner") != nil && UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
            mainImageView.layer.cornerRadius = 0
        }
        //mainImageView.layer.borderWidth = 0.2
        
        self.moreImage.contentMode = .scaleAspectFit
        if (status.reblog?.favourited ?? status.favourited ?? false) && (status.reblog?.reblogged ?? status.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
        } else if status.reblog?.reblogged ?? status.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
        } else if (status.reblog?.favourited ?? status.favourited ?? false) || StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) {
            self.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
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



        imageCountTag.isUserInteractionEnabled = false
        if status.mediaAttachments[0].type == .video {
            imageCountTag.setTitle("\u{25b6}", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
            self.mainImageView.pin_setImage(from: URL(string: "\(status.mediaAttachments[0].previewURL)"))
        } else if status.mediaAttachments[0].type == .gifv {
            imageCountTag.setTitle("GIF", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
            self.mainImageView.pin_setImage(from: URL(string: "\(status.mediaAttachments[0].previewURL)"))
        } else if status.mediaAttachments.count > 1 {
            imageCountTag.setTitle("\(status.mediaAttachments.count)", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
            self.mainImageView.pin_setImage(from: URL(string: "\(status.mediaAttachments[0].url)"))
        } else {
            imageCountTag.backgroundColor = Colours.clear
            imageCountTag.alpha = 0
            self.mainImageView.pin_setImage(from: URL(string: "\(status.mediaAttachments[0].url)"))
        }
        
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
        
    }
    
    func configure0(_ status: Status) {
        self.moreImage.contentMode = .scaleAspectFit
        if (status.reblog?.favourited ?? status.favourited ?? false) && (status.reblog?.reblogged ?? status.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
        } else if status.reblog?.reblogged ?? status.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
        } else if (status.reblog?.favourited ?? status.favourited ?? false) || StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) {
            self.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
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
