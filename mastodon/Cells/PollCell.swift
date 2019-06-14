//
//  PollCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 05/03/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class PollCell: UITableViewCell, CoreChartViewDataSource {
    
    var barChart: HCoreBarChart = HCoreBarChart()
    var countLabel = UILabel()
    var expiryLabel = UILabel()
    var options: [PollOptions] = []
    var poll: Poll!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCoreChartData() -> [CoreChartEntry] {
        var allData = [CoreChartEntry]()
        for index in 0..<self.options.count {
            let newEntry = CoreChartEntry(id: "\(index)",
                barTitle: options[index].title,
                barHeight: Double(self.options[index].votesCount ?? 0),
                barColor: Colours.tabSelected)
            allData.append(newEntry)
        }
        return allData
    }
    
    func didTouch(entryData: CoreChartEntry) {
        print("tapped \(entryData.id)")
        StoreStruct.currentPollSelectionTitle = entryData.barTitle
        StoreStruct.currentPollSelection.append(Int(entryData.id) ?? 0)
        StoreStruct.currentPollSelection = StoreStruct.currentPollSelection.removeDuplicates()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tappedPoll"), object: nil)
    }
    
    func configure(thePoll: Poll, theOptions: [PollOptions]) {
        self.options = theOptions
        self.poll = thePoll
        
        StoreStruct.currentPollSelection = []
        
        StoreStruct.pollHeight = (self.options.count*32) + (self.options.count*16) + 80
        barChart.frame = CGRect(x: 20, y: 6, width: Int(CGFloat(UIScreen.main.bounds.width - 40)), height: StoreStruct.pollHeight)
        barChart.dataSource = self
        barChart.displayConfig = CoreBarChartsDisplayConfig(barWidth: 32.0,
                                                            barSpace: 16.0,
                                                            bottomSpace: 10.0,
                                                            topSpace: 6.0,
                                                            backgroundColor: Colours.white,
                                                            titleFontSize: 14,
                                                            valueFontSize: 16,
                                                            titleFont: nil,
                                                            valueFont: nil,
                                                            titleLength: 400)
        contentView.addSubview(self.barChart)
        
        var voteText = "\(thePoll.votesCount) votes"
        if thePoll.voted ?? false {
            voteText = "\(thePoll.votesCount) votes • VOTED"
        }
        if thePoll.multiple {
            voteText = "\(voteText) • Multiple choices allowed"
        }
        countLabel.frame = CGRect(x: 30, y: Int(StoreStruct.pollHeight - 60), width: Int(CGFloat(UIScreen.main.bounds.width - 60)), height: 30)
        countLabel.text = voteText
        countLabel.font = UIFont.boldSystemFont(ofSize: 13)
        countLabel.textColor = Colours.grayDark
        countLabel.textAlignment = .left
        contentView.addSubview(self.countLabel)
        
        var timeText = "Expires at \(thePoll.expiresAt?.toString(dateStyle: .short, timeStyle: .short) ?? "")"
        if thePoll.expired {
            timeText = "CLOSED"
        }
        expiryLabel.frame = CGRect(x: 30, y: Int(StoreStruct.pollHeight - 38), width: Int(CGFloat(UIScreen.main.bounds.width - 60)), height: 30)
        expiryLabel.text = timeText
        expiryLabel.font = UIFont.systemFont(ofSize: 13)
        expiryLabel.textColor = Colours.grayDark.withAlphaComponent(0.38)
        expiryLabel.textAlignment = .left
        contentView.addSubview(self.expiryLabel)
    }
    
}

class NotificationPollCell: SwipeTableViewCell, CoreChartViewDataSource {
    
    var barChart: HCoreBarChart = HCoreBarChart()
    var countLabel = UILabel()
    var options: [PollOptions] = []
    var poll: Poll!
    var toot = ActiveLabel()
    var profileImageView = UIButton()
    var typeImage = UIButton()
    var userName = UILabel()
    var userTag = UIButton()
    var date = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.clear
        typeImage.backgroundColor = Colours.clear
        
        toot.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        typeImage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        barChart.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        toot.numberOfLines = 0
        toot.textColor = Colours.black
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        userName.numberOfLines = 0
        userName.textColor = Colours.black
        userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        date.textColor = Colours.grayDark.withAlphaComponent(0.38)
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
        userTag.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
        userTag.setCompressionResistance(LayoutPriority(rawValue: 498), for: .horizontal)
        userName.setCompressionResistance(LayoutPriority(rawValue: 499), for: .horizontal)
        date.setCompressionResistance(LayoutPriority(rawValue: 501), for: .horizontal)
        
        contentView.addSubview(typeImage)
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(barChart)
        contentView.addSubview(countLabel)
        contentView.addSubview(toot)
        
        let viewsDict = [
            "image" : profileImageView,
            "type" : typeImage,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "poll" : barChart,
            "count" : countLabel,
            "episodes" : toot,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[type(40)]-4-[image(40)]-13-[name]-2-[artist]-(>=5)-[date]-12-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[type(40)]-4-[image(40)]-13-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[type(40)]-4-[image(40)]-13-[poll]-12-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[type(40)]-4-[image(40)]-13-[count]-12-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[type(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-13-[name]-2-[episodes]-2-[poll]-2-[count]-18-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[artist]-2-[episodes]-2-[poll]-2-[count]-18-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCoreChartData() -> [CoreChartEntry] {
        var allData = [CoreChartEntry]()
        for index in 0..<self.options.count {
            let newEntry = CoreChartEntry(id: "\(index)",
                barTitle: options[index].title,
                barHeight: Double(self.options[index].votesCount ?? 0),
                barColor: Colours.tabSelected)
            allData.append(newEntry)
        }
        return allData
    }
    
    func configure(thePoll: Poll, theOptions: [PollOptions], status: Notificationt) {
        self.options = theOptions
        self.poll = thePoll
        
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        profileImageView.isUserInteractionEnabled = true
        toot.textColor = Colours.black
        userName.textColor = Colours.black
        userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        date.textColor = Colours.grayDark.withAlphaComponent(0.38)
        userName.text = "\(status.account.displayName)'s poll has ended"
        
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
        
        typeImage.setImage(UIImage(named: "pollbubble")?.maskWithColor(color: Colours.purple), for: .normal)
        
        StoreStruct.currentPollSelection = []
        
        StoreStruct.pollHeight = (self.options.count*32) + (self.options.count*16) + 14
        
        let heightConstraint = NSLayoutConstraint(item: self.barChart, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(StoreStruct.pollHeight))
        self.barChart.addConstraint(heightConstraint)
        
        barChart.isUserInteractionEnabled = false
        barChart.frame = CGRect(x: 20, y: 6, width: Int(CGFloat(UIScreen.main.bounds.width - 40)), height: StoreStruct.pollHeight)
        barChart.dataSource = self
        barChart.displayConfig = CoreBarChartsDisplayConfig(barWidth: 32.0,
                                                            barSpace: 16.0,
                                                            bottomSpace: 10.0,
                                                            topSpace: 6.0,
                                                            backgroundColor: Colours.white,
                                                            titleFontSize: 14,
                                                            valueFontSize: 16,
                                                            titleFont: nil,
                                                            valueFont: nil,
                                                            titleLength: 400)
        
        var voteText = "Poll ended with \(thePoll.votesCount) votes"
        if thePoll.votesCount == 1 {
            voteText = "Poll ended with 1 vote"
        }
        countLabel.frame = CGRect(x: 30, y: Int(StoreStruct.pollHeight - 60), width: Int(CGFloat(UIScreen.main.bounds.width - 60)), height: 30)
        countLabel.text = voteText
        countLabel.font = UIFont.boldSystemFont(ofSize: 13)
        countLabel.textColor = Colours.grayDark
        countLabel.textAlignment = .left
        
        if status.status?.emojis.isEmpty ?? true {
            toot.text = status.status?.content.stripHTML() ?? status.account.note.stripHTML()
        } else {
            let attributedString = NSMutableAttributedString(string: status.status?.content.stripHTML() ?? status.account.note.stripHTML())
            (status.status?.emojis)!.map({
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
        
        userName.font = UIFont.systemFont(ofSize: Colours.fontSize1, weight: .heavy)
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
    }
    
}

