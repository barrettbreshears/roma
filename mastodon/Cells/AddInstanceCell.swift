//
//  InstanceCell.swift
//  mastodon
//
//  Created by Barrett Breshears on 12/5/18.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit

class AddInstanceCell: UITableViewCell {

    var bgImage = UIImageView()
    var label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Set the cell's imageView's image to nil
        self.bgImage.image = nil
        self.label.text = nil
        
    }
    
    public func configure() {
        self.bgImage.backgroundColor = Colours.white
        self.bgImage.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        self.bgImage.layer.cornerRadius = 12
        contentView.addSubview(bgImage)
        
        contentView.addSubview(label)
        self.label.centerInSuperview()
        self.label.textAlignment = .center
        self.label.text = "Add Instance +"
        self.layoutIfNeeded()
        
    }

}
