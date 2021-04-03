//
//  DetailCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class DetailCell: UITableViewCell {
    
    var profileImageView = UIButton()
    var userName = UILabel()
    var userTag = UIButton()
    var toot = ActiveLabel()
    var faves = UIButton()
    var fromClient = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.clear
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        fromClient.translatesAutoresizingMaskIntoConstraints = false
        faves.translatesAutoresizingMaskIntoConstraints = false
        
//        userName.adjustsFontForContentSizeCategory = true
//        userTag.adjustsFontForContentSizeCategory = true
//        date.adjustsFontForContentSizeCategory = true
//        toot.adjustsFontForContentSizeCategory = true
        
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
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0
        fromClient.numberOfLines = 0
        faves.titleLabel?.textAlignment = .left
        
        userName.textColor = Colours.black
        userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        toot.textColor = Colours.black
        fromClient.textColor = Colours.grayDark.withAlphaComponent(0.38)
        faves.titleLabel?.textColor = Colours.tabSelected
        faves.setTitleColor(Colours.tabSelected, for: .normal)
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        fromClient.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        faves.titleLabel?.font = UIFont.boldSystemFont(ofSize: Colours.fontSize3)
        
        
        
        
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        userName.setCompressionResistance(LayoutPriority(rawValue: 499), for: .horizontal)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(toot)
        contentView.addSubview(fromClient)
        contentView.addSubview(faves)
        
        let viewsDict = [
            "image" : profileImageView,
            "name" : userName,
            "artist" : userTag,
            "episodes" : toot,
            "from" : fromClient,
            "faves" : faves,
            ]
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCell-Image40-Name$", withVisualFormat: "H:|-12-[image(40)]-13-[name]-(>=12)-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCell-Image40-Artist$", withVisualFormat: "H:|-12-[image(40)]-13-[artist]-(>=12)-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCell-Episodes$", withVisualFormat: "H:|-12-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCell-From$", withVisualFormat: "H:|-12-[from]-12-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCell-Faves$", withVisualFormat: "H:|-12-[faves]-(>=12)-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCell-constraintsImage4018$", withVisualFormat: "V:|-18-[image(40)]", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCell-NameArtistEpisoesFavesFrom$", withVisualFormat: "V:|-18-[name]-1-[artist]-3-[episodes]-10-[faves]-6-[from]-18-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Status) {
        
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        
        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil || UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
            userTag.setTitle("@\(status.reblog?.account.acct ?? status.account.acct)", for: .normal)
        } else {
            userTag.setTitle("@\(status.reblog?.account.username ?? status.account.username)", for: .normal)
        }
        
        
        if status.reblog?.content.stripHTML() != nil {
//            toot.text = "\(status.reblog?.content.stripHTML() ?? "")\n\n\u{21bb} @\(status.account.username) reposted"
            var theUsernameTag = status.account.displayName
            if (UserDefaults.standard.object(forKey: "boostusern") == nil) || (UserDefaults.standard.object(forKey: "boostusern") as! Int == 0) {
                
            } else {
                theUsernameTag = "@\(status.account.acct)"
            }
            
            if status.reblog!.emojis.isEmpty {
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.content.stripHTML() ?? "")\n\n")
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"boost2")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.38))
                imageAttachment.bounds = CGRect(x: 0, y: -3, width: Int(self.toot.font.lineHeight - 5), height: Int(self.toot.font.lineHeight))
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
                imageAttachment.bounds = CGRect(x: 0, y: -3, width: Int(self.toot.font.lineHeight - 5), height: Int(self.toot.font.lineHeight))
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
                userName.text = status.reblog?.account.displayName.stripHTML()
            } else {
                let attributedString = NSMutableAttributedString(string: status.reblog?.account.displayName.stripHTML() ?? "")
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
                self.userName.attributedText = attributedString
                self.reloadInputViews()
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
            
        }
        
        
        let z = status.reblog?.application?.name ?? status.application?.name ?? ""
        let da = status.createdAt.toString(dateStyle: .medium, timeStyle: .medium)
        if z == "" {
            fromClient.text = da
        } else {
            fromClient.text = "\(da), via \(z)"
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: status.reblog?.favouritesCount ?? status.favouritesCount))
        
        let numberFormatter2 = NumberFormatter()
        numberFormatter2.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber2 = numberFormatter2.string(from: NSNumber(value: status.reblog?.reblogsCount ?? status.reblogsCount))
        
        var likeText = "likes"
        if formattedNumber == "1" {
            likeText = "like"
        }
        var boostText = "reposts"
        if formattedNumber2 == "1" {
            boostText = "repost"
        }
        
        faves.setTitle("\(formattedNumber ?? "0") \(likeText) and \(formattedNumber2 ?? "0") \(boostText)", for: .normal)
        
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
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        fromClient.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        faves.titleLabel?.font = UIFont.boldSystemFont(ofSize: Colours.fontSize3)
        
        
//        userName.text = status.reblog?.account.displayName ?? status.account.displayName
        if userName.text == "" {
            userName.text = " "
        }
        
    }
    
}

