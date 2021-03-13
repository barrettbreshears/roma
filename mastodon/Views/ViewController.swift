//
//  ViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit
import SafariServices
import StatusAlert
import SJFluidSegmentedControl
import SAConfettiView
import WatchConnectivity
import Disk
import UserNotifications
import ReactiveSSE
import ReactiveSwift

class ViewController: UITabBarController, UITabBarControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SJFluidSegmentedControlDataSource, SJFluidSegmentedControlDelegate, WCSessionDelegate, UNUserNotificationCenterDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("active: \(activationState)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("deactivate")
    }

    var watchSession: WCSession? {
        didSet {
            if let session = watchSession {
                session.delegate = self
                session.activate()
            }
        }
    }

    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .circleStrokeSpin, color: Colours.tabSelected)
    var loadingAdditionalInstance = false
    var screenshotLabel = UILabel()
    var screenshot = UIImage()
    var identity = CGAffineTransform.identity
    let view0pinch = UIView()
    let view1pinch = UIImageView()
    var doOnce = true
    var doOncePinch = true
    var doOnceScreen = true
    var newInstance = false
    var segmentedControl: SJFluidSegmentedControl!
    var typeOfSearch = 0
    var newestText = ""
    var searchIcon = UIImageView()
    
    var tabOne = UINavigationController()
    var tabTwo = UINavigationController()
    var tabDM = UINavigationController()
    var tabThree = UINavigationController()
    var tabFour = UINavigationController()
    
    var firstView = FirstViewController()
    var secondView = SecondViewController()
    var dmView = DMViewController()
    var thirdView = ThirdViewController()
    var fourthView = FourthViewController()

    var statusBarView = UIView()
    var bgView = UIView()
    var settingsButton = MNGExpandedTouchAreaButton()
    var searchButton = MNGExpandedTouchAreaButton()

    var loginBG = UIView()
    var loginLogo = UIImageView()
    var loginLabel = UILabel()
    var textField = PaddedTextField()
    var termsButton = UIButton()
    var safariVC: SFSafariViewController?

    var searcherView = UIView()
    var searchTextField = SearchField()
    var backgroundView = UIButton()
    var tableView = UITableView()
    var tableViewLists = UITableView()
    let volumeBar = VolumeBar.shared
    let reachability = Reachability()!
    var keyHeight = 0
    var tagListView = DLTagView()
    var closeButton = MNGExpandedTouchAreaButton()
    var dStream = false
    var dMod: [Notificationt] = []
    var nsocket: WebSocket!
    
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

    func genericStuff() {

        self.firstView.loadLoadLoad()
        self.secondView.loadLoadLoad()
        self.dmView.loadLoadLoad()
        self.thirdView.loadLoadLoad()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

        self.view.backgroundColor = Colours.white
        self.navigationController?.navigationBar.backgroundColor = Colours.white
        self.navigationController?.navigationBar.tintColor = Colours.white

        self.tabBar.barTintColor = Colours.white
        self.tabBar.backgroundColor = Colours.white
        self.tabBar.unselectedItemTintColor = Colours.grayDark.withAlphaComponent(0.21)
        self.tabBar.tintColor = Colours.tabSelected

        self.firstView.view.backgroundColor = Colours.white
        self.secondView.view.backgroundColor = Colours.white
        self.dmView.view.backgroundColor = Colours.white
        self.thirdView.view.backgroundColor = Colours.white
        self.fourthView.view.backgroundColor = Colours.white

        self.tabOne.navigationBar.backgroundColor = Colours.white
        self.tabOne.navigationBar.barTintColor = Colours.white
        self.tabTwo.navigationBar.backgroundColor = Colours.white
        self.tabTwo.navigationBar.barTintColor = Colours.white
        self.tabDM.navigationBar.backgroundColor = Colours.white
        self.tabDM.navigationBar.barTintColor = Colours.white
        self.tabThree.navigationBar.backgroundColor = Colours.white
        self.tabThree.navigationBar.barTintColor = Colours.white
        self.tabFour.navigationBar.backgroundColor = Colours.white
        self.tabFour.navigationBar.barTintColor = Colours.white

        statusBarView.backgroundColor = Colours.white
    }

    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.global(qos: .background).asyncAfter(deadline: when, execute: closure)
    }

    func setupSiri() {
            let activity1 = NSUserActivity(activityType: "com.vm.roma.light")
            activity1.title = "Switch to light mode".localized
            activity1.userInfo = ["state" : "light"]
            activity1.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity1.isEligibleForPrediction = true
                activity1.persistentIdentifier = "com.vm.roma.light"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity1
            activity1.becomeCurrent()

        delay(1.5) {
            let activity2 = NSUserActivity(activityType: "com.vm.roma.dark")
            activity2.title = "Switch to dark mode".localized
            activity2.userInfo = ["state" : "dark"]
            activity2.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity2.isEligibleForPrediction = true
                activity2.persistentIdentifier = "com.vm.roma.dark"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity2
            activity2.becomeCurrent()
        }
        
        delay(3) {
            let activity21 = NSUserActivity(activityType: "com.vm.roma.dark2")
            activity21.title = "Switch to extra dark mode".localized
            activity21.userInfo = ["state" : "dark2"]
            activity21.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity21.isEligibleForPrediction = true
                activity21.persistentIdentifier = "com.vm.roma.dark2"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity21
            activity21.becomeCurrent()
        }
        
        delay(4.5) {
            let activity3 = NSUserActivity(activityType: "com.vm.roma.oled")
            activity3.title = "Switch to true black dark mode".localized
            activity3.userInfo = ["state" : "oled"]
            activity3.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity3.isEligibleForPrediction = true
                activity3.persistentIdentifier = "com.vm.roma.oled"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity3
            activity3.becomeCurrent()
        }
        
        delay(6) {
            let activity3 = NSUserActivity(activityType: "com.vm.rom.bluemid")
            activity3.title = "Switch to midnight blue mode".localized
            activity3.userInfo = ["state" : "blue"]
            activity3.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity3.isEligibleForPrediction = true
                activity3.persistentIdentifier = "com.vm.rom.bluemid"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity3
            activity3.becomeCurrent()
        }
        
        delay(7.5) {
            let activity3 = NSUserActivity(activityType: "com.vm.roma.confetti")
            activity3.title = "Confetti time".localized
            activity3.userInfo = ["state" : "confetti"]
            activity3.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity3.isEligibleForPrediction = true
                activity3.persistentIdentifier = "com.vm.roma.confetti"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity3
            activity3.becomeCurrent()
        }
    }

    @objc func logged() {
        
        StoreStruct.tappedSignInCheck = false
        
        self.loginBG.removeFromSuperview()
        self.loginLogo.removeFromSuperview()
        self.loginLabel.removeFromSuperview()
        self.textField.removeFromSuperview()
        self.termsButton.removeFromSuperview()
        self.safariVC?.dismiss(animated: true, completion: nil)
        
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
                   
//                    let currentInstance = InstanceData(clientID: StoreStruct.currentInstance.clientID, clientSecret: StoreStruct.currentInstance.clientSecret, authCode: StoreStruct.currentInstance.authCode, accessToken: StoreStruct.currentInstance.accessToken, returnedText: StoreStruct.currentInstance.returnedText, redirect:StoreStruct.currentInstance.redirect)
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
                            }

                        }
                    }
                    
                    let request = Timelines.home()
                    StoreStruct.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.statusesHome = stat
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
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
                    
                    
                    // onboarding
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

        let task = URLSession.shared.dataTask(with: request) { (data, respose, error) in
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
                                }
                            }
                        }
                    
                    let request = Timelines.home()
                    StoreStruct.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.statusesHome = stat
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                        }
                        
                        DispatchQueue.main.async {
                            StoreStruct.tappedSignInCheck = false
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.reloadApplication()
                        }
                        
                        
                    }
                    
                }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()

    }




    lazy var bulletinManager: BulletinManager = {

        let page = PageBulletinItem(title: "Welcome to Roma")
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
        page.descriptionText = "Roma can send you push notifications for statuses you're mentioned in, reposted and liked statuses, as well as for new followers."
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
        page.descriptionText = "You're all ready to go.\nHappy posting!"
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




    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.viewControllers?.last {
            return false
        }
        return true
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.tag == 1 && StoreStruct.currentPage == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop1"), object: nil)
        }
        if item.tag == 2 && StoreStruct.currentPage == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop2"), object: nil)
        }
        if item.tag == 3 && StoreStruct.currentPage == 101010 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTopDM"), object: nil)
        }
        if item.tag == 4 && StoreStruct.currentPage == 2 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop3"), object: nil)
        }
        if item.tag == 5 {
            
//            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                let imp = UIImpactFeedbackGenerator(style: .light)
//                imp.impactOccurred()
//            }
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
    }


    @objc func switch11() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 0
    }
    @objc func switch22() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 1
    }
    @objc func switch222() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 2
    }
    @objc func switch33() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 3
    }
    @objc func switch44() {
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

    @objc func reloadLists() {
        self.tableViewLists.reloadData()
    }

    @objc func startindi() {
        self.ai.alpha = 1
        self.ai.startAnimating()
    }

    @objc func stopindi() {
        self.ai.alpha = 0
        self.ai.stopAnimating()
        if StoreStruct.newdrafts.count > 0 {
            StoreStruct.newdrafts.remove(at: StoreStruct.newdrafts.count - 1)
        }
        DispatchQueue.global(qos: .userInitiated).async {
        do {
            // ** try Disk.save(StoreStruct.newdrafts, to: .documents, as: "drafts1.json")
        } catch {
            print("err")
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func presentIntro() {
        DispatchQueue.main.async {
            self.bulletinManager.prepare()
            self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
        }
    }

    func switchTo1() {
        self.tabBarController?.selectedIndex = 0
    }

    func switchTo2() {
        self.tabBarController?.selectedIndex = 1
    }

    func switchTo3() {
        self.tabBarController?.selectedIndex = 3
    }
    
    @objc func gotoID() {
        if StoreStruct.currentPage == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid"), object: self)
        } else if StoreStruct.currentPage == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid2"), object: self)
        } else if StoreStruct.currentPage == 101010 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid3"), object: self)
        } else if StoreStruct.currentPage == 2 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid4"), object: self)
        } else if StoreStruct.currentPage == 778 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid778"), object: self)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid779"), object: self)
        }
    }

    override var keyCommands: [UIKeyCommand]? {
        //shortkeys
        let op1 = UIKeyCommand(input: "1", modifierFlags: .control, action: #selector(b1Touched), discoverabilityTitle: "Home Timelines")
        let op2 = UIKeyCommand(input: "2", modifierFlags: .control, action: #selector(b2Touched), discoverabilityTitle: "Notification Timelines")
        let op3 = UIKeyCommand(input: "3", modifierFlags: .control, action: #selector(b22Touched), discoverabilityTitle: "Direct Messages")
        let op4 = UIKeyCommand(input: "4", modifierFlags: .control, action: #selector(b3Touched), discoverabilityTitle: "Profile Timelines")
        let listThing = UIKeyCommand(input: "l", modifierFlags: .control, action: #selector(b56Touched), discoverabilityTitle: "Lists")
        let searchThing = UIKeyCommand(input: "f", modifierFlags: .command, action: #selector(b4Touched), discoverabilityTitle: "Search")
        let newToot = UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(switch44), discoverabilityTitle: "New Toot")
        let settings = UIKeyCommand(input: ";", modifierFlags: .command, action: #selector(goToSettings), discoverabilityTitle: "Settings")
        let esca = UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(dismissDetail), discoverabilityTitle: "Close Detail")
        return [
            op1, op2, op3, op4, listThing, searchThing, newToot, settings, esca
        ]
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }

    @objc func goToSettings() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "goToSettings"), object: self)
    }

    @objc func dismissDetail() {
        let controller = DetailViewController()
        controller.mainStatus = []
        self.splitViewController?.showDetailViewController(controller, sender: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "splitload"), object: nil)
    }

    @objc func b1Touched() {
        self.selectedIndex = 0
    }

    @objc func b2Touched() {
        self.selectedIndex = 1
    }
    
    @objc func b22Touched() {
        self.selectedIndex = 2
    }
    
    @objc func b3Touched() {
        self.selectedIndex = 3
    }
    
    @objc func b56Touched() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "touchList"), object: nil)
    }

    @objc func b4Touched() {
        self.tSearch()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("couldn't start network checker")
        }
    }
    
    func composedToot() {
        let request0 = Statuses.create(status: StoreStruct.composedTootText, replyToID: nil, mediaIDs: [], sensitive: false, spoilerText: nil, scheduledAt: nil, poll: nil, visibility: .public)
//        DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request0) { (statuses) in
                
            }
//        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
        print("Finished restoring state")
    }
    
    @objc func tappedOnTag() {
        self.textField.text = StoreStruct.tappedTag
    }
    
    @objc func addBadge() {
        StoreStruct.badgeCount = StoreStruct.badgeCount + 1
        self.tabBar.items?[1].badgeValue = "\(StoreStruct.badgeCount)" ?? "1"
        self.tabBar.items?[1].badgeColor = Colours.tabSelected
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refnoti0"), object: nil)
    }
    
    func streamDataDirect() {
        if UserDefaults.standard.object(forKey: "accessToken") == nil {} else {
        if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
            
            var sss = StoreStruct.client.baseURL.replacingOccurrences(of: "https", with: "wss")
            sss = sss.replacingOccurrences(of: "http", with: "wss")
            nsocket = WebSocket(url: URL(string: "\(sss)/api/v1/streaming/user?access_token=\(StoreStruct.currentInstance.accessToken)&stream=user")!)
            nsocket.onConnect = {
                print("websocket is connected")
            }
            //websocketDidDisconnect
            nsocket.onDisconnect = { (error: Error?) in
                print("websocket is disconnected")
            }
            //websocketDidReceiveMessage
            nsocket.onText = { (text: String) in
                
                let data0 = text.data(using: .utf8)!
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data0, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    let re = jsonResult?["payload"]
                    if jsonResult?["event"] as? String == "notification" {
                        let te = SSEvent.init(type: "notification", data: re as! String)
                        let data = te.data.data(using: .utf8)!
                        guard let model = try? Notificationt.decode(data: data) else {
                            return
                        }
                        
                        if (model.status?.visibility) ?? Visibility.private == .direct {
                            let request = Timelines.direct(range: .since(id: StoreStruct.notificationsDirect.first?.id ?? "", limit: nil))
                            // let request = Timelines.conversations(range: .since(id: StoreStruct.notificationsDirect.first?.id ?? "", limit: nil))
                            StoreStruct.client.run(request) { [weak self] (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.isEmpty {} else {
//                                        DispatchQueue.main.async {
                                            if (UserDefaults.standard.object(forKey: "badgeMentd") == nil) || (UserDefaults.standard.object(forKey: "badgeMentd") as! Int == 0) {
                                                StoreStruct.badgeCount2 = StoreStruct.badgeCount2 + 1
                                                self?.tabBar.items?[2].badgeValue = "\(StoreStruct.badgeCount2)" ?? "1"
                                                self?.tabBar.items?[2].badgeColor = Colours.tabSelected
                                            }
                                            StoreStruct.notificationsDirect = stat + StoreStruct.notificationsDirect
                                            StoreStruct.notificationsDirect = StoreStruct.notificationsDirect.removeDuplicates()
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateDM"), object: nil)
//                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                } catch {
                    print("failfail")
                    return
                }
            }
            //websocketDidReceiveData
            nsocket.onData = { (data: Data) in
                print("got some data: \(data.count)")
            }
            nsocket.connect()
        }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUpProfileImage), name: NSNotification.Name(rawValue: "setUpProfileImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriLight00), name: NSNotification.Name(rawValue: "light00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriDark00), name: NSNotification.Name(rawValue: "dark00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriDark200), name: NSNotification.Name(rawValue: "darker00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriOled00), name: NSNotification.Name(rawValue: "black00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.siriBlue00), name: NSNotification.Name(rawValue: "blue00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentIntro), name: NSNotification.Name(rawValue: "presentIntro00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoID), name: NSNotification.Name(rawValue: "gotoid00"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tappedOnTag), name: NSNotification.Name(rawValue: "tappedOnTag"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.logged), name: NSNotification.Name(rawValue: "logged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newInstanceLogged), name: NSNotification.Name(rawValue: "newInstancelogged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.switch11), name: NSNotification.Name(rawValue: "switch11"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.switch22), name: NSNotification.Name(rawValue: "switch22"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.switch33), name: NSNotification.Name(rawValue: "switch33"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.switch44), name: NSNotification.Name(rawValue: "switch44"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeLight), name: NSNotification.Name(rawValue: "light"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeNight), name: NSNotification.Name(rawValue: "night"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeNight2), name: NSNotification.Name(rawValue: "night2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeBlack), name: NSNotification.Name(rawValue: "black"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.midBlue), name: NSNotification.Name(rawValue: "midblue"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreate), name: NSNotification.Name(rawValue: "confettiCreate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreateRe), name: NSNotification.Name(rawValue: "confettiCreateRe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreateLi), name: NSNotification.Name(rawValue: "confettiCreateLi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeTopStuff), name: NSNotification.Name(rawValue: "themeTopStuff"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLists), name: NSNotification.Name(rawValue: "reloadLists"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startindi), name: NSNotification.Name(rawValue: "startindi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopindi), name: NSNotification.Name(rawValue: "stopindi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.touchList), name: NSNotification.Name(rawValue: "touchList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.signOut), name: NSNotification.Name(rawValue: "signOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.signOutNewInstance), name: NSNotification.Name(rawValue: "signOut2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didTouchSearch), name: NSNotification.Name(rawValue: "searchthething"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addBadge), name: NSNotification.Name(rawValue: "addBadge"), object: nil)
        
        
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
        
        self.tabBar.barTintColor = Colours.white
        self.tabBar.backgroundColor = Colours.white
        self.tabBar.isTranslucent = false
        self.tabBar.unselectedItemTintColor = Colours.grayDark.withAlphaComponent(0.21)
        self.tabBar.tintColor = Colours.tabSelected

        statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = Colours.white
        view.addSubview(statusBarView)

        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UITabBar.appearance().layer.borderWidth = 1.0
        UITabBar.appearance().layer.borderColor = Colours.grayDark.cgColor
        
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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cc")
        self.tableView.register(FollowersCell.self, forCellReuseIdentifier: "cellfs")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell00")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell002")
        self.tableViewLists.register(ListCell.self, forCellReuseIdentifier: "cell002l")
        self.tableViewLists.register(ListCell2.self, forCellReuseIdentifier: "cell002l2")
        self.tableViewLists.register(ProCells.self, forCellReuseIdentifier: "colcell2")

        
        self.view0pinch.frame = self.view.frame
        self.view1pinch.frame = self.view.frame
        self.screenshotLabel.frame = (CGRect(x: 40, y: 70, width: self.view.bounds.width - 80, height: 50))
        self.screenshotLabel.text = "Let go to status screenshot"
        self.screenshotLabel.textColor = UIColor.white
        self.screenshotLabel.textAlignment = .center
        self.screenshotLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(Colours.fontSize1))
        self.screenshotLabel.alpha = 0

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchAction(sender:)))
        view.addGestureRecognizer(pinchGesture)

        self.createTabBar()
        self.setupSiri()
        self.delegate = self
        
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
        if UserDefaults.standard.object(forKey: "accessToken") == nil {
            self.createLoginView()
        } else {
            
            StoreStruct.currentInstance.accessToken = UserDefaults.standard.object(forKey: "accessToken") as! String
            StoreStruct.client = Client(
                baseURL: "https://\(StoreStruct.currentInstance.returnedText)",
                accessToken: StoreStruct.currentInstance.accessToken
            )
        }
        
        
        let request = Instances.customEmojis()
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.emotiFace = stat
                StoreStruct.mainResult = []
                StoreStruct.mainResult1 = []
                StoreStruct.mainResult2 = []
                _ = stat.map({
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




    @objc func pinchAction(sender:UIPinchGestureRecognizer) {

        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale


            if sender.state == .began {



                self.identity = self.view1pinch.transform


                if self.doOncePinch == true {
                    UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
                    layer.render(in: UIGraphicsGetCurrentContext()!)
                    self.screenshot = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()

                    if (UserDefaults.standard.object(forKey: "screenshotcol") == nil) || (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 0) {
                        self.view0pinch.backgroundColor = Colours.tabSelected
                    } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 1) {
                        self.view0pinch.backgroundColor = UIColor(red: 53/250, green: 53/250, blue: 64/250, alpha: 1.0)
                    } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 2) {
                        self.view0pinch.backgroundColor = UIColor(red: 36/250, green: 33/250, blue: 37/250, alpha: 1.0)
                    } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 3) {
                        self.view0pinch.backgroundColor = UIColor(red: 0/250, green: 0/250, blue: 0/250, alpha: 1.0)
                    } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 4) {
                        self.view0pinch.backgroundColor = UIColor(red: 18/250, green: 42/250, blue: 111/250, alpha: 1.0)
                    }
                    self.view1pinch.image = self.screenshot
                    self.view1pinch.layer.shadowColor = UIColor.black.cgColor
                    self.view1pinch.layer.shadowOffset = CGSize(width:0, height:5)
                    self.view1pinch.layer.shadowRadius = 12
                    self.view1pinch.layer.shadowOpacity = 0.2


                    if UIDevice().userInterfaceIdiom == .phone {
                        switch UIScreen.main.nativeBounds.height {
                        case 2688:
                            print("iPhone Xs Max")
                            self.view1pinch.layer.cornerRadius = 42
                        case 2436, 1792:
                            print("iPhone X")
                            self.view1pinch.layer.cornerRadius = 42
                        default:
                            self.view1pinch.layer.cornerRadius = 0
                        }
                    }
                    self.view1pinch.layer.masksToBounds = true


                    self.view.addSubview(self.view0pinch)
                    self.view.addSubview(self.view1pinch)
                    self.view0pinch.addSubview(self.screenshotLabel)

                    self.doOncePinch = false
                }

            }
            if sender.state == .changed {
                print(sender.scale)


                if sender.scale < 0.9 {
                    if self.doOnceScreen == true {
                        self.screenshotLabel.transform = CGAffineTransform(translationX: 0, y: -200)
                        springWithDelay(duration: 0.5, delay: 0.0, animations: {
                            self.screenshotLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.screenshotLabel.alpha = 0.6
                        })
                        self.doOnceScreen = false
                    }
                } else {
                    if self.doOnceScreen == false {
                        self.screenshotLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                        springWithDelay(duration: 0.3, delay: 0.0, animations: {
                            self.screenshotLabel.transform = CGAffineTransform(translationX: 0, y: -200)
                            self.screenshotLabel.alpha = 0
                        })
                        self.doOnceScreen = true
                    }
                }


                if sender.scale < 0.8 {

                    if doOnce == true {

                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                        }

//                        if (UserDefaults.standard.object(forKey: "screenshotpinch") as! Int == 0) {
//                            UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
//                        }

                        doOnce = false
                    }


                }


                if sender.scale > 1 {

                } else {
                    DispatchQueue.main.async {
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            self.view1pinch.transform = self.identity.scaledBy(x: sender.scale, y: sender.scale)
                        })
                    }
                }

            }
            if sender.state == .ended {

                DispatchQueue.main.async {
                    springWithCompletion(duration: 0.2, animations: {
                        self.view0pinch.frame = self.view.frame
                        self.view1pinch.frame = self.view.frame
                        if UIDevice().userInterfaceIdiom == .phone {
                            switch UIScreen.main.nativeBounds.height {
                            case 2688:
                                print("iPhone Xs Max")
                                self.view1pinch.layer.cornerRadius = 42
                            case 2436, 1792:
                                print("iPhone X")
                                self.view1pinch.layer.cornerRadius = 42
                            default:
                                self.view1pinch.layer.cornerRadius = 0
                            }
                        }
                    }, completion: { finished in

                        self.view0pinch.removeFromSuperview()
                        self.view1pinch.removeFromSuperview()
                        self.doOnce = true
                        self.doOncePinch = true
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
                        controller.selectedImage1.image = self.screenshot
                        self.present(controller, animated: true, completion: nil)
                    })
                }

            }

    }






    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView {
            return 0
        } else {
            if section == 1 {
                return 0
            } else {
                if tableView == self.tableViewLists {
                    if section == 0 {
                        return 34
                    } else if section == 2 {
                        if StoreStruct.allLists.isEmpty {
                            return 0
                        } else {
                            return 34
                        }
                    } else if section == 3 {
                        if StoreStruct.instanceLocalToAdd.isEmpty {
                            return 0
                        } else {
                            return 34
                        }
                    } else {
                        return 0
                    }
                } else {
                    return 34
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 34)
        let title = UILabel()
        title.frame = CGRect(x: 10, y: 8, width: self.view.bounds.width, height: 26)
        if section == 0 {
            title.text = "Your Accounts"
        } else if section == 2 {
            title.text = "Your Lists"
        } else if section == 3 {
            title.text = "Your Instances"
        }
        title.textColor = UIColor(red: 67/255.0, green: 67/255.0, blue: 75/255.0, alpha: 1.0)
        title.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.grayDark3

        return vw
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return 1
        } else {
            if StoreStruct.instanceLocalToAdd.count > 0 {
                return 3
            } else {
                return 2
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            if self.typeOfSearch == 2 {
                return StoreStruct.statusSearchUser.count
            } else {
                return StoreStruct.statusSearch.count
            }
        } else {
            if section == 0 {
                return 1
            } else if section == 1 {
                return 1
            } else if section == 2 {
                return 0
            } else {
                
                let z1 = Account.getAccounts().count
                let z2 = InstanceData.getAllInstances().count
                
                
                if z1 != z2 {
                    showAccountError()
                    return 0
                }
                
                return StoreStruct.instanceLocalToAdd.count
            }
        }
    }
    
    func showAccountError(){
        
        let alert = UIAlertController(title: "Looks like we encountered an error please log in again", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut"), object: nil)
            case .pad:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "logBackOut"), object: nil)
            default:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut"), object: nil)
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableViewLists {
            if indexPath.section == 0 {
                return 100
            } else {
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            //        if StoreStruct.statusSearch[indexPath.row].mediaAttachments.isEmpty {

            if self.typeOfSearch == 2 {
                if StoreStruct.statusSearchUser.count > 0 {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "cellfs", for: indexPath) as? FollowersCell {
                    cell.configure(StoreStruct.statusSearchUser[indexPath.row])
                    cell.profileImageView.tag = indexPath.row
                    cell.profileImageView.isUserInteractionEnabled = false
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                    cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                        return cell
                    }
                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as? MainFeedCell {
                    cell.profileImageView.tag = indexPath.row
                    cell.profileImageView.isUserInteractionEnabled = false
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                    cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                        return cell
                    }
                }
            } else {

                if StoreStruct.statusSearch.count > 0 {
                    if StoreStruct.statusSearch[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as? MainFeedCell {
                    cell.configure(StoreStruct.statusSearch[indexPath.row])
                    cell.warningB.backgroundColor = Colours.grayDark3
                    cell.moreImage.backgroundColor = Colours.grayDark3
                    cell.rep1.backgroundColor = Colours.grayDark3
                    cell.like1.backgroundColor = Colours.grayDark3
                    cell.boost1.backgroundColor = Colours.grayDark3
                    cell.more1.backgroundColor = Colours.grayDark3
                    cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.userTag.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                        cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                        } else {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                            return cell
                        }
            } else {
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell002", for: indexPath) as? MainFeedCellImage {
                        cell.configure(StoreStruct.statusSearch[indexPath.row])
                        cell.warningB.backgroundColor = Colours.grayDark3
                        cell.moreImage.backgroundColor = Colours.grayDark3
                        cell.rep1.backgroundColor = Colours.grayDark3
                        cell.like1.backgroundColor = Colours.grayDark3
                        cell.boost1.backgroundColor = Colours.grayDark3
                        cell.more1.backgroundColor = Colours.grayDark3
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.userTag.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.backgroundColor = Colours.grayDark3
                        cell.userName.textColor = UIColor.white
                        cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                        cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                        cell.toot.textColor = UIColor.white
                        cell.mainImageView.backgroundColor = Colours.white
                        cell.mainImageViewBG.backgroundColor = Colours.white
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.grayDark3
                        cell.selectedBackgroundView = bgColorView
                        return cell
                        } else {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                            return cell
                        }
                    }
                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as? MainFeedCell {
                    cell.profileImageView.tag = indexPath.row
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                    cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                        return cell
                    }
                }
            }
        } else {
            if indexPath.section == 0 {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "colcell2", for: indexPath) as? ProCells {
                cell.configure()
                cell.backgroundColor = Colours.grayDark3
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                cell.frame.size.width = 60
                cell.frame.size.height = 80
                return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                    return cell
                }
                
            } else if indexPath.section == 1 {
                if let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as? ListCell {
                    cell.userName.text = "Settings"
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = Colours.tabSelected
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                    return cell
                }
            } else if indexPath.section == 2 {
                if let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as? ListCell {
                cell.delegate = self
                cell.configure(StoreStruct.allLists[indexPath.row])
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                    return cell
                }
            } else {
                
                if let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l2", for: indexPath) as? ListCell2 {
                cell.delegate = self
                cell.configure(StoreStruct.instanceLocalToAdd[indexPath.row])
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                    return cell
                }
            }
        }
    }


    @objc func didTouchProfile(sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        
        self.dismissOverlayProperSearch()

        StoreStruct.searchIndex = sender.tag
        if StoreStruct.currentPage == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "searchPro"), object: self)
        } else if StoreStruct.currentPage == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "searchPro2"), object: self)
        } else if StoreStruct.currentPage == 101010 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "searchPro3"), object: self)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "searchPro4"), object: self)
        }
    }

    func members(ind: Int) {
        self.dismissOverlayProper()
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .right else { return nil }
        
        guard indexPath.section > 1 else { return nil }
        
        if indexPath.section == 2 {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)

        let more = SwipeAction(style: .default, title: nil) { action, indexPath in
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                impact.impactOccurred()
            }
            Alertift.actionSheet(title: nil, message: nil)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default("Edit List Name".localized), image: UIImage(named: "list")) { (action, ind) in
                     
                    let controller = NewListViewController()
                    controller.listID = StoreStruct.allLists[indexPath.row].id
                    controller.editListName = StoreStruct.allLists[indexPath.row].title
                    self.present(controller, animated: true, completion: nil)
                }
                .action(.default("View List Members".localized), image: UIImage(named: "profile")) { (action, ind) in
                     
                    StoreStruct.allListRelID = StoreStruct.allLists[indexPath.row].id
                    self.dismissOverlayProper()
                    if StoreStruct.currentPage == 0 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers"), object: self)
                    } else if StoreStruct.currentPage == 1 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers2"), object: self)
                    } else if StoreStruct.currentPage == 101010 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers3"), object: self)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers3"), object: self)
                    }
                }
                .action(.default("Delete List".localized), image: UIImage(named: "block")) { (action, ind) in
                     
                    
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let notification = UINotificationFeedbackGenerator()
                        notification.notificationOccurred(.success)
                    }

                    let statusAlert = StatusAlert()
                    statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                    statusAlert.title = "Deleted".localized
                    statusAlert.tintColor = Colours.grayDark
                    statusAlert.message = StoreStruct.allLists[indexPath.row].title
                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                        statusAlert.show(withOffset: CGFloat(0))
                    }

                    let request = Lists.delete(id: StoreStruct.allLists[indexPath.row].id)
                    StoreStruct.client.run(request) { [weak self] (statuses) in
                        DispatchQueue.main.async {
                            StoreStruct.allLists.remove(at: indexPath.row)
                            self?.tableViewLists.reloadData()
                        }
                    }
                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
                .show(on: self)


            if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                cell.hideSwipe(animated: true)
            }
        }
        more.backgroundColor = Colours.grayDark3
        more.image = UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected)
        more.transitionDelegate = ScaleTransition.default
        more.textColor = Colours.tabUnselected
        return [more]



        } else if indexPath.section == 1 {
            let impact = UIImpactFeedbackGenerator(style: .medium)

            let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    impact.impactOccurred()
                }
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Remove".localized), image: UIImage(named: "block")) { (action, ind) in
                         
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }

                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Removed".localized
                        statusAlert.tintColor = Colours.grayDark
                        statusAlert.message = StoreStruct.allLists[indexPath.row].title
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show(withOffset: CGFloat(0))
                        }

                        let request = Lists.delete(id: StoreStruct.allLists[indexPath.row].id)
                        StoreStruct.client.run(request) {[weak self] (statuses) in
                            DispatchQueue.main.async {
                                StoreStruct.allLists.remove(at: indexPath.row)
                                self?.tableViewLists.reloadData()
                            }
                        }
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .show(on: self)


                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.grayDark3
            more.image = UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected)
            more.transitionDelegate = ScaleTransition.default
            more.textColor = Colours.tabUnselected
            return [more]


        } else {



            let impact = UIImpactFeedbackGenerator(style: .medium)

            let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    impact.impactOccurred()
                }
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Remove".localized), image: UIImage(named: "block")) { (action, ind) in
                         
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }

                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Removed".localized
                        statusAlert.tintColor = Colours.grayDark
                        statusAlert.message = StoreStruct.instanceLocalToAdd[indexPath.row]
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                        statusAlert.show(withOffset: CGFloat(0))
                    }

                        StoreStruct.instanceLocalToAdd.remove(at: indexPath.row)
                        UserDefaults.standard.set(StoreStruct.instanceLocalToAdd, forKey: "instancesLocal")
                        //cbackhere
                        self.tableViewLists.reloadData()
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .show(on: self)


                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.grayDark3
            more.image = UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected)
            more.transitionDelegate = ScaleTransition.default
            more.textColor = Colours.tabUnselected
            return [more]


        }
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        options.buttonSpacing = 0
        options.buttonPadding = 0
        options.maximumButtonWidth = 60
        options.backgroundColor = Colours.grayDark3
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            self.dismissOverlayProperSearch()

            if self.typeOfSearch == 2 {
                StoreStruct.searchIndex = indexPath.row
                if StoreStruct.currentPage == 0 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser"), object: self)
                } else if StoreStruct.currentPage == 1 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser2"), object: self)
                } else if StoreStruct.currentPage == 101010 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser3"), object: self)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser4"), object: self)
                }
            } else {
                StoreStruct.searchIndex = indexPath.row
                if StoreStruct.currentPage == 0 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "search"), object: self)
                } else if StoreStruct.currentPage == 1 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "search2"), object: self)
                } else if StoreStruct.currentPage == 101010 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "search3"), object: self)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "search4"), object: self)
                }
            }

        } else {
            self.dismissOverlayProper()

            if indexPath.section == 0 {

            } else if indexPath.section == 1 {
               
                // go to settings
                if StoreStruct.currentPage == 0 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goToSettings"), object: self)
                } else if StoreStruct.currentPage == 1 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goToSettings2"), object: self)
                } else if StoreStruct.currentPage == 101010 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goToSettings3"), object: self)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goToSettings4"), object: self)
                }
            } else if indexPath.section == 2 {

                // go to list
                StoreStruct.currentList = []
                let request = Lists.accounts(id: StoreStruct.allLists[indexPath.row].id)
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        stat.map({
                            let request1 = Accounts.statuses(id: $0.id)
                            StoreStruct.client.run(request1) { (statuses) in
                                if let stat = (statuses.value) {
                                    StoreStruct.currentList = StoreStruct.currentList + stat
                                    StoreStruct.currentList = StoreStruct.currentList.sorted(by: { $0.createdAt > $1.createdAt })
                                    StoreStruct.currentListTitle = StoreStruct.allLists[indexPath.row].title
                                    StoreStruct.currentListIID = StoreStruct.allLists[indexPath.row].id
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                                }
                            }
                        })
                        if StoreStruct.currentPage == 0 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists"), object: self)
                        } else if StoreStruct.currentPage == 1 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists2"), object: self)
                        } else if StoreStruct.currentPage == 101010 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists3"), object: self)
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists4"), object: self)
                        }
                    }
                }


            } else {

                if (UserDefaults.standard.object(forKey: "instancesLocal") == nil) {

                } else {
                    StoreStruct.instanceLocalToAdd = UserDefaults.standard.object(forKey: "instancesLocal") as! [String]
                    StoreStruct.instanceText = StoreStruct.instanceLocalToAdd[indexPath.row]
                }

                if StoreStruct.currentPage == 0 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance"), object: self)
                } else if StoreStruct.currentPage == 1 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance2"), object: self)
                } else if StoreStruct.currentPage == 101010 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance3"), object: self)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance4"), object: self)
                }


            }

        }
    }



    @objc func themeTopStuff() {
        self.tabBar.tintColor = Colours.tabSelected
    }


    @objc func longAction(sender: UILongPressGestureRecognizer) {

        if (UserDefaults.standard.object(forKey: "longToggle") == nil) || (UserDefaults.standard.object(forKey: "longToggle") as! Int == 0) {


        if sender.state == .began {
            
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UIImpactFeedbackGenerator(style: .light)
            selection.impactOccurred()
            }

            var newNum = 0
            if UserDefaults.standard.object(forKey: "theme") == nil {
                newNum = 1
                UIApplication.shared.statusBarStyle = .lightContent
                Colours.keyCol = UIKeyboardAppearance.dark
            } else {
                let z = UserDefaults.standard.object(forKey: "theme") as! Int
                if z == 0 {
                    newNum = 1
                    UIApplication.shared.statusBarStyle = .lightContent
                    Colours.keyCol = UIKeyboardAppearance.dark
                }
                if z == 1 {
                    newNum = 2
                    UIApplication.shared.statusBarStyle = .lightContent
                    Colours.keyCol = UIKeyboardAppearance.dark
                }
                if z == 2 {
                    newNum = 3
                    UIApplication.shared.statusBarStyle = .lightContent
                    Colours.keyCol = UIKeyboardAppearance.dark
                }
                if z == 3 {
                    newNum = 4
                    UIApplication.shared.statusBarStyle = .lightContent
                    Colours.keyCol = UIKeyboardAppearance.dark
                }
                if z == 4 {
                    newNum = 0
                    UIApplication.shared.statusBarStyle = .default
                    Colours.keyCol = UIKeyboardAppearance.light
                }
            }

            UserDefaults.standard.set(newNum, forKey: "theme")

            DispatchQueue.main.async {

                self.firstView.loadLoadLoad()
                self.secondView.loadLoadLoad()
                self.dmView.loadLoadLoad()
                self.thirdView.loadLoadLoad()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

                self.view.backgroundColor = Colours.white
                self.navigationController?.navigationBar.backgroundColor = Colours.white
                self.navigationController?.navigationBar.tintColor = Colours.white

                self.tabBar.barTintColor = Colours.white
                self.tabBar.backgroundColor = Colours.white
                self.tabBar.unselectedItemTintColor = Colours.grayDark.withAlphaComponent(0.21)
                self.tabBar.tintColor = Colours.tabSelected

                self.firstView.view.backgroundColor = Colours.white
                self.secondView.view.backgroundColor = Colours.white
                self.dmView.view.backgroundColor = Colours.white
                self.thirdView.view.backgroundColor = Colours.white
                self.fourthView.view.backgroundColor = Colours.white

                self.tabOne.navigationBar.backgroundColor = Colours.white
                self.tabOne.navigationBar.barTintColor = Colours.white
                self.tabTwo.navigationBar.backgroundColor = Colours.white
                self.tabTwo.navigationBar.barTintColor = Colours.white
                self.tabDM.navigationBar.backgroundColor = Colours.white
                self.tabDM.navigationBar.barTintColor = Colours.white
                self.tabThree.navigationBar.backgroundColor = Colours.white
                self.tabThree.navigationBar.barTintColor = Colours.white
                self.tabFour.navigationBar.backgroundColor = Colours.white
                self.tabFour.navigationBar.barTintColor = Colours.white

                self.statusBarView.backgroundColor = Colours.white

        }
        }

        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 1) {
            //cback2
            if sender.state == .began {
            self.tList()
            }
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 2) {

            if sender.state == .began {
//            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                let imp = UIImpactFeedbackGenerator(style: .light)
//                imp.impactOccurred()
//            }
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
                self.tSearch()
            }
        }
    }








    @objc func themeLight() {

                UIApplication.shared.statusBarStyle = .default
                Colours.keyCol = UIKeyboardAppearance.light
            UserDefaults.standard.set(0, forKey: "theme")

            DispatchQueue.main.async {

                self.firstView.loadLoadLoad()
                self.secondView.loadLoadLoad()
                self.dmView.loadLoadLoad()
                self.thirdView.loadLoadLoad()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

                self.view.backgroundColor = Colours.white
                self.navigationController?.navigationBar.backgroundColor = Colours.white
                self.navigationController?.navigationBar.tintColor = Colours.white

                self.tabBar.barTintColor = Colours.white
                self.tabBar.backgroundColor = Colours.white
                self.tabBar.unselectedItemTintColor = Colours.grayDark.withAlphaComponent(0.21)
                self.tabBar.tintColor = Colours.tabSelected

                self.firstView.view.backgroundColor = Colours.white
                self.secondView.view.backgroundColor = Colours.white
                self.dmView.view.backgroundColor = Colours.white
                self.thirdView.view.backgroundColor = Colours.white
                self.fourthView.view.backgroundColor = Colours.white

                self.tabOne.navigationBar.backgroundColor = Colours.white
                self.tabOne.navigationBar.barTintColor = Colours.white
                self.tabTwo.navigationBar.backgroundColor = Colours.white
                self.tabTwo.navigationBar.barTintColor = Colours.white
                self.tabDM.navigationBar.backgroundColor = Colours.white
                self.tabDM.navigationBar.barTintColor = Colours.white
                self.tabThree.navigationBar.backgroundColor = Colours.white
                self.tabThree.navigationBar.barTintColor = Colours.white
                self.tabFour.navigationBar.backgroundColor = Colours.white
                self.tabFour.navigationBar.barTintColor = Colours.white

                self.statusBarView.backgroundColor = Colours.white

            }
    }

    @objc func themeNight() {

            UIApplication.shared.statusBarStyle = .lightContent
            Colours.keyCol = UIKeyboardAppearance.dark

        UserDefaults.standard.set(1, forKey: "theme")

        DispatchQueue.main.async {

            self.firstView.loadLoadLoad()
            self.secondView.loadLoadLoad()
            self.dmView.loadLoadLoad()
            self.thirdView.loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.white

            self.tabBar.barTintColor = Colours.white
            self.tabBar.backgroundColor = Colours.white
            self.tabBar.unselectedItemTintColor = Colours.grayDark.withAlphaComponent(0.21)
            self.tabBar.tintColor = Colours.tabSelected

            self.firstView.view.backgroundColor = Colours.white
            self.secondView.view.backgroundColor = Colours.white
            self.dmView.view.backgroundColor = Colours.white
            self.thirdView.view.backgroundColor = Colours.white
            self.fourthView.view.backgroundColor = Colours.white

            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
            self.tabDM.navigationBar.backgroundColor = Colours.white
            self.tabDM.navigationBar.barTintColor = Colours.white
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white

            self.statusBarView.backgroundColor = Colours.white

        }
    }

    @objc func themeNight2() {

        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark

        UserDefaults.standard.set(2, forKey: "theme")

        DispatchQueue.main.async {

            self.firstView.loadLoadLoad()
            self.secondView.loadLoadLoad()
            self.dmView.loadLoadLoad()
            self.thirdView.loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.white

            self.tabBar.barTintColor = Colours.white
            self.tabBar.backgroundColor = Colours.white
            self.tabBar.unselectedItemTintColor = Colours.grayDark.withAlphaComponent(0.21)
            self.tabBar.tintColor = Colours.tabSelected

            self.firstView.view.backgroundColor = Colours.white
            self.secondView.view.backgroundColor = Colours.white
            self.dmView.view.backgroundColor = Colours.white
            self.thirdView.view.backgroundColor = Colours.white
            self.fourthView.view.backgroundColor = Colours.white

            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
            self.tabDM.navigationBar.backgroundColor = Colours.white
            self.tabDM.navigationBar.barTintColor = Colours.white
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white

            self.statusBarView.backgroundColor = Colours.white

        }
    }

    @objc func themeBlack() {

        UIApplication.shared.statusBarStyle = .lightContent
                Colours.keyCol = UIKeyboardAppearance.dark

        UserDefaults.standard.set(3, forKey: "theme")

        DispatchQueue.main.async {

            self.firstView.loadLoadLoad()
            self.secondView.loadLoadLoad()
            self.dmView.loadLoadLoad()
            self.thirdView.loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.white

            self.tabBar.barTintColor = Colours.white
            self.tabBar.backgroundColor = Colours.white
            self.tabBar.unselectedItemTintColor = Colours.grayDark.withAlphaComponent(0.21)
            self.tabBar.tintColor = Colours.tabSelected

            self.firstView.view.backgroundColor = Colours.white
            self.secondView.view.backgroundColor = Colours.white
            self.dmView.view.backgroundColor = Colours.white
            self.thirdView.view.backgroundColor = Colours.white
            self.fourthView.view.backgroundColor = Colours.white

            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
            self.tabDM.navigationBar.backgroundColor = Colours.white
            self.tabDM.navigationBar.barTintColor = Colours.white
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white

            self.statusBarView.backgroundColor = Colours.white

        }
    }


    @objc func midBlue() {

        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark

        UserDefaults.standard.set(4, forKey: "theme")

        DispatchQueue.main.async {

            self.firstView.loadLoadLoad()
            self.secondView.loadLoadLoad()
            self.dmView.loadLoadLoad()
            self.thirdView.loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.white

            self.tabBar.barTintColor = Colours.white
            self.tabBar.backgroundColor = Colours.white
            self.tabBar.unselectedItemTintColor = Colours.grayDark.withAlphaComponent(0.21)
            self.tabBar.tintColor = Colours.tabSelected

            self.firstView.view.backgroundColor = Colours.white
            self.secondView.view.backgroundColor = Colours.white
            self.dmView.view.backgroundColor = Colours.white
            self.thirdView.view.backgroundColor = Colours.white
            self.fourthView.view.backgroundColor = Colours.white

            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
            self.tabDM.navigationBar.backgroundColor = Colours.white
            self.tabDM.navigationBar.barTintColor = Colours.white
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white

            self.statusBarView.backgroundColor = Colours.white

        }
    }


    @objc func signOutNewInstance() {
        DispatchQueue.main.async {
            let loginController = ViewController()
            loginController.loadingAdditionalInstance = true
            loginController.createLoginView(newInstance: true)
            self.present(loginController, animated: true, completion: {
                loginController.textField.becomeFirstResponder()
            })
        }
    }


    //bh9
    @objc func signOut() {

        UserDefaults.standard.set(nil, forKey: "accessToken")
        
        self.textField.text = ""

        StoreStruct.client = Client(baseURL: "")
        StoreStruct.currentInstance.redirect = ""
        StoreStruct.currentInstance.returnedText = ""
        StoreStruct.currentInstance.clientID = ""
        StoreStruct.currentInstance.clientSecret = ""
        StoreStruct.currentInstance.authCode = ""
        StoreStruct.currentInstance.accessToken = ""
        StoreStruct.currentPage = 0
        StoreStruct.playerID = ""

        StoreStruct.caption1 = ""
        StoreStruct.caption2 = ""
        StoreStruct.caption3 = ""
        StoreStruct.caption4 = ""

        StoreStruct.emotiSize = 16
        StoreStruct.emotiFace = []
        StoreStruct.mainResult = []
        StoreStruct.mainResult1 = []
        StoreStruct.mainResult2 = []
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

        InstanceData.clearInstances()
        Account.clearAccounts()
        self.createLoginView()


    }



    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            print("Swipe Down")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTouchUpInsideCloseButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func createLoginView(newInstance: Bool = false) {
        self.newInstance = newInstance
        self.loginBG.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.loginBG.backgroundColor = Colours.tabSelected
        self.view.addSubview(self.loginBG)
        
        if self.newInstance {
            var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
            var offset = 88
            var closeB = 47
            var botbot = 20
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2688:
                    offset = 88
                    closeB = 47
                    botbot = 40
                case 2436, 1792:
                    offset = 88
                    closeB = 47
                    botbot = 40
                default:
                    offset = 64
                    closeB = 24
                    botbot = 20
                    tabHeight = Int(UITabBarController().tabBar.frame.size.height)
                }
            }
            self.closeButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 15, y: closeB, width: 32, height: 32)))
            self.closeButton.setImage(UIImage(named: "block")?.maskWithColor(color: Colours.grayLight2), for: .normal)
            self.closeButton.alpha = 0.3
            self.closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.closeButton.adjustsImageWhenHighlighted = false
            self.closeButton.addTarget(self, action: #selector(didTouchUpInsideCloseButton), for: .touchUpInside)
            self.view.addSubview(self.closeButton)
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.loginBG.addGestureRecognizer(swipeDown)

        self.loginLogo.frame = CGRect(x: self.view.bounds.width/2 - 40, y: self.view.bounds.height/4 - 40, width: 80, height: 80)
        self.loginLogo.image = UIImage(named: "logLogo")
        self.loginLogo.contentMode = .scaleAspectFit
        self.loginLogo.backgroundColor = UIColor.clear
        self.view.addSubview(self.loginLogo)

        self.loginLabel.frame = CGRect(x: 50, y: self.view.bounds.height/2 - 57.5, width: self.view.bounds.width - 80, height: 35)
        self.loginLabel.text = "Instance name:".localized
        self.loginLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        self.loginLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(self.loginLabel)

        self.textField.frame = CGRect(x: 40, y: self.view.bounds.height/2 - 22.5, width: self.view.bounds.width - 80, height: 45)
        self.textField.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        self.textField.borderStyle = .none
        self.textField.layer.cornerRadius = 10
        self.textField.textColor = UIColor.white
        self.textField.spellCheckingType = .no
        self.textField.returnKeyType = .done
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.textField.delegate = self
        self.textField.attributedPlaceholder = NSAttributedString(string: "mastodon.social",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: Colours.tabSelected])
        self.view.addSubview(self.textField)
        
        
        self.termsButton.frame = CGRect(x: 40, y: textField.frame.origin.y + 200, width: self.view.bounds.width - 80, height: 50)
        self.termsButton.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        self.termsButton.layer.cornerRadius = 10
        self.termsButton.tintColor = UIColor.white.withAlphaComponent(0.6)
        self.termsButton.titleLabel?.numberOfLines = 0
        self.termsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.termsButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.termsButton.setTitle("By using Roma you agree to our Terms of Service. Tap to review them.", for: .normal)
        self.termsButton.addTarget(self, action: #selector(self.showTerms), for: .touchUpInside)
        self.view.addSubview(self.termsButton)
        
        tagListView.alpha = 0
        tagListView.frame = CGRect(x: 0, y: Int(self.view.bounds.height) - self.keyHeight - 70, width: Int(self.view.bounds.width), height: 60)
        self.view.addSubview(tagListView)
        
        let urlStr = "https://instances.social/api/1.0/instances/list?count=\(100)&include_closed=\(false)&include_down=\(false)"
        let url: URL = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer 8gVQzoU62VFjvlrdnBUyAW8slAekA5uyuwdMi0CBzwfWwyStkqQo80jTZemuSGO8QomSycdD1JYgdRUnJH0OVT3uYYUilPMenrRZupuMQLl9hVt6xnhV6bwdXVSAT1wR", forHTTPHeaderField: "Authorization")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: request) { (data, response, err) in
            do {
                let json = try JSONDecoder().decode(tagInstances.self, from: data ?? Data())
                for x in json.instances {
                    DispatchQueue.main.async {
                        var tag = DLTag(text: "\(x.name)")
                        tag.fontSize = 15
                        tag.backgroundColor = Colours.grayLight2.withAlphaComponent(0.3)
                        tag.borderWidth = 0
                        tag.textColor = UIColor.white
                        tag.cornerRadius = 12
                        tag.enabled = true
                        tag.altText = "\(x.name)"
                        tag.padding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
                        self.tagListView.addTag(tag: tag)
                        self.tagListView.singleLine = true
                    }
                }
            } catch {
                print("err")
            }
        }
        task.resume()
    }

    @objc func showTerms(){
        let termsController = TermsController()
        let navigationController = UINavigationController(rootViewController: termsController)
        self.present(navigationController, animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }

        let wid = self.view.bounds.width - 20
        let he = Int(self.view.bounds.height) - fromTop - fromTop


        springWithDelay(duration: 0.75, delay: 0.02, animations: {
            self.textField.transform = CGAffineTransform(translationX: 0, y: -40)
        })
        springWithDelay(duration: 0.6, delay: 0, animations: {
            self.loginLabel.transform = CGAffineTransform(translationX: 0, y: -40)
        })

        if textField.text == "" {} else {
        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
        })
        self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
        })
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == self.searchTextField {

            var fromTop = 45
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2688:
                    print("iPhone Xs Max")
                    fromTop = 45
                case 2436, 1792:
                    print("iPhone X")
                    fromTop = 45
                default:
                    fromTop = 22
                }
            }

            let wid = self.view.bounds.width - 20
            let he = Int(self.view.bounds.height) - fromTop - fromTop

            textField.resignFirstResponder()

            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
            springWithDelay(duration: 0.5, delay: 0, animations: {
                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
            })
            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
            springWithDelay(duration: 0.5, delay: 0, animations: {
                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
            })

            return true


        } else {

        let returnedText = textField.text ?? ""
        if returnedText == "" || returnedText == " " || returnedText == "  " {

        } else {


            DispatchQueue.main.async {
                self.textField.resignFirstResponder()
            
            
            // Send off returnedText to client
            if self.newInstance {
                
                StoreStruct.newInstance = InstanceData()
                StoreStruct.newClient = Client(baseURL: "https://\(returnedText)")
                let request = Clients.register(
                    clientName: "Roma",
                    redirectURI: "com.vm.roma://addNewInstance",
                    scopes: [.read, .write, .follow, .push],
                    website: "https://pleroma.com"
                )
                StoreStruct.newClient.run(request) { (application) in
                    
//                    DispatchQueue.main.async {
                    
                    if application.value == nil {

                        DispatchQueue.main.async {
                            
                            
                            Alertift.actionSheet(title: "Not a valid instance (may be closed or dead)", message: "Please enter an instance name like mastodon.social or mastodon.technology, or use one from the list to get started. You can sign in if you already have an account registered with the instance, or you can choose to sign up with a new account.")
                                .backgroundColor(Colours.white)
                                .titleTextColor(Colours.grayDark)
                                .messageTextColor(Colours.grayDark)
                                .messageTextAlignment(.left)
                                .titleTextAlignment(.left)
                                .action(.default("Find out more".localized), image: UIImage(named: "share")) { (action, ind) in
                                     
                                    let queryURL = URL(string: "https://joinmastodon.org")!
                                    UIApplication.shared.open(queryURL, options: [.universalLinksOnly: true]) { (success) in
                                        if !success {
                                            if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                            self.safariVC = SFSafariViewController(url: queryURL)
                                            self.present(self.safariVC!, animated: true, completion: nil)
                                            } else {
                                                UIApplication.shared.open(queryURL)
                                            }
                                            
                                        }
                                    }
                                }
                                .action(.cancel("Dismiss"))
                                .finally { action, index in
                                    if action.style == .cancel {
                                        return
                                    }
                                }
                                .popover(anchorView: self.view)
                                .show(on: self)
                            
                            
                        }

                    } else {
                        
                        
                        
                        let application = application.value!
                        
                        StoreStruct.newInstance?.clientID = application.clientID
                        StoreStruct.newInstance?.clientSecret = application.clientSecret
                        StoreStruct.newInstance?.returnedText = returnedText
                        
                        DispatchQueue.main.async {
                            StoreStruct.newInstance?.redirect = "com.vm.roma://addNewInstance".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                            let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.newInstance!.redirect)&scope=read%20write%20follow%20push&client_id=\(application.clientID)")!
                            UIApplication.shared.open(queryURL, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: queryURL)
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(queryURL)
                                    }
                                }
                            }
                        }
                    }
//                    }
                }
            } else {
                StoreStruct.client = Client(baseURL: "https://\(returnedText)")
                let request = Clients.register(
                    clientName: "Roma",
                    redirectURI: "com.vm.roma://success",
                    scopes: [.read, .write, .follow, .push],
                    website: "https://pleroma.com"
                )
                StoreStruct.client.run(request) { [weak self] (application) in
                    
                    
                    guard let ref = self else {
                        return
                    }
//                    DispatchQueue.main.async {
                    if application.value == nil {

                        DispatchQueue.main.async {
                            
                            
                            Alertift.actionSheet(title: "Not a valid instance (may be closed or dead)", message: "Please enter an instance name like mastodon.social or mastodon.technology, or use one from the list to get started. You can sign in if you already have an account registered with the instance, or you can choose to sign up with a new account.")
                                .backgroundColor(Colours.white)
                                .titleTextColor(Colours.grayDark)
                                .messageTextColor(Colours.grayDark)
                                .messageTextAlignment(.left)
                                .titleTextAlignment(.left)
                                .action(.default("Find out more".localized), image: UIImage(named: "share")) { (action, ind) in
                                     
                                    let queryURL = URL(string: "https://joinmastodon.org")!
                                    UIApplication.shared.open(queryURL, options: [.universalLinksOnly: true]) { (success) in
                                        if !success {
                                            if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                            ref.safariVC = SFSafariViewController(url: queryURL)
                                            ref.present(ref.safariVC!, animated: true, completion: nil)
                                            } else {
                                                UIApplication.shared.openURL(queryURL)
                                            }
                                        }
                                    }
                                }
                                .action(.cancel("Dismiss"))
                                .finally { action, index in
                                    if action.style == .cancel {
                                        return
                                    }
                                }
                                .popover(anchorView: ref.view)
                                .show(on: ref)
                            
                        }

                    } else {
                        let application = application.value!
                        
                        StoreStruct.currentInstance.clientID = application.clientID
                        StoreStruct.currentInstance.clientSecret = application.clientSecret
                        StoreStruct.currentInstance.returnedText = returnedText
                        
                        DispatchQueue.main.async {
                            
                            ref.tagListView.alpha = 0
                            
                            StoreStruct.currentInstance.redirect = "com.vm.roma://success".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                            let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.currentInstance.redirect)&scope=read%20write%20follow%20push&client_id=\(application.clientID)")!
                            UIApplication.shared.open(queryURL, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    ref.safariVC = SFSafariViewController(url: queryURL)
                                    ref.present(ref.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(queryURL)
                                    }
                                }
                            }
                        }
                    }
//                    }
                }
                }
            }



        }
        return true

        }
    }

    func runCurrentClient(){

    }

    func runNewCleint(){

    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyHeight = Int(keyboardHeight)
            self.tagListView.frame = CGRect(x: 0, y: Int(self.view.bounds.height) - self.keyHeight - 70, width: Int(self.view.bounds.width), height: 60)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.keyHeight = Int(0)
        self.tagListView.frame = CGRect(x: 0, y: Int(self.view.bounds.height) - self.keyHeight - 70, width: Int(self.view.bounds.width), height: 60)
    }
    
    
    @objc func setUpProfileImage(){
        if StoreStruct.currentUser != nil {
            self.settingsButton.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatarStatic)"))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // super.viewDidAppear(animated)
        
//        if StoreStruct.currentUser == nil {
            let request2 = Accounts.currentUser()
            StoreStruct.client.run(request2) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.currentUser = stat
                    
                    let request9 = Accounts.statuses(id: stat.id, mediaOnly: false, pinnedOnly: false, excludeReplies: true, excludeReblogs: true, range: .default)
                    StoreStruct.client.run(request9) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.profileStatuses0 = stat
                            
                            NotificationCenter.default.post(name: NSNotification.Name("setUpProfileImage"), object: nil)
                            
                            let request = Accounts.statuses(id: StoreStruct.currentUser.id, mediaOnly: true, pinnedOnly: nil, excludeReplies: nil, excludeReblogs: true, range: .default)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    StoreStruct.profileStatusesHasImage0 = stat
                                }
                            }
                        }
                    }
                    
                }
            }
//        } else {
//            let request9 = Accounts.statuses(id: StoreStruct.currentUser.id, mediaOnly: false, pinnedOnly: false, excludeReplies: true, excludeReblogs: true, range: .default)
//            StoreStruct.client.run(request9) { (statuses) in
//                if let stat = (statuses.value) {
//                    StoreStruct.profileStatuses0 = stat
//
//                    let request = Accounts.statuses(id: StoreStruct.currentUser.id, mediaOnly: true, pinnedOnly: nil, excludeReplies: nil, excludeReblogs: true, range: .default)
//                    StoreStruct.client.run(request) { (statuses) in
//                        if let stat = (statuses.value) {
//                            StoreStruct.profileStatusesHasImage0 = stat
//                        }
//                    }
//                }
//            }
//        }
        
        let request0 = Lists.all()
        StoreStruct.client.run(request0) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.allLists = stat
                DispatchQueue.main.async {
                    self.tableViewLists.reloadData()
                }
            }
        }
        
        let request8 = FilterToots.all()
        StoreStruct.client.run(request8) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.allCurrentFilters = stat
            }
        }

        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            UIApplication.shared.statusBarStyle = .default
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        if let userDefaults = UserDefaults(suiteName: "group.com.vm.roma.wormhole") {
            userDefaults.set(StoreStruct.currentInstance.accessToken, forKey: "key1")
            userDefaults.set(StoreStruct.currentInstance.returnedText, forKey: "key2")
            userDefaults.synchronize()
        }
        
        if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
            if self.dStream == false {
                self.streamDataDirect()
            }
        }
        
//        if UserDefaults.standard.object(forKey: "accessToken") == nil {} else {
//            self.watchSession?.delegate = self
//            self.watchSession?.activate()
//            do {
//                try self.watchSession?.updateApplicationContext(applicationContext)
//                self.watchSession?.transferUserInfo(applicationContext)
//            } catch {
//                print("err")
//            }
//        }
    }

    func checkAccounts(){

        if InstanceData.getAllInstances().count != Account.getAccounts().count {
            Account.clearAccounts()
            getAccount(currentIndex: 0)
        }

    }

    func getAccount(currentIndex:Int){

        if currentIndex >= InstanceData.getAllInstances().count {
            return
        }

        let instance = InstanceData.getAllInstances()[currentIndex]
        let accountClient = Client(baseURL: "https://\(instance.returnedText)", accessToken: instance.accessToken, session: .shared)
        let accountRequest = Accounts.currentUser()
        accountClient.run(accountRequest) { (account) in
            print("THIS IS THE STATUS \(account)")
            print(account.error?.localizedDescription)
            if let stat = (account.value) {
                Account.addAccountToList(account: stat)
                let nextIndex = currentIndex + 1
                self.getAccount(currentIndex: nextIndex)
            }
        }


    }

    @objc func touchList() {
        self.tList()
    }

    func tList() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let imp = UIImpactFeedbackGenerator(style: .light)
            imp.impactOccurred()
        }

        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }

        self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.alpha = 0.1
        self.backgroundView.addTarget(self, action: #selector(self.dismissOverlay), for: .touchUpInside)
        self.view.addSubview(self.backgroundView)

        let wid = self.view.bounds.width - 20
        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 60)
        self.searcherView.backgroundColor = Colours.grayDark3
        self.searcherView.layer.cornerRadius = 20
        self.searcherView.alpha = 0
        self.searcherView.layer.masksToBounds = true
        self.view.addSubview(self.searcherView)

        //table


        self.tableViewLists.frame = CGRect(x: 0, y: 0, width: Int(wid), height: Int(0))
        self.tableViewLists.alpha = 0
        self.tableViewLists.delegate = self
        self.tableViewLists.dataSource = self
        self.tableViewLists.separatorStyle = .singleLine
        self.tableViewLists.backgroundColor = Colours.grayDark3
        self.tableViewLists.separatorColor = UIColor(red: 50/250, green: 53/250, blue: 63/250, alpha: 1.0)
        self.tableViewLists.layer.masksToBounds = true
        self.tableViewLists.estimatedRowHeight = UITableView.automaticDimension
        self.tableViewLists.rowHeight = UITableView.automaticDimension
        self.searcherView.addSubview(self.tableViewLists)


        self.tableViewLists.reloadData()

        //animate
        self.searcherView.transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.searcherView.alpha = 1
            self.searcherView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })

        var maxHe = (Int(52) * Int(StoreStruct.allLists.count + 3)) + (Int(52) * Int(StoreStruct.instanceLocalToAdd.count))
        if maxHe > 364 {
            maxHe = Int(364)
        }
        maxHe += 134

        if StoreStruct.instanceLocalToAdd.count > 0 {
            maxHe += 34
        }
        if StoreStruct.allLists.count > 0 {
            maxHe += 34
        }

        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 60)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.searcherView.alpha = 1
            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: maxHe)
        })
        self.tableViewLists.frame = CGRect(x: 0, y: 0, width: Int(wid), height: Int(0))
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.tableViewLists.alpha = 1
            self.tableViewLists.frame = CGRect(x: 0, y: 0, width: Int(wid), height: maxHe)
        })
    }


    @objc func didTouchSearch() {
        self.tSearch()
    }

    func tSearch() {

        self.tableViewLists.alpha = 0

        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let imp = UIImpactFeedbackGenerator(style: .light)
            imp.impactOccurred()
        }

        self.typeOfSearch = 0

        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }

        self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.alpha = 0.1
        self.backgroundView.addTarget(self, action: #selector(self.dismissOverlaySearch), for: .touchUpInside)
        self.view.addSubview(self.backgroundView)

        let wid = self.view.bounds.width - 20
        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 120)
        self.searcherView.backgroundColor = Colours.grayDark3
        self.searcherView.layer.cornerRadius = 20
        self.searcherView.alpha = 0
        self.searcherView.layer.masksToBounds = true
        self.view.addSubview(self.searcherView)

        //text field
        
        searchTextField.frame = CGRect(x: 0, y: 10, width: Int(Int(wid) - 20), height: 40)
        searchTextField.backgroundColor = Colours.grayDark3
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.layer.cornerRadius = 10
        searchTextField.alpha = 1
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...".localized,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 67/255.0, green: 67/255.0, blue: 75/255.0, alpha: 1.0)])
        searchTextField.becomeFirstResponder()
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.textColor = UIColor.white
        searchTextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.searcherView.addSubview(searchTextField)

        self.searchIcon.frame = CGRect(x: 15, y: 10, width: 20, height: 20)
        self.searchIcon.backgroundColor = UIColor.clear
        self.searchIcon.image = UIImage(named: "search")?.maskWithColor(color: UIColor(red: 67/255.0, green: 67/255.0, blue: 75/255.0, alpha: 1.0))
        self.searchTextField.addSubview(self.searchIcon)

        segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: 20, y: 60, width: Int(wid - 40), height: Int(40)))
        segmentedControl.dataSource = self
        segmentedControl.shapeStyle = .roundedRect
        segmentedControl.textFont = .systemFont(ofSize: 15, weight: .heavy)
        segmentedControl.cornerRadius = 12
        segmentedControl.shadowsEnabled = false
        segmentedControl.transitionStyle = .slide
        segmentedControl.delegate = self
        self.searcherView.addSubview(segmentedControl)

        //table

        self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(0))
        self.tableView.alpha = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.grayDark3
        self.tableView.separatorColor = UIColor(red: 50/250, green: 53/250, blue: 63/250, alpha: 1.0)
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.searcherView.addSubview(self.tableView)

        //animate
        self.searcherView.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
        springWithDelay(duration: 0.45, delay: 0, animations: {
            self.searcherView.alpha = 1
            self.searcherView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }



    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 3
    }

    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        if index == 0 {
            return "Hashtags".localized
        } else if index == 1 {
            return "Related".localized
        } else {
            return "Users".localized
        }
    }

    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        if (UserDefaults.standard.object(forKey: "seghue1") == nil) || (UserDefaults.standard.object(forKey: "seghue1") as! Int == 0) {
            return [Colours.tabSelected, Colours.tabSelected]
        } else if (UserDefaults.standard.object(forKey: "seghue1") as! Int == 1) {
            return [Colours.grayLight2, Colours.grayLight2]
        } else {
            return [Colours.clear, Colours.clear]
        }
    }

    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForBounce bounce: SJFluidSegmentedControlBounce) -> [UIColor] {
        if (UserDefaults.standard.object(forKey: "seghue1") == nil) || (UserDefaults.standard.object(forKey: "seghue1") as! Int == 0) {
            return [Colours.tabSelected, Colours.tabSelected]
        } else if (UserDefaults.standard.object(forKey: "seghue1") as! Int == 1) {
            return [Colours.grayLight2, Colours.grayLight2]
        } else {
            return [Colours.clear, Colours.clear]
        }
    }

    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didChangeFromSegmentAtIndex fromIndex: Int, toSegmentAtIndex toIndex: Int) {

        if toIndex == 0 {
            self.typeOfSearch = 0
            let request = Timelines.tag(self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.statusSearch = stat
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }
        if toIndex == 1 {
            self.typeOfSearch = 1
            let request = Search.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.statusSearch = stat.statuses
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }
        if toIndex == 2 {
            self.typeOfSearch = 2
            let request = Accounts.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.statusSearchUser = stat
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }

    }



    @objc func textFieldDidChange(_ textField: UITextField) {

        if (UserDefaults.standard.object(forKey: "keyhap") == nil) || (UserDefaults.standard.object(forKey: "keyhap") as! Int == 0) {

        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 1) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 2) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }

        self.tableViewLists.alpha = 0
        print("changed")
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }

        let wid = self.view.bounds.width - 20
        self.newestText = textField.text ?? ""
        if self.typeOfSearch == 0 {
            let theText = textField.text?.replacingOccurrences(of: "#", with: "")
            let request = Timelines.tag(theText ?? "")
            StoreStruct.client.run(request) { [weak self] (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.statusSearch = stat
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        if self.typeOfSearch == 1 {
            let request = Search.search(query: textField.text ?? "")
            StoreStruct.client.run(request) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.statusSearch = stat.statuses
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        if self.typeOfSearch == 2 {

            let request = Accounts.search(query: self.newestText)
            StoreStruct.client.run(request) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.statusSearchUser = stat
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }

        }


            if textField.text == "" {
                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
                springWithDelay(duration: 0.7, delay: 0, animations: {
                    self.searcherView.alpha = 1
                    self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 120)
                })
                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
                springWithDelay(duration: 0.7, delay: 0, animations: {
                    self.tableView.alpha = 0
                    self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(0))
                })
            } else {

                if self.tableView.alpha == 0 {
                    self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 100)
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.searcherView.alpha = 1
                        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
                    })
                    self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(0))
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.tableView.alpha = 1
                        self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
                    })
                }

            }


    }





    @objc func dismissOverlay(button: UIButton) {
        dismissOverlayProper()
    }
    func dismissOverlayProper() {
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }


        self.backgroundView.alpha = 0

        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = ""
        self.searchTextField.alpha = 0
        
        springWithDelay(duration: 0.37, delay: 0, animations: {
            self.searcherView.alpha = 0
        })
    }
    @objc func dismissOverlaySearch(button: UIButton) {
        dismissOverlayProperSearch()
    }
    func dismissOverlayProperSearch() {
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }

        self.segmentedControl.removeFromSuperview()

        self.backgroundView.alpha = 0

        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = ""
        self.searchTextField.alpha = 0
        
        springWithDelay(duration: 0.4, delay: 0, animations: {
            self.searcherView.alpha = 0
        })
    }
    
//    public override var additionalSafeAreaInsets: UIEdgeInsets {
//        didSet {
//            if #available(iOS 13.0, *) {
//                guard additionalSafeAreaInsets.bottom != 0 else {
//                    return
//                }
//                viewControllers?.forEach { $0.additionalSafeAreaInsets.bottom = additionalSafeAreaInsets.bottom }
//                additionalSafeAreaInsets.bottom = 0
//            }
//        }
//    }
    
    func createTabBar() {

        DispatchQueue.main.async {

            // Create Tab one
            self.tabOne = UINavigationController(rootViewController: self.firstView)
            let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "feed")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "feed")?.maskWithColor(color: Colours.gray))
            tabOneBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabOne.tabBarItem = tabOneBarItem
            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
//            self.tabOne.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabOne.tabBarItem.tag = 1

            // Create Tab two
            self.tabTwo = UINavigationController(rootViewController: self.secondView)
            let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "notifications")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "notifications")?.maskWithColor(color: Colours.gray))
            tabTwoBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabTwo.tabBarItem = tabTwoBarItem2
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
//            self.tabTwo.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabTwo.tabBarItem.tag = 2
            
            // Create Tab DM
            self.tabDM = UINavigationController(rootViewController: self.dmView)
            let tabDMBarItem2 = UITabBarItem(title: "", image: UIImage(named: "direct")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "direct")?.maskWithColor(color: Colours.gray))
            tabDMBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabDM.tabBarItem = tabDMBarItem2
            self.tabDM.navigationBar.backgroundColor = Colours.white
            self.tabDM.navigationBar.barTintColor = Colours.white
//            self.tabDM.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabDM.tabBarItem.tag = 3
            
            // Create Tab three
            self.tabThree = UINavigationController(rootViewController: self.thirdView)
            let tabThreeBarItem = UITabBarItem(title: "", image: UIImage(named: "profile")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "profile")?.maskWithColor(color: Colours.gray))
            tabThreeBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabThree.tabBarItem = tabThreeBarItem
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
//            self.tabThree.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabThree.tabBarItem.tag = 4
            
            // Create Tab four
            self.tabFour = UINavigationController(rootViewController: self.fourthView)
            let tabFourBarItem = UITabBarItem(title: "", image: UIImage(named: "toot")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "toot")?.maskWithColor(color: Colours.gray))
            tabFourBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabFour.tabBarItem = tabFourBarItem
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white
//            self.tabFour.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabFour.tabBarItem.tag = 5
            
            let viewControllerList = [self.tabOne, self.tabTwo, self.tabDM, self.tabThree, self.tabFour]
            
            for x in viewControllerList {

                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 2688:
                        print("iPhone Xs Max")
                        let topIcon = UIButton(frame:(CGRect(x: self.view.bounds.width/2 - 100, y: 50, width: 200, height: 30)))
                        topIcon.setTitleColor(Colours.grayDark, for: .normal)
                        topIcon.adjustsImageWhenHighlighted = false
                        self.searchButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: self.view.bounds.width - 50, y: 50, width: 32, height: 32)))
                        self.searchButton.setImage(UIImage(named: "search")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.searchButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.searchButton.adjustsImageWhenHighlighted = false
                        self.searchButton.addTarget(self, action: #selector(self.didTouchSearch), for: .touchUpInside)
                        
                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                        switch (deviceIdiom) {
                        case .phone :
                            x.view.addSubview(self.searchButton)
                        default :
                            print("nil")
                        }
                    case 2436, 1792:
                        print("iPhone X")
                        let topIcon = UIButton(frame:(CGRect(x: self.view.bounds.width/2 - 100, y: 50, width: 200, height: 30)))
                        topIcon.setTitleColor(Colours.grayDark, for: .normal)
                        topIcon.adjustsImageWhenHighlighted = false
                        self.searchButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: self.view.bounds.width - 50, y: 50, width: 32, height: 32)))
                        self.searchButton.setImage(UIImage(named: "search")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.searchButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.searchButton.adjustsImageWhenHighlighted = false
                        self.searchButton.addTarget(self, action: #selector(self.didTouchSearch), for: .touchUpInside)
                        
                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                        switch (deviceIdiom) {
                        case .phone :
                            x.view.addSubview(self.searchButton)
                        default :
                            print("nil")
                        }
                    default:
                        let topIcon = UIButton(frame:(CGRect(x: self.view.bounds.width/2 - 100, y: 26, width: 200, height: 30)))
                        topIcon.setTitleColor(Colours.grayDark, for: .normal)
                        topIcon.adjustsImageWhenHighlighted = false
                        self.searchButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: self.view.bounds.width - 50, y: 27, width: 32, height: 32)))
                        self.searchButton.setImage(UIImage(named: "search")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.searchButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.searchButton.adjustsImageWhenHighlighted = false
                        self.searchButton.addTarget(self, action: #selector(self.didTouchSearch), for: .touchUpInside)
                        
                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                        switch (deviceIdiom) {
                        case .phone :
                            x.view.addSubview(self.searchButton)
                        default :
                            print("nil")
                        }
                    }
                }

            }

            self.viewControllers = viewControllerList
            
            var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
            var offset = 88
            var newoff = 45
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2688:
                    offset = 88
                    newoff = 45
                case 2436, 1792:
                    offset = 88
                    newoff = 45
                default:
                    offset = 64
                    newoff = 24
                    tabHeight = Int(UITabBarController().tabBar.frame.size.height)
                }
            }
            
            self.ai = NVActivityIndicatorView(frame: CGRect(x: -100, y: self.view.bounds.height + 100, width: 27, height: 27), type: .circleStrokeSpin, color: Colours.tabSelected)
            let xOffset = (self.view.bounds.width/10) * 9
            self.ai.center = CGPoint(x: CGFloat(xOffset), y: CGFloat(self.view.bounds.height) - CGFloat(tabHeight) + 24)
            self.ai.isUserInteractionEnabled = false
            self.ai.alpha = 0
            self.view.addSubview(self.ai)
        }
    }
}

extension UIImage {

    public func maskWithColor(color: UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        let rect = CGRect(origin: CGPoint.zero, size: size)

        color.setFill()
        self.draw(in: rect)

        context.setBlendMode(.sourceIn)
        context.fill(rect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }

}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

class MNGExpandedTouchAreaButton: UIButton {

    var margin:CGFloat = 10.0
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }

}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
