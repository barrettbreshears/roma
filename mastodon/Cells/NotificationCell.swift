//
//  NotificationCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 21/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class NotificationCell: SwipeTableViewCell {

    var profileImageView = UIButton()
    var typeImage = UIButton()
    var userName = UILabel()
    var userTag = UIButton()
    var date = UILabel()
    var toot = ActiveLabel()
    var moreImage = UIImageView()
    var warningB = MultiLineButton()
    
    var rep1 = UIButton()
    var like1 = UIButton()
    var boost1 = UIButton()
    var more1 = UIButton()

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
        profileImageView.layer.masksToBounds = true
        typeImage.layer.cornerRadius = 0
        typeImage.layer.masksToBounds = true


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
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)



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
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            "warning" : warningB,
            "rep1" : rep1,
            "like1" : like1,
            "boost1" : boost1,
            "more1" : more1,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[name]-2-[artist]-(>=5)-[more(16)]-4-[date]-10-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[episodes]-10-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[type(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
            
            if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[name]-2-[episodes]-18-|", options: [], metrics: nil, views: viewsDict))
            } else {
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[name]-2-[episodes]-15-[rep1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[name]-2-[episodes]-15-[like1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[name]-2-[episodes]-15-[boost1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[name]-2-[episodes]-15-[more1(20)]-18-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-107-[rep1(36)]-20-[like1(40)]-11-[boost1(34)]-24-[more1(20)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
            }
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[artist]-0-[episodes]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-101-[warning]-7-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[name]-1-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.profileImageView.imageView?.image = nil
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
            rep1.alpha = 0
            like1.alpha = 0
            boost1.alpha = 0
            more1.alpha = 0
            profileImageView.isUserInteractionEnabled = true
            userName.text = "\(status.account.displayName) liked"
            typeImage.setImage(UIImage(named: "like3"), for: .normal)
            if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                toot.textColor = Colours.black
                userName.textColor = Colours.black
                userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                date.textColor = Colours.grayDark.withAlphaComponent(0.38)
            } else {
                toot.textColor = Colours.black.withAlphaComponent(0.3)
                userName.textColor = Colours.black.withAlphaComponent(0.3)
                userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                date.textColor = Colours.grayDark.withAlphaComponent(0.38)
            }
        }
        if status.type == .reblog {
            rep1.alpha = 0
            like1.alpha = 0
            boost1.alpha = 0
            more1.alpha = 0
            profileImageView.isUserInteractionEnabled = true
            userName.text = "\(status.account.displayName) reposted"
            typeImage.setImage(UIImage(named: "boost3"), for: .normal)
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
                self.boost1.alpha = 0
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
            rep1.alpha = 0
            like1.alpha = 0
            boost1.alpha = 0
            more1.alpha = 0
            profileImageView.isUserInteractionEnabled = false
            userName.text = "\(status.account.displayName) followed you"
            typeImage.setImage(UIImage(named: "follow3")?.maskWithColor(color: Colours.redBright), for: .normal)
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

//        toot.text = status.status?.content.stripHTML() ?? status.account.note.stripHTML()





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

class MultiLineButton: UIButton {
    func setup() {
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.setContentHuggingPriority(UILayoutPriority.defaultLow + 5, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriority.defaultLow + 5, for: .horizontal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        let size = self.titleLabel!.intrinsicContentSize
        return CGSize(width: size.width + 10, height: size.height + 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = self.titleLabel!.frame.size.width - 10
    }
}
