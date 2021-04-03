//
//  RepliesCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class RepliesCell: SwipeTableViewCell {
    
    var profileImageView = UIButton()
    var userName = UILabel()
    var userTag = UIButton()
    var date = UILabel()
    var toot = ActiveLabel()
    var moreImage = UIImageView()
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
        profileImageView.layer.masksToBounds = true
        
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
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        contentView.addSubview(warningB)
        contentView.addSubview(indi)
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
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
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
            "third": 61 + repdep
        ]
        
//        contentView.constraints.map({
//            contentView.removeConstraint($0)
//        })
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-HorizontalFirstIndi$", withVisualFormat: "H:|-first@999-[indi(2)]", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-HorizontalSecondImage40NameArtistMoreDate$", withVisualFormat: "H:|-second@999-[image(40)]-13-[name]-2-[artist]-(>=5)-[more(16)]-4-[date]-12@999-|", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-HorizontalSecondImage40Episodes$", withVisualFormat: "H:|-second@999-[image(40)]-13-[episodes]-12@999-|", options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-HorizontalThirdWarning$", withVisualFormat: "H:|-third@999-[warning]-9@999-|", options: [], metrics: metrics, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-VerticalIndi$", withVisualFormat: "V:|-64-[indi(>=0)]-16-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-VerticalMore16$", withVisualFormat: "V:|-18-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-VerticalDate$", withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-VerticalArtist$", withVisualFormat: "V:|-12-[artist]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-VerticalImage40$", withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-VerticalNameEpisodes$", withVisualFormat: "V:|-18-[name]-1-[episodes]-18-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$RepliesCell-VerticalNameWarning$", withVisualFormat: "V:|-18-[name]-1-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
//        contentView.layoutSubviews()
    }
    
    func configure(_ status: Status) {
        
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        warningB.backgroundColor = Colours.clear
        
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
        
        if status.reblog?.content.stripHTML() != nil {
//            toot.text = "\(status.reblog?.content.stripHTML() ?? "")\n\n\u{21bb} @\(status.account.username) reposted"
            if status.reblog!.emojis.isEmpty {
                toot.text = "\(status.reblog?.content.stripHTML() ?? "")\n\n\u{21bb} @\(status.account.acct) reposted"
            } else {
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.content.stripHTML() ?? "")\n\n\u{21bb} @\(status.account.acct) reposted")
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
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colours.black, range: NSMakeRange(0, attributedString.length))
                self.toot.attributedText = attributedString
                self.reloadInputViews()
            }
            
            if status.reblog?.account.emojis.isEmpty ?? true {
                userName.text = status.reblog?.account.displayName.stripHTML()
                if userName.text == "" {
                    userName.text = " "
                }
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
//            toot.text = status.content.stripHTML()
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
        }
        
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

