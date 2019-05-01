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

class AppearanceSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPhotoBrowserDelegate, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate {
    
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
        
        self.title = "Appearance"
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
        self.tableView.register(AppIconsCells.self, forCellReuseIdentifier: "appcell")
        self.tableView.register(ColourCells.self, forCellReuseIdentifier: "colcell")
        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellse")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse2")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse23")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse234")
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
        return 8
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
            title.text = "App Icon".localized
        } else if section == 1 {
            title.text = "App Icon".localized
        } else if section == 2 {
            title.text = "Theme".localized
        } else if section == 3 {
            title.text = "Timeline".localized
        } else if section == 4 {
            title.text = "Profile".localized
        } else if section == 5 {
            title.text = "Media".localized
        } else if section == 6 {
            title.text = "Segments".localized
        } else if section == 7 {
            title.text = "Other".localized
        } else {
            title.text = "".localized
        }
        title.textColor = Colours.grayDark.withAlphaComponent(0.38)
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return thArray.count
        } else if section == 3 {
            return tiArray.count
        } else if section == 4 {
            return prArray.count
        } else if section == 5 {
            return meArray.count
        } else if section == 6 {
            return seArray.count
        } else if section == 7 {
            return otArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else if indexPath.section == 1 {
            return 105
        } else {
            return UITableView.automaticDimension
        }
    }
    
    var thArray = ["Theme", "Text Size", "Pinch and History View Background", "Toot Bar Hue", "Activity Graph Hue"]
    var thArrayDesc = ["Select from a white day theme, a dark dusk theme, an even darker night theme, a truly black OLED-friendly theme, or a midnight blue theme.", "Always be able to read posts with adjustable text sizing.", "Select a theme for the background when pinching to toot a screenshot, or when long-holding a back button to enter the history view.", "Select the hue for the keyboard bar when composing toots.", "Select the hue for the activity graph columns."]
    var thArrayIm = ["setnight", "settext", "pinchset", "barcol", "acthue"]
    
    var tiArray = ["Swipe Action Order", "Activity Graph", "Activity Graph Animation", "Toot Action Placement", "Full Usernames", "Full Usernames in Boosts", "Time Style", "Subtle Activity Notifications", "Highlight Direct Messages", "Hide Images"]
    var tiArrayDesc = ["Select the order of swipe action elements.", "Display an activity graph showing recent activity in the mentions tab.", "Animate the activity graph when displaying it.", "Choose whether to display toot actions on the toot cell or behind a swipe. This will require restarting the app to take effect.", "Display the user's full username, with the instance, in toots.", "Display the user's full username in boosts.", "Pick between displaying absolute or relative time in timelines.", "Dim activity notification text, whilst keeping mentions untouched.", "Highlight direct messages in timelines with a subtle, distinct, or themed background.", "Timelines without media, for a distraction-free browsing experience."]
    var tiArrayIm = ["swipeact3", "setgraph", "setgraph2", "like", "userat", "userat2", "timese", "subtleno", "direct23", "setima2"]
    
    var prArray = ["Profile Corner Radius", "Profile Header Background", "Profile Display Picture Border", "Profile Display Picture in Toot Composition"]
    var prArrayDesc = ["Circle or square, your choice.", "Change the style of the profile header background.", "Select a size for the border around display pictures.", "Choose whether to display the current account's display picture in the top-left when composing toots."]
    var prArrayIm = ["setpro", "headbgse", "bordset", "compav"]
    
    var meArray = ["Image Corner Radius", "Media Captions", "Media Gallery Columns", "Photos Gallery Columns"]
    var meArrayDesc = ["Rounded or not, your choice.", "Pick whether to display the toot text or the image's alt text in media captions.", "Pick the amount of columns for the media gallery grid.", "Pick the amount of columns for the toot composition photo picker gallery grid."]
    var meArrayIm = ["setima", "heavyse", "gridse", "gridse"]
    
    var seArray = ["Segment Size", "Segment Transition Style", "Segment Hue"]
    var seArrayDesc = ["Choose from larger home and notification section segments, or tinier ones.", "Pick between a static transition, or a playful liquid one.", "Select the hue for segments. This may require restarting the app to take effect."]
    var seArrayIm = ["segse", "segse2", "seghue"]
    
    var otArray = ["Toot Progress Indicator", "Instances and Lists Icon", "Popup Alerts", "Confetti"]
    var otArrayDesc = ["Choose whether to show the toot progress indicator or not.", "Select an icon to use for the top-left instances and list section icon.", "Pick whether to display popup alerts for a variety of actions including tooting, liking, and boosting.", "Add some fun to posting toots, following users, boosting toots, and liking toots."]
    var otArrayIm = ["indic", "barcol10", "popupset", "confett"]
    
    @objc func handleToggleSelectGraph(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "setGraph")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refrefref"), object: self)
        } else {
            UserDefaults.standard.set(1, forKey: "setGraph")
            sender.setOn(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refrefref"), object: self)
        }
    }
    @objc func handleToggleSelectGraph2(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "setGraph2")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "setGraph2")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleHide(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "mentionToggle")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        } else {
            UserDefaults.standard.set(1, forKey: "mentionToggle")
            sender.setOn(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        }
    }
    @objc func handleToggleBoostusern(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "boostusern")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "boostusern")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleSubtle1(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "subtleToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "subtleToggle")
            sender.setOn(false, animated: true)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
    }
    @objc func handleToggleSensitive(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "sensitiveToggle")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        } else {
            UserDefaults.standard.set(0, forKey: "sensitiveToggle")
            sender.setOn(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        }
    }
    @objc func handleToggleCompav(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "compav")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "compav")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleTogglePopupset(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "popupset")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "popupset")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleNotif(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "notifToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "notifToggle")
            sender.setOn(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appcell", for: indexPath) as! AppIconsCells
            cell.configure()
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            cell.frame.size.width = 60
            cell.frame.size.height = 60
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "colcell", for: indexPath) as! ColourCells
            cell.configure()
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            cell.frame.size.width = 60
            cell.frame.size.height = 60
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
            cell.configure(status: thArray[indexPath.row], status2: thArrayDesc[indexPath.row], image: thArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell
        } else if indexPath.section == 3 {
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse2", for: indexPath) as! SettingsCellToggle
                cell.configure(status: tiArray[indexPath.row], status2: tiArrayDesc[indexPath.row], image: tiArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 1 {
                    if (UserDefaults.standard.object(forKey: "setGraph") == nil) || (UserDefaults.standard.object(forKey: "setGraph") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectGraph), for: .touchUpInside)
                }
                if indexPath.row == 2 {
                    if (UserDefaults.standard.object(forKey: "setGraph2") == nil) || (UserDefaults.standard.object(forKey: "setGraph2") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectGraph2), for: .touchUpInside)
                }
                if indexPath.row == 4 {
                    if (UserDefaults.standard.object(forKey: "mentionToggle") == nil) || (UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleHide), for: .touchUpInside)
                }
                if indexPath.row == 5 {
                    if (UserDefaults.standard.object(forKey: "boostusern") == nil) || (UserDefaults.standard.object(forKey: "boostusern") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleBoostusern), for: .touchUpInside)
                }
                if indexPath.row == 7 {
                    if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSubtle1), for: .touchUpInside)
                }
                if indexPath.row == 9 {
                    if (UserDefaults.standard.object(forKey: "sensitiveToggle") == nil) || (UserDefaults.standard.object(forKey: "sensitiveToggle") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSensitive), for: .touchUpInside)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                cell.configure(status: tiArray[indexPath.row], status2: tiArrayDesc[indexPath.row], image: tiArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        } else if indexPath.section == 4 {
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse23", for: indexPath) as! SettingsCellToggle
                cell.configure(status: prArray[indexPath.row], status2: prArrayDesc[indexPath.row], image: prArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 3 {
                    if (UserDefaults.standard.object(forKey: "compav") == nil) || (UserDefaults.standard.object(forKey: "compav") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleCompav), for: .touchUpInside)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                cell.configure(status: prArray[indexPath.row], status2: prArrayDesc[indexPath.row], image: prArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
            cell.configure(status: meArray[indexPath.row], status2: meArrayDesc[indexPath.row], image: meArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell
        } else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
            cell.configure(status: seArray[indexPath.row], status2: seArrayDesc[indexPath.row], image: seArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell
        } else if indexPath.section == 7 {
            if indexPath.row == 2 || indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse234", for: indexPath) as! SettingsCellToggle
                cell.configure(status: otArray[indexPath.row], status2: otArrayDesc[indexPath.row], image: otArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 2 {
                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleTogglePopupset), for: .touchUpInside)
                }
                if indexPath.row == 3 {
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleNotif), for: .touchUpInside)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                cell.configure(status: otArray[indexPath.row], status2: otArrayDesc[indexPath.row], image: otArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
            cell.configure(status: thArray[indexPath.row], status2: thArrayDesc[indexPath.row], image: thArrayIm[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "theme") == nil) || (UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "theme") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "theme") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "theme") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                }
                
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Day".localized), image: filledSet1) { (action, ind) in
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "light"), object: self)
                    }
                    .action(.default("Dusk".localized), image: filledSet2) { (action, ind) in
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "night"), object: self)
                    }
                    .action(.default("Night".localized), image: filledSet3) { (action, ind) in
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "night2"), object: self)
                    }
                    .action(.default("Midnight".localized), image: filledSet4) { (action, ind) in
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "black"), object: self)
                    }
                    .action(.default("Midnight Blue".localized), image: filledSet5) { (action, ind) in
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "midblue"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 1 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                var filledSet6 = UIImage(named: "unfilledset")
                var filledSet7 = UIImage(named: "unfilledset")
                var filledSet8 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "systemText") == nil) || (UserDefaults.standard.object(forKey: "systemText") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 0) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "filledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 5) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "filledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 6) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "filledset")
                }
                
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("System Text Size".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "systemText")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("8 Points".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(0, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("9 Points".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(1, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("10 Points".localized), image: filledSet4) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(2, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("11 Points".localized), image: filledSet5) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(3, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("12 Points".localized), image: filledSet6) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(4, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("13 Points".localized), image: filledSet7) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(5, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("14 Points".localized), image: filledSet8) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(6, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 2 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "screenshotcol") == nil) || (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                }
                
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Theme".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "screenshotcol")
                    }
                    .action(.default("Dusk".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "screenshotcol")
                    }
                    .action(.default("Night".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "screenshotcol")
                    }
                    .action(.default("Midnight".localized), image: filledSet4) { (action, ind) in
                        
                        UserDefaults.standard.set(3, forKey: "screenshotcol")
                    }
                    .action(.default("Midnight Blue".localized), image: filledSet5) { (action, ind) in
                        
                        UserDefaults.standard.set(4, forKey: "screenshotcol")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 3 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "barhue1") == nil) || (UserDefaults.standard.object(forKey: "barhue1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "barhue1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Theme Hue".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "barhue1")
                    }
                    .action(.default("Subtle".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "barhue1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 4 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "acthue1") == nil) || (UserDefaults.standard.object(forKey: "acthue1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "acthue1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Theme Hue".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "acthue1")
                    }
                    .action(.default("Subtle".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "acthue1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                var filledSet6 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "sworder") == nil) || (UserDefaults.standard.object(forKey: "sworder") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 5) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Reply Like Boost".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "sworder")
                    }
                    .action(.default("Reply Boost Like".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "sworder")
                    }
                    .action(.default("Boost Reply Like".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "sworder")
                    }
                    .action(.default("Boost Like Reply".localized), image: filledSet4) { (action, ind) in
                        
                        UserDefaults.standard.set(3, forKey: "sworder")
                    }
                    .action(.default("Like Reply Boost".localized), image: filledSet5) { (action, ind) in
                        
                        UserDefaults.standard.set(4, forKey: "sworder")
                    }
                    .action(.default("Like Boost Reply".localized), image: filledSet6) { (action, ind) in
                        
                        UserDefaults.standard.set(5, forKey: "sworder")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 3))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 3 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "tootpl") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Swipe Cells to Display Actions".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "tootpl")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Actions on Toot Cells".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "tootpl")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 3))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 6 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "timerel") == nil) || (UserDefaults.standard.object(forKey: "timerel") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "timerel") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Absolute".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "timerel")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.default("Relative".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "timerel")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 3))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 8 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "dmTog") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "dmTog") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "dmTog") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("None".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "dmTog")
                    }
                    .action(.default("Subtle".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "dmTog")
                    }
                    .action(.default("Distinct".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "dmTog")
                    }
                    .action(.default("Theme".localized), image: filledSet4) { (action, ind) in
                        
                        UserDefaults.standard.set(3, forKey: "dmTog")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 3))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "proCorner") == nil) || (UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Circle".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "proCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.default("Rounded Square".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "proCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.default("Square".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "proCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 4))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 1 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "headbg1") == nil) || (UserDefaults.standard.object(forKey: "headbg1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "headbg1") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "headbg1") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Light".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "headbg1")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Regular".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "headbg1")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Dark".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(3, forKey: "headbg1")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 4))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 2 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "bord") == nil) || (UserDefaults.standard.object(forKey: "bord") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "bord") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "bord") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("None".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "bord")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Mild".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "bord")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Wild".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "bord")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 4))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 5 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "imCorner") == nil) || (UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Rounded Rectangle".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "imCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.default("Rectangle".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "imCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 5))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 1 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "captionset") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "captionset") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Toot Text".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "captionset")
                    }
                    .action(.default("Image Alt Text".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "captionset")
                    }
                    .action(.default("No Caption".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "captionset")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 5))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 2 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "medcolgrid") == nil) || (UserDefaults.standard.object(forKey: "medcolgrid") as! Int == 0) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "medcolgrid") as! Int == 1) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "medcolgrid") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("2 Columns".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "medcolgrid")
                    }
                    .action(.default("3 Columns".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "medcolgrid")
                    }
                    .action(.default("4 Columns".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "medcolgrid")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 5))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 3 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "colgrid") == nil) || (UserDefaults.standard.object(forKey: "colgrid") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "colgrid") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "colgrid") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("2 Column Grid".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "colgrid")
                    }
                    .action(.default("3 Column Grid".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "colgrid")
                    }
                    .action(.default("4 Column Grid".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "colgrid")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 5))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 6 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "segsize") == nil) || (UserDefaults.standard.object(forKey: "segsize") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "segsize") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Small".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "segsize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSeg"), object: self)
                    }
                    .action(.default("Large".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "segsize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSeg"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 6))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 1 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "segstyle") == nil) || (UserDefaults.standard.object(forKey: "segstyle") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "segstyle") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Static".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "segstyle")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSeg"), object: self)
                    }
                    .action(.default("Liquid".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "segstyle")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSeg"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 6))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 2 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "seghue1") == nil) || (UserDefaults.standard.object(forKey: "seghue1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "seghue1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Theme Hue".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "seghue1")
                    }
                    .action(.default("Subtle".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "seghue1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 6))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 7 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "progprogprogprog") == nil) || (UserDefaults.standard.object(forKey: "progprogprogprog") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "progprogprogprog") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Hidden".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "progprogprogprog")
                    }
                    .action(.default("Displayed".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "progprogprogprog")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 7))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 1 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "insicon1") == nil) || (UserDefaults.standard.object(forKey: "insicon1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "insicon1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("List Icon".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "insicon1")
                    }
                    .action(.default("Profile Icon".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "insicon1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 7))?.contentView ?? self.view)
                    .show(on: self)
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
