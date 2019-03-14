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

class DetailCellLink: UITableViewCell {
    
    var containerView = UIButton()
    var image1 = UIImageView()
    var name = UILabel()
    var name2 = UILabel()
    var safariVC: SFSafariViewController?
    var currentURL = ""
    
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
        
        image1.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        image1.backgroundColor = Colours.white3
        image1.contentMode = .scaleAspectFill
        image1.clipsToBounds = true
        containerView.addSubview(image1)
        
        name.text = ""
        name.frame = CGRect(x: 85, y: 5, width: UIScreen.main.bounds.width - 140, height: 25)
        name.textColor = Colours.grayDark
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.isUserInteractionEnabled = false
        containerView.addSubview(name)
        
        name2.text = ""
        name2.frame = CGRect(x: 85, y: 26, width: UIScreen.main.bounds.width - 140, height: 40)
        name2.textColor = Colours.grayDark.withAlphaComponent(0.6)
        name2.font = UIFont.systemFont(ofSize: 12)
        name2.isUserInteractionEnabled = false
        name2.numberOfLines = 2
        containerView.addSubview(name2)
        
        contentView.addSubview(containerView)
        
        let viewsDict = [
            "containerView" : containerView,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[containerView]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[containerView(70)]-10-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ url: String) {
        self.currentURL = url
        
        let slp = SwiftLinkPreview(session: URLSession.shared,
                                   workQueue: DispatchQueue.global(qos: .userInitiated),
                                   responseQueue: DispatchQueue.main)
        
        if self.name.text == "" {
            self.name.text = "URL"
            self.name2.text = url
            self.image1.pin_setPlaceholder(with: UIImage(named: "logo"))
            self.image1.pin_updateWithProgress = true
        }
        slp.preview(url,
                    onSuccess: { result in
                        print("\(result)")
                        self.name.text = result.title ?? ""
                        self.name2.text = result.description ?? result.canonicalUrl ?? url
                        self.image1.pin_setImage(from: URL(string: result.image ?? result.icon ?? ""))
                        self.containerView.addTarget(self, action: #selector(self.didTouchLink), for: .touchUpInside)
        },
                    onError: { error in
                        print("\(error)")
        })
    }
    
    @objc func didTouchLink() {
        print(self.currentURL)
        if self.currentURL.contains("http") {} else {
            self.currentURL = "http://\(self.currentURL)"
        }
        
        if self.currentURL.contains("http") {
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let url = URL(string: self.currentURL) ?? URL(string: "google.com")!
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
}
