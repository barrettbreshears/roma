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
import SKPhotoBrowser

class NotificationsSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPhotoBrowserDelegate, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate {
    
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
        
        self.title = "Notifications"
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
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 0)
        case .pad:
            self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        default:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 0)
        }
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse2")
        self.tableView.alpha = 1
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.grayDark.withAlphaComponent(0.21)
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        self.tableView.tableFooterView = UIView()
        self.loadLoadLoad()
        
        let deviceIdiom0 = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom0) {
        case .pad:
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        default:
            print("nothing")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = Colours.tabUnselected
        
//        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
//        tap.numberOfTapsRequired = 1
//        tap.numberOfTouchesRequired = 1
//        tap.cancelsTouchesInView = false
//        tap.delegate = self
//        self.view.window?.addGestureRecognizer(tap)
        
        StoreStruct.currentPage = 90
    }
    
//    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    
//    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        let location = touch.location(in: self.view)
//        
//        if self.view.point(inside: location, with: nil) {
//            return false
//        }
//        else {
//            return true
//        }
//    }
//    
//    @objc private func onTap(sender: UITapGestureRecognizer) {
//        
//        self.view.window?.removeGestureRecognizer(sender)
//        self.dismiss(animated: true, completion: nil)
//    }
    
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
        title.frame = CGRect(x: 10, y: 8, width: self.view.bounds.width, height: 30)
        if section == 0 {
            title.text = "Push Notifications".localized
        } else {
            title.text = "In-App Notifications".localized
        }
        title.textColor = Colours.grayDark.withAlphaComponent(0.38)
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func handleToggle1(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "pnmentions")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(false, forKey: "pnmentions")
            sender.setOn(false, animated: true)
        }
    }
    
    @objc func handleToggle2(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "pnlikes")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(false, forKey: "pnlikes")
            sender.setOn(false, animated: true)
        }
    }
    
    @objc func handleToggle3(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "pnboosts")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(false, forKey: "pnboosts")
            sender.setOn(false, animated: true)
        }
    }
    
    @objc func handleToggle4(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "pnfollows")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(false, forKey: "pnfollows")
            sender.setOn(false, animated: true)
        }
    }
    
    @objc func handleToggleBadgeMent(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "badgeMent")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "badgeMent")
            sender.setOn(false, animated: true)
        }
    }
    
    @objc func handleToggleBadgeMentd(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "badgeMentd")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "badgeMentd")
            sender.setOn(false, animated: true)
        }
    }
    
    var notifArray = ["Mentions", "Likes", "Reposts", "Follows"]
    var notifArrayDesc = ["Get notified via a push notification when mentioned by other users.", "Get notified via a push notification when your toot is liked by other users.", "Get notified via a push notification when your toot is reposted by other users.", "Get notified via a push notification when you get a new follower."]
    var notifArrayIm = ["notifs0", "notifs0", "notifs0", "notifs0"]
    
    var innotifArray = ["Mentions and Activity", "Direct Messages"]
    var innotifArrayDesc = ["Display a badge on the mentions and activity tab icon when receiving a new notification whilst in the app.", "Display a badge on the direct messages tab icon when receiving a new direct message whilst in the app."]
    var innotifArrayIm = ["notifs", "notifs"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse2", for: indexPath) as! SettingsCellToggle
            cell.configure(status: self.notifArray[indexPath.row], status2: self.notifArrayDesc[indexPath.row], image: self.notifArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            if indexPath.row == 0 {
                if (UserDefaults.standard.object(forKey: "pnmentions") == nil) || (UserDefaults.standard.object(forKey: "pnmentions") as! Bool == true) {
                    cell.switchView.setOn(true, animated: false)
                } else {
                    cell.switchView.setOn(false, animated: false)
                }
                cell.switchView.addTarget(self, action: #selector(self.handleToggle1), for: .touchUpInside)
            } else if indexPath.row == 1 {
                if (UserDefaults.standard.object(forKey: "pnlikes") == nil) || (UserDefaults.standard.object(forKey: "pnlikes") as! Bool == true) {
                    cell.switchView.setOn(true, animated: false)
                } else {
                    cell.switchView.setOn(false, animated: false)
                }
                cell.switchView.addTarget(self, action: #selector(self.handleToggle2), for: .touchUpInside)
            } else if indexPath.row == 2 {
                if (UserDefaults.standard.object(forKey: "pnboosts") == nil) || (UserDefaults.standard.object(forKey: "pnboosts") as! Bool == true) {
                    cell.switchView.setOn(true, animated: false)
                } else {
                    cell.switchView.setOn(false, animated: false)
                }
                cell.switchView.addTarget(self, action: #selector(self.handleToggle3), for: .touchUpInside)
            } else {
                if (UserDefaults.standard.object(forKey: "pnfollows") == nil) || (UserDefaults.standard.object(forKey: "pnfollows") as! Bool == true) {
                    cell.switchView.setOn(true, animated: false)
                } else {
                    cell.switchView.setOn(false, animated: false)
                }
                cell.switchView.addTarget(self, action: #selector(self.handleToggle4), for: .touchUpInside)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse2", for: indexPath) as! SettingsCellToggle
            cell.configure(status: self.innotifArray[indexPath.row], status2: self.innotifArrayDesc[indexPath.row], image: self.innotifArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            if indexPath.row == 0 {
                if (UserDefaults.standard.object(forKey: "badgeMent") == nil) || (UserDefaults.standard.object(forKey: "badgeMent") as! Int == 0) {
                    cell.switchView.setOn(true, animated: false)
                } else {
                    cell.switchView.setOn(false, animated: false)
                }
                cell.switchView.addTarget(self, action: #selector(self.handleToggleBadgeMent), for: .touchUpInside)
            } else {
                if (UserDefaults.standard.object(forKey: "badgeMentd") == nil) || (UserDefaults.standard.object(forKey: "badgeMentd") as! Int == 0) {
                    cell.switchView.setOn(true, animated: false)
                } else {
                    cell.switchView.setOn(false, animated: false)
                }
                cell.switchView.addTarget(self, action: #selector(self.handleToggleBadgeMentd), for: .touchUpInside)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
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
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0.45)
        topBorder.backgroundColor = Colours.tabUnselected.cgColor
        self.tabBarController?.tabBar.layer.addSublayer(topBorder)
        
        
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
        
        
        self.navigationController?.navigationBar.backgroundColor = Colours.white
        self.navigationController?.navigationBar.tintColor = Colours.black
        self.navigationController?.navigationBar.barTintColor = Colours.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
        
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.grayDark.withAlphaComponent(0.21)
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
