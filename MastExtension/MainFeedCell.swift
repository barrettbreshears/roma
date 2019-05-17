//
//  MainFeedCell.swift
//  MastExtension
//
//  Created by Shihab Mehboob on 04/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class MainFeedCell: UITableViewCell {
    
    var profileImageView = UIButton()
    var userName = UILabel()
    var date = UILabel()
    var toot = UILabel()
    var moreImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = UIColor.white
        moreImage.backgroundColor = UIColor.clear
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        moreImage.translatesAutoresizingMaskIntoConstraints = false
        
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as? Int == 0) {
            profileImageView.layer.cornerRadius = 20
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as? Int == 1) {
            profileImageView.layer.cornerRadius = 8
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as? Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        profileImageView.layer.masksToBounds = true
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = UIColor.black
        date.textColor = UIColor.black.withAlphaComponent(0.6)
        toot.textColor = UIColor.black
        
        userName.font = UIFont.boldSystemFont(ofSize: 14)
        date.font = UIFont.systemFont(ofSize: 12)
        toot.font = UIFont.systemFont(ofSize: 14)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        
        let viewsDict = [
            "image" : profileImageView,
            "name" : userName,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[image(40)]-13-[name]-(>=5)-[date]-15-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[image(40)]-(>=5)-[more(16)]-15-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[image(40)]-13-[episodes]-15-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-2-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Status) {
        userName.text = status.reblog?.account.displayName ?? status.account.displayName
        date.text = status.reblog?.createdAt.toStringWithRelativeTime() ?? status.createdAt.toStringWithRelativeTime()
        toot.text = status.reblog?.content.stripHTML() ?? status.content.stripHTML()
        
        if status.reblog?.content.stripHTML() != nil {
            if status.reblog!.emojis.isEmpty {
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.content.stripHTML() ?? "")\n\n")
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"boost2")?.maskWithColor(color: UIColor.black.withAlphaComponent(0.38))
                imageAttachment.bounds = CGRect(x: 0, y: -1, width: Int(self.toot.font.lineHeight - 5), height: Int(self.toot.font.lineHeight))
                let attachmentString2 = NSAttributedString(attachment: imageAttachment)
                let completeText2 = NSMutableAttributedString(string: "")
                completeText2.append(attachmentString2)
                let textAfterIcon2 = NSMutableAttributedString(string: " \(status.account.displayName)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.38)])
                completeText2.append(textAfterIcon2)
                attributedString.append(completeText2)
                self.toot.attributedText = attributedString
                self.reloadInputViews()
            } else {
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.content.stripHTML() ?? "")\n\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
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
                imageAttachment.image = UIImage(named:"boost2")?.maskWithColor(color: UIColor.black.withAlphaComponent(0.38))
                imageAttachment.bounds = CGRect(x: 0, y: -1, width: Int(self.toot.font.lineHeight - 5), height: Int(self.toot.font.lineHeight))
                let attachmentString2 = NSAttributedString(attachment: imageAttachment)
                let completeText2 = NSMutableAttributedString(string: "")
                completeText2.append(attachmentString2)
                let textAfterIcon2 = NSMutableAttributedString(string: " \(status.account.displayName)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.38)])
                completeText2.append(textAfterIcon2)
                attributedString.append(completeText2)
                
                self.toot.attributedText = attributedString
                self.reloadInputViews()
            }
        } else {
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
        }
        
        userName.font = UIFont.boldSystemFont(ofSize: 14)
        date.font = UIFont.systemFont(ofSize: 12)
        toot.font = UIFont.systemFont(ofSize: 14)
        
        
        let url3 = URL(string: "\(status.reblog?.account.avatar ?? status.account.avatar)")
        if url3 == nil {} else {
        DispatchQueue.global().async {
            if "\(status.reblog?.account.avatar ?? status.account.avatar)" == "" {} else {
                let data = try? Data(contentsOf: url3!)
                DispatchQueue.main.async {
                    self.profileImageView.setImage(UIImage(data: data ?? Data()), for: .normal)
                }
            }
        }
        }
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 0.2
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as? Int == 0) {
            profileImageView.layer.cornerRadius = 20
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as? Int == 1) {
            profileImageView.layer.cornerRadius = 8
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as? Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        
        
        
    }
    
}



extension String {
    func stripHTML() -> String {
        //z = z.replacingOccurrences(of: "<p>", with: "\n", options: NSString.CompareOptions.regularExpression, range: nil)
        
        var z = self.replacingOccurrences(of: "</p><p>", with: "\n\n", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "<br />", with: "\n", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "<[^>]+>", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&apos;", with: "'", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&quot;", with: "\"", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&amp;", with: "&", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&lt;", with: "<", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&gt;", with: ">", options: NSString.CompareOptions.regularExpression, range: nil)
        return z
    }
}

extension UIImage {
    public func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
}

let imageCache = NSCache<NSString, AnyObject>()

extension NSTextAttachment {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}
