//
//  AppDelegate.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit
import Disk
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectViewMain = UIView()

    var storeStruct = StoreStruct.shared
    var blurEffect0 = UIBlurEffect()
    var blurEffectView0 = UIVisualEffectView()

    var oneTime = false

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            if let tabBarViewControllers = tabBarController.viewControllers {
                if let projectsNavigationController = tabBarViewControllers[1] as? UINavigationController {
                    if projectsNavigationController.visibleViewController is SKPhotoBrowser {
                        return .all
                    }
                }
            }
        }
        return .portrait
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == "com.vm.roma.confetti" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriConfetti()
        } else if userActivity.activityType == "com.vm.roma.light" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriLight()
        } else if userActivity.activityType == "com.vm.roma.dark" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriDark()
        } else if userActivity.activityType == "com.vm.roma.dark2" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriDark2()
        } else if userActivity.activityType == "com.vm.roma.bluemid" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriBlue()
        } else {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriOled()
        }
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if application.applicationState == .inactive {
            if let userDefaults = UserDefaults(suiteName: "group.com.vm.roma.wormhole") {
                if userDefaults.value(forKey: "notidpush") != nil {
                    if let id = userDefaults.value(forKey: "notidpush") as? Int64 {
                        StoreStruct.curIDNoti = "\(id)"
                        if StoreStruct.currentPage == 0 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoidnoti"), object: self)
                        } else if StoreStruct.currentPage == 1 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoidnoti2"), object: self)
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoidnoti3"), object: self)
                        }
                    }
                    userDefaults.set(nil, forKey: "notidpush")
                }
            }
        } else if application.applicationState == .active {
            if (UserDefaults.standard.object(forKey: "badgeMent") == nil) || (UserDefaults.standard.object(forKey: "badgeMent") as! Int == 0) {
                if StoreStruct.currentPage != 1 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "addBadge"), object: nil)
                }
            }
        }
        
        if application.applicationState == .inactive || application.applicationState == .background {
            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        }
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        Messaging.messaging().apnsToken = deviceToken
        
        InstanceID.instanceID().instanceID { (result, error) in
            
            
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                
                self.createSubscription(fcmToken: result.token)
                
            }
        }

    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.vm.roma.feed" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switch11"), object: self)
            completionHandler(true)
        } else if shortcutItem.type == "com.vm.roma.notifications" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switch22"), object: self)
            completionHandler(true)
        } else if shortcutItem.type == "com.vm.roma.profile" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switch33"), object: self)
            completionHandler(true)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switch44"), object: self)
            completionHandler(false)
        }
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

            if url.host == "light" {
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.siriLight()
                }
                return true
            } else if url.host == "dark" {
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.siriDark()
                }
                return true
            } else if url.host == "darker" {
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.siriDark2()
                }
                return true
            } else if url.host == "black" {
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.siriOled()
                }
                return true
            } else if url.host == "blue" {
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.siriBlue()
                }
                return true
            } else if url.host == "confetti" {
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.siriConfetti()
                }
                return true
            } else if url.host == "onboard" {
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.presentIntro()
                }
                return true
            } else if url.host == "settings" {
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.goToSettings()
                }
                return true
            } else if url.absoluteString.contains("id=") {
                let x = url.absoluteString
                let y = x.split(separator: "=")
                StoreStruct.curID = y[1].description
                if let viewController = window?.rootViewController as? ViewController {
                    viewController.gotoID()
                }
                return true
            } else if url.absoluteString.contains("toot=") {
                let x = url.absoluteString
                let y = x.split(separator: "=")
                StoreStruct.composedTootText = y[1].description.replace("%20", with: " ")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch44"), object: self)
                return true
            } else if url.absoluteString.contains("instance=") {
                let x = url.absoluteString
                let y = x.split(separator: "=")
                self.tempGotoInstance(y[1].description)
                return true
            } else if url.host == "home" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch11"), object: self)
                return true
            } else if url.host == "mentions" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch22"), object: self)
                return true
            } else if url.host == "direct" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch222"), object: self)
                return true
            } else if url.host == "profile" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch33"), object: self)
                return true
            } else if url.host == "toot" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch44"), object: self)
                return true
            } else if url.host == "addNewInstance" {
                print("Response ==> \(url.absoluteString)")
                let x = url.absoluteString
                let y = x.split(separator: "=")
                StoreStruct.shared.newInstance!.authCode = y.last?.description ?? ""
                if StoreStruct.tappedSignInCheck == false {
                    StoreStruct.tappedSignInCheck = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newInstancelogged"), object: nil)
                }
                return true
            } else if url.host == "success" {
                print("Response ==> \(url.absoluteString)")
                let x = url.absoluteString
                let y = x.split(separator: "=")
                StoreStruct.shared.currentInstance.authCode = y[1].description
                if StoreStruct.tappedSignInCheck == false {
                    StoreStruct.tappedSignInCheck = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logged"), object: nil)
                }
                return true
            } else {
                return true
            }
    }

    func tempGotoInstance(_ text: String) {
        StoreStruct.client = Client(baseURL: "https://\(text)")
        let request = Clients.register(
            clientName: "Mast",
            redirectURI: "com.vm.roma://success",
            scopes: [.read, .write, .follow, .push],
            website: "https://pleroma.com"
        )
        StoreStruct.client.run(request) { (application) in

            if application.value == nil {} else {

                DispatchQueue.main.async {
                    // go to next view
                    StoreStruct.shared.currentInstance.instanceText = text

                    if StoreStruct.instanceLocalToAdd.contains(StoreStruct.shared.currentInstance.instanceText.lowercased()) {} else {
                        StoreStruct.instanceLocalToAdd.append(StoreStruct.shared.currentInstance.instanceText.lowercased())
                        UserDefaults.standard.set(StoreStruct.instanceLocalToAdd, forKey: "instancesLocal")
                    }

                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadLists"), object: nil)
                    if StoreStruct.currentPage == 0 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance"), object: self)
                    } else if StoreStruct.currentPage == 1 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance2"), object: self)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance3"), object: self)
                    }
                }

            }
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
//        if UIApplication.shared.isSplitOrSlideOver {
//            self.window?.rootViewController = ViewController()
//            self.window?.makeKeyAndVisible()
//        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.backgroundColor = Colours.white

            let splitViewController =  UISplitViewController()
            let rootViewController = ViewController()
            let detailViewController = DetailViewController()
            splitViewController.viewControllers = [rootViewController, detailViewController]
            splitViewController.preferredDisplayMode = .allVisible
            let minimumWidth = min(splitViewController.view.bounds.width, splitViewController.view.bounds.height)
            
            if (UserDefaults.standard.object(forKey: "splitra") == nil) || (UserDefaults.standard.object(forKey: "splitra") as? Int == 0) {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.5
                splitViewController.minimumPrimaryColumnWidth = minimumWidth/2
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 1 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.25
                splitViewController.minimumPrimaryColumnWidth = minimumWidth/4
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 2 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.3
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/10)*3
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 3 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.35
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*7
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 4 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.4
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/5)*2
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 5 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.45
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*9
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 6 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.55
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*11
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 7 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.6
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/5)*4
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 8 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.65
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*13
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 9 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.7
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/10)*7
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 10 {
                splitViewController.preferredPrimaryColumnWidthFraction = 0.75
                splitViewController.minimumPrimaryColumnWidth = (minimumWidth/4)*3
                splitViewController.maximumPrimaryColumnWidth = minimumWidth
            }
                
            self.window!.rootViewController = splitViewController
            self.window!.makeKeyAndVisible()

            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().backgroundColor = Colours.white
            UINavigationBar.appearance().barTintColor = Colours.black
            UINavigationBar.appearance().tintColor = Colours.black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
//        }
        
        SwiftyGiphyAPI.shared.apiKey = SwiftyGiphyAPI.publicBetaKey


        WatchSessionManager.sharedManager.startSession()


        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colours.grayLight2], for: .normal)
        BarButtonItemAppearance.tintColor = Colours.grayLight2


        window?.tintColor = Colours.tabSelected


        if StoreStruct.currentUser != nil {
            if (UserDefaults.standard.object(forKey: "\(StoreStruct.shared.currentInstance.clientID)homeid") == nil) {} else {
                StoreStruct.gapLastHomeID = UserDefaults.standard.object(forKey: "\(StoreStruct.shared.currentInstance.clientID)homeid") as! String
            }
            if (UserDefaults.standard.object(forKey: "\(StoreStruct.shared.currentInstance.clientID)localid") == nil) {} else {
                StoreStruct.gapLastLocalID = UserDefaults.standard.object(forKey: "\(StoreStruct.shared.currentInstance.clientID)localid") as! String
            }
            if (UserDefaults.standard.object(forKey: "\(StoreStruct.shared.currentInstance.clientID)fedid") == nil) {} else {
                StoreStruct.gapLastFedID = UserDefaults.standard.object(forKey: "\(StoreStruct.shared.currentInstance.clientID)fedid") as! String
            }
        }

        do {
            StoreStruct.currentUser = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)use.json", from: .documents, as: Account.self)
            StoreStruct.statusesHome = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)home.json", from: .documents, as: [Status].self)
            StoreStruct.statusesLocal = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)local.json", from: .documents, as: [Status].self)
            StoreStruct.statusesFederated = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)fed.json", from: .documents, as: [Status].self)
            StoreStruct.notifications = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)noti.json", from: .documents, as: [Notificationt].self)
            StoreStruct.notificationsMentions = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)ment.json", from: .documents, as: [Notificationt].self)

            StoreStruct.gapLastHomeStat = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)homestat.json", from: .documents, as: Status.self)
            StoreStruct.gapLastLocalStat = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)localstat.json", from: .documents, as: Status.self)
            StoreStruct.gapLastFedStat = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)fedstat.json", from: .documents, as: Status.self)
        } catch {
            print("Couldn't load")
        }

        return true
    }





    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

        if StoreStruct.currentPage == 587 {
            UserDefaults.standard.set(StoreStruct.savedComposeText, forKey: "composeSaved")
            UserDefaults.standard.set(StoreStruct.savedInReplyText, forKey: "savedInReplyText")
        } else {
            UserDefaults.standard.set("", forKey: "composeSaved")
            UserDefaults.standard.set("", forKey: "savedInReplyText")
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        if StoreStruct.currentUser != nil {
            UserDefaults.standard.set(StoreStruct.gapLastHomeID, forKey: "\(StoreStruct.shared.currentInstance.clientID)homeid")
            UserDefaults.standard.set(StoreStruct.gapLastLocalID, forKey: "\(StoreStruct.shared.currentInstance.clientID)localid")
            UserDefaults.standard.set(StoreStruct.gapLastFedID, forKey: "\(StoreStruct.shared.currentInstance.clientID)fedid")

            UserDefaults.standard.set(StoreStruct.currentUser.username, forKey: "userN")
            do {
                try Disk.save(StoreStruct.currentUser, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)use.json")

                try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")

                try Disk.save(StoreStruct.notifications, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)noti.json")
                try Disk.save(StoreStruct.notificationsMentions, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)ment.json")

                try Disk.save(StoreStruct.gapLastHomeStat, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)homestat.json")
                try Disk.save(StoreStruct.gapLastLocalStat, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)localstat.json")
                try Disk.save(StoreStruct.gapLastFedStat, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fedstat.json")
            } catch {
                print("Couldn't save")
            }
        }


    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "startStream"), object: self)

        UIApplication.shared.applicationIconBadgeNumber = 0

        if (UserDefaults.standard.object(forKey: "composeSaved") == nil) || (UserDefaults.standard.object(forKey: "composeSaved") as? String == "") {

        } else {
            if let x = UserDefaults.standard.object(forKey: "composeSaved") as? String {
                StoreStruct.savedComposeText = x
                if let y = UserDefaults.standard.object(forKey: "savedInReplyText") as? String {
                    StoreStruct.savedInReplyText = y
                    StoreStruct.savedComposeText = x
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "savedComposePresent"), object: nil)
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "savedComposePresent"), object: nil)
            }
        }

        SettingsBundleHelper.checkAndExecuteSettings()
        SettingsBundleHelper.setVersionAndBuildNumber()

        if self.oneTime == false {
            if (UserDefaults.standard.object(forKey: "biometrics") == nil) || (UserDefaults.standard.object(forKey: "biometrics") as! Int == 0) {} else {
                self.biometricAuthenticationClicked(self)
                self.oneTime = true
            }
        }
        
        
//        if UIApplication.shared.isSplitOrSlideOver {
//            self.window?.rootViewController = ViewController()
//            self.window?.makeKeyAndVisible()
//            StoreStruct.isSplit = true
//        } else {
//            if StoreStruct.isSplit {
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                print("nothing")
            case .pad:
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window!.backgroundColor = Colours.white

                let splitViewController =  UISplitViewController()
                let rootViewController = ViewController()
                let detailViewController = DetailViewController()
                splitViewController.viewControllers = [rootViewController, detailViewController]
                splitViewController.preferredDisplayMode = .allVisible
                let minimumWidth = min(splitViewController.view.bounds.width, splitViewController.view.bounds.height)
                
                if (UserDefaults.standard.object(forKey: "splitra") == nil) || (UserDefaults.standard.object(forKey: "splitra") as? Int == 0) {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.5
                    splitViewController.minimumPrimaryColumnWidth = minimumWidth/2
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 1 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.25
                    splitViewController.minimumPrimaryColumnWidth = minimumWidth/4
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 2 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.3
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/10)*3
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 3 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.35
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*7
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 4 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.4
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/5)*2
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 5 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.45
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*9
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 6 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.55
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*11
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 7 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.6
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/5)*4
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 8 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.65
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*13
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 9 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.7
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/10)*7
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 10 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.75
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/4)*3
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                }
                self.window!.rootViewController = splitViewController
                self.window!.makeKeyAndVisible()

                UINavigationBar.appearance().shadowImage = UIImage()
                UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
                UINavigationBar.appearance().backgroundColor = Colours.white
                UINavigationBar.appearance().barTintColor = Colours.black
                UINavigationBar.appearance().tintColor = Colours.black
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
            default:
                print("nothing")
            }
//                StoreStruct.isSplit = false
//            }
//        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func biometricAuthenticationClicked(_ sender: Any) {

        let win = window
        blurEffectViewMain.frame = UIScreen.main.bounds
        blurEffectViewMain.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        win!.addSubview(blurEffectViewMain)

        blurEffect0 = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView0 = UIVisualEffectView(effect: blurEffect0)
        blurEffectView0.frame = UIScreen.main.bounds
        blurEffectView0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        win!.addSubview(blurEffectView0)

        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {

            self.blurEffectViewMain.removeFromSuperview()
            self.blurEffectView0.removeFromSuperview()

        }, failure: { [weak self] (error) in
            self?.showPasscodeAuthentication(message: "Error")
        })
    }
    func showPasscodeAuthentication(message: String) {
        BioMetricAuthenticator.authenticateWithPasscode(reason: message, success: {

            self.blurEffectViewMain.removeFromSuperview()
            self.blurEffectView0.removeFromSuperview()

        }) { (error) in
            print(error.message())
            self.biometricAuthenticationClicked(self)
        }
    }

    func reloadTint() {
        window?.tintColor = Colours.tabSelected
    }

    func reloadApplication() {
        do {
            StoreStruct.currentUser = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)use.json", from: .documents, as: Account.self)
            StoreStruct.statusesHome = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)home.json", from: .documents, as: [Status].self)
            StoreStruct.statusesLocal = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)local.json", from: .documents, as: [Status].self)
            StoreStruct.statusesFederated = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)fed.json", from: .documents, as: [Status].self)
            StoreStruct.notifications = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)noti.json", from: .documents, as: [Notificationt].self)
            StoreStruct.notificationsMentions = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)ment.json", from: .documents, as: [Notificationt].self)

            StoreStruct.gapLastHomeStat = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)homestat.json", from: .documents, as: Status.self)
            StoreStruct.gapLastLocalStat = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)localstat.json", from: .documents, as: Status.self)
            StoreStruct.gapLastFedStat = try Disk.retrieve("\(StoreStruct.shared.currentInstance.clientID)fedstat.json", from: .documents, as: Status.self)
        } catch {
            print("Couldn't load")
        }

        if UIApplication.shared.isSplitOrSlideOver {
//            self.window?.rootViewController = ViewController()
//            self.window?.makeKeyAndVisible()
        } else {

            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                self.window?.rootViewController = ViewController()
                self.window?.makeKeyAndVisible()
            case .pad:
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window!.backgroundColor = Colours.white

                let splitViewController =  UISplitViewController()
                let rootViewController = ViewController()
                let detailViewController = DetailViewController()
                splitViewController.viewControllers = [rootViewController, detailViewController]
                splitViewController.preferredDisplayMode = .allVisible
                let minimumWidth = min(splitViewController.view.bounds.width, splitViewController.view.bounds.height)
                
                if (UserDefaults.standard.object(forKey: "splitra") == nil) || (UserDefaults.standard.object(forKey: "splitra") as? Int == 0) {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.5
                    splitViewController.minimumPrimaryColumnWidth = minimumWidth/2
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 1 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.25
                    splitViewController.minimumPrimaryColumnWidth = minimumWidth/4
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 2 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.3
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/10)*3
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 3 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.35
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*7
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 4 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.4
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/5)*2
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 5 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.45
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*9
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 6 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.55
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*11
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 7 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.6
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/5)*4
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 8 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.65
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/20)*13
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 9 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.7
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/10)*7
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                } else if UserDefaults.standard.object(forKey: "splitra") as? Int == 10 {
                    splitViewController.preferredPrimaryColumnWidthFraction = 0.75
                    splitViewController.minimumPrimaryColumnWidth = (minimumWidth/4)*3
                    splitViewController.maximumPrimaryColumnWidth = minimumWidth
                }
                self.window!.rootViewController = splitViewController
                self.window!.makeKeyAndVisible()

                UINavigationBar.appearance().shadowImage = UIImage()
                UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
                UINavigationBar.appearance().backgroundColor = Colours.white
                UINavigationBar.appearance().barTintColor = Colours.black
                UINavigationBar.appearance().tintColor = Colours.black
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
            default:
                self.window?.rootViewController = ViewController()
                self.window?.makeKeyAndVisible()
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        createSubscription(fcmToken:fcmToken)
        
    }
    
    func createSubscription(fcmToken: String){
        
        let jsonObject = ["data":
            ["alerts":
                ["favourite":UserDefaults.standard.object(forKey: "pnlikes") as? Bool ?? true,
                 "follow":UserDefaults.standard.object(forKey: "pnfollows") as? Bool ?? true,
                 "mention": UserDefaults.standard.object(forKey: "pnmentions") as? Bool ?? true,
                 "reblog":UserDefaults.standard.object(forKey: "pnboosts") as? Bool ?? true]
            ],
                    "subscription":
                        ["keys":
                            ["p256dh":"BEpPCn0cfs3P0E0fY-gyOuahx5dW5N8quUowlrPyfXlMa6tABLqqcSpOpMnC1-o_UB_s4R8NQsqMLbASjnqSbqw=",
                             "auth":"T5bhIIyre5TDC1LyX4mFAQ=="
                            ],
                         "endpoint":"https://pushrelay-roma1-fcm.your.org/push/\(fcmToken)?account=test&server=server&device=iOS"
            ]
        ]
        //create the url with URL
        let url = URL(string: "https://\(StoreStruct.shared.currentInstance.returnedText)/api/v1/push/subscription")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            request.httpBody = jsonData
            print("JSON String : " + jsonString!)
        }
        catch {
            print(error.localizedDescription)
        }
        request.httpMethod = "DELETE"// "POST" //set http method as POST
        request.setValue("Bearer \(StoreStruct.shared.currentInstance.accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            //create the url with URL
            let url = URL(string: "https://\(StoreStruct.shared.currentInstance.returnedText)/api/v1/push/subscription")! //change the url
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"// "POST" //set http method as POST
            
           
            
            // "https://pushrelay-roma1-fcm.your.org/push/\(fcmToken)?account=test&server=server"
            
            do {
                let jsonData = try JSONSerialization.data(
                    withJSONObject: jsonObject,
                    options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                request.httpBody = jsonData
                print("JSON String : " + jsonString!)
            }
            catch {
                print(error.localizedDescription)
            }
            request.setValue("Bearer \(StoreStruct.shared.currentInstance.accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        // handle json...
                    }
                    Account.pushSetSuccess(instance: StoreStruct.shared.currentInstance.returnedText)
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
            
        })
        task.resume()
    }
}

extension UIApplication {
    public var isSplitOrSlideOver: Bool {
        guard let w = self.delegate?.window, let window = w else { return false }
        return !window.frame.equalTo(window.screen.bounds)
    }

    public func isRunningInFullScreen() -> Bool {
        if let w = self.keyWindow {
            let maxScreenSize = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            let minScreenSize = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            let maxAppSize = max(w.bounds.size.width, w.bounds.size.height)
            let minAppSize = min(w.bounds.size.width, w.bounds.size.height)
            return maxScreenSize == maxAppSize && minScreenSize == minAppSize
        }
        return true
    }
}
