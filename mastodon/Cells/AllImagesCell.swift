//
//  AllImagesCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 24/04/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class AllImagesCell: UICollectionViewCell {
    
    var bgImage = UIImageView()
    var image = UIImageView()
    var imageCountTag = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Set the cell's imageView's image to nil
        self.bgImage.image = nil
        self.image.image = nil
    }
    
    public func configure() {
        self.bgImage.backgroundColor = Colours.clear
        self.bgImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        self.bgImage.layer.cornerRadius = 10
        contentView.addSubview(bgImage)
        
        self.image.backgroundColor = UIColor.clear
        self.image.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        self.image.layer.cornerRadius = 10
        contentView.addSubview(image)
        
        imageCountTag.isUserInteractionEnabled = false
        imageCountTag.setTitle("", for: .normal)
        imageCountTag.backgroundColor = Colours.clear
        imageCountTag.translatesAutoresizingMaskIntoConstraints = false
        imageCountTag.layer.cornerRadius = 7
        imageCountTag.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        imageCountTag.layer.shadowColor = UIColor.black.cgColor
        imageCountTag.layer.shadowOffset = CGSize(width: 0, height: 7)
        imageCountTag.layer.shadowRadius = 10
        imageCountTag.layer.shadowOpacity = 0.22
        imageCountTag.layer.masksToBounds = false
        imageCountTag.alpha = 1
        contentView.addSubview(imageCountTag)
        
        let viewsDict = [
            "countTag" : imageCountTag,
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[countTag(30)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[countTag(22)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
    }
}




