//
//  StoreStruct.swift
//  mastodon
//
//  Created by Shihab Mehboob on 19/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

struct StoreStruct {
    
    init(){ }
    
    static var shared = StoreStruct()
    
    // UIColor(red: 156/255.0, green: 203/255.0, blue: 88/255.0, alpha: 1.0)
    
    // UIColor(red: 107/255.0, green: 122/255.0, blue: 214/255.0, alpha: 1.0)
    static var colArray = [UIColor(red: 156/255.0, green: 203/255.0, blue: 88/255.0, alpha: 1.0),
                           UIColor(red: 79/255.0, green: 121/255.0, blue: 251/255.0, alpha: 1.0),
                           UIColor(red: 83/255.0, green: 153/255.0, blue: 244/255.0, alpha: 1.0),
                           UIColor(red: 149/255.0, green: 192/255.0, blue: 248/255.0, alpha: 1.0),
                           UIColor(red: 152/255.0, green: 228/255.0, blue: 220/255.0, alpha: 1.0),
                           UIColor(red: 122/255.0, green: 236/255.0, blue: 238/255.0, alpha: 1.0),
                           UIColor(red: 122/255.0, green: 238/255.0, blue: 145/255.0, alpha: 1.0),
                           UIColor(red: 115/255.0, green: 191/255.0, blue: 105/255.0, alpha: 1.0),
                           UIColor(red: 159/255.0, green: 224/255.0, blue: 151/255.0, alpha: 1.0),
                           UIColor(red: 238/255.0, green: 235/255.0, blue: 162/255.0, alpha: 1.0),
                           UIColor(red: 255/255.0, green: 238/255.0, blue: 71/255.0, alpha: 1.0),
                           UIColor(red: 240/255.0, green: 252/255.0, blue: 83/255.0, alpha: 1.0),
                           UIColor(red: 248/255.0, green: 173/255.0, blue: 59/255.0, alpha: 1.0),
                           UIColor(red: 244/255.0, green: 135/255.0, blue: 83/255.0, alpha: 1.0),
                           UIColor(red: 255/255.0, green: 108/255.0, blue: 38/255.0, alpha: 1.0),
                           UIColor(red: 253/255.0, green: 109/255.0, blue: 109/255.0, alpha: 1.0),
                           UIColor(red: 254/255.0, green: 72/255.0, blue: 72/255.0, alpha: 1.0),
                           UIColor(red: 253/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1.0),
                           UIColor(red: 243/255.0, green: 137/255.0, blue: 201/255.0, alpha: 1.0),
                           UIColor(red: 250/255.0, green: 69/255.0, blue: 178/255.0, alpha: 1.0),
                           UIColor(red: 165/255.0, green: 29/255.0, blue: 111/255.0, alpha: 1.0),
                           UIColor(red: 216/255.0, green: 166/255.0, blue: 102/255.0, alpha: 1.0),
                           UIColor(red: 203/255.0, green: 144/255.0, blue: 42/255.0, alpha: 1.0),
                           UIColor(red: 168/255.0, green: 111/255.0, blue: 13/255.0, alpha: 1.0),
                           UIColor(red: 150/255.0, green: 150/255.0, blue: 160/255.0, alpha: 1.0),
                           UIColor(red: 100/255.0, green: 100/255.0, blue: 110/255.0, alpha: 1.0),
                           UIColor(red: 58/255.0, green: 58/255.0, blue: 65/255.0, alpha: 1.0),
                           UIColor(red: 38/255.0, green: 38/255.0, blue: 45/255.0, alpha: 1.0),
                           UIColor.clear]
    
    static var client = Client(baseURL: StoreStruct.shared.currentInstance.returnedText, accessToken:StoreStruct.shared.currentInstance.accessToken)
    var currentInstance:InstanceData = InstanceData.getCurrentInstance() ?? InstanceData()
    var allInstances:[InstanceData] = InstanceData.getAllInstances()
    var newClient = Client(baseURL: "")
    var newInstance:InstanceData?
    static var currentPage = 0
    static var playerID = ""
    
    static var caption1: String = ""
    static var caption2: String = ""
    static var caption3: String = ""
    static var caption4: String = ""
    
    static var emotiSize = 16
    static var emotiFace: [Emoji] = []
    static var mainResult: [NSAttributedString] = []
    static var instanceLocalToAdd: [String] = []
    
    static var statusesHome: [Status] = []
    static var statusesLocal: [Status] = []
    static var statusesFederated: [Status] = []
    
    static var notifications: [Notificationt] = []
    static var notificationsMentions: [Notificationt] = []
    static var notificationsDirect: [Notificationt] = []
    
    static var fromOtherUser = false
    static var userIDtoUse = ""
    static var profileStatuses: [Status] = []
    static var profileStatusesHasImage: [Status] = []
    
    static var statusSearch: [Status] = []
    static var statusSearchUser: [Account] = []
    static var searchIndex: Int = 0
    
    static var tempLiked: [Status] = []
    static var tempPinned: [Status] = []
    
    static var tappedTag = ""
    static var currentUser: Account!
    static var userAccounts: [Account]!
    static var newInstanceTags: [Status] = []
    static var instanceText = ""
    
    static var allLists: [List] = []
    static var allListRelID: String = ""
    static var currentList: [Status] = []
    static var currentListTitle: String = ""
    static var drafts: [String] = []
    
    static var allLikes: [String] = []
    static var allBoosts: [String] = []
    static var allPins: [String] = []
    static var photoNew = UIImage()
    static var spoilerText = ""
    static var typeOfSearch = 0
    
    static var curID = ""
    static var curIDNoti = ""
    static var doOnce = true
    static var isSplit = false
    
    static var gapLastHomeID = ""
    static var gapLastLocalID = ""
    static var gapLastFedID = ""
    
    static var gapLastHomeStat: Status? = nil
    static var gapLastLocalStat: Status? = nil
    static var gapLastFedStat: Status? = nil
    
    static var newIDtoGoTo = ""
    static var maxChars = 500
    static var initTimeline = false
    
    static var savedComposeText = ""
    static var savedInReplyText = ""
    
    static var hexCol = UIColor.white
    static var historyBool = false
    
    static var currentInstanceDetails: [Instance] = []
    static var currentImageURL = URL(string: "www.google.com")
}
