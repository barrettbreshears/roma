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
        
        self.bgImage.backgroundColor = Colours.white
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.bgImage.frame = CGRect(x: 0, y: 0, width: 290, height: 250)
        } else {
            self.bgImage.frame = CGRect(x: 0, y: 0, width: 174, height: 150)
        }
        self.bgImage.layer.cornerRadius = 10
        contentView.addSubview(bgImage)
        
        self.image.frame.origin.x = 0
        self.image.frame.origin.y = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.image.frame.size.width = 290
            self.image.frame.size.height = 250
        } else {
            self.image.frame.size.width = 190
            self.image.frame.size.height = 150
        }
        self.image.backgroundColor = UIColor.clear
        self.image.layer.cornerRadius = 10
        contentView.addSubview(image)
    }
}

