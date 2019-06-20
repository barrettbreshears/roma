//
//  CollectionProCells.swift
//  mastodon
//
//  Created by Shihab Mehboob on 20/12/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class CollectionProCells: UICollectionViewCell {
    
    var account:Account?
    var bgImage = UIImageView()
    var image = UIImageView()
    var name = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Set the cell's imageView's image to nil
//        self.bgImage.image = nil
//        self.image.image = nil
//        self.name.text = ""
    }
    
    public func configure() {
        self.bgImage.backgroundColor = Colours.clear
        self.bgImage.frame = CGRect(x: 0, y: 5, width: 55, height: 55)
        self.bgImage.layer.cornerRadius = 27.5
        contentView.addSubview(bgImage)
        
        self.image.frame = CGRect(x: 0, y: 5, width: 55, height: 55)
        self.image.backgroundColor = UIColor.clear
        self.image.layer.cornerRadius = 27.5
        self.image.image = nil
        contentView.addSubview(image)
        
        self.name.frame = CGRect(x: 0, y: 63, width: 55, height: 20)
        self.name.font = UIFont.boldSystemFont(ofSize: 12)
        self.name.textColor = Colours.grayDark2.withAlphaComponent(0.35)
        self.name.textAlignment = .center
        self.name.minimumScaleFactor = 0.75
        self.name.adjustsFontSizeToFitWidth = true
        contentView.addSubview(name)
    }
    
    func setImageFromAccount(account:Account){
        
        if account.avatarStatic != nil {
            self.image.pin_setImage(from: URL(string: account.avatarStatic))
            
        }
        
    }
}




