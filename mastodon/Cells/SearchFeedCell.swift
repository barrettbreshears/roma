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
import ActiveLabel

class SearchFeedCell: SwipeTableViewCell {
    
    var profileImageView = UIButton()
    var profileImageView2 = UIButton()
    var warningB = UIButton()
    var userName = UILabel()
    var userTag = UILabel()
    var date = UILabel()
    var toot = ActiveLabel()
    var moreImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.clear
        profileImageView2.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        moreImage.backgroundColor = Colours.clear
        
//        userName.adjustsFontForContentSizeCategory = true
//        userTag.adjustsFontForContentSizeCategory = true
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
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = warningB.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.isUserInteractionEnabled = false
//        warningB.addSubview(blurEffectView)
//        warningB.sendSubviewToBack(blurEffectView)
        
        userName.numberOfLines = 0
        userTag.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = Colours.black
        userTag.textColor = Colours.grayDark.withAlphaComponent(0.38)
        date.textColor = Colours.grayDark.withAlphaComponent(0.38)
        toot.textColor = Colours.black
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.font = UIFont.systemFont(ofSize: Colours.fontSize3)
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
            ]
        
        
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-HorizontalImageNameArtistMoreDate$", withVisualFormat: "H:|-12-[image(40)]-13-[name]-2-[artist]-(>=5)-[more(16)]-4-[date]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-HorizontalImage2$", withVisualFormat: "H:|-30-[image2(26)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
//            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-13-[artist]-(>=5)-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-HorizontalImage40Episodes$", withVisualFormat: "H:|-12-[image(40)]-13-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-VerticalMore16$", withVisualFormat: "V:|-18-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-VerticalDate$", withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-VerticalArtist$", withVisualFormat: "V:|-12-[artist]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-VerticalImage40$", withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-VerticalImage2$", withVisualFormat: "V:|-38-[image2(26)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-VerticalNameEpisodes$", withVisualFormat: "V:|-18-[name]-1-[episodes]-18-|", options: [], metrics: nil, views: viewsDict))
            
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-HorizontalWarning$", withVisualFormat: "H:|-63-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$SearchFeedCell-VerticalWarning$", withVisualFormat: "V:|-54-[warning]-16-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Status) {
        
        
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
            userTag.text = "@\(status.reblog?.account.acct ?? status.account.acct)"
        } else {
            userTag.text = "@\(status.reblog?.account.username ?? status.account.username)"
        }
        
        
        if (UserDefaults.standard.object(forKey: "timerel") == nil) || (UserDefaults.standard.object(forKey: "timerel") as! Int == 0) {
            date.text = status.reblog?.createdAt.toStringWithRelativeTime() ?? status.createdAt.toStringWithRelativeTime()
        } else {
            date.text = status.reblog?.createdAt.toString(dateStyle: .short, timeStyle: .short) ?? status.createdAt.toString(dateStyle: .short, timeStyle: .short)
        }
        
        if status.reblog?.content.stripHTML() != nil {
            
            
            
       
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
                self.userName.attributedText = attributedString
                self.reloadInputViews()
            }
            
            
            
            
            
            profileImageView2.pin_setPlaceholder(with: UIImage(named: "logo"))
            profileImageView2.pin_updateWithProgress = true
            profileImageView2.pin_setImage(from: URL(string: "\(status.account.avatar)"))
            profileImageView2.layer.masksToBounds = true
            profileImageView2.layer.borderColor = UIColor.black.cgColor
            profileImageView2.layer.borderWidth = 0.2
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
            
            
            //            if status.emojis.isEmpty {
            //                toot.text = status.content.stripHTML()
            //            } else {
            //                toot.text = "loading"
            //                toot.textColor = Colours.white
            //                let attributedString = NSMutableAttributedString(string: status.content.stripHTML())
            //                for y in status.emojis {
            //                    let textAttachment = NSTextAttachment()
            //                    let data = try? Data(contentsOf: y.url)
            //                    if let imageData = data {
            //                        textAttachment.image = UIImage(data: imageData)
            //                        textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.toot.font.lineHeight), height: Int(self.toot.font.lineHeight))
            //                        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            //                        while attributedString.mutableString.contains(":\(y.shortcode):") {
            //                            let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\(y.shortcode):")
            //                            attributedString.replaceCharacters(in: range, with: attrStringWithImage)
            //                        }
            //                    }
            //                }
            //                self.toot.attributedText = attributedString
            //            }
            
            
            
            
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
                self.userName.attributedText = attributedString
                self.reloadInputViews()
            }
            
            
            
            
            profileImageView2.pin_setPlaceholder(with: UIImage(named: "logo2345"))
            profileImageView2.layer.masksToBounds = true
            profileImageView2.layer.borderColor = UIColor.black.cgColor
            profileImageView2.layer.borderWidth = 0
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
        userTag.font = UIFont.systemFont(ofSize: Colours.fontSize3)
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
    
    @objc func didTouchWarning() {
        warningB.backgroundColor = Colours.clear
        warningB.alpha = 0
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
    }
    
}
