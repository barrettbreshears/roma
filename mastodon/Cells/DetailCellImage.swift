//
//  DetailCellImage.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class DetailCellImage: UITableViewCell {
    
    var profileImageView = UIButton()
    var userName = UILabel()
    var userTag = UIButton()
    var toot = ActiveLabel() // ActiveLabel does not support images in NSTextAttachment(). Maybe update the pod?
    var faves = UIButton()
    var fromClient = UILabel()
    var mainImageView = UIButton()
    var mainImageViewBG = UIView()
    var imageCountTag = UIButton()
    
    var smallImage1 = UIButton()
    var smallImage2 = UIButton()
    var smallImage3 = UIButton()
    var smallImage4 = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.clear
        mainImageView.backgroundColor = Colours.clear
        mainImageViewBG.backgroundColor = Colours.clear
        
//        userName.adjustsFontForContentSizeCategory = true
//        userTag.adjustsFontForContentSizeCategory = true
//        date.adjustsFontForContentSizeCategory = true
//        toot.adjustsFontForContentSizeCategory = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageViewBG.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        fromClient.translatesAutoresizingMaskIntoConstraints = false
        faves.translatesAutoresizingMaskIntoConstraints = false
        
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
        mainImageView.layer.masksToBounds = true
        
        mainImageViewBG.layer.masksToBounds = false
        mainImageViewBG.layer.shadowColor = UIColor.black.cgColor
        mainImageViewBG.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainImageViewBG.layer.shadowRadius = 12
        mainImageViewBG.layer.shadowOpacity = 0
        mainImageViewBG.layer.masksToBounds = false
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            mainImageViewBG.alpha = 0
//        }
        
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
        contentView.addSubview(mainImageViewBG)
        contentView.addSubview(mainImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(toot)
        contentView.addSubview(fromClient)
        contentView.addSubview(faves)
        
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
            "mainImageBG" : mainImageViewBG,
            "mainImage" : mainImageView,
            "name" : userName,
            "artist" : userTag,
            "episodes" : toot,
            "from" : fromClient,
            "faves" : faves,
            "countTag" : imageCountTag,
            ]
        
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-Image40-Name$", withVisualFormat: "H:|-12-[image(40)]-13-[name]-(>=12)-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-Image40-Artist$", withVisualFormat: "H:|-12-[image(40)]-13-[artist]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
       contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-Episodes$", withVisualFormat: "H:|-12-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
                                  
       contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-From$", withVisualFormat: "H:|-12-[from]-12-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-Faves$", withVisualFormat: "H:|-12-[faves]-(>=12)-|", options: [], metrics: nil, views: viewsDict))

        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-MainImage$", withVisualFormat: "H:|-0-[mainImage]-0-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-MainImageBG$", withVisualFormat: "H:|-0-[mainImageBG]-0-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-constraintsImage4018$", withVisualFormat: "V:|-18-[image(40)]", options: [], metrics: nil, views: viewsDict))
        
        let deviceMetrics = [
            "top": 10,
            "bottom": 18,
            "nameArtistSpacing": 1,
            "artistEpisodesSpacing": 3,
            "episodesMainImageSpacing": 15,
            "phoneImageHeight": 275,
            "padImageHeight": 500,
            "mainImageFavesSpacing": 10,
            "favesFromSpacing": 6
        ]
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-PhoneNameArtistEpisodesMainImage275FavesFrom$", withVisualFormat: "V:|-top-[name]-nameArtistSpacing-[artist]-artistEpisodesSpacing-[episodes]-episodesMainImageSpacing@999-[mainImage(phoneImageHeight)]-mainImageFavesSpacing-[faves]-favesFromSpacing-[from]-bottom-|", options: [], metrics: deviceMetrics, views: viewsDict))
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-PhoneNameArtistEpisodesMainImageBG275FavesFrom$", withVisualFormat: "V:|-top-[name]-nameArtistSpacing-[artist]-artistEpisodesSpacing-[episodes]-episodesMainImageSpacing@999-[mainImageBG(phoneImageHeight)]-mainImageFavesSpacing-[faves]-favesFromSpacing-[from]-bottom-|", options: [], metrics: deviceMetrics, views: viewsDict))
        case .pad:
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-PadNameArtistEpisodesMainImage500FavesFrom$", withVisualFormat: "V:|-top-[name]-nameArtistSpacing-[artist]-artistEpisodesSpacing-[episodes]-episodesMainImageSpacing@999-[mainImage(padImageHeigh)]-mainImageFavesSpacing-[faves]-favesFromSpacing-[from]-bottom-|", options: [], metrics: deviceMetrics, views: viewsDict))
            
            contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-PadNameArtistEpisodesMainImageBG500FavesFrom$", withVisualFormat: "V:|-top-[name]-nameArtistSpacing-[artist]-artistEpisodesSpacing-[episodes]-episodesMainImageSpacing@999-[mainImageBG(padImageHeigh)]-mainImageFavesSpacing-[faves]-favesFromSpacing-[from]-bottom-|", options: [], metrics: deviceMetrics, views: viewsDict))
        default:
            print("nothing")
        }
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-CountTag30$", withVisualFormat: "H:|-5-[countTag(30)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(ConstraintsHelper.constraintsWithIdentifier(identifier: "$DetailCellImage-CountTag22$", withVisualFormat: "V:|-5-[countTag(22)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
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
                //completeText2.append(textAfterIcon2)
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
        let da = status.reblog?.createdAt.toString(dateStyle: .medium, timeStyle: .medium) ?? status.createdAt.toString(dateStyle: .medium, timeStyle: .medium)
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
        
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.imageView?.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.layer.masksToBounds = true
        
        
        self.smallImage1.alpha = 0
        self.smallImage2.alpha = 0
        self.smallImage3.alpha = 0
        self.smallImage4.alpha = 0
        imageCountTag.isUserInteractionEnabled = false
        if status.reblog?.mediaAttachments[0].type ?? status.mediaAttachments[0].type == .video {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            self.mainImageView.contentMode = .scaleAspectFit
            self.mainImageView.imageView?.contentMode = .scaleAspectFit
            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
            }
            imageCountTag.setTitle("\u{25b6}", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.reblog?.mediaAttachments[0].type ?? status.mediaAttachments[0].type == .gifv {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            self.mainImageView.contentMode = .scaleAspectFit
            self.mainImageView.imageView?.contentMode = .scaleAspectFit
            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
            }
            imageCountTag.setTitle("GIF", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count > 1 {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                imageCountTag.backgroundColor = Colours.clear
                imageCountTag.alpha = 0
                DispatchQueue.global(qos: .userInitiated).async {
                    self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                    self.mainImageView.pin_updateWithProgress = true
                    self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments.first?.previewURL ?? status.mediaAttachments.first?.previewURL ?? "")"))
                }
                
            } else {
            
            
            self.mainImageView.setImage(UIImage(), for: .normal)
            if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count == 2 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (UIScreen.main.bounds.width)/2, height: 275)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: 0, width: (UIScreen.main.bounds.width)/2, height: 275)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
            } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count == 3 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (UIScreen.main.bounds.width)/2, height: 275)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: -2, width: (UIScreen.main.bounds.width)/2, height: 137.5)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
                
                self.smallImage3.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: 139.5, width: (UIScreen.main.bounds.width)/2, height: 137.5)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[2].previewURL ?? status.mediaAttachments[2].previewURL)"))
                }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
            } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count >= 4 {
                self.smallImage1.frame = CGRect(x: -2, y: -2, width: (UIScreen.main.bounds.width)/2, height: 137.5)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: -2, width: (UIScreen.main.bounds.width)/2, height: 137.5)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
                
                self.smallImage3.frame = CGRect(x: -2, y: 139.5, width: (UIScreen.main.bounds.width)/2, height: 137.5)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[2].previewURL ?? status.mediaAttachments[2].previewURL)"))
                }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
                
                self.smallImage4.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: 139.5, width: (UIScreen.main.bounds.width)/2, height: 137.5)
                self.smallImage4.contentMode = .scaleAspectFill
                self.smallImage4.imageView?.contentMode = .scaleAspectFill
                self.smallImage4.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage4.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage4.pin_updateWithProgress = true
                self.smallImage4.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[3].previewURL ?? status.mediaAttachments[3].previewURL)"))
                }
                self.smallImage4.layer.masksToBounds = true
                self.smallImage4.layer.borderColor = UIColor.black.cgColor
                self.smallImage4.alpha = 1
                self.mainImageView.addSubview(self.smallImage4)
            } else {
                self.smallImage1.alpha = 0
                self.smallImage2.alpha = 0
                self.smallImage3.alpha = 0
                self.smallImage4.alpha = 0
            }
                
            }
        } else {
            imageCountTag.backgroundColor = Colours.clear
            imageCountTag.alpha = 0
            DispatchQueue.global(qos: .userInitiated).async {
            self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
            self.mainImageView.pin_updateWithProgress = true
            self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments.first?.url ?? status.mediaAttachments.first?.url ?? "")"))
            }
        }
        
//        userName.text = status.reblog?.account.displayName ?? status.account.displayName
        if userName.text == "" {
            userName.text = " "
        }
        
    }
    
}


