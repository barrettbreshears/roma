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
    
    static var ASCIIFace: [String] = ["¯\\_(ツ)_/¯", "( ͡° ͜ʖ ͡°)", "( ͡° ʖ̯ ͡°)", "ಠ_ಠ", "(╯°□°）╯︵ ┻━┻", "┬──┬◡ﾉ(° -°ﾉ)", "( •_•)", "( •_•)>⌐■-■", "(⌐■_■)", "(̿▀̿‿ ̿▀̿ ̿)", "ᕕ( ᐛ )ᕗ", "(☞ﾟヮﾟ)☞", "ʕ•ᴥ•ʔ", "(°ー°〃)", "༼ つ ◕_◕ ༽つ", "ԅ(≖‿≖ԅ)", "(•̀ᴗ•́)و ̑̑", "ಠᴗಠ", "ಥ_ಥ", "(ಥ﹏ಥ)", "(づ￣ ³￣)づ", "ლ(ಠ_ಠლ)", "(⊙_☉)", "ʘ‿ʘ", "ᕦ(ò_óˇ)ᕤ", "( ˘ ³˘)♥", "ಠ_ರೃ", "( ˇ෴ˇ )", "(ﾉ◕ヮ◕)ﾉ*:・ﾟ✧", "(∩｀-´)⊃━☆ﾟ.*･｡ﾟ", "(ง •̀_•́)ง", "(◕‿◕✿)", "(~‾▿‾)~", "ヾ(-_- )ゞ", "|_・)", "(●__●)", "｡◕‿◕｡", "ᕙ(⇀‸↼‶)ᕗ", "｡^‿^｡", "(ง^ᗜ^)ง", "(⊙﹏⊙✿)", "(๑•́ ヮ •̀๑)", "\\_(-_-)_/", "┬┴┬┴┤(･_├┬┴┬┴", "ツ", "ε(´סּ︵סּ`)з", "O=('-'Q)", "L(° O °L)", "._.)/\\(._.", "٩(^‿^)۶", "ᶘ ᵒᴥᵒᶅ", "ᵔᴥᵔ", "ʕ·͡ˑ·ཻʔ", "ʕ⁎̯͡⁎ʔ༄", "ʕ•ᴥ•ʔ", "ʕ￫ᴥ￩ʔ", "ʕ·ᴥ·　ʔ", "ʕ　·ᴥ·ʔ", "ʕっ˘ڡ˘ςʔ", "ʕ´•ᴥ•`ʔ", "ʕ◕ ͜ʖ◕ʔ", "o(^∀^*)o", "( ƅ°ਉ°)ƅ", "⁽(◍˃̵͈̑ᴗ˂̵͈̑)⁽", "ヽ(〃･ω･)ﾉ", "(p^-^)p", "（ﾉ｡≧◇≦）ﾉ", "ヽ/❀o ل͜ o\\ﾉ", "⌒°(ᴖ◡ᴖ)°⌒", "ヽ( ´ー`)ノ", "ヽ(^o^)丿", "(｡♥‿♥｡)", "✿♥‿♥✿", "໒( ♥ ◡ ♥ )७", "ლ(́◉◞౪◟◉‵ლ)", "(^～^;)ゞ", "(-_-)ゞ゛", "⁀⊙﹏☉⁀", "ヾ|`･､●･|ﾉ", "ﾍ(ﾟ∇ﾟﾍ)", "ヽ(๏∀◕ )ﾉ", "ミ●﹏☉ミ", "へ[ ᴼ ▃ ᴼ ]_/¯", "╰། ￣ ۝ ￣ །╯", "╰། ❛ ڡ ❛ །╯", "(*´ڡ`●)", "¯\\(°_o)/¯", "¯\\_༼ ಥ ‿ ಥ ༽_/¯", "＼（〇_ｏ）／", "(‘-’*)", "(*´∀`*)", "(￣ω￣)", "(」゜ロ゜)」", "(ꐦ ಠ皿ಠ )", "（╬ಠ益ಠ)", "༼ つ ͠° ͟ ͟ʖ ͡° ༽つ", ".( ̵˃﹏˂̵ )", "(˃̶᷄︿๏）", "~(>_<~)", "(っ- ‸ – ς)", "✧*。ヾ(｡>﹏<｡)ﾉﾞ✧*。", "(⌣_⌣”)", "(｡•́︿•̀｡)", "ಠ╭╮ಠ", "(˵¯͒⌢͗¯͒˵)", "(⌯˃̶᷄ ﹏ ˂̶᷄⌯)", "( ˃̶͈ ̯ ̜ ˂̶͈ˊ ) ︠³", "(⊃д⊂)", "( ⚆ _ ⚆ )", "(๑˃̵ᴗ˂̵)و", "ಠ_ಠ", "ಠoಠ", "ಠ~ಠ", "ಠ‿ಠ", "ಠ⌣ಠ", "ಠ╭╮ಠ", "ರ_ರ", "ง ͠° ل͜ °)ง", "๏̯͡๏﴿", "( ° ͜ ʖ °)", "( ͡° ͜ʖ ͡°)", "( ⚆ _ ⚆ )", "( ︶︿︶)", "( ﾟヮﾟ)", "┌( ಠ_ಠ)┘", "╚(ಠ_ಠ)=┐", "⚆ _ ⚆"]
    
    static var colArray = [UIColor(red: 156/255.0, green: 203/255.0, blue: 88/255.0, alpha: 1.0),
                           UIColor(red: 62/255.0, green: 74/255.0, blue: 152/255.0, alpha: 1.0),
                           UIColor(red: 33/255.0, green: 86/255.0, blue: 250/255.0, alpha: 1.0),
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
    
    static var client = Client(baseURL: StoreStruct.currentInstance.returnedText, accessToken: StoreStruct.currentInstance.accessToken)
    static var currentInstance: InstanceData = InstanceData.getCurrentInstance() ?? InstanceData()
    static var allInstances: [InstanceData] = InstanceData.getAllInstances()
    static var newClient = Client(baseURL: "")
    static var newInstance: InstanceData?
    static var currentPage = 0
    static var playerID = ""
    
    static var caption1: String = ""
    static var caption2: String = ""
    static var caption3: String = ""
    static var caption4: String = ""
    
    static var emotiSize = 16
    static var emotiFace: [Emoji] = []
    static var mainResult: [NSAttributedString] = []
    static var mainResult1: [NSAttributedString] = []
    static var mainResult2: [NSAttributedString] = []
    static var instanceLocalToAdd: [String] = []
    
    static var tempStatusesHome: [Status] = []
    static var statusesHome: [Status] = []
    static var tempStatusesLocal: [Status] = []
    static var statusesLocal: [Status] = []
    static var tempStatusesFederated: [Status] = []
    static var statusesFederated: [Status] = []
    
    static var tempNotifications: [Notificationt] = []
    static var notifications: [Notificationt] = []
    static var tempNotificationsMentions: [Notificationt] = []
    static var notificationsMentions: [Notificationt] = []
    static var notificationsDirect: [Conversation] = []
    
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
    static var currentListIID: String = ""
//    static var drafts: [Any] = []
    
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
    
    static var containsPoll = false
    static var pollHeight = 0
    static var currentPollSelection: [Int] = []
    static var currentPollSelectionTitle = ""
    
    static var newPollPost: [Any]? = []
    
    static var currentOptions: [String] = []
    static var expiresIn = 86400
    static var allowsMultiple = false
    static var totalsHidden = false
    static var pollPickerDate = Date()
    
    static var composedTootText = ""
    static var holdOnTempText = ""
    
    static var tappedSignInCheck = false
    static var markedReadIDs: [String] = []
    
    static var newdrafts: [Drafts] = []
    static var notTypes: [NotificationType] = []
    
    static var profileStatuses0: [Status] = []
    static var profileStatusesHasImage0: [Status] = []
    
    static var allCurrentFilters: [Filters] = []
    
    static var medType = 0
    static var switchedNow = false
    static var badgeCount = 0
    static var badgeCount2 = 0
    
    static var avaFile = "avatar"
    static var heaFile = "header"
    
    static var nowPlayingText = ""
}

struct Drafts: Codable {
    var text: String
    var image1: Data?
    var image2: Data?
    var image3: Data?
    var image4: Data?
    var isGifVid: Bool
    var textVideoURL: String?
    var gifVidData: Data?
}

class TextStyling {
    func boldTheText(string: String) -> String {
        StoreStruct.holdOnTempText = string
        var string2 = string
        string2 = string.replacingOccurrences(of: "a", with: "𝗮")
        string2 = string2.replacingOccurrences(of: "b", with: "𝗯")
        string2 = string2.replacingOccurrences(of: "c", with: "𝗰")
        string2 = string2.replacingOccurrences(of: "d", with: "𝗱")
        string2 = string2.replacingOccurrences(of: "e", with: "𝗲")
        string2 = string2.replacingOccurrences(of: "f", with: "𝗳")
        string2 = string2.replacingOccurrences(of: "g", with: "𝗴")
        string2 = string2.replacingOccurrences(of: "h", with: "𝗵")
        string2 = string2.replacingOccurrences(of: "i", with: "𝗶")
        string2 = string2.replacingOccurrences(of: "j", with: "𝗷")
        string2 = string2.replacingOccurrences(of: "k", with: "𝗸")
        string2 = string2.replacingOccurrences(of: "l", with: "𝗹")
        string2 = string2.replacingOccurrences(of: "m", with: "𝗺")
        string2 = string2.replacingOccurrences(of: "n", with: "𝗻")
        string2 = string2.replacingOccurrences(of: "o", with: "𝗼")
        string2 = string2.replacingOccurrences(of: "p", with: "𝗽")
        string2 = string2.replacingOccurrences(of: "q", with: "𝗾")
        string2 = string2.replacingOccurrences(of: "r", with: "𝗿")
        string2 = string2.replacingOccurrences(of: "s", with: "𝘀")
        string2 = string2.replacingOccurrences(of: "t", with: "𝘁")
        string2 = string2.replacingOccurrences(of: "u", with: "𝘂")
        string2 = string2.replacingOccurrences(of: "v", with: "𝘃")
        string2 = string2.replacingOccurrences(of: "w", with: "𝘄")
        string2 = string2.replacingOccurrences(of: "x", with: "𝘅")
        string2 = string2.replacingOccurrences(of: "y", with: "𝘆")
        string2 = string2.replacingOccurrences(of: "z", with: "𝘇")
        
        string2 = string2.replacingOccurrences(of: "A", with: "𝗔")
        string2 = string2.replacingOccurrences(of: "B", with: "𝗕")
        string2 = string2.replacingOccurrences(of: "C", with: "𝗖")
        string2 = string2.replacingOccurrences(of: "D", with: "𝗗")
        string2 = string2.replacingOccurrences(of: "E", with: "𝗘")
        string2 = string2.replacingOccurrences(of: "F", with: "𝗙")
        string2 = string2.replacingOccurrences(of: "G", with: "𝗚")
        string2 = string2.replacingOccurrences(of: "H", with: "𝗛")
        string2 = string2.replacingOccurrences(of: "I", with: "𝗜")
        string2 = string2.replacingOccurrences(of: "J", with: "𝗝")
        string2 = string2.replacingOccurrences(of: "K", with: "𝗞")
        string2 = string2.replacingOccurrences(of: "L", with: "𝗟")
        string2 = string2.replacingOccurrences(of: "M", with: "𝗠")
        string2 = string2.replacingOccurrences(of: "N", with: "𝗡")
        string2 = string2.replacingOccurrences(of: "O", with: "𝗢")
        string2 = string2.replacingOccurrences(of: "P", with: "𝗣")
        string2 = string2.replacingOccurrences(of: "Q", with: "𝗤")
        string2 = string2.replacingOccurrences(of: "R", with: "𝗥")
        string2 = string2.replacingOccurrences(of: "S", with: "𝗦")
        string2 = string2.replacingOccurrences(of: "T", with: "𝗧")
        string2 = string2.replacingOccurrences(of: "U", with: "𝗨")
        string2 = string2.replacingOccurrences(of: "V", with: "𝗩")
        string2 = string2.replacingOccurrences(of: "W", with: "𝗪")
        string2 = string2.replacingOccurrences(of: "X", with: "𝗫")
        string2 = string2.replacingOccurrences(of: "Y", with: "𝗬")
        string2 = string2.replacingOccurrences(of: "Z", with: "𝗭")
        
        string2 = string2.replacingOccurrences(of: "1", with: "𝟭")
        string2 = string2.replacingOccurrences(of: "2", with: "𝟮")
        string2 = string2.replacingOccurrences(of: "3", with: "𝟯")
        string2 = string2.replacingOccurrences(of: "4", with: "𝟰")
        string2 = string2.replacingOccurrences(of: "5", with: "𝟱")
        string2 = string2.replacingOccurrences(of: "6", with: "𝟲")
        string2 = string2.replacingOccurrences(of: "7", with: "𝟳")
        string2 = string2.replacingOccurrences(of: "8", with: "𝟴")
        string2 = string2.replacingOccurrences(of: "9", with: "𝟵")
        string2 = string2.replacingOccurrences(of: "0", with: "𝟬")
        
        return string2
    }
    
    func italicsTheText(string: String) -> String {
        StoreStruct.holdOnTempText = string
        var string2 = string
        string2 = string.replacingOccurrences(of: "a", with: "𝘢")
        string2 = string2.replacingOccurrences(of: "b", with: "𝘣")
        string2 = string2.replacingOccurrences(of: "c", with: "𝘤")
        string2 = string2.replacingOccurrences(of: "d", with: "𝘥")
        string2 = string2.replacingOccurrences(of: "e", with: "𝘦")
        string2 = string2.replacingOccurrences(of: "f", with: "𝘧")
        string2 = string2.replacingOccurrences(of: "g", with: "𝘨")
        string2 = string2.replacingOccurrences(of: "h", with: "𝘩")
        string2 = string2.replacingOccurrences(of: "i", with: "𝘪")
        string2 = string2.replacingOccurrences(of: "j", with: "𝘫")
        string2 = string2.replacingOccurrences(of: "k", with: "𝘬")
        string2 = string2.replacingOccurrences(of: "l", with: "𝘭")
        string2 = string2.replacingOccurrences(of: "m", with: "𝘮")
        string2 = string2.replacingOccurrences(of: "n", with: "𝘯")
        string2 = string2.replacingOccurrences(of: "o", with: "𝘰")
        string2 = string2.replacingOccurrences(of: "p", with: "𝘱")
        string2 = string2.replacingOccurrences(of: "q", with: "𝘲")
        string2 = string2.replacingOccurrences(of: "r", with: "𝘳")
        string2 = string2.replacingOccurrences(of: "s", with: "𝘴")
        string2 = string2.replacingOccurrences(of: "t", with: "𝘵")
        string2 = string2.replacingOccurrences(of: "u", with: "𝘶")
        string2 = string2.replacingOccurrences(of: "v", with: "𝘷")
        string2 = string2.replacingOccurrences(of: "w", with: "𝘸")
        string2 = string2.replacingOccurrences(of: "x", with: "𝘹")
        string2 = string2.replacingOccurrences(of: "y", with: "𝘺")
        string2 = string2.replacingOccurrences(of: "z", with: "𝘻")
        
        string2 = string2.replacingOccurrences(of: "A", with: "𝘈")
        string2 = string2.replacingOccurrences(of: "B", with: "𝘉")
        string2 = string2.replacingOccurrences(of: "C", with: "𝘊")
        string2 = string2.replacingOccurrences(of: "D", with: "𝘋")
        string2 = string2.replacingOccurrences(of: "E", with: "𝘌")
        string2 = string2.replacingOccurrences(of: "F", with: "𝘍")
        string2 = string2.replacingOccurrences(of: "G", with: "𝘎")
        string2 = string2.replacingOccurrences(of: "H", with: "𝘏")
        string2 = string2.replacingOccurrences(of: "I", with: "𝘐")
        string2 = string2.replacingOccurrences(of: "J", with: "𝘑")
        string2 = string2.replacingOccurrences(of: "K", with: "𝘒")
        string2 = string2.replacingOccurrences(of: "L", with: "𝘓")
        string2 = string2.replacingOccurrences(of: "M", with: "𝘔")
        string2 = string2.replacingOccurrences(of: "N", with: "𝘕")
        string2 = string2.replacingOccurrences(of: "O", with: "𝘖")
        string2 = string2.replacingOccurrences(of: "P", with: "𝘗")
        string2 = string2.replacingOccurrences(of: "Q", with: "𝘘")
        string2 = string2.replacingOccurrences(of: "R", with: "𝘙")
        string2 = string2.replacingOccurrences(of: "S", with: "𝘚")
        string2 = string2.replacingOccurrences(of: "T", with: "𝘛")
        string2 = string2.replacingOccurrences(of: "U", with: "𝘜")
        string2 = string2.replacingOccurrences(of: "V", with: "𝘝")
        string2 = string2.replacingOccurrences(of: "W", with: "𝘞")
        string2 = string2.replacingOccurrences(of: "X", with: "𝘟")
        string2 = string2.replacingOccurrences(of: "Y", with: "𝘠")
        string2 = string2.replacingOccurrences(of: "Z", with: "𝘡")
        
        return string2
    }
    
    func monoTheText(string: String) -> String {
        StoreStruct.holdOnTempText = string
        var string2 = string
        string2 = string.replacingOccurrences(of: "a", with: "𝚊")
        string2 = string2.replacingOccurrences(of: "b", with: "𝚋")
        string2 = string2.replacingOccurrences(of: "c", with: "𝚌")
        string2 = string2.replacingOccurrences(of: "d", with: "𝚍")
        string2 = string2.replacingOccurrences(of: "e", with: "𝚎")
        string2 = string2.replacingOccurrences(of: "f", with: "𝚏")
        string2 = string2.replacingOccurrences(of: "g", with: "𝚐")
        string2 = string2.replacingOccurrences(of: "h", with: "𝚑")
        string2 = string2.replacingOccurrences(of: "i", with: "𝚒")
        string2 = string2.replacingOccurrences(of: "j", with: "𝚓")
        string2 = string2.replacingOccurrences(of: "k", with: "𝚔")
        string2 = string2.replacingOccurrences(of: "l", with: "𝚕")
        string2 = string2.replacingOccurrences(of: "m", with: "𝚖")
        string2 = string2.replacingOccurrences(of: "n", with: "𝚗")
        string2 = string2.replacingOccurrences(of: "o", with: "𝚘")
        string2 = string2.replacingOccurrences(of: "p", with: "𝚙")
        string2 = string2.replacingOccurrences(of: "q", with: "𝚚")
        string2 = string2.replacingOccurrences(of: "r", with: "𝚛")
        string2 = string2.replacingOccurrences(of: "s", with: "𝚜")
        string2 = string2.replacingOccurrences(of: "t", with: "𝚝")
        string2 = string2.replacingOccurrences(of: "u", with: "𝚞")
        string2 = string2.replacingOccurrences(of: "v", with: "𝚟")
        string2 = string2.replacingOccurrences(of: "w", with: "𝚠")
        string2 = string2.replacingOccurrences(of: "x", with: "𝚡")
        string2 = string2.replacingOccurrences(of: "y", with: "𝚢")
        string2 = string2.replacingOccurrences(of: "z", with: "𝚣")
        
        string2 = string2.replacingOccurrences(of: "A", with: "𝙰")
        string2 = string2.replacingOccurrences(of: "B", with: "𝙱")
        string2 = string2.replacingOccurrences(of: "C", with: "𝙲")
        string2 = string2.replacingOccurrences(of: "D", with: "𝙳")
        string2 = string2.replacingOccurrences(of: "E", with: "𝙴")
        string2 = string2.replacingOccurrences(of: "F", with: "𝙵")
        string2 = string2.replacingOccurrences(of: "G", with: "𝙶")
        string2 = string2.replacingOccurrences(of: "H", with: "𝙷")
        string2 = string2.replacingOccurrences(of: "I", with: "𝙸")
        string2 = string2.replacingOccurrences(of: "J", with: "𝙹")
        string2 = string2.replacingOccurrences(of: "K", with: "𝙺")
        string2 = string2.replacingOccurrences(of: "L", with: "𝙻")
        string2 = string2.replacingOccurrences(of: "M", with: "𝙼")
        string2 = string2.replacingOccurrences(of: "N", with: "𝙽")
        string2 = string2.replacingOccurrences(of: "O", with: "𝙾")
        string2 = string2.replacingOccurrences(of: "P", with: "𝙿")
        string2 = string2.replacingOccurrences(of: "Q", with: "𝚀")
        string2 = string2.replacingOccurrences(of: "R", with: "𝚁")
        string2 = string2.replacingOccurrences(of: "S", with: "𝚂")
        string2 = string2.replacingOccurrences(of: "T", with: "𝚃")
        string2 = string2.replacingOccurrences(of: "U", with: "𝚄")
        string2 = string2.replacingOccurrences(of: "V", with: "𝚅")
        string2 = string2.replacingOccurrences(of: "W", with: "𝚆")
        string2 = string2.replacingOccurrences(of: "X", with: "𝚇")
        string2 = string2.replacingOccurrences(of: "Y", with: "𝚈")
        string2 = string2.replacingOccurrences(of: "Z", with: "𝚉")
        
        string2 = string2.replacingOccurrences(of: "1", with: "𝟷")
        string2 = string2.replacingOccurrences(of: "2", with: "𝟸")
        string2 = string2.replacingOccurrences(of: "3", with: "𝟹")
        string2 = string2.replacingOccurrences(of: "4", with: "𝟺")
        string2 = string2.replacingOccurrences(of: "5", with: "𝟻")
        string2 = string2.replacingOccurrences(of: "6", with: "𝟼")
        string2 = string2.replacingOccurrences(of: "7", with: "𝟽")
        string2 = string2.replacingOccurrences(of: "8", with: "𝟾")
        string2 = string2.replacingOccurrences(of: "9", with: "𝟿")
        string2 = string2.replacingOccurrences(of: "0", with: "𝟶")
        
        return string2
    }
    
    func frakturTheText(string: String) -> String {
        StoreStruct.holdOnTempText = string
        var string2 = string
        string2 = string.replacingOccurrences(of: "a", with: "𝔞")
        string2 = string2.replacingOccurrences(of: "b", with: "𝔟")
        string2 = string2.replacingOccurrences(of: "c", with: "𝔠")
        string2 = string2.replacingOccurrences(of: "d", with: "𝔡")
        string2 = string2.replacingOccurrences(of: "e", with: "𝔢")
        string2 = string2.replacingOccurrences(of: "f", with: "𝔣")
        string2 = string2.replacingOccurrences(of: "g", with: "𝔤")
        string2 = string2.replacingOccurrences(of: "h", with: "𝔥")
        string2 = string2.replacingOccurrences(of: "i", with: "𝔦")
        string2 = string2.replacingOccurrences(of: "j", with: "𝔧")
        string2 = string2.replacingOccurrences(of: "k", with: "𝔨")
        string2 = string2.replacingOccurrences(of: "l", with: "𝔩")
        string2 = string2.replacingOccurrences(of: "m", with: "𝔪")
        string2 = string2.replacingOccurrences(of: "n", with: "𝔫")
        string2 = string2.replacingOccurrences(of: "o", with: "𝔬")
        string2 = string2.replacingOccurrences(of: "p", with: "𝔭")
        string2 = string2.replacingOccurrences(of: "q", with: "𝔮")
        string2 = string2.replacingOccurrences(of: "r", with: "𝔯")
        string2 = string2.replacingOccurrences(of: "s", with: "𝔰")
        string2 = string2.replacingOccurrences(of: "t", with: "𝔱")
        string2 = string2.replacingOccurrences(of: "u", with: "𝔲")
        string2 = string2.replacingOccurrences(of: "v", with: "𝔳")
        string2 = string2.replacingOccurrences(of: "w", with: "𝔴")
        string2 = string2.replacingOccurrences(of: "x", with: "𝔵")
        string2 = string2.replacingOccurrences(of: "y", with: "𝔶")
        string2 = string2.replacingOccurrences(of: "z", with: "𝔷")
        
        string2 = string2.replacingOccurrences(of: "A", with: "𝔄")
        string2 = string2.replacingOccurrences(of: "B", with: "𝔅")
        string2 = string2.replacingOccurrences(of: "C", with: "ℭ")
        string2 = string2.replacingOccurrences(of: "D", with: "𝔇")
        string2 = string2.replacingOccurrences(of: "E", with: "𝔈")
        string2 = string2.replacingOccurrences(of: "F", with: "𝔉")
        string2 = string2.replacingOccurrences(of: "G", with: "𝔊")
        string2 = string2.replacingOccurrences(of: "H", with: "ℌ")
        string2 = string2.replacingOccurrences(of: "I", with: "ℑ")
        string2 = string2.replacingOccurrences(of: "J", with: "𝔍")
        string2 = string2.replacingOccurrences(of: "K", with: "𝔎")
        string2 = string2.replacingOccurrences(of: "L", with: "𝔏")
        string2 = string2.replacingOccurrences(of: "M", with: "𝔐")
        string2 = string2.replacingOccurrences(of: "N", with: "𝔑")
        string2 = string2.replacingOccurrences(of: "O", with: "𝔒")
        string2 = string2.replacingOccurrences(of: "P", with: "𝔓")
        string2 = string2.replacingOccurrences(of: "Q", with: "𝔔")
        string2 = string2.replacingOccurrences(of: "R", with: "ℜ")
        string2 = string2.replacingOccurrences(of: "S", with: "𝔖")
        string2 = string2.replacingOccurrences(of: "T", with: "𝔗")
        string2 = string2.replacingOccurrences(of: "U", with: "𝔘")
        string2 = string2.replacingOccurrences(of: "V", with: "𝔙")
        string2 = string2.replacingOccurrences(of: "W", with: "𝔚")
        string2 = string2.replacingOccurrences(of: "X", with: "𝔛")
        string2 = string2.replacingOccurrences(of: "Y", with: "𝔜")
        string2 = string2.replacingOccurrences(of: "Z", with: "ℨ")
        
        string2 = string2.replacingOccurrences(of: "1", with: "յ")
        string2 = string2.replacingOccurrences(of: "2", with: "շ")
        string2 = string2.replacingOccurrences(of: "3", with: "Յ")
        string2 = string2.replacingOccurrences(of: "4", with: "կ")
        string2 = string2.replacingOccurrences(of: "5", with: "Տ")
        string2 = string2.replacingOccurrences(of: "6", with: "ճ")
        string2 = string2.replacingOccurrences(of: "7", with: "Դ")
        string2 = string2.replacingOccurrences(of: "8", with: "Ց")
        string2 = string2.replacingOccurrences(of: "9", with: "գ")
        string2 = string2.replacingOccurrences(of: "0", with: "օ")
        
        return string2
    }
    
    func bubbleTheText(string: String) -> String {
        StoreStruct.holdOnTempText = string
        var string2 = string
        string2 = string.replacingOccurrences(of: "a", with: "ⓐ")
        string2 = string2.replacingOccurrences(of: "b", with: "ⓑ")
        string2 = string2.replacingOccurrences(of: "c", with: "ⓒ")
        string2 = string2.replacingOccurrences(of: "d", with: "ⓓ")
        string2 = string2.replacingOccurrences(of: "e", with: "ⓔ")
        string2 = string2.replacingOccurrences(of: "f", with: "ⓕ")
        string2 = string2.replacingOccurrences(of: "g", with: "ⓖ")
        string2 = string2.replacingOccurrences(of: "h", with: "ⓗ")
        string2 = string2.replacingOccurrences(of: "i", with: "ⓘ")
        string2 = string2.replacingOccurrences(of: "j", with: "ⓙ")
        string2 = string2.replacingOccurrences(of: "k", with: "ⓚ")
        string2 = string2.replacingOccurrences(of: "l", with: "ⓛ")
        string2 = string2.replacingOccurrences(of: "m", with: "ⓜ")
        string2 = string2.replacingOccurrences(of: "n", with: "ⓝ")
        string2 = string2.replacingOccurrences(of: "o", with: "ⓞ")
        string2 = string2.replacingOccurrences(of: "p", with: "ⓟ")
        string2 = string2.replacingOccurrences(of: "q", with: "ⓠ")
        string2 = string2.replacingOccurrences(of: "r", with: "ⓡ")
        string2 = string2.replacingOccurrences(of: "s", with: "ⓢ")
        string2 = string2.replacingOccurrences(of: "t", with: "ⓣ")
        string2 = string2.replacingOccurrences(of: "u", with: "ⓤ")
        string2 = string2.replacingOccurrences(of: "v", with: "ⓥ")
        string2 = string2.replacingOccurrences(of: "w", with: "ⓦ")
        string2 = string2.replacingOccurrences(of: "x", with: "ⓧ")
        string2 = string2.replacingOccurrences(of: "y", with: "ⓨ")
        string2 = string2.replacingOccurrences(of: "z", with: "ⓩ")
        
        string2 = string2.replacingOccurrences(of: "A", with: "Ⓐ")
        string2 = string2.replacingOccurrences(of: "B", with: "Ⓑ")
        string2 = string2.replacingOccurrences(of: "C", with: "Ⓒ")
        string2 = string2.replacingOccurrences(of: "D", with: "Ⓓ")
        string2 = string2.replacingOccurrences(of: "E", with: "Ⓔ")
        string2 = string2.replacingOccurrences(of: "F", with: "Ⓕ")
        string2 = string2.replacingOccurrences(of: "G", with: "Ⓖ")
        string2 = string2.replacingOccurrences(of: "H", with: "Ⓗ")
        string2 = string2.replacingOccurrences(of: "I", with: "Ⓘ")
        string2 = string2.replacingOccurrences(of: "J", with: "Ⓙ")
        string2 = string2.replacingOccurrences(of: "K", with: "Ⓚ")
        string2 = string2.replacingOccurrences(of: "L", with: "Ⓛ")
        string2 = string2.replacingOccurrences(of: "M", with: "Ⓜ")
        string2 = string2.replacingOccurrences(of: "N", with: "Ⓝ")
        string2 = string2.replacingOccurrences(of: "O", with: "Ⓞ")
        string2 = string2.replacingOccurrences(of: "P", with: "Ⓟ")
        string2 = string2.replacingOccurrences(of: "Q", with: "Ⓠ")
        string2 = string2.replacingOccurrences(of: "R", with: "Ⓡ")
        string2 = string2.replacingOccurrences(of: "S", with: "Ⓢ")
        string2 = string2.replacingOccurrences(of: "T", with: "Ⓣ")
        string2 = string2.replacingOccurrences(of: "U", with: "Ⓤ")
        string2 = string2.replacingOccurrences(of: "V", with: "Ⓥ")
        string2 = string2.replacingOccurrences(of: "W", with: "Ⓦ")
        string2 = string2.replacingOccurrences(of: "X", with: "Ⓧ")
        string2 = string2.replacingOccurrences(of: "Y", with: "Ⓨ")
        string2 = string2.replacingOccurrences(of: "Z", with: "Ⓩ")
        
        string2 = string2.replacingOccurrences(of: "1", with: "①")
        string2 = string2.replacingOccurrences(of: "2", with: "②")
        string2 = string2.replacingOccurrences(of: "3", with: "③")
        string2 = string2.replacingOccurrences(of: "4", with: "④")
        string2 = string2.replacingOccurrences(of: "5", with: "⑤")
        string2 = string2.replacingOccurrences(of: "6", with: "⑥")
        string2 = string2.replacingOccurrences(of: "7", with: "⑦")
        string2 = string2.replacingOccurrences(of: "8", with: "⑧")
        string2 = string2.replacingOccurrences(of: "9", with: "⑨")
        string2 = string2.replacingOccurrences(of: "0", with: "⓪")
        
        return string2
    }
    
    func bubbleTheText2(string: String) -> String {
        StoreStruct.holdOnTempText = string
        var string2 = string
        string2 = string.replacingOccurrences(of: "a", with: "🅐")
        string2 = string2.replacingOccurrences(of: "b", with: "🅑")
        string2 = string2.replacingOccurrences(of: "c", with: "🅒")
        string2 = string2.replacingOccurrences(of: "d", with: "🅓")
        string2 = string2.replacingOccurrences(of: "e", with: "🅔")
        string2 = string2.replacingOccurrences(of: "f", with: "🅕")
        string2 = string2.replacingOccurrences(of: "g", with: "🅖")
        string2 = string2.replacingOccurrences(of: "h", with: "🅗")
        string2 = string2.replacingOccurrences(of: "i", with: "🅘")
        string2 = string2.replacingOccurrences(of: "j", with: "🅙")
        string2 = string2.replacingOccurrences(of: "k", with: "🅚")
        string2 = string2.replacingOccurrences(of: "l", with: "🅛")
        string2 = string2.replacingOccurrences(of: "m", with: "🅜")
        string2 = string2.replacingOccurrences(of: "n", with: "🅝")
        string2 = string2.replacingOccurrences(of: "o", with: "🅞")
        string2 = string2.replacingOccurrences(of: "p", with: "🅟")
        string2 = string2.replacingOccurrences(of: "q", with: "🅠")
        string2 = string2.replacingOccurrences(of: "r", with: "🅡")
        string2 = string2.replacingOccurrences(of: "s", with: "🅢")
        string2 = string2.replacingOccurrences(of: "t", with: "🅣")
        string2 = string2.replacingOccurrences(of: "u", with: "🅤")
        string2 = string2.replacingOccurrences(of: "v", with: "🅥")
        string2 = string2.replacingOccurrences(of: "w", with: "🅦")
        string2 = string2.replacingOccurrences(of: "x", with: "🅧")
        string2 = string2.replacingOccurrences(of: "y", with: "🅨")
        string2 = string2.replacingOccurrences(of: "z", with: "🅩")
        
        string2 = string.replacingOccurrences(of: "A", with: "🅐")
        string2 = string2.replacingOccurrences(of: "B", with: "🅑")
        string2 = string2.replacingOccurrences(of: "C", with: "🅒")
        string2 = string2.replacingOccurrences(of: "D", with: "🅓")
        string2 = string2.replacingOccurrences(of: "E", with: "🅔")
        string2 = string2.replacingOccurrences(of: "F", with: "🅕")
        string2 = string2.replacingOccurrences(of: "G", with: "🅖")
        string2 = string2.replacingOccurrences(of: "H", with: "🅗")
        string2 = string2.replacingOccurrences(of: "I", with: "🅘")
        string2 = string2.replacingOccurrences(of: "J", with: "🅙")
        string2 = string2.replacingOccurrences(of: "K", with: "🅚")
        string2 = string2.replacingOccurrences(of: "L", with: "🅛")
        string2 = string2.replacingOccurrences(of: "M", with: "🅜")
        string2 = string2.replacingOccurrences(of: "N", with: "🅝")
        string2 = string2.replacingOccurrences(of: "O", with: "🅞")
        string2 = string2.replacingOccurrences(of: "P", with: "🅟")
        string2 = string2.replacingOccurrences(of: "Q", with: "🅠")
        string2 = string2.replacingOccurrences(of: "R", with: "🅡")
        string2 = string2.replacingOccurrences(of: "S", with: "🅢")
        string2 = string2.replacingOccurrences(of: "T", with: "🅣")
        string2 = string2.replacingOccurrences(of: "U", with: "🅤")
        string2 = string2.replacingOccurrences(of: "V", with: "🅥")
        string2 = string2.replacingOccurrences(of: "W", with: "🅦")
        string2 = string2.replacingOccurrences(of: "X", with: "🅧")
        string2 = string2.replacingOccurrences(of: "Y", with: "🅨")
        string2 = string2.replacingOccurrences(of: "Z", with: "🅩")
        
        string2 = string2.replacingOccurrences(of: "1", with: "➊")
        string2 = string2.replacingOccurrences(of: "2", with: "➋")
        string2 = string2.replacingOccurrences(of: "3", with: "➌")
        string2 = string2.replacingOccurrences(of: "4", with: "➍")
        string2 = string2.replacingOccurrences(of: "5", with: "➎")
        string2 = string2.replacingOccurrences(of: "6", with: "➏")
        string2 = string2.replacingOccurrences(of: "7", with: "➐")
        string2 = string2.replacingOccurrences(of: "8", with: "➑")
        string2 = string2.replacingOccurrences(of: "9", with: "➒")
        string2 = string2.replacingOccurrences(of: "0", with: "⓿")
        
        return string2
    }
    
    func handwriteTheText(string: String) -> String {
        StoreStruct.holdOnTempText = string
        var string2 = string
        string2 = string.replacingOccurrences(of: "a", with: "𝒶")
        string2 = string2.replacingOccurrences(of: "b", with: "𝒷")
        string2 = string2.replacingOccurrences(of: "c", with: "𝒸")
        string2 = string2.replacingOccurrences(of: "d", with: "𝒹")
        string2 = string2.replacingOccurrences(of: "e", with: "𝑒")
        string2 = string2.replacingOccurrences(of: "f", with: "𝒻")
        string2 = string2.replacingOccurrences(of: "g", with: "𝑔")
        string2 = string2.replacingOccurrences(of: "h", with: "𝒽")
        string2 = string2.replacingOccurrences(of: "i", with: "𝒾")
        string2 = string2.replacingOccurrences(of: "j", with: "𝒿")
        string2 = string2.replacingOccurrences(of: "k", with: "𝓀")
        string2 = string2.replacingOccurrences(of: "l", with: "𝓁")
        string2 = string2.replacingOccurrences(of: "m", with: "𝓂")
        string2 = string2.replacingOccurrences(of: "n", with: "𝓃")
        string2 = string2.replacingOccurrences(of: "o", with: "𝑜")
        string2 = string2.replacingOccurrences(of: "p", with: "𝓅")
        string2 = string2.replacingOccurrences(of: "q", with: "𝓆")
        string2 = string2.replacingOccurrences(of: "r", with: "𝓇")
        string2 = string2.replacingOccurrences(of: "s", with: "𝓈")
        string2 = string2.replacingOccurrences(of: "t", with: "𝓉")
        string2 = string2.replacingOccurrences(of: "u", with: "𝓊")
        string2 = string2.replacingOccurrences(of: "v", with: "𝓋")
        string2 = string2.replacingOccurrences(of: "w", with: "𝓌")
        string2 = string2.replacingOccurrences(of: "x", with: "𝓍")
        string2 = string2.replacingOccurrences(of: "y", with: "𝓎")
        string2 = string2.replacingOccurrences(of: "z", with: "𝓏")
        
        string2 = string2.replacingOccurrences(of: "A", with: "𝒜")
        string2 = string2.replacingOccurrences(of: "B", with: "𝐵")
        string2 = string2.replacingOccurrences(of: "C", with: "𝒞")
        string2 = string2.replacingOccurrences(of: "D", with: "𝒟")
        string2 = string2.replacingOccurrences(of: "E", with: "𝐸")
        string2 = string2.replacingOccurrences(of: "F", with: "𝐹")
        string2 = string2.replacingOccurrences(of: "G", with: "𝒢")
        string2 = string2.replacingOccurrences(of: "H", with: "𝐻")
        string2 = string2.replacingOccurrences(of: "I", with: "𝐼")
        string2 = string2.replacingOccurrences(of: "J", with: "𝒥")
        string2 = string2.replacingOccurrences(of: "K", with: "𝒦")
        string2 = string2.replacingOccurrences(of: "L", with: "𝐿")
        string2 = string2.replacingOccurrences(of: "M", with: "𝑀")
        string2 = string2.replacingOccurrences(of: "N", with: "𝒩")
        string2 = string2.replacingOccurrences(of: "O", with: "𝒪")
        string2 = string2.replacingOccurrences(of: "P", with: "𝒫")
        string2 = string2.replacingOccurrences(of: "Q", with: "𝒬")
        string2 = string2.replacingOccurrences(of: "R", with: "𝑅")
        string2 = string2.replacingOccurrences(of: "S", with: "𝒮")
        string2 = string2.replacingOccurrences(of: "T", with: "𝒯")
        string2 = string2.replacingOccurrences(of: "U", with: "𝒰")
        string2 = string2.replacingOccurrences(of: "V", with: "𝒱")
        string2 = string2.replacingOccurrences(of: "W", with: "𝒲")
        string2 = string2.replacingOccurrences(of: "X", with: "𝒳")
        string2 = string2.replacingOccurrences(of: "Y", with: "𝒴")
        string2 = string2.replacingOccurrences(of: "Z", with: "𝒵")
        
        return string2
    }
    
    func doubleTheText(string: String) -> String {
        StoreStruct.holdOnTempText = string
        var string2 = string
        string2 = string.replacingOccurrences(of: "a", with: "𝕒")
        string2 = string2.replacingOccurrences(of: "b", with: "𝕓")
        string2 = string2.replacingOccurrences(of: "c", with: "𝕔")
        string2 = string2.replacingOccurrences(of: "d", with: "𝕕")
        string2 = string2.replacingOccurrences(of: "e", with: "𝕖")
        string2 = string2.replacingOccurrences(of: "f", with: "𝕗")
        string2 = string2.replacingOccurrences(of: "g", with: "𝕘")
        string2 = string2.replacingOccurrences(of: "h", with: "𝕙")
        string2 = string2.replacingOccurrences(of: "i", with: "𝕚")
        string2 = string2.replacingOccurrences(of: "j", with: "𝕛")
        string2 = string2.replacingOccurrences(of: "k", with: "𝕜")
        string2 = string2.replacingOccurrences(of: "l", with: "𝕝")
        string2 = string2.replacingOccurrences(of: "m", with: "𝕞")
        string2 = string2.replacingOccurrences(of: "n", with: "𝕟")
        string2 = string2.replacingOccurrences(of: "o", with: "𝕠")
        string2 = string2.replacingOccurrences(of: "p", with: "𝕡")
        string2 = string2.replacingOccurrences(of: "q", with: "𝕢")
        string2 = string2.replacingOccurrences(of: "r", with: "𝕣")
        string2 = string2.replacingOccurrences(of: "s", with: "𝕤")
        string2 = string2.replacingOccurrences(of: "t", with: "𝕥")
        string2 = string2.replacingOccurrences(of: "u", with: "𝕦")
        string2 = string2.replacingOccurrences(of: "v", with: "𝕧")
        string2 = string2.replacingOccurrences(of: "w", with: "𝕨")
        string2 = string2.replacingOccurrences(of: "x", with: "𝕩")
        string2 = string2.replacingOccurrences(of: "y", with: "𝕪")
        string2 = string2.replacingOccurrences(of: "z", with: "𝕫")
        
        string2 = string2.replacingOccurrences(of: "A", with: "𝔸")
        string2 = string2.replacingOccurrences(of: "B", with: "𝔹")
        string2 = string2.replacingOccurrences(of: "C", with: "ℂ")
        string2 = string2.replacingOccurrences(of: "D", with: "𝔻")
        string2 = string2.replacingOccurrences(of: "E", with: "𝔼")
        string2 = string2.replacingOccurrences(of: "F", with: "𝔽")
        string2 = string2.replacingOccurrences(of: "G", with: "𝔾")
        string2 = string2.replacingOccurrences(of: "H", with: "ℍ")
        string2 = string2.replacingOccurrences(of: "I", with: "𝕀")
        string2 = string2.replacingOccurrences(of: "J", with: "𝕁")
        string2 = string2.replacingOccurrences(of: "K", with: "𝕂")
        string2 = string2.replacingOccurrences(of: "L", with: "𝕃")
        string2 = string2.replacingOccurrences(of: "M", with: "𝕄")
        string2 = string2.replacingOccurrences(of: "N", with: "ℕ")
        string2 = string2.replacingOccurrences(of: "O", with: "𝕆")
        string2 = string2.replacingOccurrences(of: "P", with: "ℙ")
        string2 = string2.replacingOccurrences(of: "Q", with: "ℚ")
        string2 = string2.replacingOccurrences(of: "R", with: "ℝ")
        string2 = string2.replacingOccurrences(of: "S", with: "𝕊")
        string2 = string2.replacingOccurrences(of: "T", with: "𝕋")
        string2 = string2.replacingOccurrences(of: "U", with: "𝕌")
        string2 = string2.replacingOccurrences(of: "V", with: "𝕍")
        string2 = string2.replacingOccurrences(of: "W", with: "𝕎")
        string2 = string2.replacingOccurrences(of: "X", with: "𝕏")
        string2 = string2.replacingOccurrences(of: "Y", with: "𝕐")
        string2 = string2.replacingOccurrences(of: "Z", with: "ℤ")
        
        string2 = string2.replacingOccurrences(of: "1", with: "𝟙")
        string2 = string2.replacingOccurrences(of: "2", with: "𝟚")
        string2 = string2.replacingOccurrences(of: "3", with: "𝟛")
        string2 = string2.replacingOccurrences(of: "4", with: "𝟜")
        string2 = string2.replacingOccurrences(of: "5", with: "𝟝")
        string2 = string2.replacingOccurrences(of: "6", with: "𝟞")
        string2 = string2.replacingOccurrences(of: "7", with: "𝟟")
        string2 = string2.replacingOccurrences(of: "8", with: "𝟠")
        string2 = string2.replacingOccurrences(of: "9", with: "𝟡")
        string2 = string2.replacingOccurrences(of: "0", with: "𝟘")
        
        return string2
    }
}
