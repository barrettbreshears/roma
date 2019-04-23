//
//  DMFeedCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 29/03/2019.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class DMFeedCell: SwipeTableViewCell {
    
    var profileImageView = UIButton()
    var profileImageView2 = UIButton()
    var warningB = UIButton()
    var userName = UILabel()
    var userTag = UIButton()
    var date = UILabel()
    var toot = ActiveLabel()
    var moreImage = UIImageView()
    var readIndi = UIView()
    
    var rep1 = UIButton()
    var like1 = UIButton()
    var boost1 = UIButton()
    var more1 = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.clear
        profileImageView2.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        moreImage.backgroundColor = Colours.clear
        
//        userName.adjustsFontForContentSizeCategory = true
//        userTag.titleLabel?.adjustsFontForContentSizeCategory = true
//        date.adjustsFontForContentSizeCategory = true
//        toot.adjustsFontForContentSizeCategory = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView2.translatesAutoresizingMaskIntoConstraints = false
        warningB.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        moreImage.translatesAutoresizingMaskIntoConstraints = false
        readIndi.translatesAutoresizingMaskIntoConstraints = false
        
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
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = warningB.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false
        warningB.addSubview(blurEffectView)
        warningB.sendSubviewToBack(blurEffectView)
        
        userName.numberOfLines = 1
        date.numberOfLines = 1
        date.textAlignment = .right
        userName.textColor = Colours.black
        userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
        date.textColor = Colours.black.withAlphaComponent(0.6)
        toot.textColor = Colours.black
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        toot.numberOfLines = 2
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        readIndi.backgroundColor = Colours.tabSelected
        readIndi.layer.cornerRadius = 4
        readIndi.layer.masksToBounds = true
        readIndi.alpha = 0
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileImageView2)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        contentView.addSubview(readIndi)
        
        
        rep1.translatesAutoresizingMaskIntoConstraints = false
        rep1.setImage(UIImage(named: "reply3")?.maskWithColor(color: Colours.gray), for: .normal)
        rep1.backgroundColor = UIColor.clear
        rep1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            self.rep1.alpha = 0
        } else {
            self.rep1.alpha = 1
        }
        like1.translatesAutoresizingMaskIntoConstraints = false
        like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
        like1.backgroundColor = UIColor.clear
        like1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            self.like1.alpha = 0
        } else {
            self.like1.alpha = 1
        }
        boost1.translatesAutoresizingMaskIntoConstraints = false
        boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
        boost1.backgroundColor = UIColor.clear
        boost1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            self.boost1.alpha = 0
        } else {
            self.boost1.alpha = 1
        }
        more1.translatesAutoresizingMaskIntoConstraints = false
        more1.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.gray), for: .normal)
        more1.backgroundColor = UIColor.clear
        more1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
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
            "image2" : profileImageView2,
            "warning" : warningB,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            "rep1" : rep1,
            "like1" : like1,
            "boost1" : boost1,
            "more1" : more1,
            "readIndi" : readIndi,
        ]
        
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[readIndi(8)]-5-[image(40)]-13-[name]-5-[artist]-(>=5)-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-43-[image2(26)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[readIndi(8)]-5-[image(40)]-13-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[image2(26)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-28-[readIndi(8)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-5-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[artist]-5-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
        } else {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-5-[episodes]-15-[rep1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[artist]-5-[episodes]-15-[rep1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-15-[rep1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-15-[like1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-15-[boost1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-15-[more1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-73-[rep1(36)]-24-[like1(40)]-15-[boost1(40)]-24-[more1(20)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
        }
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-74-[warning]-17-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.profileImageView.imageView?.image = nil
        self.profileImageView2.imageView?.image = nil
    }
    
    func configure2(_ unread: Bool, id: String) {
        if StoreStruct.markedReadIDs.contains(id) {
            self.readIndi.alpha = 0
        } else {
            if unread {
                self.readIndi.alpha = 1
            } else {
                self.readIndi.alpha = 0
            }
        }
    }
    
    func configure(_ status: Status) {
        
        userName.textColor = Colours.black
        userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
        date.textColor = Colours.black.withAlphaComponent(0.6)
        toot.textColor = Colours.black
        
        rep1.setImage(UIImage(named: "reply3")?.maskWithColor(color: Colours.gray), for: .normal)
        more1.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.gray), for: .normal)
        if StoreStruct.allBoosts.contains(status.reblog?.id ?? status.id) || status.reblog?.reblogged ?? status.reblogged ?? false {
            boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
        } else {
            boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
        }
        if StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) || status.reblog?.favourited ?? status.favourited ?? false {
            like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
        } else {
            like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
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
            rep1.setTitle(repc1, for: .normal)
            rep1.setTitleColor(Colours.grayDark.withAlphaComponent(0.4), for: .normal)
            rep1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rep1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            rep1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            like1.setTitle(likec1, for: .normal)
            like1.setTitleColor(Colours.grayDark.withAlphaComponent(0.4), for: .normal)
            like1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            like1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            like1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            boost1.setTitle(boostc1, for: .normal)
            boost1.setTitleColor(Colours.grayDark.withAlphaComponent(0.4), for: .normal)
            boost1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            boost1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            boost1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
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
        
        
        
        //        let viewsDict = [
        //            "warning" : warningB,
        //            ]
        //        if status.reblog?.content.stripHTML() != nil {
        //            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-46-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
        //        } else {
        //            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-54-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
        //        }
        
        
        
        if status.reblog?.content.stripHTML() != nil {
            
            
            
            
            if status.reblog!.emojis.isEmpty {
                toot.text = "\(status.reblog?.content.stripHTML() ?? "")".replace("@\(StoreStruct.currentUser.acct) ", with: "").replace("@\(StoreStruct.currentUser.acct)\n", with: "").replace("@\(StoreStruct.currentUser.acct)", with: "")
            } else {
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.content.stripHTML() ?? "")")
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
                self.toot.attributedText = attributedString
                self.reloadInputViews()
            }
            
            var theUsernameTag = status.account.displayName
            if (UserDefaults.standard.object(forKey: "boostusern") == nil) || (UserDefaults.standard.object(forKey: "boostusern") as! Int == 0) {
                
            } else {
                theUsernameTag = "@\(status.account.acct)"
            }
            
            if status.reblog?.account.emojis.isEmpty ?? true {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"boost")
                imageAttachment.bounds = CGRect(x: 0, y: -3, width: Int(self.userName.font.lineHeight), height: Int(self.userName.font.lineHeight))
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                let completeText = NSMutableAttributedString(string: "")
                completeText.append(attachmentString)
                let textAfterIcon = NSMutableAttributedString(string: " \(theUsernameTag) boosted\n\n\(status.reblog?.account.displayName.stripHTML() ?? "")")
                completeText.append(textAfterIcon)
                userName.attributedText = completeText
            } else {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"boost")
                imageAttachment.bounds = CGRect(x: 0, y: -3, width: Int(self.userName.font.lineHeight), height: Int(self.userName.font.lineHeight))
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                let completeText = NSMutableAttributedString(string: "")
                completeText.append(attachmentString)
                let attributedString = NSMutableAttributedString(string: " \(theUsernameTag) boosted\n\n\(status.reblog?.account.displayName.stripHTML() ?? "")")
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
                completeText.append(attributedString)
                self.userName.attributedText = completeText
                self.reloadInputViews()
            }
            
            
            
            
            profileImageView2.pin_setPlaceholder(with: UIImage(named: "logo"))
            profileImageView2.pin_updateWithProgress = true
            profileImageView2.pin_setImage(from: URL(string: "\(status.account.avatar)"))
            profileImageView2.layer.masksToBounds = true
            profileImageView2.layer.borderColor = Colours.clear.cgColor
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
                toot.text = status.content.stripHTML().replace("@\(StoreStruct.currentUser.acct) ", with: "").replace("@\(StoreStruct.currentUser.acct)\n", with: "").replace("@\(StoreStruct.currentUser.acct)", with: "")
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
                self.toot.attributedText = attributedString
                self.reloadInputViews()
            }
            
            
            
            if status.account.emojis.isEmpty {
                userName.text = status.account.displayName.stripHTML()
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
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
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
        
        self.moreImage.contentMode = .scaleAspectFit
        if (status.reblog?.favourited ?? status.favourited ?? false) && (status.reblog?.reblogged ?? status.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")
        } else if status.reblog?.reblogged ?? status.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost")
        } else if (status.reblog?.favourited ?? status.favourited ?? false) || StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) {
            self.moreImage.image = UIImage(named: "like")
        } else {
            if status.reblog?.poll ?? status.poll != nil {
                self.moreImage.image = UIImage(named: "list")
            } else {
                
                if status.reblog?.visibility ?? status.visibility == .direct {
                    self.moreImage.image = UIImage(named: "direct")
                } else if status.reblog?.visibility ?? status.visibility == .unlisted {
                    self.moreImage.image = UIImage(named: "unlisted")
                } else if status.reblog?.visibility ?? status.visibility == .private {
                    self.moreImage.image = UIImage(named: "private")
                } else {
                    self.moreImage.image = nil
                }
                
            }
        }
        
        
        if (UserDefaults.standard.object(forKey: "senseTog") == nil) || (UserDefaults.standard.object(forKey: "senseTog") as! Int == 0) {
            
            if status.reblog?.sensitive ?? false || status.sensitive ?? false {
                warningB.backgroundColor = Colours.clear
                
                let z = status.reblog?.spoilerText ?? status.spoilerText
                var zz = "Sensitive Content"
                if z == "" {} else {
                    zz = z
                }
                warningB.setTitle("\(zz)", for: .normal)
                warningB.setTitleColor(Colours.white, for: .normal)
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
    
    @objc func didTouchWarning() {
        warningB.backgroundColor = Colours.clear
        warningB.alpha = 0
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
    }
    
}
