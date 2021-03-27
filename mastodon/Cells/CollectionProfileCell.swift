//
//  CollectionProfileCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 21/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class CollectionProfileCell: UICollectionViewCell {
    
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
//        self.bgImage.image = nil
//        self.image.image = nil
    }
    
    public func configure() {
        
        self.bgImage.backgroundColor = Colours.white
        self.bgImage.frame = CGRect(x: 0, y: 0, width: 174, height: 150)
        self.bgImage.layer.cornerRadius = 10
        contentView.addSubview(bgImage)
        
        self.image.frame.origin.x = 0
        self.image.frame.origin.y = 0
        self.image.frame.size.width = 190
        self.image.frame.size.height = 150
        self.image.backgroundColor = UIColor.clear
        self.image.layer.cornerRadius = 10
        contentView.addSubview(image)
        
//        imageCountTag.translatesAutoresizingMaskIntoConstraints = false
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
        let constraintsCountTag30 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[countTag(30)]-(>=12)-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsCountTag30 {
            constraint.identifier = "$CollectionProfileCell-contentView-countTag30$"
        }
        contentView.addConstraints(constraintsCountTag30)
        let constraintsCountTag22 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[countTag(22)]-(>=12)-|", options: [], metrics: nil, views: viewsDict)
        for constraint in constraintsCountTag22 {
            constraint.identifier = "$CollectionProfileCell-contentView-countTag22$"
        }
        contentView.addConstraints(constraintsCountTag22)
    }
}

