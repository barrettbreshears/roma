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
        
        userName.numberOfLines = 1
        date.numberOfLines = 1
        date.textAlignment = .right
        userName.textColor = Colours.black
        userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        date.textColor = Colours.grayDark.withAlphaComponent(0.38)
        toot.textColor = Colours.black
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
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
        
        userTag.setCompressionResistance(LayoutPriority(rawValue: 499), for: .horizontal)
        date.setCompressionResistance(LayoutPriority(rawValue: 501), for: .horizontal)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileImageView2)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        contentView.addSubview(readIndi)
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
            "readIndi" : readIndi,
        ]
        
        let constraintsReadIndiImage40NameArtistDate = NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[readIndi(8)]-5-[image(40)]-13-[name]-5-[artist]-(>=5)-[date]-12-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsReadIndiImage40NameArtistDate {
            constraint.identifier = "$DMFeedCell-ReadIndiImage40NameArtistDate$"
        }
        contentView.addConstraints(constraintsReadIndiImage40NameArtistDate)
        
        let constraintsImage226 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-45-[image2(26)]-(>=20)-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsImage226 {
            constraint.identifier = "$DMFeedCell-Image226$"
        }
        contentView.addConstraints(constraintsImage226)
        
        let constraintsReadIndiImage40Episodes = NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[readIndi(8)]-5-[image(40)]-13-[episodes]-20-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsReadIndiImage40Episodes {
            constraint.identifier = "$DMFeedCell-ReadIndiImage40Episodes$"
        }
        contentView.addConstraints(constraintsReadIndiImage40Episodes)
        
        let constraintsImage40 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsImage40 {
            constraint.identifier = "$DMFeedCell-Image40$"
        }
        contentView.addConstraints(constraintsImage40)
        
        let constraintsImage38226 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-38-[image2(26)]-(>=12)-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsImage38226 {
            constraint.identifier = "$DMFeedCell-Image38226$"
        }
        contentView.addConstraints(constraintsImage38226)
        
        let constraintsReadIndi8 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-34-[readIndi(8)]-(>=12)-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsReadIndi8 {
            constraint.identifier = "$DMFeedCell-ReadIndi8$"
        }
        contentView.addConstraints(constraintsReadIndi8)
        
        let constraintsDate = NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsDate {
            constraint.identifier = "$DMFeedCell-Date$"
        }
        contentView.addConstraints(constraintsDate)
        
        let constraintsArtistEpisodes = NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[artist]-1-[episodes]-18-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsArtistEpisodes {
            constraint.identifier = "$DMFeedCell-ArtistEpisodes$"
        }
        contentView.addConstraints(constraintsArtistEpisodes)
        
        let constraintsNameEpisodes = NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[episodes]-18-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsNameEpisodes {
            constraint.identifier = "$DMFeedCell-NameEpisodes$"
        }
        contentView.addConstraints(constraintsNameEpisodes)
        
        let constraintsWarning = NSLayoutConstraint.constraints(withVisualFormat: "H:|-74-[warning]-17-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsWarning {
            constraint.identifier = "$DMFeedCell-Warning$"
        }
        contentView.addConstraints(constraintsWarning)
        
        let constraintsNameWarning = NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[name]-1-[warning]-16-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsNameWarning {
            constraint.identifier = "$DMFeedCell-NameWarning$"
        }
        contentView.addConstraints(constraintsNameWarning)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.profileImageView.imageView?.image = nil
//        self.profileImageView2.imageView?.image = nil
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
        userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        date.textColor = Colours.grayDark.withAlphaComponent(0.38)
        toot.textColor = Colours.black
        
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
        
        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil || UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
            userTag.setTitle("@\(status.reblog?.account.acct ?? status.account.acct)", for: .normal)
        } else {
            userTag.setTitle("@\(status.reblog?.account.username ?? status.account.username)", for: .normal)
        }
        
        self.profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
        self.profileImageView.pin_updateWithProgress = true
        
        userName.text = status.reblog?.account.displayName ?? status.account.displayName
        if userName.text == StoreStruct.currentUser.displayName {
            let request = Accounts.account(id: status.inReplyToAccountID ?? "")
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        self.userName.text = stat.displayName
                        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil || UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
                            self.userTag.setTitle("@\(stat.acct)", for: .normal)
                        } else {
                            self.userTag.setTitle("@\(stat.username)", for: .normal)
                        }
                        self.profileImageView.pin_setImage(from: URL(string: "\(stat.avatar)"))
                        self.reloadInputViews()
                    }
                }
            }
        } else {
            self.profileImageView.pin_setImage(from: URL(string: "\(status.reblog?.account.avatar ?? status.account.avatar)"))
        }
        
        
        if (UserDefaults.standard.object(forKey: "timerel") == nil) || (UserDefaults.standard.object(forKey: "timerel") as! Int == 0) {
            date.text = status.reblog?.createdAt.toStringWithRelativeTime() ?? status.createdAt.toStringWithRelativeTime()
        } else {
            date.text = status.reblog?.createdAt.toString(dateStyle: .short, timeStyle: .short) ?? status.createdAt.toString(dateStyle: .short, timeStyle: .short)
        }
        
        
        //TODO did I comment this out????
        //        let viewsDict = [
        //            "warning" : warningB,
        //            ]
        //        if status.reblog?.content.stripHTML() != nil {
        //            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-46-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
        //        } else {
        //            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-54-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
        //        }
        
        
        
        if status.reblog?.content.stripHTML() != nil {
            
            
            
            
            if status.reblog!.emojis.isEmpty {
                toot.text = "\(status.reblog?.content.stripHTML() ?? "")"
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
                let textAfterIcon = NSMutableAttributedString(string: " \(theUsernameTag) reposted\n\(status.reblog?.account.displayName.stripHTML() ?? "")")
                completeText.append(textAfterIcon)
                userName.attributedText = completeText
            } else {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"boost")
                imageAttachment.bounds = CGRect(x: 0, y: -3, width: Int(self.userName.font.lineHeight), height: Int(self.userName.font.lineHeight))
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                let completeText = NSMutableAttributedString(string: "")
                completeText.append(attachmentString)
                let attributedString = NSMutableAttributedString(string: " \(theUsernameTag) reposted\n\(status.reblog?.account.displayName.stripHTML() ?? "")")
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
            
            var statusText = "";
            
            if userName.text == StoreStruct.currentUser.displayName {
                statusText = "You: "
            }
            if status.emojis.isEmpty {
                statusText = statusText + status.content.stripHTML()
                toot.text = statusText
            } else {
                statusText = statusText + status.content.stripHTML()
                let attributedString = NSMutableAttributedString(string: statusText)
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
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        
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
        } else if status.reblog?.reblogged ?? status.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
        } else if (status.reblog?.favourited ?? status.favourited ?? false) || StoreStruct.allLikes.contains(status.reblog?.id ?? status.id) {
            self.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
        } else {
            if status.reblog?.poll ?? status.poll != nil {
                self.moreImage.image = UIImage(named: "pollbubble")
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
    
    @objc func didTouchWarning() {
        warningB.backgroundColor = Colours.clear
        warningB.alpha = 0
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
    }
    
}
