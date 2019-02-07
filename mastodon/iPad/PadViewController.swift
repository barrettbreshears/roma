//
//  PadViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 26/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import OneSignal
import StatusAlert
import SAConfettiView

class PadViewController: UIViewController, UITextFieldDelegate, OSSubscriptionObserver, UIGestureRecognizerDelegate {
    
    var curr = 0
    var unselectCol = UIColor(red: 75/255.0, green: 75/255.0, blue: 85/255.0, alpha: 1.0)
    var isSearching = false
    var isListing = false
    var tappedB = 0
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
        
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            let x00 = StoreStruct.client.baseURL
            let x11 = StoreStruct.shared.currentInstance.accessToken
            let player = playerId
            StoreStruct.playerID = playerId
            
            let url = URL(string: "http:// 163.237.247.103:3000/register")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let myParams = "instance_url=\(x00)&access_token=\(x11)&device_token=\(player)"
            let postData = myParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
            let postLength = String(format: "%d", postData!.count)
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
            
        }
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
    
    var statusBarView = UIView()
    var searcherView = UIView()
    var searchTextField = UITextField()
    var backgroundView = UIButton()
    let volumeBar = VolumeBar.shared
    
    var button1 = MNGExpandedTouchAreaButton()
    var button2 = MNGExpandedTouchAreaButton()
    var button3 = MNGExpandedTouchAreaButton()
    var button4 = MNGExpandedTouchAreaButton()
    var button5 = MNGExpandedTouchAreaButton()
    
    var button56 = MNGExpandedTouchAreaButton()
    var button6 = MNGExpandedTouchAreaButton()
    var button7 = MNGExpandedTouchAreaButton()
    
    
    var window: UIWindow?
    
    let splitViewController2 =  UISplitViewController()
    let rootNavigationController2 = UINavigationController(rootViewController: PadTimelinesViewController())
    let rootNavigationController22 = UINavigationController(rootViewController: PadTimelinesViewController())
    let splitViewController31 =  UISplitViewController()
    
    let splitViewController21 =  UISplitViewController()
    let rootNavigationController21 = UINavigationController(rootViewController: PadMentionsViewController())
    
    let splitViewController5 =  UISplitViewController()
    let rootNavigationController5 = UINavigationController(rootViewController: ThirdViewController())
    let splitViewController6 =  UISplitViewController()
    let rootNavigationController6 = UINavigationController(rootViewController: PinnedViewController())
    let detailNavigationController6 = UINavigationController(rootViewController: LikedViewController())
    
    
    let splitViewControllerA =  UISplitViewController()
    let rootNavigationControllerA = UINavigationController(rootViewController: PadSidebarViewController())
    
    //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //
    //        if self.window?.bounds.width ?? CGFloat(0) > CGFloat(400) && previousTraitCollection == nil {
    //
    //        } else {
    //
    //            print("changed trait")
    //
    //
    //        if UIApplication.shared.isSplitOrSlideOver {
    //            self.window?.rootViewController = ViewController()
    //            self.window?.makeKeyAndVisible()
    //        } else {
    //
    //        }
    //        }
    //    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("newsize")
        print(size)
        
        super.viewWillTransition(to: size, with: coordinator)
        //        coordinator.animate(alongsideTransition: nil, completion: {
        //            _ in
        
        self.statusBarView.frame = UIApplication.shared.statusBarFrame
        
        self.splitViewControllerA.preferredDisplayMode = .allVisible
        
        //        self.rootNavigationController2.preferredContentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        
        if UIDevice.current.orientation.isPortrait {
            let SCREEN_MAX_LENGTH = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            if SCREEN_MAX_LENGTH == 1366.0 {
                
            } else if SCREEN_MAX_LENGTH <= 1024.0 {
                self.size9 = 691
                self.splitViewControllerA.minimumPrimaryColumnWidth = CGFloat(size9)
                self.splitViewControllerA.maximumPrimaryColumnWidth = CGFloat(size9)
            } else if SCREEN_MAX_LENGTH == 1112.0 {
                self.size9 = 761
                self.splitViewControllerA.minimumPrimaryColumnWidth = CGFloat(size9)
                self.splitViewControllerA.maximumPrimaryColumnWidth = CGFloat(size9)
            } else {
                self.size9 = 761
            }
        } else {
            let SCREEN_MAX_LENGTH = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            if SCREEN_MAX_LENGTH == 1366.0 {
                
            } else if SCREEN_MAX_LENGTH <= 1024.0 {
                self.size9 = 611
                self.splitViewControllerA.minimumPrimaryColumnWidth = CGFloat(size9)
                self.splitViewControllerA.maximumPrimaryColumnWidth = CGFloat(size9)
            } else if SCREEN_MAX_LENGTH == 1112.0 {
                self.size9 = 661
                self.splitViewControllerA.minimumPrimaryColumnWidth = CGFloat(size9)
                self.splitViewControllerA.maximumPrimaryColumnWidth = CGFloat(size9)
            } else {
                self.size9 = 761
            }
        }
        
        //        })
        
        
        
    }
    
    func load2() {
        
        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            Colours.white = UIColor.white
            Colours.grayDark = UIColor(red: 40/250, green: 40/250, blue: 40/250, alpha: 1.0)
            Colours.grayDark2 = UIColor(red: 110/250, green: 113/250, blue: 121/250, alpha: 1.0)
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.black = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
            Colours.white = UIColor(red: 53/255.0, green: 53/255.0, blue: 64/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 33/255.0, green: 33/255.0, blue: 43/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 2) {
            Colours.white = UIColor(red: 36/255.0, green: 33/255.0, blue: 37/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 33/255.0, green: 33/255.0, blue: 43/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            Colours.white = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 10/255.0, green: 10/255.0, blue: 20/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    @objc func b1Touched() {
        
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isSearching = false
        panelController2.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isListing = false
        
        self.load2()
        self.curr = 0
        self.tappedB = 0
        
        self.splitViewControllerA.viewControllers = [rootNavigationController2, rootNavigationControllerA]
        self.splitViewControllerA.minimumPrimaryColumnWidth = CGFloat(size9)
        self.splitViewControllerA.maximumPrimaryColumnWidth = CGFloat(size9)
        
        self.splitViewController?.viewControllers[1] = splitViewControllerA
        
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    @objc func b2Touched() {
        
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isSearching = false
        panelController2.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isListing = false
        
        self.load2()
        self.curr = 1
        self.tappedB = 1
        
        self.splitViewControllerA.viewControllers = [rootNavigationController21, rootNavigationControllerA]
        self.splitViewControllerA.minimumPrimaryColumnWidth = CGFloat(size9)
        self.splitViewControllerA.maximumPrimaryColumnWidth = CGFloat(size9)
        
        self.splitViewController?.viewControllers[1] = splitViewControllerA
        
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    @objc func b3Touched() {
        
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isSearching = false
        panelController2.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isListing = false
        
        self.load2()
        self.curr = 2
        self.tappedB = 2
        
        self.splitViewControllerA.viewControllers = [rootNavigationController5, rootNavigationControllerA]
        self.splitViewControllerA.minimumPrimaryColumnWidth = CGFloat(size9)
        self.splitViewControllerA.maximumPrimaryColumnWidth = CGFloat(size9)
        
        self.splitViewController?.viewControllers[1] = splitViewControllerA
        
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    
    
    
    
    @objc func setVC() {
        let con = PadDetailViewController()
        con.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
        panelController.set(viewController: con)
        
    }
    @objc func setVC2() {
        let con = ThirdViewController()
        con.fromOtherUser = true
        con.userIDtoUse = StoreStruct.statusSearchUser[StoreStruct.searchIndex].id
        panelController.set(viewController: con)
    }
    
    
    let panelController = FloatingPanelController()
    let panelController2 = FloatingPanelController()
    
    @objc func dismissThings() {
        
        panelController.removeFromParent()
        panelController2.removeFromParent()
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        panelController2.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.bgbg.removeFromSuperview()
        self.bgbg2.removeFromSuperview()
        self.isListing = false
        self.isSearching = false
    }
    
    @objc func searchThing() {
        
        panelController.removeFromParent()
        panelController2.removeFromParent()
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        panelController2.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.bgbg.removeFromSuperview()
        self.bgbg2.removeFromSuperview()
        self.isListing = false
        self.isSearching = false
        
        if StoreStruct.typeOfSearch == 2 {
            if StoreStruct.currentPage == 0 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser"), object: self)
            } else if StoreStruct.currentPage == 1 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser2"), object: self)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser3"), object: self)
            }
        } else {
            if StoreStruct.currentPage == 0 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "search"), object: self)
            } else if StoreStruct.currentPage == 1 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "search2"), object: self)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "search3"), object: self)
            }
        }
    }
    
    @objc func listThing() {
        
        panelController.removeFromParent()
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        panelController2.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isListing = false
        self.isSearching = false
        
        print("gogo")
        
        //        if StoreStruct.typeOfSearch == 2 {
        //            if StoreStruct.currentPage == 0 {
        //                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser"), object: self)
        //            } else if StoreStruct.currentPage == 1 {
        //                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser2"), object: self)
        //            } else {
        //                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser3"), object: self)
        //            }
        //        } else {
        //            if StoreStruct.currentPage == 0 {
        //                NotificationCenter.default.post(name: Notification.Name(rawValue: "search"), object: self)
        //            } else if StoreStruct.currentPage == 1 {
        //                NotificationCenter.default.post(name: Notification.Name(rawValue: "search2"), object: self)
        //            } else {
        //                NotificationCenter.default.post(name: Notification.Name(rawValue: "search3"), object: self)
        //            }
        //        }
    }
    
    
    let bgbg = UIButton()
    @objc func b4Touched() {
        panelController2.removeFromParent()
        panelController2.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isListing = false
        
        if self.isSearching {
            
            self.bgbg.removeFromSuperview()
            panelController.removeFromParent()
            panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
            self.isSearching = false
            
        } else {
            
            self.bgbg.frame = UIScreen.main.bounds
            self.bgbg.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.bgbg.addTarget(self, action: #selector(self.b4Touched), for: .touchUpInside)
            let wind = UIApplication.shared.keyWindow!
            wind.addSubview(self.bgbg)
            
            if self.tappedB == 0 {
                panelController.addTo(parent: self.rootNavigationController2)
            } else if self.tappedB == 1 {
                panelController.addTo(parent: self.rootNavigationController21)
            } else {
                panelController.addTo(parent: self.rootNavigationController5)
            }
            
            panelController.resizeTo(CGSize(width:  440,
                                            height: 540))
            panelController.pinTo(position: .topLeading,
                                  margins: UIEdgeInsets(top:    60, left:  0,
                                                        bottom: 42, right: 18))
            let yourContentVC = PadSearchViewController()
            panelController.set(viewController: yourContentVC)
            panelController.showPanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
            
            self.isSearching = true
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    @objc func b5Touched() {
        
    }
    
    let bgbg2 = UIButton()
    @objc func b56Touched() {
        panelController.removeFromParent()
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isSearching = false
        
        if self.isListing {
            
            self.bgbg2.removeFromSuperview()
            panelController2.removeFromParent()
            panelController2.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
            self.isListing = false
            
        } else {
            
            self.bgbg2.frame = UIScreen.main.bounds
            self.bgbg2.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.bgbg2.addTarget(self, action: #selector(self.b56Touched), for: .touchUpInside)
            let wind = UIApplication.shared.keyWindow!
            wind.addSubview(self.bgbg2)
            
            if self.tappedB == 0 {
                panelController2.addTo(parent: self.rootNavigationController2)
            } else if self.tappedB == 1 {
                panelController2.addTo(parent: self.rootNavigationController21)
            } else {
                panelController2.addTo(parent: self.rootNavigationController5)
            }
            
            panelController2.resizeTo(CGSize(width:  440,
                                             height: 540))
            panelController2.pinTo(position: .topLeading,
                                   margins: UIEdgeInsets(top:    60, left:  18,
                                                         bottom: 42, right: 18))
            let yourContentVC = PadListViewController()
            panelController2.set(viewController: yourContentVC)
            panelController2.showPanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
            
            self.isListing = true
        }
    }
    
    @objc func b6Touched() {
        let controller = SettingsViewController()
        controller.preferredContentSize.width = 700
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    @objc func b7Touched() {
        let controller = ComposeViewController()
        controller.inReply = []
        controller.inReplyText = ""
        self.present(controller, animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    
    
    @objc func logBackOut() {
        print("log back out")
        let controller = PadLogInViewController()
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        becomeFirstResponder()
        
        if UserDefaults.standard.object(forKey: "accessToken2") == nil {
            print("didl123")
            let controller = PadLogInViewController()
            controller.modalPresentationStyle = .formSheet
            self.present(controller, animated: true, completion: nil)
        } else {
            
            
            
            
            StoreStruct.shared.currentInstance.accessToken = UserDefaults.standard.object(forKey: "accessToken2") as! String
            StoreStruct.client = Client(
                baseURL: "https://\(StoreStruct.shared.currentInstance.returnedText)",
                accessToken: StoreStruct.shared.currentInstance.accessToken
            )
            
            
            
            if StoreStruct.statusesHome.isEmpty {
                let request = Timelines.home()
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        StoreStruct.statusesHome = stat
                        StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                    }
                }
            }
            
            
            
            let request2 = Accounts.currentUser()
            StoreStruct.client.run(request2) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.currentUser = stat
                }
            }
            
            
        }
        
//        let insetsConst: CGFloat = 22
//        if (UserDefaults.standard.object(forKey: "insicon1") == nil) || (UserDefaults.standard.object(forKey: "insicon1") as! Int == 0) {
//            self.button56.frame = CGRect(x: 5, y: 340, width: 70, height: 70)
//            self.button56.setImage(UIImage(named: "list")?.maskWithColor(color: self.unselectCol), for: .normal)
//            self.button56.contentEdgeInsets = UIEdgeInsets(top: insetsConst, left: insetsConst, bottom: insetsConst, right: insetsConst)
//            self.button56.layer.cornerRadius = 0
//            self.button56.layer.masksToBounds = true
//        } else {
//            self.button56.frame = CGRect(x: 5, y: 340, width: 70, height: 70)
//            self.button56.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatarStatic)"))
//            self.button56.contentEdgeInsets = UIEdgeInsets(top: insetsConst, left: insetsConst, bottom: insetsConst, right: insetsConst)
//            self.button56.imageView?.layer.cornerRadius = 35
//            self.button56.imageView?.contentMode = .scaleAspectFill
//            self.button56.layer.masksToBounds = true
//        }
    }
    
    
    override var keyCommands: [UIKeyCommand]? {
        //shortkeys
        let op1 = UIKeyCommand(input: "1", modifierFlags: .control, action: #selector(b1Touched), discoverabilityTitle: "Home Timelines")
        let op2 = UIKeyCommand(input: "2", modifierFlags: .control, action: #selector(b2Touched), discoverabilityTitle: "Notification Timelines")
        let op3 = UIKeyCommand(input: "3", modifierFlags: .control, action: #selector(b3Touched), discoverabilityTitle: "Profile Timelines")
        let listThing = UIKeyCommand(input: "l", modifierFlags: .control, action: #selector(b56Touched), discoverabilityTitle: "Lists")
        let searchThing = UIKeyCommand(input: "f", modifierFlags: .command, action: #selector(b4Touched), discoverabilityTitle: "Search")
        let setThing = UIKeyCommand(input: ";", modifierFlags: .command, action: #selector(b6Touched), discoverabilityTitle: "Settings")
        let newToot = UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(b7Touched), discoverabilityTitle: "New Toot")
        return [
            op1, op2, op3, listThing, searchThing, setThing, newToot
        ]
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func becomeFirst() {
        self.becomeFirstResponder()
    }
    
    
    @objc func signOutNewInstance() {
        let instances = InstanceData.getAllInstances()
        let loginController = PadLogInViewController()
        loginController.loadingAdditionalInstance = true
        loginController.createLoginView(newInstance: true)
        self.present(loginController, animated: true, completion: nil)
    }
    
    var size9 = 961
    
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
    
    func gotoID() {
        
        if StoreStruct.currentPage == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid"), object: self)
        } else if StoreStruct.currentPage == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid2"), object: self)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoid3"), object: self)
        }
        
    }
    
    func genericStuff() {
        (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
        (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
        (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
        (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
        (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
        
        self.splitViewController2.view.backgroundColor = Colours.white
        self.splitViewController31.view.backgroundColor = Colours.white
        self.rootNavigationController22.view.backgroundColor = Colours.white
        self.splitViewController21.view.backgroundColor = Colours.white
        self.splitViewController5.view.backgroundColor = Colours.white
        self.splitViewController6.view.backgroundColor = Colours.white
        self.rootNavigationController2.view.backgroundColor = Colours.white
        self.rootNavigationController21.view.backgroundColor = Colours.white
        self.rootNavigationController5.view.backgroundColor = Colours.white
        self.rootNavigationController6.view.backgroundColor = Colours.white
        self.detailNavigationController6.view.backgroundColor = Colours.white
        
        self.navigationController?.view.backgroundColor = Colours.white
        
        self.view.backgroundColor = Colours.white
        self.navigationController?.navigationBar.backgroundColor = Colours.white
        self.navigationController?.navigationBar.tintColor = Colours.black
        
        
        self.statusBarView.backgroundColor = Colours.white
        self.splitViewController?.view.backgroundColor = Colours.cellQuote
        
        self.load2()
        if self.curr == 0 {
            self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
            self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
            self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        } else if self.curr == 1 {
            self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
            self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
            self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        } else {
            self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
            self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
            self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        }
    }
    
    func siriConfetti() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colours.white
        splitViewController?.view.backgroundColor = Colours.cellQuote
        
        self.splitViewControllerA.preferredDisplayMode = .allVisible
        
        print("testtesttest")
        print(max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height))
        
        
        if UIDevice.current.orientation.isPortrait {
            let SCREEN_MAX_LENGTH = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            if SCREEN_MAX_LENGTH == 1366.0 {
                
            } else if SCREEN_MAX_LENGTH <= 1024.0 {
                self.size9 = 691
            } else if SCREEN_MAX_LENGTH == 1112.0 {
                self.size9 = 761
            } else {
                self.size9 = 761
            }
        } else {
            
            let SCREEN_MAX_LENGTH = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            if SCREEN_MAX_LENGTH == 1366.0 {
                
            } else if SCREEN_MAX_LENGTH <= 1024.0 {
                self.size9 = 611
            } else if SCREEN_MAX_LENGTH == 1112.0 {
                self.size9 = 661
            } else {
                self.size9 = 761
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreate), name: NSNotification.Name(rawValue: "confettiCreate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreateRe), name: NSNotification.Name(rawValue: "confettiCreateRe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreateLi), name: NSNotification.Name(rawValue: "confettiCreateLi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.signOutNewInstance), name: NSNotification.Name(rawValue: "signOut2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissThings), name: NSNotification.Name(rawValue: "dismissThings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.logBackOut), name: NSNotification.Name(rawValue: "logBackOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeLight), name: NSNotification.Name(rawValue: "light"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeNight), name: NSNotification.Name(rawValue: "night"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeNight2), name: NSNotification.Name(rawValue: "night2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeBlack), name: NSNotification.Name(rawValue: "black"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setVC), name: NSNotification.Name(rawValue: "setVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setVC2), name: NSNotification.Name(rawValue: "setVC2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.becomeFirst), name: NSNotification.Name(rawValue: "becomeFirst"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchThing), name: NSNotification.Name(rawValue: "hideP"), object: nil)
        
        statusBarView.frame = UIApplication.shared.statusBarFrame
        statusBarView.backgroundColor = Colours.white
        view.addSubview(statusBarView)
        
        
        
        self.load2()
        self.curr = 0
        
        self.splitViewControllerA.viewControllers = [rootNavigationController2, rootNavigationControllerA]
        self.splitViewControllerA.minimumPrimaryColumnWidth = CGFloat(size9)
        self.splitViewControllerA.maximumPrimaryColumnWidth = CGFloat(size9)
        
        self.splitViewController?.viewControllers[1] = splitViewControllerA
        
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        
        
        
        
        
        
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longAction(sender:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        self.view.addGestureRecognizer(longPress)
        
        let margins = view.layoutMarginsGuide
        let insetsConst: CGFloat = 22
        let insetsConst2: CGFloat = 22
        
        self.load2()
        
        self.button1.frame = CGRect(x: 5, y: 60, width: 70, height: 70)
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button1.backgroundColor = UIColor.clear
        self.button1.addTarget(self, action: #selector(self.b1Touched), for: .touchUpInside)
        self.view.addSubview(self.button1)
        
        self.button2.frame = CGRect(x: 5, y: 130, width: 70, height: 70)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button2.backgroundColor = UIColor.clear
        self.button2.addTarget(self, action: #selector(self.b2Touched), for: .touchUpInside)
        self.view.addSubview(self.button2)
        
        self.button3.frame = CGRect(x: 5, y: 200, width: 70, height: 70)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button3.backgroundColor = UIColor.clear
        self.button3.addTarget(self, action: #selector(self.b3Touched), for: .touchUpInside)
        self.view.addSubview(self.button3)
        
        self.button4.frame = CGRect(x: 5, y: 270, width: 70, height: 70)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button4.contentEdgeInsets = UIEdgeInsets(top: insetsConst2, left: insetsConst2, bottom: insetsConst2, right: insetsConst2)
        self.button4.backgroundColor = UIColor.clear
        self.button4.addTarget(self, action: #selector(self.b4Touched), for: .touchUpInside)
        self.view.addSubview(self.button4)
        
        
        if (UserDefaults.standard.object(forKey: "insicon1") == nil) || (UserDefaults.standard.object(forKey: "insicon1") as! Int == 0) {
            self.button56.frame = CGRect(x: 5, y: 340, width: 70, height: 70)
            self.button56.setImage(UIImage(named: "list")?.maskWithColor(color: self.unselectCol), for: .normal)
            self.button56.contentEdgeInsets = UIEdgeInsets(top: insetsConst, left: insetsConst, bottom: insetsConst, right: insetsConst)
            self.button56.layer.cornerRadius = 0
            self.button56.layer.masksToBounds = true
        } else {
            self.button56.frame = CGRect(x: 5, y: 340, width: 70, height: 70)
            if StoreStruct.currentUser != nil {
                self.button56.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatarStatic)"))
            }
            self.button56.contentEdgeInsets = UIEdgeInsets(top: insetsConst, left: insetsConst, bottom: insetsConst, right: insetsConst)
            self.button56.imageView?.layer.cornerRadius = 35
            self.button56.imageView?.contentMode = .scaleAspectFill
            self.button56.layer.masksToBounds = true
        }
        
        self.button56.backgroundColor = UIColor.clear
        self.button56.addTarget(self, action: #selector(self.b56Touched), for: .touchUpInside)
        self.view.addSubview(self.button56)
        
        self.button6.frame.size.height = 70
        self.button6.frame.size.width = 70
        self.button6.setImage(UIImage(named: "settings2")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button6.contentEdgeInsets = UIEdgeInsets(top: insetsConst, left: insetsConst, bottom: insetsConst, right: insetsConst)
        self.button6.backgroundColor = UIColor.clear
        self.button6.addTarget(self, action: #selector(self.b6Touched), for: .touchUpInside)
        self.view.addSubview(self.button6)
        self.button6.translatesAutoresizingMaskIntoConstraints = false
        
        self.button6.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -65).isActive = true
        self.button6.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -14).isActive = true
        
        self.button7.frame.size.height = 70
        self.button7.frame.size.width = 70
        self.button7.setImage(UIImage(named: "toot")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button7.backgroundColor = UIColor.clear
        self.button7.addTarget(self, action: #selector(self.b7Touched), for: .touchUpInside)
        self.view.addSubview(self.button7)
        self.button7.translatesAutoresizingMaskIntoConstraints = false
        
        self.button7.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        self.button7.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 6).isActive = true
        
        
        
        
        
        if UserDefaults.standard.object(forKey: "clientID") == nil {} else {
            StoreStruct.shared.currentInstance.clientID = UserDefaults.standard.object(forKey: "clientID") as! String
        }
        if UserDefaults.standard.object(forKey: "clientSecret") == nil {} else {
            StoreStruct.shared.currentInstance.clientSecret = UserDefaults.standard.object(forKey: "clientSecret") as! String
        }
        if UserDefaults.standard.object(forKey: "authCode") == nil {} else {
            StoreStruct.shared.currentInstance.authCode = UserDefaults.standard.object(forKey: "authCode") as! String
        }
        if UserDefaults.standard.object(forKey: "returnedText") == nil {} else {
            StoreStruct.shared.currentInstance.returnedText = UserDefaults.standard.object(forKey: "returnedText") as! String
        }
        
        
        
        let request = Lists.all()
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.allLists = stat
            }
        }
    }
    
    
    
    
    
    
    
    
    @objc func longAction(sender: UILongPressGestureRecognizer) {
        
        if (UserDefaults.standard.object(forKey: "longToggle") == nil) || (UserDefaults.standard.object(forKey: "longToggle") as! Int == 0) {
            
            
            if sender.state == .began {
                print("long pressed")
                
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    let selection = UIImpactFeedbackGenerator()
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
                    
                    (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
                    (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
                    (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
                    (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
                    (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    
                    self.splitViewController2.view.backgroundColor = Colours.white
                    self.splitViewController31.view.backgroundColor = Colours.white
                    self.rootNavigationController22.view.backgroundColor = Colours.white
                    self.splitViewController21.view.backgroundColor = Colours.white
                    self.splitViewController5.view.backgroundColor = Colours.white
                    self.splitViewController6.view.backgroundColor = Colours.white
                    self.rootNavigationController2.view.backgroundColor = Colours.white
                    self.rootNavigationController21.view.backgroundColor = Colours.white
                    self.rootNavigationController5.view.backgroundColor = Colours.white
                    self.rootNavigationController6.view.backgroundColor = Colours.white
                    self.detailNavigationController6.view.backgroundColor = Colours.white
                    
                    self.navigationController?.view.backgroundColor = Colours.white
                    
                    self.view.backgroundColor = Colours.white
                    self.navigationController?.navigationBar.backgroundColor = Colours.white
                    self.navigationController?.navigationBar.tintColor = Colours.black
                    
                    self.statusBarView.backgroundColor = Colours.white
                    self.splitViewController?.view.backgroundColor = Colours.cellQuote
                    
                    
                    self.load2()
                    if self.curr == 0 {
                        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
                    } else if self.curr == 1 {
                        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
                    } else {
                        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
                    }
                    
                    
                    
                    
                }
            }
            
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 1) {
            //cback2
            if sender.state == .began {
                self.b56Touched()
            }
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 2) {
            
            if sender.state == .began {
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    let imp = UIImpactFeedbackGenerator()
                    imp.impactOccurred()
                }
                let controller = ComposeViewController()
                controller.inReply = []
                controller.inReplyText = ""
                self.present(controller, animated: true, completion: nil)
            }
            
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 3) {
            
            if sender.state == .began {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
            }
        } else {
            
            if sender.state == .began {
                self.b4Touched()
            }
        }
    }
    
    
    
    
    
    
    
    
    @objc func themeLight() {
        
        UIApplication.shared.statusBarStyle = .default
        Colours.keyCol = UIKeyboardAppearance.light
        UserDefaults.standard.set(0, forKey: "theme")
        
        DispatchQueue.main.async {
            
            (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
            (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
            (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
            (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
            (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
            
            self.splitViewController2.view.backgroundColor = Colours.white
            self.splitViewController31.view.backgroundColor = Colours.white
            self.rootNavigationController22.view.backgroundColor = Colours.white
            self.splitViewController21.view.backgroundColor = Colours.white
            self.splitViewController5.view.backgroundColor = Colours.white
            self.splitViewController6.view.backgroundColor = Colours.white
            self.rootNavigationController2.view.backgroundColor = Colours.white
            self.rootNavigationController21.view.backgroundColor = Colours.white
            self.rootNavigationController5.view.backgroundColor = Colours.white
            self.rootNavigationController6.view.backgroundColor = Colours.white
            self.detailNavigationController6.view.backgroundColor = Colours.white
            
            self.navigationController?.view.backgroundColor = Colours.white
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.black
            
            self.statusBarView.backgroundColor = Colours.white
            self.splitViewController?.view.backgroundColor = Colours.cellQuote
            
            self.load2()
            if self.curr == 0 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else if self.curr == 1 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            }
            
        }
    }
    
    @objc func themeNight() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        
        UserDefaults.standard.set(1, forKey: "theme")
        
        DispatchQueue.main.async {
            
            (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
            (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
            (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
            (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
            (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
            
            self.splitViewController2.view.backgroundColor = Colours.white
            self.splitViewController31.view.backgroundColor = Colours.white
            self.rootNavigationController22.view.backgroundColor = Colours.white
            self.splitViewController21.view.backgroundColor = Colours.white
            self.splitViewController5.view.backgroundColor = Colours.white
            self.splitViewController6.view.backgroundColor = Colours.white
            self.rootNavigationController2.view.backgroundColor = Colours.white
            self.rootNavigationController21.view.backgroundColor = Colours.white
            self.rootNavigationController5.view.backgroundColor = Colours.white
            self.rootNavigationController6.view.backgroundColor = Colours.white
            self.detailNavigationController6.view.backgroundColor = Colours.white
            
            self.navigationController?.view.backgroundColor = Colours.white
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.black
            
            
            self.statusBarView.backgroundColor = Colours.white
            self.splitViewController?.view.backgroundColor = Colours.cellQuote
            
            self.load2()
            if self.curr == 0 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else if self.curr == 1 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            }
            
        }
    }
    
    @objc func themeNight2() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        
        UserDefaults.standard.set(2, forKey: "theme")
        
        DispatchQueue.main.async {
            
            (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
            (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
            (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
            (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
            (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
            
            self.splitViewController2.view.backgroundColor = Colours.white
            self.splitViewController31.view.backgroundColor = Colours.white
            self.rootNavigationController22.view.backgroundColor = Colours.white
            self.splitViewController21.view.backgroundColor = Colours.white
            self.splitViewController5.view.backgroundColor = Colours.white
            self.splitViewController6.view.backgroundColor = Colours.white
            self.rootNavigationController2.view.backgroundColor = Colours.white
            self.rootNavigationController21.view.backgroundColor = Colours.white
            self.rootNavigationController5.view.backgroundColor = Colours.white
            self.rootNavigationController6.view.backgroundColor = Colours.white
            self.detailNavigationController6.view.backgroundColor = Colours.white
            
            self.navigationController?.view.backgroundColor = Colours.white
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.black
            
            
            self.statusBarView.backgroundColor = Colours.white
            self.splitViewController?.view.backgroundColor = Colours.cellQuote
            
            self.load2()
            if self.curr == 0 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else if self.curr == 1 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            }
            
        }
    }
    
    @objc func themeBlack() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        
        UserDefaults.standard.set(3, forKey: "theme")
        
        DispatchQueue.main.async {
            
            (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
            (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
            (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
            (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
            (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
            
            self.splitViewController2.view.backgroundColor = Colours.white
            self.splitViewController31.view.backgroundColor = Colours.white
            self.rootNavigationController22.view.backgroundColor = Colours.white
            self.splitViewController21.view.backgroundColor = Colours.white
            self.splitViewController5.view.backgroundColor = Colours.white
            self.splitViewController6.view.backgroundColor = Colours.white
            self.rootNavigationController2.view.backgroundColor = Colours.white
            self.rootNavigationController21.view.backgroundColor = Colours.white
            self.rootNavigationController5.view.backgroundColor = Colours.white
            self.rootNavigationController6.view.backgroundColor = Colours.white
            self.detailNavigationController6.view.backgroundColor = Colours.white
            
            self.navigationController?.view.backgroundColor = Colours.white
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.black
            
            self.statusBarView.backgroundColor = Colours.white
            self.splitViewController?.view.backgroundColor = Colours.cellQuote
            
            self.load2()
            if self.curr == 0 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else if self.curr == 1 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            }
            
        }
    }
    
    
}
