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

class MainFeedCell: SwipeTableViewCell {

    var profileImageView = UIButton()
    var profileImageView2 = UIButton()
    var warningB = MultiLineButton()
    var userName = UILabel()
    var userTag = UIButton()
    var date = UILabel()
    var toot = ActiveLabel()
    var moreImage = UIImageView()

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
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView2.translatesAutoresizingMaskIntoConstraints = false
        warningB.translatesAutoresizingMaskIntoConstraints = false
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
        profileImageView.contentHorizontalAlignment = .fill
        profileImageView.contentVerticalAlignment = .fill
        profileImageView.imageView?.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView2.contentHorizontalAlignment = .fill
        profileImageView2.contentVerticalAlignment = .fill
        profileImageView2.imageView?.contentMode = .scaleAspectFill
        profileImageView2.layer.masksToBounds = true

        warningB.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        warningB.titleLabel?.textAlignment = .center
        warningB.setTitleColor(Colours.black.withAlphaComponent(0.4), for: .normal)
        warningB.layer.cornerRadius = 7
        warningB.titleLabel?.font = UIFont.boldSystemFont(ofSize: Colours.fontSize3)
        warningB.titleLabel?.numberOfLines = 0
        warningB.layer.masksToBounds = true
        
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
            ]
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-Image40NameArtistMoreDate$", withVisualFormat: "H:|-12-[image(40)]-13-[name]-2-[artist]-(>=5)-[more(16)]-4-[date]-12-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-HorizontalImage226$", withVisualFormat: "H:|-30-[image2(26)]", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-HorizontalImage40Episodes$", withVisualFormat: "H:|-12-[image(40)]-13-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalMore16$", withVisualFormat: "V:|-18-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalDate18$", withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalImage40$", withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalImage226$", withVisualFormat: "V:|-38-[image2(26)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))

        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalNameEpisodes$", withVisualFormat: "V:|-14-[name]-2-[episodes]-18-|", options: [], metrics: nil, views: viewsDict))
        } else {
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalNameEpisodesRep1$", withVisualFormat: "V:|-14-[name]-2-[episodes]-15-[rep1(20)]-18-|", options: [], metrics: nil, views: viewsDict))

            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalNameEpisodesLike1$", withVisualFormat: "V:|-14-[name]-2-[episodes]-15-[like1(20)]-18-|", options: [], metrics: nil, views: viewsDict))

            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalNameEpisodesBoost1$", withVisualFormat: "V:|-14-[name]-2-[episodes]-15-[boost1(20)]-18-|", options: [], metrics: nil, views: viewsDict))

            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalNameEpisodesMore1$", withVisualFormat: "V:|-14-[name]-2-[episodes]-15-[more1(20)]-18-|", options: [], metrics: nil, views: viewsDict))

            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-HorizontalRep1Like1Boost1More1$", withVisualFormat: "H:|-65-[rep1(36)]-20-[like1(40)]-11-[boost1(34)]-24-[more1(20)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        }
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalArtistEpisodes$", withVisualFormat: "V:|-12-[artist]-0-[episodes]-(>=12)-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-HorizontalWarning$", withVisualFormat: "H:|-63-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$MainFeedCell-VerticalNameWarning$", withVisualFormat: "V:|-14-[name]-1-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        self.profileImageView.imageView?.image = nil
//        self.profileImageView2.imageView?.image = nil
    }

    func configure(_ status: Status) {
        
        profileImageView.backgroundColor = Colours.clear
        profileImageView2.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        moreImage.backgroundColor = Colours.clear
        rep1.backgroundColor = Colours.clear
        like1.backgroundColor = Colours.clear
        boost1.backgroundColor = Colours.clear
        more1.backgroundColor = Colours.clear
        toot.textColor = Colours.black
        
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
        if StoreStruct.allBoosts.contains(status.reblog?.id ?? status.id) || status.reblog?.reblogged ?? status.reblogged ?? false {
            boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
        } else {
            boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
        }
        if StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) || status.reblog?.favourited ?? status.favourited ?? false {
            like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
        } else {
            like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
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
                attributedString.append(completeText2)
                
                self.toot.attributedText = attributedString
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

        DispatchQueue.main.async { [weak self]  in
            self?.profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
            self?.profileImageView.pin_updateWithProgress = true
            self?.profileImageView.pin_setImage(from: URL(string: "\(status.reblog?.account.avatar ?? status.account.avatar)"))
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

let imageCache = NSCache<NSString, AnyObject>()

extension NSTextAttachment {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }

        }).resume()
    }
}
