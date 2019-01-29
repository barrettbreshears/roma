//
//  AppDelegate.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit
import OneSignal
import Disk
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectViewMain = UIView()
    
    var storeStruct = StoreStruct.shared
    var blurEffect0 = UIBlurEffect()
    var blurEffectView0 = UIVisualEffectView()
    
    var oneTime = false
    
    //    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    //        if 1 == 1 {
    //            NotificationCenter.default.post(name: Notification.Name(rawValue: "createNoti"), object: self)
    //            completionHandler(.newData)
    //        } else {
    //            completionHandler(.failed)
    //        }
    //    }
    
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
        print("RECRECREC")
        
        let request = Notifications.all(range: .default)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.notifications = stat
                
                for x in StoreStruct.notifications {
                    if x.type == .mention {
                        StoreStruct.notificationsMentions.append(x)
                        DispatchQueue.main.async {
                            StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
                            StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "loadNewest"), object: nil)
                        }
                    }
                }
                
            }
        }
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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if url.host == "light" {
                let viewController0 = window?.rootViewController as! UISplitViewController
                let viewController = viewController0.viewControllers[0] as! PadViewController
                viewController.siriLight()
                return true
            } else if url.host == "dark" {
                let viewController0 = window?.rootViewController as! UISplitViewController
                let viewController = viewController0.viewControllers[0] as! PadViewController
                viewController.siriDark()
                return true
            } else if url.host == "darker" {
                let viewController0 = window?.rootViewController as! UISplitViewController
                let viewController = viewController0.viewControllers[0] as! PadViewController
                viewController.siriDark2()
                return true
            } else if url.host == "black" {
                let viewController0 = window?.rootViewController as! UISplitViewController
                let viewController = viewController0.viewControllers[0] as! PadViewController
                viewController.siriOled()
                return true
            } else if url.host == "blue" {
                let viewController0 = window?.rootViewController as! UISplitViewController
                let viewController = viewController0.viewControllers[0] as! PadViewController
                viewController.siriBlue()
                return true
            } else if url.host == "confetti" {
                let viewController0 = window?.rootViewController as! UISplitViewController
                let viewController = viewController0.viewControllers[0] as! PadViewController
                viewController.siriConfetti()
                return true
            } else if url.host == "onboard" {
//                let viewController = window?.rootViewController as! PadViewController
//                viewController.presentIntro()
                return true
            } else if url.absoluteString.contains("id=") {
                let x = url.absoluteString
                let y = x.split(separator: "=")
                StoreStruct.curID = y[1].description
                let viewController0 = window?.rootViewController as! UISplitViewController
                let viewController = viewController0.viewControllers[0] as! PadViewController
                viewController.gotoID()
                return true
            } else if url.host == "home" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch11"), object: self)
                return true
            } else if url.host == "mentions" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch22"), object: self)
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
                StoreStruct.shared.newInstance!.authCode = y[1].description
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                switch (deviceIdiom) {
                case .phone:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newInstancelogged"), object: nil)
                case .pad:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newInstancelogged2"), object: nil)
                default:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newInstancelogged"), object: nil)
                }
                return true
            } else if url.host == "success" {
                print("Response ==> \(url.absoluteString)")
                let x = url.absoluteString
                let y = x.split(separator: "=")
                StoreStruct.shared.currentInstance.authCode = y[1].description
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                switch (deviceIdiom) {
                case .phone:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logged"), object: nil)
                case .pad:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logged2"), object: nil)
                default:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logged"), object: nil)
                }
                return true
            } else {
                return true
            }
            
            
            
        } else {
            if url.host == "light" {
                let viewController = window?.rootViewController as! ViewController
                viewController.siriLight()
                return true
            } else if url.host == "dark" {
                let viewController = window?.rootViewController as! ViewController
                viewController.siriDark()
                return true
            } else if url.host == "darker" {
                let viewController = window?.rootViewController as! ViewController
                viewController.siriDark2()
                return true
            } else if url.host == "black" {
                let viewController = window?.rootViewController as! ViewController
                viewController.siriOled()
                return true
            } else if url.host == "blue" {
                let viewController = window?.rootViewController as! ViewController
                viewController.siriBlue()
                return true
            } else if url.host == "confetti" {
                let viewController = window?.rootViewController as! ViewController
                viewController.siriConfetti()
                return true
            } else if url.host == "onboard" {
                let viewController = window?.rootViewController as! ViewController
                viewController.presentIntro()
                return true
            } else if url.absoluteString.contains("id=") {
                let x = url.absoluteString
                let y = x.split(separator: "=")
                StoreStruct.curID = y[1].description
                let viewController = window?.rootViewController as! ViewController
                viewController.gotoID()
                return true
            } else if url.host == "home" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch11"), object: self)
                return true
            } else if url.host == "mentions" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switch22"), object: self)
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
                StoreStruct.shared.newInstance!.authCode = y[1].description
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                switch (deviceIdiom) {
                case .phone:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newInstancelogged"), object: nil)
                case .pad:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newInstancelogged2"), object: nil)
                default:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "newInstancelogged"), object: nil)
                }
                return true
            } else if url.host == "success" {
                print("Response ==> \(url.absoluteString)")
                let x = url.absoluteString
                let y = x.split(separator: "=")
                StoreStruct.shared.currentInstance.authCode = y[1].description
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                switch (deviceIdiom) {
                case .phone:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logged"), object: nil)
                case .pad:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logged2"), object: nil)
                default:
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logged"), object: nil)
                }
                return true
            } else {
                return true
            }
        }
    }
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
        if UIApplication.shared.isSplitOrSlideOver {
            self.window?.rootViewController = ViewController()
            self.window?.makeKeyAndVisible()
        } else {
            
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                //            self.window?.rootViewController = ViewController()
                //            self.window?.makeKeyAndVisible()
                print("nothing")
            case .pad:
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window!.backgroundColor = Colours.white
                
                let splitViewController =  UISplitViewController()
                let rootViewController = PadViewController()
                
                let splitViewController2 =  UISplitViewController()
                let rootViewController2 = PadTimelinesViewController()
                let rootNavigationController2 = UINavigationController(rootViewController: rootViewController2)
                
                
                splitViewController2.viewControllers = [rootNavigationController2]
                splitViewController2.preferredPrimaryColumnWidthFraction = 0.5
                splitViewController2.preferredDisplayMode = .allVisible
                
                splitViewController.viewControllers = [rootViewController, splitViewController2]
                splitViewController.minimumPrimaryColumnWidth = 80
                splitViewController.maximumPrimaryColumnWidth = 80
                splitViewController.preferredDisplayMode = .allVisible
                
                splitViewController.view.backgroundColor = Colours.white
                splitViewController2.view.backgroundColor = Colours.white
                rootNavigationController2.view.backgroundColor = Colours.white
                self.window!.rootViewController = splitViewController
                self.window!.makeKeyAndVisible()
                
                
                UINavigationBar.appearance().shadowImage = UIImage()
                UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
                UINavigationBar.appearance().backgroundColor = Colours.white
                UINavigationBar.appearance().barTintColor = Colours.black
                UINavigationBar.appearance().tintColor = Colours.black
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
            default:
                //            self.window?.rootViewController = ViewController()
                //            self.window?.makeKeyAndVisible()
                print("nothing")
            }
            
        }
        
        SwiftyGiphyAPI.shared.apiKey = SwiftyGiphyAPI.publicBetaKey
        
        
        
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "4f67f45a-7d0f-4e7d-8624-0ec148f064ed",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        
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
        
        SettingsBundleHelper.checkAndExecuteSettings()
        SettingsBundleHelper.setVersionAndBuildNumber()
        
        if self.oneTime == false {
            if (UserDefaults.standard.object(forKey: "biometrics") == nil) || (UserDefaults.standard.object(forKey: "biometrics") as! Int == 0) {} else {
                self.biometricAuthenticationClicked(self)
                self.oneTime = true
            }
        }
        
        
        if UIApplication.shared.isSplitOrSlideOver {
            self.window?.rootViewController = ViewController()
            self.window?.makeKeyAndVisible()
            StoreStruct.isSplit = true
        } else {
            if StoreStruct.isSplit {
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                print("nothing")
            case .pad:
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window!.backgroundColor = Colours.white
                
                let splitViewController =  UISplitViewController()
                let rootViewController = PadViewController()
                
                let splitViewController2 =  UISplitViewController()
                let rootViewController2 = PadTimelinesViewController()
                let rootNavigationController2 = UINavigationController(rootViewController: rootViewController2)
                
                
                splitViewController2.viewControllers = [rootNavigationController2]
                splitViewController2.preferredPrimaryColumnWidthFraction = 0.5
                splitViewController2.preferredDisplayMode = .allVisible
                
                splitViewController.viewControllers = [rootViewController, splitViewController2]
                splitViewController.minimumPrimaryColumnWidth = 80
                splitViewController.maximumPrimaryColumnWidth = 80
                splitViewController.preferredDisplayMode = .allVisible
                
                splitViewController.view.backgroundColor = Colours.white
                splitViewController2.view.backgroundColor = Colours.white
                rootNavigationController2.view.backgroundColor = Colours.white
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
                StoreStruct.isSplit = false
            }
        }
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
            self.window?.rootViewController = ViewController()
            self.window?.makeKeyAndVisible()
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
                let rootViewController = PadViewController()
                
                let splitViewController2 =  UISplitViewController()
                let rootViewController2 = PadTimelinesViewController()
                let rootNavigationController2 = UINavigationController(rootViewController: rootViewController2)
                
                splitViewController2.viewControllers = [rootNavigationController2]
                splitViewController2.preferredPrimaryColumnWidthFraction = 0.5
                splitViewController2.preferredDisplayMode = .allVisible
                
                splitViewController.viewControllers = [rootViewController, splitViewController2]
                splitViewController.minimumPrimaryColumnWidth = 80
                splitViewController.maximumPrimaryColumnWidth = 80
                splitViewController.preferredDisplayMode = .allVisible
                
                splitViewController.view.backgroundColor = Colours.white
                splitViewController2.view.backgroundColor = Colours.white
                rootNavigationController2.view.backgroundColor = Colours.white
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
