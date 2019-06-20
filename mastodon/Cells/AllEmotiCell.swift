//
//  AllEmotiCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 25/04/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class AllEmotiCell: UICollectionViewCell {
    
    var emoti = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.emoti.text = ""
    }
    
    public func configure() {
        self.emoti.backgroundColor = UIColor.clear
        self.emoti.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        self.emoti.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(emoti)
    }
}





