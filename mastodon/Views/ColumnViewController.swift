//
//  ColumnViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 07/06/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SAConfettiView

class ColumnViewController: UIViewController, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate {
    
    let volumeBar = VolumeBar.shared
    let reachability = Reachability()!
    
    var viewControllers: [UIViewController] = [] {
        didSet {
            for viewController in viewControllers {
                self.addChild(viewController)
                self.view.addSubview(viewController.view)
                viewController.didMove(toParent: self)
            }
        }
    }
    
    override var keyCommands: [UIKeyCommand]? {
        //shortkeys
        let newToot = UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(comp1), discoverabilityTitle: "New Toot")
        let listThing = UIKeyCommand(input: "l", modifierFlags: .control, action: #selector(list1), discoverabilityTitle: "Lists")
        let searchThing = UIKeyCommand(input: "f", modifierFlags: .command, action: #selector(search1), discoverabilityTitle: "Search")
        let leftAr = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(left1), discoverabilityTitle: "Scroll to Start")
        let rightAr = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(right1), discoverabilityTitle: "Scroll to End")
        return [
            newToot, listThing, searchThing, leftAr, rightAr
        ]
    }
    
    @objc func comp1() {
        let controller = ComposeViewController()
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            controller.modalPresentationStyle = .pageSheet
        default:
            print("nil")
        }
        controller.inReply = []
        controller.inReplyText = ""
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func list1() {
        
    }
    
    @objc func search1() {
        let controller = UINavigationController(rootViewController: SearchViewController())
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            controller.modalPresentationStyle = .pageSheet
        default:
            print("nil")
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func left1() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "leftAr"), object: nil)
    }
    
    @objc func right1() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "rightAr"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let firstViewWidth: CGFloat = 80
        var count = 0
        for viewController in viewControllers {
            if count == 0 {
                viewController.view.frame = CGRect(x: 0, y: 0, width: firstViewWidth, height: self.view.bounds.height)
                count += 1
            } else {
                viewController.view.frame = CGRect(x: firstViewWidth + 0.6, y: 0, width: self.view.bounds.width - firstViewWidth, height: self.view.bounds.height)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colours.whitePad
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriLight00), name: NSNotification.Name(rawValue: "light00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriDark00), name: NSNotification.Name(rawValue: "dark00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriDark200), name: NSNotification.Name(rawValue: "darker00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriOled00), name: NSNotification.Name(rawValue: "black00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriBlue00), name: NSNotification.Name(rawValue: "blue00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentIntro), name: NSNotification.Name(rawValue: "presentIntro00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoID), name: NSNotification.Name(rawValue: "gotoid00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreate), name: NSNotification.Name(rawValue: "confettiCreate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreateRe), name: NSNotification.Name(rawValue: "confettiCreateRe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreateLi), name: NSNotification.Name(rawValue: "confettiCreateLi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.logged), name: NSNotification.Name(rawValue: "logged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newInstanceLogged), name: NSNotification.Name(rawValue: "newInstancelogged"), object: nil)
        
        if (UserDefaults.standard.object(forKey: "themeaccent") == nil) || (UserDefaults.standard.object(forKey: "themeaccent") as! Int == 0) {
            Colours.tabSelected = StoreStruct.colArray[0]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.reloadTint()
        } else if (UserDefaults.standard.object(forKey: "themeaccent") as? Int == 500) {
            if UserDefaults.standard.object(forKey: "hexhex") as? String != nil {
                let hexText = UserDefaults.standard.object(forKey: "hexhex") as? String ?? "ffffff"
                StoreStruct.hexCol = UIColor(hexString: hexText) ?? UIColor(red: 84/250, green: 133/250, blue: 234/250, alpha: 1.0)
                Colours.tabSelected = StoreStruct.hexCol
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.reloadTint()
            }
        } else {
            Colours.tabSelected = StoreStruct.colArray[UserDefaults.standard.object(forKey: "themeaccent") as! Int]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.reloadTint()
        }
        
        if (UserDefaults.standard.object(forKey: "autol1") == nil) {
            UserDefaults.standard.set(1, forKey: "autol1")
        }
        
        if (UserDefaults.standard.object(forKey: "bord") == nil) {
            UserDefaults.standard.set(1, forKey: "bord")
        }
        
        if (UserDefaults.standard.object(forKey: "segsize") == nil) {
            UserDefaults.standard.set(1, forKey: "segsize")
        }
        
        if (UserDefaults.standard.object(forKey: "sworder") == nil) {
            UserDefaults.standard.set(1, forKey: "sworder")
        }
        
        if (UserDefaults.standard.object(forKey: "notifToggle") == nil) {
            UserDefaults.standard.set(1, forKey: "notifToggle")
        }
        
        if (UserDefaults.standard.object(forKey: "instancesLocal") == nil) {
            
        } else {
            StoreStruct.instanceLocalToAdd = UserDefaults.standard.object(forKey: "instancesLocal") as! [String]
        }
        
        if UserDefaults.standard.object(forKey: "accessToken") == nil {} else {
            var customStyle = VolumeBarStyle.likeInstagram
            customStyle.trackTintColor = Colours.cellQuote
            customStyle.progressTintColor = Colours.grayDark
            customStyle.backgroundColor = Colours.white
            volumeBar.style = customStyle
            
            if UserDefaults.standard.object(forKey: "bulletindone") == nil {} else {
                self.volumeBar.start()
                self.volumeBar.showInitial()
            }
        }
        
        self.setupSiri()
        
        if UserDefaults.standard.object(forKey: "clientID") == nil {} else {
            StoreStruct.currentInstance.clientID = UserDefaults.standard.object(forKey: "clientID") as! String
        }
        if UserDefaults.standard.object(forKey: "clientSecret") == nil {} else {
            StoreStruct.currentInstance.clientSecret = UserDefaults.standard.object(forKey: "clientSecret") as! String
        }
        if UserDefaults.standard.object(forKey: "authCode") == nil {} else {
            StoreStruct.currentInstance.authCode = UserDefaults.standard.object(forKey: "authCode") as! String
        }
        if UserDefaults.standard.object(forKey: "returnedText") == nil {} else {
            StoreStruct.currentInstance.returnedText = UserDefaults.standard.object(forKey: "returnedText") as! String
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longAction(sender:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        self.view.addGestureRecognizer(longPress)
    }
    
    @objc func gotoID() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid"), object: self)
    }
    
    @objc func presentIntro() {
        DispatchQueue.main.async {
            self.bulletinManager.prepare()
            self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
        }
    }
    
    @objc func logged() {
        
        StoreStruct.tappedSignInCheck = false
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "padIsLogged"), object: nil)
        
        var request = URLRequest(url: URL(string: "https://\(StoreStruct.currentInstance.returnedText)/oauth/token?grant_type=authorization_code&code=\(StoreStruct.currentInstance.authCode)&redirect_uri=\(StoreStruct.currentInstance.redirect)&client_id=\(StoreStruct.currentInstance.clientID)&client_secret=\(StoreStruct.currentInstance.clientSecret)&scope=read%20write%20follow%20push")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else { print(error);return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    DispatchQueue.main.async {
                        var customStyle = VolumeBarStyle.likeInstagram
                        customStyle.trackTintColor = Colours.cellQuote
                        customStyle.progressTintColor = Colours.grayDark
                        customStyle.backgroundColor = Colours.white
                        self.volumeBar.style = customStyle
                    }
                    
                    StoreStruct.currentInstance.accessToken = (json["access_token"] as? String ?? "")
                    StoreStruct.client.accessToken = (json["access_token"] as? String ?? "")
                    
                    InstanceData.setCurrentInstance(instance: StoreStruct.currentInstance)
                    
                    let request2 = Accounts.currentUser()
                    StoreStruct.client.run(request2) { (statuses) in
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {
                                var instances = InstanceData.getAllInstances()
                                instances.append(StoreStruct.currentInstance)
                                UserDefaults.standard.set(try? PropertyListEncoder().encode(instances), forKey:"instances")
                                StoreStruct.currentUser = stat
                                Account.addAccountToList(account: stat)
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refpush1"), object: nil)
                            }
                        }
                    }
                    
                    let request = Timelines.home()
                    StoreStruct.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.statusesHome = stat
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refpush1"), object: nil)
                        }
                    }
                    
                    let request3 = Instances.customEmojis()
                    StoreStruct.client.run(request3) { (statuses) in
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {
                                StoreStruct.emotiFace = stat
                            }
                            stat.map({
                                let attributedString = NSAttributedString(string: "    \($0.shortcode)")
                                let textAttachment = NSTextAttachment()
                                textAttachment.loadImageUsingCache(withUrl: $0.staticURL.absoluteString)
                                textAttachment.bounds = CGRect(x:0, y: Int(-9), width: Int(30), height: Int(30))
                                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                                let result = NSMutableAttributedString()
                                result.append(attrStringWithImage)
                                result.append(attributedString)
                                StoreStruct.mainResult.append(result)
                                
                                let textAttachment1 = NSTextAttachment()
                                textAttachment1.loadImageUsingCache(withUrl: $0.staticURL.absoluteString)
                                textAttachment1.bounds = CGRect(x:0, y: Int(-9), width: Int(30), height: Int(30))
                                let attrStringWithImage1 = NSAttributedString(attachment: textAttachment1)
                                let result1 = NSMutableAttributedString()
                                result1.append(attrStringWithImage1)
                                StoreStruct.mainResult1.append(result1)
                                
                                let attributedString2 = NSAttributedString(string: "\($0.shortcode)")
                                let result2 = NSMutableAttributedString()
                                result2.append(attributedString2)
                                StoreStruct.mainResult2.append(result)
                            })
                        }
                    }
                    
                    if (UserDefaults.standard.object(forKey: "onb") == nil) || (UserDefaults.standard.object(forKey: "onb") as! Int == 0) {
                        DispatchQueue.main.async {
                            self.bulletinManager.prepare()
                            self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    @objc func newInstanceLogged() {
        
        var request = URLRequest(url: URL(string: "https://\(StoreStruct.newInstance!.returnedText)/oauth/token?grant_type=authorization_code&code=\(StoreStruct.newInstance!.authCode)&redirect_uri=\(StoreStruct.newInstance!.redirect)&client_id=\(StoreStruct.newInstance!.clientID)&client_secret=\(StoreStruct.newInstance!.clientSecret)&scope=read%20write%20follow%20push")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else { print(error);return }
            guard let data = data else { return }
            guard let newInstance = StoreStruct.newInstance else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    if let access1 = (json["access_token"] as? String) {
                        
                        StoreStruct.client = StoreStruct.newClient
                        newInstance.accessToken = access1
                        InstanceData.setCurrentInstance(instance: newInstance)
                        
                        let request2 = Accounts.currentUser()
                        StoreStruct.client.run(request2) { (statuses) in
                            if let stat = (statuses.value) {
                                DispatchQueue.main.async {
                                    var instances = InstanceData.getAllInstances()
                                    instances.append(newInstance)
                                    UserDefaults.standard.set(try? PropertyListEncoder().encode(instances), forKey: "instances")
                                    StoreStruct.currentUser = stat
                                    Account.addAccountToList(account: stat)
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refpush1"), object: nil)
                                }
                            }
                        }
                        
                        let request = Timelines.home()
                        StoreStruct.client.run(request) { (statuses) in
                            if let stat = (statuses.value) {
                                StoreStruct.statusesHome = stat
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refpush1"), object: nil)
                            }
                        }
                        
                        if (UserDefaults.standard.object(forKey: "onb") == nil) || (UserDefaults.standard.object(forKey: "onb") as! Int == 0) {
                            DispatchQueue.main.async {
                                self.bulletinManager.prepare()
                                self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            StoreStruct.tappedSignInCheck = false
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.reloadApplication()
                        }
                        
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    lazy var bulletinManager: BulletinManager = {
        
        let page = PageBulletinItem(title: "Welcome to Mast")
        page.image = UIImage(named: "iconb")
        page.shouldCompactDescriptionText = true
        page.descriptionText = "You're almost ready to go.\nLet's configure some things first."
        page.actionButtonTitle = "Configure"
        page.nextItem = makeNotPage()
        
        page.actionHandler = { item in
            print("Action button tapped")
            item.manager?.push(item: self.makeNotPage())
        }
        
        let rootItem: BulletinItem = page
        return BulletinManager(rootItem: rootItem)
    }()
    
    func makeNotPage() -> PageBulletinItem {
        
        let page = PageBulletinItem(title: "Notifications")
        page.image = UIImage(named: "notib")
        page.shouldCompactDescriptionText = true
        page.descriptionText = "Mast can send you push notifications for toots you're mentioned in, boosted and liked toots, as well as for new followers."
        page.actionButtonTitle = "Subscribe"
        page.alternativeButtonTitle = "No thanks"
        page.nextItem = makeSiriPage()
        
        page.actionHandler = { item in
            print("Action button tapped")
            
            UserDefaults.standard.set(true, forKey: "pnmentions")
            UserDefaults.standard.set(true, forKey: "pnlikes")
            UserDefaults.standard.set(true, forKey: "pnboosts")
            UserDefaults.standard.set(true, forKey: "pnfollows")
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            
            item.manager?.push(item: self.makeSiriPage())
        }
        
        page.alternativeHandler = { item in
            print("Action button tapped")
            UserDefaults.standard.set(false, forKey: "pnmentions")
            UserDefaults.standard.set(false, forKey: "pnlikes")
            UserDefaults.standard.set(false, forKey: "pnboosts")
            UserDefaults.standard.set(false, forKey: "pnfollows")
            item.manager?.push(item: self.makeSiriPage())
        }
        
        return page
    }
    
    func makeSiriPage() -> PageBulletinItem {
        
        let page = PageBulletinItem(title: "Theme it Your Way")
        page.image = UIImage(named: "themeb")
        page.shouldCompactDescriptionText = true
        page.descriptionText = "You can change the theme (and a variety of settings) via the app's settings section, or long-hold anywhere in the app to cycle through them.\n\nYou can also use Siri to do the same (Settings > Siri & Search > All Shortcuts)."
        page.actionButtonTitle = "Got it!"
        page.nextItem = makeDonePage()
        
        page.actionHandler = { item in
            print("Action button tapped")
            item.manager?.push(item: self.makeDonePage())
        }
        
        return page
    }
    
    func makeDonePage() -> PageBulletinItem {
        
        let page = PageBulletinItem(title: "Setup Complete")
        page.image = UIImage(named: "doneb")
        page.shouldCompactDescriptionText = true
        page.descriptionText = "You're all ready to go.\nHappy tooting!"
        page.actionButtonTitle = "Get Started"
        //page.isDismissable = true
        
        page.actionHandler = { item in
            print("Action button tapped")
            
            item.manager?.dismissBulletin(animated: true)
            
            UserDefaults.standard.set(1, forKey: "bulletindone")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.volumeBar.start()
                self.volumeBar.showInitial()
            })
        }
        
        return page
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.global(qos: .background).asyncAfter(deadline: when, execute: closure)
    }
    
    func setupSiri() {
        let activity1 = NSUserActivity(activityType: "com.shi.Mast.light")
        activity1.title = "Switch to light mode".localized
        activity1.userInfo = ["state" : "light"]
        activity1.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity1.isEligibleForPrediction = true
            activity1.persistentIdentifier = "com.shi.Mast.light"
        } else {
            // Fallback on earlier versions
        }
        self.view.userActivity = activity1
        activity1.becomeCurrent()
        
        delay(1.5) {
            let activity2 = NSUserActivity(activityType: "com.shi.Mast.dark")
            activity2.title = "Switch to dark mode".localized
            activity2.userInfo = ["state" : "dark"]
            activity2.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity2.isEligibleForPrediction = true
                activity2.persistentIdentifier = "com.shi.Mast.dark"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity2
            activity2.becomeCurrent()
        }
        
        delay(3) {
            let activity21 = NSUserActivity(activityType: "com.shi.Mast.dark2")
            activity21.title = "Switch to extra dark mode".localized
            activity21.userInfo = ["state" : "dark2"]
            activity21.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity21.isEligibleForPrediction = true
                activity21.persistentIdentifier = "com.shi.Mast.dark2"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity21
            activity21.becomeCurrent()
        }
        
        delay(4.5) {
            let activity3 = NSUserActivity(activityType: "com.shi.Mast.oled")
            activity3.title = "Switch to true black dark mode".localized
            activity3.userInfo = ["state" : "oled"]
            activity3.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity3.isEligibleForPrediction = true
                activity3.persistentIdentifier = "com.shi.Mast.oled"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity3
            activity3.becomeCurrent()
        }
        
        delay(6) {
            let activity3 = NSUserActivity(activityType: "com.shi.Mast.bluemid")
            activity3.title = "Switch to midnight blue mode".localized
            activity3.userInfo = ["state" : "blue"]
            activity3.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity3.isEligibleForPrediction = true
                activity3.persistentIdentifier = "com.shi.Mast.bluemid"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity3
            activity3.becomeCurrent()
        }
        
        delay(7.5) {
            let activity3 = NSUserActivity(activityType: "com.shi.Mast.confetti")
            activity3.title = "Confetti time".localized
            activity3.userInfo = ["state" : "confetti"]
            activity3.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity3.isEligibleForPrediction = true
                activity3.persistentIdentifier = "com.shi.Mast.confetti"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity3
            activity3.becomeCurrent()
        }
    }
    
    @objc func siriLight00() {
        self.siriLight()
    }
    
    @objc func siriDark00() {
        self.siriDark()
    }
    
    @objc func siriDark200() {
        self.siriDark2()
    }
    
    @objc func siriOled00() {
        self.siriOled()
    }
    
    @objc func siriBlue00() {
        self.siriBlue()
    }
    
    func siriLight() {
        UIApplication.shared.statusBarStyle = .default
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(0, forKey: "theme")
        self.genericStuff()
    }
    
    func siriDark() {
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(1, forKey: "theme")
        self.genericStuff()
    }
    
    func siriDark2() {
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(2, forKey: "theme")
        self.genericStuff()
    }
    
    func siriOled() {
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(3, forKey: "theme")
        self.genericStuff()
    }
    
    func siriBlue() {
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(4, forKey: "theme")
        self.genericStuff()
    }
    
    func siriConfetti() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
    }
    
    @objc func confettiCreate() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = false
        self.view.addSubview(confettiView)
        confettiView.intensity = 1
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    @objc func confettiCreateRe() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = false
        self.view.addSubview(confettiView)
        confettiView.intensity = 1
        confettiView.colors = [UIColor(red: 89/250, green: 207/250, blue: 99/250, alpha: 1.0), UIColor(red: 84/250, green: 202/250, blue: 94/250, alpha: 1.0), UIColor(red: 79/250, green: 97/250, blue: 89/250, alpha: 1.0)]
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    @objc func confettiCreateLi() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = false
        self.view.addSubview(confettiView)
        confettiView.intensity = 1
        confettiView.colors = [UIColor(red: 255/250, green: 177/250, blue: 61/250, alpha: 1.0), UIColor(red: 250/250, green: 172/250, blue: 56/250, alpha: 1.0), UIColor(red: 245/250, green: 168/250, blue: 51/250, alpha: 1.0)]
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let warning = UINotificationFeedbackGenerator()
                warning.notificationOccurred(.warning)
            }
            let label = ToppingLabel(text: "No Connection")
            let biscuit = BiscuitViewController(title: "Oops!", toppings: [label], timeout: 2)
            self.present(biscuit, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UserDefaults.standard.object(forKey: "accessToken") == nil {
            let con = PadLoginViewController()
            con.modalPresentationStyle = .pageSheet
            self.show(con, sender: self)
        } else {
            
            StoreStruct.currentInstance.accessToken = UserDefaults.standard.object(forKey: "accessToken") as! String
            StoreStruct.client = Client(
                baseURL: "https://\(StoreStruct.currentInstance.returnedText)",
                accessToken: StoreStruct.currentInstance.accessToken
            )
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("couldn't start network checker")
        }
        
        let request = Instances.customEmojis()
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.emotiFace = stat
                StoreStruct.mainResult = []
                StoreStruct.mainResult1 = []
                StoreStruct.mainResult2 = []
                stat.map({
                    let attributedString = NSAttributedString(string: "    \($0.shortcode)")
                    let textAttachment = NSTextAttachment()
                    textAttachment.loadImageUsingCache(withUrl: $0.staticURL.absoluteString)
                    textAttachment.bounds = CGRect(x:0, y: Int(-9), width: Int(30), height: Int(30))
                    let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                    let result = NSMutableAttributedString()
                    result.append(attrStringWithImage)
                    result.append(attributedString)
                    StoreStruct.mainResult.append(result)
                    
                    let textAttachment1 = NSTextAttachment()
                    textAttachment1.loadImageUsingCache(withUrl: $0.staticURL.absoluteString)
                    textAttachment1.bounds = CGRect(x:0, y: Int(-9), width: Int(30), height: Int(30))
                    let attrStringWithImage1 = NSAttributedString(attachment: textAttachment1)
                    let result1 = NSMutableAttributedString()
                    result1.append(attrStringWithImage1)
                    StoreStruct.mainResult1.append(result1)
                    
                    let attributedString2 = NSAttributedString(string: "\($0.shortcode)")
                    let result2 = NSMutableAttributedString()
                    result2.append(attributedString2)
                    StoreStruct.mainResult2.append(result)
                })
            }
        }
    }
    
    @objc func longAction(sender: UILongPressGestureRecognizer) {
        
        if (UserDefaults.standard.object(forKey: "longToggle") == nil) || (UserDefaults.standard.object(forKey: "longToggle") as! Int == 0) {
            
            if sender.state == .began {
                self.genericStuff()
            }
            
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 1) {
            if sender.state == .began {
//                self.tList()
            }
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 2) {
            if sender.state == .began {
                let controller = ComposeViewController()
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                switch (deviceIdiom) {
                case .pad:
                    controller.modalPresentationStyle = .pageSheet
                default:
                    print("nil")
                }
                controller.inReply = []
                controller.inReplyText = ""
                self.present(controller, animated: true, completion: nil)
            }
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 3) {
            print("do nothing")
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 6) {
            print("do nothing")
        } else {
            if sender.state == .began {
//                self.tSearch()
            }
        }
    }
    
    func genericStuff() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UIImpactFeedbackGenerator(style: .light)
            selection.impactOccurred()
        }
        
        var newNum = 0
        if UserDefaults.standard.object(forKey: "theme") == nil {
            newNum = 1
            UIApplication.shared.statusBarStyle = .lightContent
            Colours.keyCol = UIKeyboardAppearance.dark
            self.view.backgroundColor = UIColor(red: 66/255.0, green: 66/255.0, blue: 72/255.0, alpha: 1.0)
        } else {
            let z = UserDefaults.standard.object(forKey: "theme") as! Int
            if z == 0 {
                newNum = 1
                UIApplication.shared.statusBarStyle = .lightContent
                Colours.keyCol = UIKeyboardAppearance.dark
                self.view.backgroundColor = UIColor(red: 66/255.0, green: 66/255.0, blue: 72/255.0, alpha: 1.0)
            }
            if z == 1 {
                newNum = 2
                UIApplication.shared.statusBarStyle = .lightContent
                Colours.keyCol = UIKeyboardAppearance.dark
                self.view.backgroundColor = UIColor(red: 56/255.0, green: 53/255.0, blue: 57/255.0, alpha: 1.0)
            }
            if z == 2 {
                newNum = 3
                UIApplication.shared.statusBarStyle = .lightContent
                Colours.keyCol = UIKeyboardAppearance.dark
                self.view.backgroundColor = UIColor(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
            }
            if z == 3 {
                newNum = 4
                UIApplication.shared.statusBarStyle = .lightContent
                Colours.keyCol = UIKeyboardAppearance.dark
                self.view.backgroundColor = UIColor(red: 61/255.0, green: 70/255.0, blue: 98/255.0, alpha: 1.0)
            }
            if z == 4 {
                newNum = 0
                UIApplication.shared.statusBarStyle = .default
                Colours.keyCol = UIKeyboardAppearance.light
                self.view.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
            }
        }
        
        
        UserDefaults.standard.set(newNum, forKey: "theme")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
            
            self.navigationController?.navigationBar.backgroundColor = Colours.whitePad
            self.navigationController?.navigationBar.tintColor = Colours.whitePad
        }
    }
}
