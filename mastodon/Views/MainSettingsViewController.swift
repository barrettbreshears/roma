//
//  MainSettingsViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 28/04/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SJFluidSegmentedControl
import SafariServices
import StatusAlert
import SAConfettiView
import UserNotifications

class MainSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPhotoBrowserDelegate, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate {
    
    var tap: UITapGestureRecognizer!
    var safariVC: SFSafariViewController?
    var segmentedControl: SJFluidSegmentedControl!
    var tableView = UITableView()
    var currentIndex = 0
    var vc: ViewController?
    
    @objc func load() {
        DispatchQueue.main.async {
            self.loadLoadLoad()
        }
    }
    
    @objc func search() {
        let controller = DetailViewController()
        controller.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.removeTabbarItemsText()
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        self.view.backgroundColor = Colours.white
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
            case 2436, 1792:
                offset = 88
            default:
                offset = 64
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 5), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
        case .pad:
            self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        default:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 5), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
        }
        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellse")
        self.tableView.register(SettingsCell2.self, forCellReuseIdentifier: "cellse1")
        self.tableView.alpha = 1
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        self.loadLoadLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = Colours.tabUnselected
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        default:
            print("nothing")
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.window?.addGestureRecognizer(tap)
        
        StoreStruct.currentPage = 90
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.view)
        
        if self.view.point(inside: location, with: nil) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        
        self.view.window?.removeGestureRecognizer(sender)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Table stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 8, width: self.view.bounds.width, height: 30)
        if section == 0 {
            title.text = "Settings".localized
        } else {
            title.text = "Mast \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")"
        }
        title.textColor = Colours.grayDark.withAlphaComponent(0.38)
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
    var generalArray = ["General", "Appearance", "Notifications", "Biometric Lock", "Accounts"]
    var generalArrayDesc = ["From timelines to toots, and media content to gestures, change how things behave.", "Pick themes and hues, change the app icon, and decide how things look.", "Select which push notifications to subscribe to.", "Add a biometric lock to various sections of the app.", "Add and manage multiple user accounts."]
    var generalArrayIm = ["setset1", "setnight", "notifs0", "biolock2", "setpro"]
    
    var otherArray = ["Rate Mast \u{2605}\u{2605}\u{2605}\u{2605}\u{2605}", "About Mast", "Tip Mast"]
    var otherArrayDesc = ["If you enjoy using Mast, please consider leaving a review on the App Store.", "Let me tell you a little bit about myself.", "Your generosity is greatly appreciated."]
    var otherArrayIm = ["like", "setmas", "heart4"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse1", for: indexPath) as! SettingsCell2
            cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell
        } else {
            if indexPath.row == 0 || indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                cell.configure(status: self.otherArray[indexPath.row], status2: self.otherArrayDesc[indexPath.row], image: self.otherArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse1", for: indexPath) as! SettingsCell2
                cell.configure(status: self.otherArray[indexPath.row], status2: self.otherArrayDesc[indexPath.row], image: self.otherArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // general
                let controller = GeneralSettingsViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            } else if indexPath.row == 1 {
                // appearance
                let controller = AppearanceSettingsViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            } else if indexPath.row == 2 {
                // notifications
                let controller = NotificationsSettingsViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            } else if indexPath.row == 3 {
                // biometrics
                let controller = LockSettingsViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                // all accounts
                let controller = AccountSettingsViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            if indexPath.row == 0 {
                // rate
                //                SKStoreReviewController.requestReview()
                if let reviewURL = URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/1437429129?action=write-review&mt=8"), UIApplication.shared.canOpenURL(reviewURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(reviewURL)
                    }
                }
            } else if indexPath.row == 1 {
                // about
                Alertift.actionSheet(title: "Mast \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")", message: "Designed and hand-crafted with \u{2665} by @JPEG@mastodon.technology\n\nI'm an independant 23 year old developer from the UK, creating and crafting Mast in my spare time. It can be daunting manning a project of this magnitude, but I love what I do and Mast is a wonderful place to pour my creativity and effort into. If you like what I do, please consider leaving a tip to encourage great continued support. If you have any questions or concerns, please get in touch and let me know how I can improve and be better!\n\nHappy tooting :)".localized)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Developer Mastodon".localized)) { (action, ind) in
                        let controller = ThirdViewController()
                        controller.fromOtherUser = true
                        controller.userIDtoUse = "107304"
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    .action(.default("Developer Twitter".localized)) { (action, ind) in
                        let twUrl = URL(string: "twitter://user?screen_name=JPEGuin")!
                        let twUrlWeb = URL(string: "https://www.twitter.com/JPEGuin")!
                        if UIApplication.shared.canOpenURL(twUrl) {
                            UIApplication.shared.open(twUrl, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.open(twUrlWeb, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                        self.safariVC = SFSafariViewController(url: twUrlWeb)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(twUrlWeb)
                                    }
                                }
                            }
                        }
                    }
                    .action(.default("Website".localized)) { (action, ind) in
                        
                        let z = URL(string: "https://www.thebluebird.app")!
                        if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                            self.safariVC = SFSafariViewController(url: z)
                            self.safariVC?.preferredBarTintColor = Colours.white
                            self.safariVC?.preferredControlTintColor = Colours.tabSelected
                            self.present(self.safariVC!, animated: true, completion: nil)
                        } else {
                            UIApplication.shared.openURL(z)
                        }
                        
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 4))?.contentView ?? self.view)
                    .show(on: self)
            } else {
                // tip mast
                let controller = TipSettingsViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func loadLoadLoad() {
        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            Colours.white = UIColor.white
            Colours.white2 = UIColor(red: 203/255.0, green: 202/255.0, blue: 206/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 40/250, green: 40/250, blue: 40/250, alpha: 1.0)
            Colours.grayDark2 = UIColor(red: 110/250, green: 113/250, blue: 121/250, alpha: 1.0)
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.black = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
            Colours.white = UIColor(red: 46/255.0, green: 46/255.0, blue: 52/255.0, alpha: 1.0)
            Colours.white2 = UIColor(red: 28/255.0, green: 28/255.0, blue: 38/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 33/255.0, green: 33/255.0, blue: 43/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 80/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.0)
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
            Colours.tabUnselected = UIColor(red: 80/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 4) {
            Colours.white = UIColor(red: 41/255.0, green: 50/255.0, blue: 78/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 20/255.0, green: 20/255.0, blue: 29/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 80/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            Colours.white = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            Colours.white2 = UIColor(red: 36/255.0, green: 36/255.0, blue: 46/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 10/255.0, green: 10/255.0, blue: 20/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        self.view.backgroundColor = Colours.white
        
        if (UserDefaults.standard.object(forKey: "systemText") == nil) || (UserDefaults.standard.object(forKey: "systemText") as! Int == 0) {
            Colours.fontSize1 = CGFloat(UIFont.systemFontSize)
            Colours.fontSize3 = CGFloat(UIFont.systemFontSize)
        } else {
            if (UserDefaults.standard.object(forKey: "fontSize") == nil) {
                Colours.fontSize0 = 14
                Colours.fontSize2 = 10
                Colours.fontSize1 = 14
                Colours.fontSize3 = 10
            } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 0) {
                Colours.fontSize0 = 12
                Colours.fontSize2 = 8
                Colours.fontSize1 = 12
                Colours.fontSize3 = 8
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 1) {
                Colours.fontSize0 = 13
                Colours.fontSize2 = 9
                Colours.fontSize1 = 13
                Colours.fontSize3 = 9
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 2) {
                Colours.fontSize0 = 14
                Colours.fontSize2 = 10
                Colours.fontSize1 = 14
                Colours.fontSize3 = 10
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 3) {
                Colours.fontSize0 = 15
                Colours.fontSize2 = 11
                Colours.fontSize1 = 15
                Colours.fontSize3 = 11
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 4) {
                Colours.fontSize0 = 16
                Colours.fontSize2 = 12
                Colours.fontSize1 = 16
                Colours.fontSize3 = 12
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 5) {
                Colours.fontSize0 = 17
                Colours.fontSize2 = 13
                Colours.fontSize1 = 17
                Colours.fontSize3 = 13
            } else {
                Colours.fontSize0 = 18
                Colours.fontSize2 = 14
                Colours.fontSize1 = 18
                Colours.fontSize3 = 14
            }
        }
        
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
    }
    
    func removeTabbarItemsText() {
        var offset: CGFloat = 6.0
        if #available(iOS 11.0, *), traitCollection.horizontalSizeClass == .regular {
            offset = 0.0
        }
        if let items = self.tabBarController?.tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0);
            }
        }
    }
}
