//
//  SettingsBundleHelper.swift
//  mastodon
//
//  Created by Shihab Mehboob on 26/01/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

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
                defaults.removeObject(forKey: key)
            }
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            
            StoreStruct.client = Client(baseURL: "")
            StoreStruct.shared.currentInstance.redirect = ""
            StoreStruct.shared.currentInstance.returnedText = ""
            StoreStruct.shared.currentInstance.clientID = ""
            StoreStruct.shared.currentInstance.clientSecret = ""
            StoreStruct.shared.currentInstance.authCode = ""
            StoreStruct.shared.currentInstance.accessToken = ""
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
            StoreStruct.drafts = []
            StoreStruct.allLikes = []
            StoreStruct.allBoosts = []
            StoreStruct.allPins = []
            StoreStruct.photoNew = UIImage()
        }
    }
    
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_preference")
    }
}
