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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        profileImageView.backgroundColor = Colours.white
        moreImage.backgroundColor = Colours.white
        
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
            ]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-73-[image(40)]-13-[name]-(>=5)-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-73-[image(40)]-13-[artist]-(>=5)-[more(16)]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-73-[image(40)]-13-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-126-[mainImage]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-136-[mainImageBG]-30-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-2-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImage(210)]-23-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImageBG(210)]-23-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[countTag(30)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[countTag(22)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ status: Status) {

        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        userName.text = status.account.displayName
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
//        DispatchQueue.global(qos: .userInitiated).async {
        self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
        self.mainImageView.pin_updateWithProgress = true
        self.mainImageView.pin_setImage(from: URL(string: "\(status.mediaAttachments[0].previewURL)"))
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
        
        if (status.favourited ?? false) && (status.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")
        } else if status.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost")
        } else if (status.favourited ?? false) || StoreStruct.allLikes.contains(status.id) {
            self.moreImage.image = UIImage(named: "like")
        } else {
            self.moreImage.image = nil
        }



        imageCountTag.isUserInteractionEnabled = false
        if status.mediaAttachments[0].type == .video {
            imageCountTag.setTitle("\u{25b6}", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.mediaAttachments[0].type == .gifv {
            imageCountTag.setTitle("GIF", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.mediaAttachments.count > 1 {
            imageCountTag.setTitle("\(status.mediaAttachments.count)", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else {
            imageCountTag.backgroundColor = Colours.clear
            imageCountTag.alpha = 0
        }

    }

}
