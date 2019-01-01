//
//  GraphCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class GraphCell: UITableViewCell, ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        if pointIndex == 0 {
            let x = StoreStruct.notifications.filter({ (item) -> Bool in
                item.type == .mention
            })
            return Double(x.count)
        } else if pointIndex == 1 {
            let x = StoreStruct.notifications.filter({ (item) -> Bool in
                item.type == .mention
            })
            let y = x.filter({ (item) -> Bool in
                item.status?.visibility == .direct
            })
            return Double(y.count)
        } else if pointIndex == 2 {
            let x = StoreStruct.notifications.filter({ (item) -> Bool in
                item.type == .reblog
            })
            return Double(x.count)
        } else if pointIndex == 3 {
            let x = StoreStruct.notifications.filter({ (item) -> Bool in
                item.type == .favourite
            })
            return Double(x.count)
        } else {
            let x = StoreStruct.notifications.filter({ (item) -> Bool in
                item.type == .follow
            })
            return Double(x.count)
        }
    }
    
    let labels = ["Mentions", "Private", "Boosts", "Likes", "Follows"]
    func label(atIndex pointIndex: Int) -> String {
        return labels[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return 5
    }
    
    var graphView = ScrollableGraphView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        self.graphView.removeFromSuperview()
        self.graphView = ScrollableGraphView(frame: CGRect(x: 0, y: 20, width: CGFloat(UIScreen.main.bounds.width), height: 200), dataSource: self)
        
        self.graphView.isScrollEnabled = false
        if (UserDefaults.standard.object(forKey: "setGraph2") == nil) || (UserDefaults.standard.object(forKey: "setGraph2") as! Int == 0) {
            self.graphView.shouldAnimateOnStartup = true
            self.graphView.shouldAnimateOnAdapt = true
        } else {
            self.graphView.shouldAnimateOnStartup = false
            self.graphView.shouldAnimateOnAdapt = false
        }
        self.graphView.shouldAdaptRange = true
        self.graphView.alpha = 1
        
        let barPlot = BarPlot(identifier: "bar")
        
        barPlot.barWidth = 34
        barPlot.barLineWidth = 1
        barPlot.barLineColor = Colours.tabSelected
        barPlot.barColor = Colours.tabSelected
        barPlot.shouldRoundBarCorners = true
        
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.easeOut
        barPlot.animationDuration = 1.5
        
        
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = Colours.black.withAlphaComponent(0.06)
        referenceLines.referenceLineLabelColor = Colours.black.withAlphaComponent(0.5)
        
        referenceLines.dataPointLabelColor = Colours.black.withAlphaComponent(0.5)
        
        graphView.backgroundFillColor = Colours.clear
        graphView.addPlot(plot: barPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        contentView.addSubview(self.graphView)
    }
    
}
