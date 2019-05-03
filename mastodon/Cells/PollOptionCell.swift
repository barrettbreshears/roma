//
//  PollOptionCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 05/03/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class PollOptionCell: SwipeTableViewCell {
    
    var optionCount = UILabel()
    var theOption = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        optionCount.translatesAutoresizingMaskIntoConstraints = false
        theOption.translatesAutoresizingMaskIntoConstraints = false
        
        optionCount.numberOfLines = 0
        theOption.numberOfLines = 0
        
        optionCount.textColor = Colours.grayDark.withAlphaComponent(0.38)
        theOption.textColor = Colours.black
        
        optionCount.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        theOption.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        
        contentView.addSubview(optionCount)
        contentView.addSubview(theOption)
        
        let viewsDict = [
            "optionCount" : optionCount,
            "theOption" : theOption,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[optionCount]-(>=5)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[theOption]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[optionCount]-5-[theOption]-18-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ poll: String, count: String) {
        optionCount.text = count
        theOption.text = poll
        
        optionCount.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        theOption.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        
    }
    
}


