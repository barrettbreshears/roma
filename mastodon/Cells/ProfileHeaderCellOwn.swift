//
//  ProfileHeaderCellOwn.swift
//  mastodon
//
//  Created by Shihab Mehboob on 25/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ProfileHeaderCellOwn: SwipeTableViewCell {
    
    var profileImageView = UIButton()
    var headerImageView = UIButton()
    var userName = UILabel()
    var userTag = UILabel()
    var date = UILabel()
    var toot = ActiveLabel()
    var follows = UIButton()
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var more = UIButton()
    var settings = UIButton()
    var settings2 = UIButton()
    var tagListView = DLTagView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.white
        headerImageView.backgroundColor = Colours.tabSelected
        more.backgroundColor = UIColor.clear
        settings.backgroundColor = UIColor.clear
        settings2.backgroundColor = UIColor.clear
//        settings.alpha = 0
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        follows.translatesAutoresizingMaskIntoConstraints = false
        more.translatesAutoresizingMaskIntoConstraints = false
        settings.translatesAutoresizingMaskIntoConstraints = false
        settings2.translatesAutoresizingMaskIntoConstraints = false
        tagListView.translatesAutoresizingMaskIntoConstraints = false
        
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 50
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        profileImageView.layer.masksToBounds = true
        more.layer.cornerRadius = 20
        more.layer.masksToBounds = true
        settings.layer.cornerRadius = 20
        settings.layer.masksToBounds = true
        settings2.layer.cornerRadius = 20
        settings2.layer.masksToBounds = true
        
        headerImageView.layer.masksToBounds = true
        
        userName.numberOfLines = 0
        userTag.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = UIColor.white
        userTag.textColor = UIColor.white
        date.textColor = UIColor.white
        toot.textColor = UIColor.white
        follows.titleLabel?.textColor = UIColor.white
        
        userName.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        userTag.font = UIFont.systemFont(ofSize: 14)
        date.font = UIFont.systemFont(ofSize: 12)
        toot.font = UIFont.boldSystemFont(ofSize: 14)
        follows.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        toot.textAlignment = .center
        date.textAlignment = .center
        follows.titleLabel?.textAlignment = .center
        
        
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = UIColor.white.withAlphaComponent(0.7)
        toot.hashtagColor = UIColor.white.withAlphaComponent(0.7)
        toot.URLColor = UIColor.white.withAlphaComponent(0.7)
        
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(more)
        contentView.addSubview(settings)
        contentView.addSubview(settings2)
        contentView.addSubview(tagListView)
        contentView.addSubview(follows)
        
        let viewsDict = [
            "header" : headerImageView,
            "image" : profileImageView,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : more,
            "settings" : settings,
            "settings2" : settings2,
            "tagListView" : tagListView,
            "follows" : follows,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[header]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=20)-[settings(40)]-28-[image(100)]-28-[more(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-60-[more(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-60-[settings(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[image(100)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[name]-4-[artist]-15-[episodes]-15-[follows]-4-[date]-10-[tagListView(60)]-10-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=20)-[settings(40)]-93-[settings2(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-95-[settings2(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tagListView]-0-|", options: [], metrics: nil, views: viewsDict))
        
        
        
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userName.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userTag.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toot.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        date.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        follows.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        headerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func tHead() {
        print("t head")
    }
    
    
    func configure(_ status: Account) {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            print("nothing")
        case .pad:
            self.settings.alpha = 0
        default:
            print("nothing")
        }
        
        
        
        toot.mentionColor = UIColor.white.withAlphaComponent(0.7)
        toot.hashtagColor = UIColor.white.withAlphaComponent(0.7)
        toot.URLColor = UIColor.white.withAlphaComponent(0.7)
        headerImageView.backgroundColor = Colours.tabSelected
        
        blurEffectView.removeFromSuperview()
        if (UserDefaults.standard.object(forKey: "headbg1") == nil) || (UserDefaults.standard.object(forKey: "headbg1") as! Int == 0) {
            blurEffect = UIBlurEffect(style: .regular)
        } else if UserDefaults.standard.object(forKey: "headbg1") as! Int == 1 {
            blurEffect = UIBlurEffect(style: .light)
        }  else if UserDefaults.standard.object(forKey: "headbg1") as! Int == 2 {
            blurEffect = UIBlurEffect(style: .extraLight)
        } else {
            blurEffect = UIBlurEffect(style: .dark)
        }

        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = headerImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerImageView.addSubview(blurEffectView)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        
        blurEffectView.isUserInteractionEnabled = false
//        headerImageView.addTarget(self, action: #selector(self.tHead), for: .touchUpInside)
        
        
        if status.fields.count > 0 {
            
            tagListView.removeAllTags()
            status.fields.forEach { text in
                if text.verifiedAt != nil {
                    var tag = DLTag(text: "\u{2713} \(text.name)")
                    tag.fontSize = 15
                    tag.backgroundColor = Colours.green
                    tag.borderWidth = 0
                    tag.textColor = UIColor.white
                    tag.cornerRadius = 12
                    tag.enabled = true
                    tag.altText = text.value.stripHTML()
                    tag.padding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
                    tagListView.addTag(tag: tag)
                    tagListView.singleLine = true
                } else {
                    var tag = DLTag(text: text.name)
                    tag.fontSize = 15
                    tag.backgroundColor = Colours.white
                    tag.borderWidth = 0
                    tag.textColor = Colours.black
                    tag.cornerRadius = 12
                    tag.enabled = true
                    tag.altText = text.value.stripHTML()
                    tag.padding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
                    tagListView.addTag(tag: tag)
                    tagListView.singleLine = true
                }
            }
            
            
            
        }
        
        
        
        profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
        profileImageView.pin_updateWithProgress = true
        profileImageView.pin_setImage(from: URL(string: "\(status.avatar)"))
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = Colours.white.cgColor
        if (UserDefaults.standard.object(forKey: "bord") == nil) || (UserDefaults.standard.object(forKey: "bord") as! Int == 0) {
            profileImageView.layer.borderWidth = 0
        } else if UserDefaults.standard.object(forKey: "bord") as! Int == 1 {
            profileImageView.layer.borderWidth = 4
        } else {
            profileImageView.layer.borderWidth = 8
        }
        
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 50
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.pin_updateWithProgress = true
        headerImageView.pin_setImage(from: URL(string: "\(status.header)"))
        headerImageView.layer.masksToBounds = true
        
        userName.text = status.displayName
        userTag.text = "@\(status.acct)"
        toot.text = status.note.stripHTML()
        
        headerImageView.imageView?.image?.getColors { colors in
            self.userName.textColor = self.pickTextColor(bgColor: colors?.background ?? UIColor.white)
            self.userTag.textColor = self.pickTextColor(bgColor: colors?.background ?? UIColor.white)
            self.toot.textColor = self.pickTextColor(bgColor: colors?.background ?? UIColor.white)
        }
        
        if status.emojis.isEmpty {
            userName.text = status.displayName.stripHTML()
        } else {
            let attributedString = NSMutableAttributedString(string: status.displayName.stripHTML())
            for y in status.emojis {
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
        
        date.text = "Joined on \(status.createdAt.toString(dateStyle: .medium, timeStyle: .medium))"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: status.followingCount))
        
        let numberFormatter2 = NumberFormatter()
        numberFormatter2.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber2 = numberFormatter2.string(from: NSNumber(value: status.followersCount))
        
        follows.setTitle("\(formattedNumber ?? "0") follows     \(formattedNumber2 ?? "0") followers", for: .normal)
        
        more.setImage(UIImage(named: "more4"), for: .normal)
        settings.backgroundColor = UIColor.white
        if (UserDefaults.standard.object(forKey: "likepin") == nil) || (UserDefaults.standard.object(forKey: "likepin") as! Int == 0) {
            settings.setImage(UIImage(named: "like2")?.maskWithColor(color: UIColor.darkGray), for: .normal)
        } else if (UserDefaults.standard.object(forKey: "likepin") as! Int == 1) {
            settings.setImage(UIImage(named: "pinned")?.maskWithColor(color: UIColor.darkGray), for: .normal)
        } else {
            settings.setImage(UIImage(named: "profile")?.maskWithColor(color: UIColor.darkGray), for: .normal)
        }
        
        if status.locked {
            settings2.setImage(UIImage(named: "private")?.maskWithColor(color: Colours.grayDark), for: .normal)
            settings2.imageEdgeInsets = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 14)
            settings2.contentMode = .scaleAspectFit
            settings2.backgroundColor = Colours.white
        } else if status.bot {
            settings2.setImage(UIImage(named: "boticon")?.maskWithColor(color: Colours.grayDark), for: .normal)
            settings2.imageEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
            settings2.contentMode = .scaleAspectFit
            settings2.backgroundColor = Colours.white
        } else {
            settings2.backgroundColor = Colours.clear
        }
    }
    
    
    func pickTextColor(bgColor: UIColor) -> UIColor {
        let r = bgColor.cgColor.components?[0] ?? 0
        let g = bgColor.cgColor.components?[1] ?? 0
        let b = bgColor.cgColor.components?[2] ?? 0
        return (((r * 0.299) + (g * 0.587) + (b * 0.114)) > 186) ? UIColor.darkGray : UIColor.white
    }
}










class ProfileHeaderCellOwn2: SwipeTableViewCell {
    
    var profileImageView = UIButton()
    var headerImageView = UIButton()
    var userName = UILabel()
    var userTag = UILabel()
    var date = UILabel()
    var toot = ActiveLabel()
    var follows = UIButton()
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var more = UIButton()
    var settings = UIButton()
    var settings2 = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.white
        headerImageView.backgroundColor = Colours.tabSelected
        more.backgroundColor = UIColor.clear
        settings.backgroundColor = UIColor.clear
        settings2.backgroundColor = UIColor.clear
//        settings.alpha = 0
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        follows.translatesAutoresizingMaskIntoConstraints = false
        more.translatesAutoresizingMaskIntoConstraints = false
        settings.translatesAutoresizingMaskIntoConstraints = false
        settings2.translatesAutoresizingMaskIntoConstraints = false
        
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 50
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        profileImageView.layer.masksToBounds = true
        more.layer.cornerRadius = 20
        more.layer.masksToBounds = true
        settings.layer.cornerRadius = 20
        settings.layer.masksToBounds = true
        settings2.layer.cornerRadius = 20
        settings2.layer.masksToBounds = true
        
        headerImageView.layer.masksToBounds = true
        
        userName.numberOfLines = 0
        userTag.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = UIColor.white
        userTag.textColor = UIColor.white
        date.textColor = UIColor.white
        toot.textColor = UIColor.white
        follows.titleLabel?.textColor = UIColor.white
        
        userName.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        userTag.font = UIFont.systemFont(ofSize: 14)
        date.font = UIFont.systemFont(ofSize: 12)
        toot.font = UIFont.boldSystemFont(ofSize: 14)
        follows.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        toot.textAlignment = .center
        date.textAlignment = .center
        follows.titleLabel?.textAlignment = .center
        
        
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = UIColor.white.withAlphaComponent(0.7)
        toot.hashtagColor = UIColor.white.withAlphaComponent(0.7)
        toot.URLColor = UIColor.white.withAlphaComponent(0.7)
        
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(more)
        contentView.addSubview(settings)
        contentView.addSubview(settings2)
        contentView.addSubview(follows)
        
        let viewsDict = [
            "header" : headerImageView,
            "image" : profileImageView,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : more,
            "settings" : settings,
            "settings2" : settings2,
            "follows" : follows,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[header]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=20)-[settings(40)]-28-[image(100)]-28-[more(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-60-[more(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-60-[settings(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[image(100)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[name]-4-[artist]-15-[episodes]-15-[follows]-4-[date]-14-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=20)-[settings(40)]-93-[settings2(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-95-[settings2(40)]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        
        
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userName.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userTag.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toot.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        date.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        follows.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        headerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Account) {
        
        toot.mentionColor = UIColor.white.withAlphaComponent(0.7)
        toot.hashtagColor = UIColor.white.withAlphaComponent(0.7)
        toot.URLColor = UIColor.white.withAlphaComponent(0.7)
        headerImageView.backgroundColor = Colours.tabSelected
        
        blurEffectView.removeFromSuperview()
        if (UserDefaults.standard.object(forKey: "headbg1") == nil) || (UserDefaults.standard.object(forKey: "headbg1") as! Int == 0) {
            blurEffect = UIBlurEffect(style: .regular)
        } else if UserDefaults.standard.object(forKey: "headbg1") as! Int == 1 {
            blurEffect = UIBlurEffect(style: .light)
        }  else if UserDefaults.standard.object(forKey: "headbg1") as! Int == 2 {
            blurEffect = UIBlurEffect(style: .extraLight)
        } else {
            blurEffect = UIBlurEffect(style: .dark)
        }
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = headerImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerImageView.addSubview(blurEffectView)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        
        
        
        profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
        profileImageView.pin_updateWithProgress = true
        profileImageView.pin_setImage(from: URL(string: "\(status.avatar)"))
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = Colours.white.cgColor
        if (UserDefaults.standard.object(forKey: "bord") == nil) || (UserDefaults.standard.object(forKey: "bord") as! Int == 0) {
            profileImageView.layer.borderWidth = 0
        } else if UserDefaults.standard.object(forKey: "bord") as! Int == 1 {
            profileImageView.layer.borderWidth = 4
        } else {
            profileImageView.layer.borderWidth = 8
        }
        
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 50
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.pin_updateWithProgress = true
        headerImageView.pin_setImage(from: URL(string: "\(status.header)"))
        headerImageView.layer.masksToBounds = true
        
        userName.text = status.displayName
        userTag.text = "@\(status.acct)"
        toot.text = status.note.stripHTML()
        
        headerImageView.imageView?.image?.getColors { colors in
            self.userName.textColor = self.pickTextColor(bgColor: colors?.background ?? UIColor.white)
            self.userTag.textColor = self.pickTextColor(bgColor: colors?.background ?? UIColor.white)
            self.toot.textColor = self.pickTextColor(bgColor: colors?.background ?? UIColor.white)
        }
        
        if status.emojis.isEmpty {
            userName.text = status.displayName.stripHTML()
        } else {
            let attributedString = NSMutableAttributedString(string: status.displayName.stripHTML())
            for y in status.emojis {
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
        
        date.text = "Joined on \(status.createdAt.toString(dateStyle: .medium, timeStyle: .medium))"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: status.followingCount))
        
        let numberFormatter2 = NumberFormatter()
        numberFormatter2.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber2 = numberFormatter2.string(from: NSNumber(value: status.followersCount))
        
        follows.setTitle("\(formattedNumber ?? "0") follows     \(formattedNumber2 ?? "0") followers", for: .normal)
        
        more.setImage(UIImage(named: "more4"), for: .normal)
        settings.backgroundColor = UIColor.white
        if (UserDefaults.standard.object(forKey: "likepin") == nil) || (UserDefaults.standard.object(forKey: "likepin") as! Int == 0) {
            settings.setImage(UIImage(named: "like2")?.maskWithColor(color: UIColor.darkGray), for: .normal)
        } else if (UserDefaults.standard.object(forKey: "likepin") as! Int == 1) {
            settings.setImage(UIImage(named: "pinned")?.maskWithColor(color: UIColor.darkGray), for: .normal)
        } else {
            settings.setImage(UIImage(named: "profile")?.maskWithColor(color: UIColor.darkGray), for: .normal)
        }
        
        if status.locked {
            settings2.setImage(UIImage(named: "private")?.maskWithColor(color: Colours.grayDark), for: .normal)
            settings2.imageEdgeInsets = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 14)
            settings2.contentMode = .scaleAspectFit
            settings2.backgroundColor = Colours.white
        } else if status.bot {
            settings2.setImage(UIImage(named: "boticon")?.maskWithColor(color: Colours.grayDark), for: .normal)
            settings2.imageEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
            settings2.contentMode = .scaleAspectFit
            settings2.backgroundColor = Colours.white
        } else {
            settings2.backgroundColor = Colours.clear
        }
    }
    
    func pickTextColor(bgColor: UIColor) -> UIColor {
        let r = bgColor.cgColor.components?[0] ?? 0
        let g = bgColor.cgColor.components?[1] ?? 0
        let b = bgColor.cgColor.components?[2] ?? 0
        return (((r * 0.299) + (g * 0.587) + (b * 0.114)) > 186) ? UIColor.darkGray : UIColor.white
    }
}


