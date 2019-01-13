//
//  DateCollectionViewCell.swift
//  DateTimePicker
//
//  Created by Huong Do on 9/26/16.
//  Copyright © 2016 ichigo. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    var dayLabel: UILabel! // rgb(128,138,147)
    var numberLabel: UILabel!
    var darkColor = Colours.grayLight2
    var highlightColor = UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 0.5)
    
    override init(frame: CGRect) {
        
        dayLabel = UILabel(frame: CGRect(x: 5, y: 15, width: frame.width - 10, height: 20))
        dayLabel.font = UIFont.systemFont(ofSize: 10)
        dayLabel.textAlignment = .center
    
        numberLabel = UILabel(frame: CGRect(x: 5, y: 30, width: frame.width - 10, height: 40))
        numberLabel.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        numberLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(numberLabel)
        contentView.backgroundColor = Colours.clear
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            dayLabel.textColor = isSelected == true ? .white : UIColor.white.withAlphaComponent(0.5)
            numberLabel.textColor = isSelected == true ? .white : .white
            contentView.backgroundColor = isSelected == true ? UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 0.5) : Colours.clear
            contentView.layer.borderWidth = isSelected == true ? 0 : 0
        }
    }
    
    func populateItem(date: Date, highlightColor: UIColor, darkColor: UIColor, locale: Locale) {
        self.highlightColor = highlightColor
        self.darkColor = darkColor
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = locale
        dayLabel.text = dateFormatter.string(from: date).uppercased()
        dayLabel.textColor = isSelected == true ? .white : UIColor.white.withAlphaComponent(0.5)
        
        let numberFormatter = DateFormatter()
        numberFormatter.dateFormat = "d"
        numberFormatter.locale = locale
        numberLabel.text = numberFormatter.string(from: date)
        numberLabel.textColor = isSelected == true ? .white : .white
        
        contentView.layer.borderColor = darkColor.withAlphaComponent(0.2).cgColor
        contentView.backgroundColor = isSelected == true ? UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 0.5) : Colours.clear
    }
    
}
