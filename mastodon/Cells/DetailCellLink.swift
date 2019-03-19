//
//  DetailCellLink.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage
import SafariServices
import AVKit
import AVFoundation

class DetailCellLink: UITableViewCell {
    
    var containerView = UIButton()
    var image1 = UIImageView()
    var name = UILabel()
    var auth = UILabel()
    var name2 = UILabel()
    var safariVC: SFSafariViewController?
    var currentURL = ""
    var currentType: CardType = .link
    var player = AVPlayer()
    var realURL = URL(string: "")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = Colours.tabUnselected.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 18
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 18
        containerView.layer.shadowOpacity = 0.18
        containerView.layer.shadowOffset = CGSize(width: 0, height: 12)
        containerView.layer.masksToBounds = true
        
        image1.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        image1.backgroundColor = Colours.white3
        image1.contentMode = .scaleAspectFill
        image1.clipsToBounds = true
        containerView.addSubview(image1)
        
        name.text = ""
        name.frame = CGRect(x: 105, y: 5, width: UIScreen.main.bounds.width - 160, height: 25)
        name.textColor = Colours.grayDark
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.isUserInteractionEnabled = false
        containerView.addSubview(name)
        
        auth.text = ""
        auth.frame = CGRect(x: 105, y: 26, width: UIScreen.main.bounds.width - 160, height: 25)
        auth.textColor = Colours.grayDark.withAlphaComponent(0.45)
        auth.font = UIFont.boldSystemFont(ofSize: 12)
        auth.isUserInteractionEnabled = false
        containerView.addSubview(auth)
        
        name2.text = ""
        name2.frame = CGRect(x: 105, y: 42, width: UIScreen.main.bounds.width - 160, height: 40)
        name2.textColor = Colours.grayDark.withAlphaComponent(0.9)
        name2.font = UIFont.systemFont(ofSize: 12)
        name2.isUserInteractionEnabled = false
        name2.numberOfLines = 2
        containerView.addSubview(name2)
        
        contentView.addSubview(containerView)
        
        let viewsDict = [
            "containerView" : containerView,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[containerView]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[containerView(90)]-10-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ card: Card) {
        self.currentType = card.type
        self.currentURL = card.authorUrl ?? card.providerUrl ?? ""
        self.realURL = card.url
        
        if self.name.text == "" {
            self.name.text = "URL"
            self.auth.text = ""
            self.name2.text = self.currentURL
            self.image1.pin_setPlaceholder(with: UIImage(named: "logo"))
            self.image1.pin_updateWithProgress = true
        }
        
        self.name.text = card.title
        self.auth.text = card.authorName ?? card.providerName ?? "Tap to view"
        if card.description == "" {
            self.name2.text = card.url.absoluteString
        } else {
            self.name2.text = card.description
        }
        self.image1.pin_setImage(from: card.image ?? nil)
        self.containerView.addTarget(self, action: #selector(self.didTouchLink), for: .touchUpInside)
    }
    
    @objc func didTouchLink() {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if self.currentType == .video {
            if self.currentURL.contains("youtube") {
                let videoURL = NSURL(string: self.realURL!.absoluteString)!
                Youtube.h264videosWithYoutubeURL(youtubeURL: videoURL) { (videoInfo, error) -> Void in
                    if let videoURLStr = videoInfo?["url"] as? String {
                        let videoURL = URL(string: videoURLStr)!
                        if (UserDefaults.standard.object(forKey: "vidgif") == nil) || (UserDefaults.standard.object(forKey: "vidgif") as! Int == 0) {
                            XPlayer.play(videoURL)
                        } else {
                            self.player = AVPlayer(url: videoURL)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = self.player
                            appDelegate.window?.rootViewController?.present(playerViewController, animated: true) {
                                playerViewController.player!.play()
                            }
                        }
                        
                    }
                }
                return
            }
            let videoURL = self.realURL!
            if (UserDefaults.standard.object(forKey: "vidgif") == nil) || (UserDefaults.standard.object(forKey: "vidgif") as! Int == 0) {
                XPlayer.play(videoURL)
            } else {
                self.player = AVPlayer(url: videoURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = self.player
                appDelegate.window?.rootViewController?.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            return
        }
        let url = self.realURL!
        UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
            if !success {
                self.safariVC = SFSafariViewController(url: url)
                self.safariVC?.preferredBarTintColor = Colours.white
                self.safariVC?.preferredControlTintColor = Colours.tabSelected
                appDelegate.window?.rootViewController?.present(self.safariVC!, animated: true, completion: nil)
            }
        }
    }
}
