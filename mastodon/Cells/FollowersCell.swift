//
//  FollowersCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 24/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class FollowersCell: SwipeTableViewCell {
    
    var profileImageView = UIButton()
    var userName = UILabel()
    var userTag = UILabel()
    var toot = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.white
        
//        userName.adjustsFontForContentSizeCategory = true
//        userTag.adjustsFontForContentSizeCategory = true
//        toot.adjustsFontForContentSizeCategory = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        userName.textColor = Colours.black
        userTag.textColor = Colours.grayDark.withAlphaComponent(0.38)
        toot.textColor = Colours.grayDark.withAlphaComponent(0.74)
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
        userName.setCompressionResistance(LayoutPriority(rawValue: 501), for: .horizontal)
        userTag.setCompressionResistance(LayoutPriority(rawValue: 478), for: .horizontal)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(toot)
        
        let viewsDict = [
            "image" : profileImageView,
            "name" : userName,
            "artist" : userTag,
            "episodes" : toot,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(40)]-13-[name]-2-[artist]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[image(40)]-13-[episodes]-10-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[name]-4-[episodes]-18-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[artist]-4-[episodes]-18-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Account) {
        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil || UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
            userTag.text = "@\(status.acct)"
        } else {
            userTag.text = "@\(status.username)"
        }
        toot.text = status.note.stripHTML()
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
        profileImageView.isUserInteractionEnabled = false
        
        if status.emojis.isEmpty {
            userName.text = status.displayName.stripHTML()
        } else {
            let attributedString = NSMutableAttributedString(string: status.displayName.stripHTML())
            status.emojis.map({
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
        
        DispatchQueue.global(qos: .userInitiated).async {
        self.profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
        self.profileImageView.pin_updateWithProgress = true
        self.profileImageView.pin_setImage(from: URL(string: "\(status.avatar)"))
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
        
    }
    
}
