//
//  SettingsBundleHelper.swift
//  mastodon
//
//  Created by Shihab Mehboob on 26/01/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import Disk

class SettingsBundleHelper {
    
    struct SettingsBundleKeys {
        static let Reset = "RESET_APP_KEY"
        static let AppVersionKey = "version_preference"
    }
    
    class func checkAndExecuteSettings() {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.Reset) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Reset)
            
            let appDomain: String? = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                if key == "PushNotificationState" || key == "PushNotificationReceiver" {} else {
                    defaults.removeObject(forKey: key)
                }
            }
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.set(nil, forKey: "onb")
            UserDefaults.standard.synchronize()
            
            StoreStruct.client = Client(baseURL: "")
            StoreStruct.newClient = Client(baseURL: "")
            StoreStruct.newInstance = nil
            StoreStruct.currentInstance = InstanceData()
            StoreStruct.newInstance = InstanceData()
            InstanceData.clearInstances()
            StoreStruct.currentPage = 0
            StoreStruct.playerID = ""
            StoreStruct.caption1 = ""
            StoreStruct.caption2 = ""
            StoreStruct.caption3 = ""
            StoreStruct.caption4 = ""
            StoreStruct.emotiSize = 16
            StoreStruct.emotiFace = []
            StoreStruct.mainResult = []
            StoreStruct.instanceLocalToAdd = []
            StoreStruct.statusesHome = []
            StoreStruct.statusesLocal = []
            StoreStruct.statusesFederated = []
            StoreStruct.notifications = []
            StoreStruct.notificationsMentions = []
            StoreStruct.fromOtherUser = false
            StoreStruct.userIDtoUse = ""
            StoreStruct.profileStatuses = []
            StoreStruct.profileStatusesHasImage = []
            StoreStruct.statusSearch = []
            StoreStruct.statusSearchUser = []
            StoreStruct.searchIndex = 0
            StoreStruct.tappedTag = ""
            StoreStruct.currentUser = nil
            StoreStruct.newInstanceTags = []
            StoreStruct.allLists = []
            StoreStruct.allListRelID = ""
            StoreStruct.currentList = []
            StoreStruct.currentListTitle = ""
            StoreStruct.allLikes = []
            StoreStruct.allBoosts = []
            StoreStruct.allPins = []
            StoreStruct.photoNew = UIImage()
            StoreStruct.spoilerText = ""
            StoreStruct.typeOfSearch = 0
            StoreStruct.curID = ""
            StoreStruct.curIDNoti = ""
            StoreStruct.doOnce = true
            StoreStruct.isSplit = false
            StoreStruct.gapLastHomeID = ""
            StoreStruct.gapLastLocalID = ""
            StoreStruct.gapLastFedID = ""
            StoreStruct.gapLastHomeStat = nil
            StoreStruct.gapLastLocalStat = nil
            StoreStruct.gapLastFedStat = nil
            StoreStruct.newIDtoGoTo = ""
            StoreStruct.maxChars = 500
            StoreStruct.initTimeline = false
            StoreStruct.savedComposeText = ""
            StoreStruct.savedInReplyText = ""
            StoreStruct.hexCol = UIColor.white
            StoreStruct.historyBool = false
            StoreStruct.currentInstanceDetails = []
            StoreStruct.currentImageURL = URL(string: "www.google.com")
            StoreStruct.containsPoll = false
            StoreStruct.pollHeight = 0
            StoreStruct.currentPollSelection = []
            StoreStruct.currentPollSelectionTitle = ""
            StoreStruct.newPollPost = []
            StoreStruct.currentOptions = []
            StoreStruct.expiresIn = 86400
            StoreStruct.allowsMultiple = false
            StoreStruct.totalsHidden = false
            StoreStruct.pollPickerDate = Date()
            StoreStruct.composedTootText = ""
            StoreStruct.holdOnTempText = ""
            StoreStruct.tappedSignInCheck = false
            StoreStruct.markedReadIDs = []
            StoreStruct.newdrafts = []
            StoreStruct.notTypes = []
            StoreStruct.notifications = []
            StoreStruct.notificationsMentions = []
            StoreStruct.notificationsDirect = []
            StoreStruct.switchedNow = true
            
            do {
                try Disk.clear(.documents)
            } catch {
                print("couldn't clear disk")
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.resetApp()
        }
    }
    
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_preference")
    }
}
