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
    var warningB = UIButton()

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

        profileImageView.backgroundColor = Colours.white
        typeImage.backgroundColor = Colours.white
        moreImage.backgroundColor = Colours.white
        warningB.backgroundColor = Colours.white
        
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
        mainImageView.backgroundColor = Colours.white
        mainImageViewBG.layer.cornerRadius = 10
        mainImageViewBG.backgroundColor = Colours.white
        mainImageViewBG.layer.shadowColor = UIColor.black.cgColor
        mainImageViewBG.layer.shadowOffset = CGSize(width: 0, height: 7)
        mainImageViewBG.layer.shadowRadius = 10
        mainImageViewBG.layer.shadowOpacity = 0.22
        mainImageViewBG.layer.masksToBounds = false


        warningB.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        warningB.titleLabel?.textAlignment = .center
        warningB.setTitleColor(Colours.black.withAlphaComponent(0.4), for: .normal)
        warningB.layer.cornerRadius = 7
        warningB.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        warningB.titleLabel?.numberOfLines = 0
        warningB.layer.masksToBounds = true

        userName.numberOfLines = 0
        toot.numberOfLines = 0

        userName.textColor = Colours.black
        userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
        date.textColor = Colours.black.withAlphaComponent(0.6)
        toot.textColor = Colours.black


        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)

        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected

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
        rep1.setImage(UIImage(named: "reply3")?.maskWithColor(color: Colours.gray), for: .normal)
        rep1.backgroundColor = Colours.white
        rep1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.rep1.alpha = 0
        } else {
            self.rep1.alpha = 1
        }
        like1.translatesAutoresizingMaskIntoConstraints = false
        like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
        like1.backgroundColor = Colours.white
        like1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.like1.alpha = 0
        } else {
            self.like1.alpha = 1
        }
        boost1.translatesAutoresizingMaskIntoConstraints = false
        boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
        boost1.backgroundColor = Colours.white
        boost1.layer.masksToBounds = true
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
            self.boost1.alpha = 0
        } else {
            self.boost1.alpha = 1
        }
        more1.translatesAutoresizingMaskIntoConstraints = false
        more1.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.gray), for: .normal)
        more1.backgroundColor = Colours.white
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

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[name]-(>=5)-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[artist]-(>=5)-[more(16)]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-107-[mainImage]-20-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-121-[mainImageBG]-30-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-2-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[type(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))


            if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImage(160)]-23-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImageBG(160)]-23-|", options: [], metrics: nil, views: viewsDict))
            } else {
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImage(160)]-23-[rep1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImageBG(160)]-23-[rep1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImageBG(160)]-23-[like1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImageBG(160)]-23-[boost1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImageBG(160)]-23-[more1(20)]-12-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-107-[rep1(36)]-20-[like1(40)]-15-[boost1(40)]-24-[more1(20)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
            }

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[countTag(30)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[countTag(22)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-105-[warning]-17-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
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
        self.profileImageView.imageView?.image = nil
        self.mainImageView.imageView?.image = nil
        self.mainImageView.imageView?.image = UIImage()
        self.smallImage1.imageView?.image = nil
        self.smallImage2.imageView?.image = nil
        self.smallImage3.imageView?.image = nil
        self.smallImage4.imageView?.image = nil
    }

    func configure(_ status: Notificationt) {
        
        profileImageView.backgroundColor = Colours.white
        typeImage.backgroundColor = Colours.white
        moreImage.backgroundColor = Colours.white
        warningB.backgroundColor = Colours.white
        rep1.backgroundColor = Colours.white
        like1.backgroundColor = Colours.white
        boost1.backgroundColor = Colours.white
        more1.backgroundColor = Colours.white
        
        rep1.setImage(UIImage(named: "reply3")?.maskWithColor(color: Colours.gray), for: .normal)
        more1.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.gray), for: .normal)
        if StoreStruct.allBoosts.contains(status.status?.reblog?.id ?? status.status?.id ?? "") || status.status?.reblogged ?? false {
            boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
        } else {
            boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
        }
        if StoreStruct.allLikes.contains(status.status?.reblog?.id ?? status.status?.id ?? "") || status.status?.favourited ?? false {
            like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
        } else {
            like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
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
                userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
                date.textColor = Colours.black.withAlphaComponent(0.6)
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
                userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
                date.textColor = Colours.black.withAlphaComponent(0.6)
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
            userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
            date.textColor = Colours.black.withAlphaComponent(0.6)
            userName.text = "\(status.account.displayName) mentioned you"
            if status.status?.visibility == .direct {
                typeImage.setImage(UIImage(named: "direct")?.maskWithColor(color: Colours.purple), for: .normal)
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
            typeImage.setImage(UIImage(named: "follow3"), for: .normal)
            //toot.textColor = Colours.black.withAlphaComponent(0.3)
            if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                toot.textColor = Colours.black
                userName.textColor = Colours.black
                userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
                date.textColor = Colours.black.withAlphaComponent(0.6)
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
            for y in (status.status?.emojis)! {
                let textAttachment = NSTextAttachment()
                textAttachment.loadImageUsingCache(withUrl: y.url.absoluteString)
                textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.toot.font.lineHeight), height: Int(self.toot.font.lineHeight))
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                while attributedString.mutableString.contains(":\(y.shortcode):") {
                    let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\(y.shortcode):")
                    attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                }
            }
            self.toot.attributedText = attributedString
            self.reloadInputViews()
        }




        if status.account.emojis.isEmpty {
            userName.text = status.account.displayName.stripHTML()
        } else {
            let attributedString = NSMutableAttributedString(string: status.account.displayName.stripHTML())
            for y in status.account.emojis {
                let textAttachment = NSTextAttachment()
                textAttachment.loadImageUsingCache(withUrl: y.url.absoluteString)
                textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.userName.font.lineHeight), height: Int(self.userName.font.lineHeight))
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                while attributedString.mutableString.contains(":\(y.shortcode):") {
                    let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\(y.shortcode):")
                    attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                }
            }
            self.userName.attributedText = attributedString
            self.reloadInputViews()
        }




        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
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
            self.moreImage.image = UIImage(named: "fifty")
        } else if status.status?.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost")
        } else if (status.status?.favourited ?? false) || StoreStruct.allLikes.contains(status.id) {
            self.moreImage.image = UIImage(named: "like")
        } else {
            self.moreImage.image = nil
        }



        self.smallImage1.alpha = 0
        self.smallImage2.alpha = 0
        self.smallImage3.alpha = 0
        self.smallImage4.alpha = 0
        imageCountTag.isUserInteractionEnabled = false
        if status.status?.reblog?.mediaAttachments.isEmpty ?? status.status?.mediaAttachments.isEmpty ?? false { return }
        if status.status?.reblog?.mediaAttachments[0].type ?? status.status?.mediaAttachments[0].type == .video {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.status?.mediaAttachments[0].previewURL ?? "")"))
            }
            imageCountTag.setTitle("\u{25b6}", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.status?.reblog?.mediaAttachments[0].type ?? status.status?.mediaAttachments[0].type == .gifv {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.status?.mediaAttachments[0].previewURL ?? "")"))
            }
            imageCountTag.setTitle("GIF", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count ?? 0 > 1 && (UIApplication.shared.isSplitOrSlideOver || UIDevice.current.userInterfaceIdiom == .phone) {
            self.mainImageView.setImage(UIImage(), for: .normal)
            if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count == 2 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (UIScreen.main.bounds.width - 127)/2, height: 200)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[0].previewURL ?? status.status?.mediaAttachments[0].previewURL ?? "")"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)

                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width - 127)/2 + 2, y: 0, width: (UIScreen.main.bounds.width - 127)/2, height: 200)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[1].previewURL ?? status.status?.mediaAttachments[1].previewURL ?? "")"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
            } else if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count == 3 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (UIScreen.main.bounds.width - 127)/2, height: 200)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[0].previewURL ?? status.status?.mediaAttachments[0].previewURL ?? "")"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)

                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width - 127)/2 + 2, y: -2, width: (UIScreen.main.bounds.width - 127)/2, height: 80)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[1].previewURL ?? status.status?.mediaAttachments[1].previewURL ?? "")"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)

                self.smallImage3.frame = CGRect(x: (UIScreen.main.bounds.width - 127)/2 + 2, y: 82, width: (UIScreen.main.bounds.width - 127)/2, height: 80)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[2].previewURL ?? status.status?.mediaAttachments[2].previewURL ?? "")"))
                }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
            } else if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count ?? 0 >= 4 {
                self.smallImage1.frame = CGRect(x: -2, y: -2, width: (UIScreen.main.bounds.width - 127)/2, height: 80)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[0].previewURL ?? status.status?.mediaAttachments[0].previewURL ?? "")"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)

                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width - 127)/2 + 2, y: -2, width: (UIScreen.main.bounds.width - 127)/2, height: 80)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[1].previewURL ?? status.status?.mediaAttachments[1].previewURL ?? "")"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)

                self.smallImage3.frame = CGRect(x: -2, y: 82, width: (UIScreen.main.bounds.width - 127)/2, height: 80)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[2].previewURL ?? status.status?.mediaAttachments[2].previewURL ?? "")"))
                }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)

                self.smallImage4.frame = CGRect(x: (UIScreen.main.bounds.width - 127)/2 + 2, y: 82, width: (UIScreen.main.bounds.width - 127)/2, height: 80)
                self.smallImage4.contentMode = .scaleAspectFill
                self.smallImage4.imageView?.contentMode = .scaleAspectFill
                self.smallImage4.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage4.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage4.pin_updateWithProgress = true
                self.smallImage4.pin_setImage(from: URL(string: "\(status.status?.reblog?.mediaAttachments[3].previewURL ?? status.status?.mediaAttachments[3].previewURL ?? "")"))
                }
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
        } else {
            imageCountTag.backgroundColor = Colours.clear
            imageCountTag.alpha = 0
            DispatchQueue.global(qos: .userInitiated).async {
            self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
            self.mainImageView.pin_updateWithProgress = true
            self.mainImageView.pin_setImage(from: URL(string: "\(status.status?.mediaAttachments[0].previewURL ?? "")"))
            }
        }



        if (UserDefaults.standard.object(forKey: "senseTog") == nil) || (UserDefaults.standard.object(forKey: "senseTog") as! Int == 0) {

            if status.status?.reblog?.sensitive ?? false || status.status?.sensitive ?? false {
                warningB.backgroundColor = Colours.tabUnselected
                let z = status.status?.reblog?.spoilerText ?? status.status?.spoilerText ?? ""
                var zz = "Content Warning"
                if z == "" {} else {
                    zz = z
                }
                warningB.setTitle("\(zz)\n\nTap to show status", for: .normal)
                warningB.setTitleColor(Colours.black.withAlphaComponent(0.4), for: .normal)
                warningB.addTarget(self, action: #selector(self.didTouchWarning), for: .touchUpInside)
                warningB.alpha = 1
            } else {
                warningB.backgroundColor = Colours.white
                warningB.alpha = 0
            }

        } else {
            warningB.backgroundColor = Colours.white
            warningB.alpha = 0
        }


    }

    @objc func didTouchWarning() {
        warningB.backgroundColor = Colours.white
        warningB.alpha = 0

        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
    }
}
