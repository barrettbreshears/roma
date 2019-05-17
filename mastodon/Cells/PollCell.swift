//
//  PollCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 05/03/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class PollCell: UITableViewCell, CoreChartViewDataSource {
    
    var barChart: HCoreBarChart = HCoreBarChart()
    var countLabel = UILabel()
    var expiryLabel = UILabel()
    var options: [PollOptions] = []
    var poll: Poll!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCoreChartData() -> [CoreChartEntry] {
        var allData = [CoreChartEntry]()
        for index in 0..<self.options.count {
            let newEntry = CoreChartEntry(id: "\(index)",
                barTitle: options[index].title,
                barHeight: Double(self.options[index].votesCount ?? 0),
                barColor: Colours.tabSelected)
            allData.append(newEntry)
        }
        return allData
    }
    
    func didTouch(entryData: CoreChartEntry) {
        print("tapped \(entryData.id)")
        StoreStruct.currentPollSelectionTitle = entryData.barTitle
        StoreStruct.currentPollSelection.append(Int(entryData.id) ?? 0)
        StoreStruct.currentPollSelection = StoreStruct.currentPollSelection.removeDuplicates()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tappedPoll"), object: nil)
    }
    
    func configure(thePoll: Poll, theOptions: [PollOptions]) {
        self.options = theOptions
        self.poll = thePoll
        
        StoreStruct.currentPollSelection = []
        
        StoreStruct.pollHeight = (self.options.count*32) + (self.options.count*16) + 80
        barChart.frame = CGRect(x: 20, y: 6, width: Int(CGFloat(UIScreen.main.bounds.width - 40)), height: StoreStruct.pollHeight)
        barChart.dataSource = self
        barChart.displayConfig = CoreBarChartsDisplayConfig(barWidth: 32.0,
                                                            barSpace: 16.0,
                                                            bottomSpace: 10.0,
                                                            topSpace: 6.0,
                                                            backgroundColor: Colours.white,
                                                            titleFontSize: 14,
                                                            valueFontSize: 16,
                                                            titleFont: nil,
                                                            valueFont: nil,
                                                            titleLength: 400)
        contentView.addSubview(self.barChart)
        
        var voteText = "\(thePoll.votesCount) votes"
        if thePoll.voted ?? false {
            voteText = "\(thePoll.votesCount) votes • VOTED"
        }
        if thePoll.multiple {
            voteText = "\(voteText) • Multiple choices allowed"
        }
        countLabel.frame = CGRect(x: 30, y: Int(StoreStruct.pollHeight - 60), width: Int(CGFloat(UIScreen.main.bounds.width - 60)), height: 30)
        countLabel.text = voteText
        countLabel.font = UIFont.boldSystemFont(ofSize: 13)
        countLabel.textColor = Colours.grayDark
        countLabel.textAlignment = .left
        contentView.addSubview(self.countLabel)
        
        var timeText = "Expires at \(thePoll.expiresAt?.toString(dateStyle: .short, timeStyle: .short) ?? "")"
        if thePoll.expired {
            timeText = "CLOSED"
        }
        expiryLabel.frame = CGRect(x: 30, y: Int(StoreStruct.pollHeight - 38), width: Int(CGFloat(UIScreen.main.bounds.width - 60)), height: 30)
        expiryLabel.text = timeText
        expiryLabel.font = UIFont.systemFont(ofSize: 13)
        expiryLabel.textColor = Colours.grayDark.withAlphaComponent(0.38)
        expiryLabel.textAlignment = .left
        contentView.addSubview(self.expiryLabel)
    }
    
}

