//
//  ScheduledCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 27/01/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ScheduledCell: SwipeTableViewCell {
    
    var userName = UILabel()
    var toot = ActiveLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = Colours.black
        toot.textColor = Colours.black
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        contentView.addSubview(userName)
        contentView.addSubview(toot)
        
        let viewsDict = [
            "name" : userName,
            "episodes" : toot,
            ]
        
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[name]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: ScheduledStatus) {
        
        self.contentView.backgroundColor = Colours.white
        
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let updatedAt = dateFormatter.date(from: status.scheduledAt)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let day = calendar.component(.day, from: updatedAt ?? Date())
        let month = calendar.component(.month, from: updatedAt ?? Date())
        let year = calendar.component(.year, from: updatedAt ?? Date())
        let hour = calendar.component(.hour, from: updatedAt ?? Date())
        let minutes = calendar.component(.minute, from: updatedAt ?? Date())
        
        let ti = String(format: "%0.2d:%0.2d", hour, minutes)
        let dmy = String(format: "%0.2d/%0.2d/%0.2d", day, month, year)
        userName.text = "Scheduled for \(ti) on \(dmy)"
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        toot.text = status.params.text
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
    }
    
}

class ScheduledCellImage: SwipeTableViewCell {
    
    var userName = UILabel()
    var toot = ActiveLabel()
    var mainImageView = UIButton()
    var mainImageViewBG = UIView()
    var imageCountTag = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageViewBG.translatesAutoresizingMaskIntoConstraints = false
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = Colours.black
        toot.textColor = Colours.black
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
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
        
        contentView.addSubview(userName)
        contentView.addSubview(toot)
        contentView.addSubview(mainImageViewBG)
        contentView.addSubview(mainImageView)
        contentView.addSubview(imageCountTag)
        
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
            "name" : userName,
            "episodes" : toot,
            "mainImage" : mainImageView,
            "mainImageBG" : mainImageViewBG,
            ]
        
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[name]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-10-[mainImageBG(200)]-12-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-10-[mainImage(200)]-12-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[mainImage]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-83-[mainImageBG]-30-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: ScheduledStatus) {
        
        self.contentView.backgroundColor = Colours.white
        
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let updatedAt = dateFormatter.date(from: status.scheduledAt)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let day = calendar.component(.day, from: updatedAt ?? Date())
        let month = calendar.component(.month, from: updatedAt ?? Date())
        let year = calendar.component(.year, from: updatedAt ?? Date())
        let hour = calendar.component(.hour, from: updatedAt ?? Date())
        let minutes = calendar.component(.minute, from: updatedAt ?? Date())
        
        let ti = String(format: "%0.2d:%0.2d", hour, minutes)
        let dmy = String(format: "%0.2d/%0.2d/%0.2d", day, month, year)
        userName.text = "Scheduled for \(ti) on \(dmy)"
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        toot.text = status.params.text
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.imageView?.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        DispatchQueue.global(qos: .userInitiated).async {
        self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
        self.mainImageView.pin_updateWithProgress = true
        self.mainImageView.pin_setImage(from: URL(string: "\(status.mediaAttachments[0].previewURL)"))
        }
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.borderColor = UIColor.black.cgColor
        if (UserDefaults.standard.object(forKey: "imCorner") == nil || UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
            mainImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "imCorner") != nil && UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
            mainImageView.layer.cornerRadius = 0
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
