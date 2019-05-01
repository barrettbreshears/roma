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
import Disk

class GeneralSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPhotoBrowserDelegate, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate {
    
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
        
        self.title = "General"
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
        self.tableView.register(SettingsCell3.self, forCellReuseIdentifier: "cellse3")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse2")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse23")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse234")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse2345")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse23456")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse234567")
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
            title.text = "Timeline"
        } else if section == 1 {
            title.text = "Profile"
        } else if section == 2 {
            title.text = "Toots"
        } else if section == 3 {
            title.text = "Media"
        } else if section == 4 {
            title.text = "Keyboard"
        } else if section == 5 {
            title.text = "Gestures"
        } else if section == 6 {
            title.text = "Other"
        } else {
            title.text = "Danger Zone"
        }
        title.textColor = Colours.grayDark.withAlphaComponent(0.38)
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tiArray.count
        } else if section == 1 {
            return prArray.count
        } else if section == 2 {
            return toArray.count
        } else if section == 3 {
            return meArray.count
        } else if section == 4 {
            return keArray.count
        } else if section == 5 {
            return geArray.count
        } else if section == 6 {
            return otArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    var tiArray = ["Realtime Updates", "Always display sensitive content", "Toot Load Position", "Load More Order", "Automatically Load Gaps", "Initial Timeline", "Default Mentions Tab"]
    var tiArrayDesc = ["No need to refresh manually, you'll get the latest toots pushed to you.", "Sensitive content will always be displayed without a content warning overlay.", "Choose whether to retain the timeline scroll position when streaming and pulling to refresh, or to scroll to the top.", "Select whether tapping the 'load more' button in timelines retains the current scroll position (allowing the new toots to be read downwards), or whether it shifts you to just below the newly loaded toots (allowing the new toots to be read upwards).", "Automatically fetch gaps in between timelines, removing the need to tap the 'load more' buttons.", "Pick the initial timeline to be displayed, whether it's home, local, or all.", "Switch to either show mentions or activity by default."]
    var tiArrayIm = ["setreal", "setsensitivec", "posse", "lmore", "autol", "segse", "actdef"]
    
    var prArray = ["Display Boosts in Profiles", "Default Profile Secondary Button"]
    var prArrayDesc = ["Display boosted toots in the Toots & Replies section of user profiles.", "Select what action the secondary profile button (on the left of the profile image) should do: View liked toots or view pinned toots."]
    var prArrayIm = ["boost", "likepin"]
    
    var toArray = ["Default Toot Privacy", "Emoticon Suggestions"]
    var toArrayDesc = ["Select a default privacy state for you toots, from public (everyone can see), unlisted (everyone apart from local and federated timelines can see), private (followers and mentioned users can see), and direct (only to the mentioned user).", "Choose whether to allow emoticon suggestions when composing toots."]
    var toArrayIm = ["biolock2", "setemot"]
    
    var meArray = ["Image Upload Quality", "Recent Media Swipe Type", "Default Video Container", "Link Previews"]
    var meArrayDesc = ["Pick the quality of images uploaded when composing toots. A higher quality image may take longer to upload.", "Pick whether swiping enlarged recent media images scrolls through all attached media in the specified toot and does nothing if there's a single image, or whether it scrolls through all recent media.", "Choose whether to show videos and GIFs in a custom Picture-in-Picture container which can be swiped down to keep the view around, or in the stock media player, where swiping down dismisses the content.", "Choose whether to display link preview cards in toot details for the attached link within the toot."]
    var meArrayIm = ["comse", "heavyse", "setvid", "linkcard"]
    
    var keArray = ["Default Keyboard Style", "Keyboard Haptics"]
    var keArrayDesc = ["Choose from a convenient social keyboard that puts the @ and # keys front and centre, or the default keyboard with a return key.", "Set haptic feedback for key presses on the keyboard."]
    var keArrayIm = ["keybse", "keyhap"]
    
    var geArray = ["Shake Gesture", "Long-Hold Anywhere Action", "Long Swipe Selection", "Tilt Depth"]
    var geArrayDesc = ["Select whether to hide sensitive content, rain confetti, or do nothing when shaking your device.", "Select what happens when you long-hold anywhere in the app.", "Swipe all the way left or right on a toot to select the action on the edge.", "Tilt the device to emulate a sense of depth. This may require restarting the app to take effect."]
    var geArrayIm = ["setshake", "holdse", "swipeact", "holdse"]
    
    var otArray = ["Haptic Feedback", "User Search Scope", "Thumb Scroller", "Links Destination", "Direct Messages View Style", "URL Schemes"]
    var otArrayDesc = ["Get a responsive little vibration when tapping buttons and other on-screen elements.", "Pick whether searching for users is across all of Mastodon or just local.", "Display a circular thumb scroller on timelines, which allows you to rotate the scroller with your thumb to navigate through timelines without lifting a finger. This may require restarting the app to take effect.", "Pick whether to open links in-app, or in Safari.", "Choose whether to open direct messages in the mentions tab in a chat-style view or a toot-style view.", "Use these to do specific actions within the app from outside the app."]
    var otArrayIm = ["sethap", "searchscope", "circscroll", "schemes", "direct23", "schemes"]
    
    @objc func handleToggleStream(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "streamToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "streamToggle")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleSensitiveMain(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "senseTog")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        } else {
            UserDefaults.standard.set(0, forKey: "senseTog")
            sender.setOn(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        }
    }
    @objc func handleToggleAutol(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "autol1")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "autol1")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleSelectBoost3(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "boostpro3")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "boostpro3")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleEmotiSug(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "emotisug")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "emotisug")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleLinkcards(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "linkcards")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "linkcards")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleSelectSwipe(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "selectSwipe")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "selectSwipe")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleHaptic(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "hapticToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "hapticToggle")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleThumbsc(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "thumbsc")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "activateCrown"), object: self)
        } else {
            UserDefaults.standard.set(0, forKey: "thumbsc")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleDepth(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "depthToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "depthToggle")
            sender.setOn(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse2", for: indexPath) as! SettingsCellToggle
                cell.configure(status: tiArray[indexPath.row], status2: tiArrayDesc[indexPath.row], image: tiArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 0 {
                    if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleStream), for: .touchUpInside)
                }
                if indexPath.row == 1 {
                    if (UserDefaults.standard.object(forKey: "senseTog") == nil) || (UserDefaults.standard.object(forKey: "senseTog") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSensitiveMain), for: .touchUpInside)
                }
                if indexPath.row == 4 {
                    if (UserDefaults.standard.object(forKey: "autol1") == nil) || (UserDefaults.standard.object(forKey: "autol1") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleAutol), for: .touchUpInside)
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
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse23", for: indexPath) as! SettingsCellToggle
                cell.configure(status: prArray[indexPath.row], status2: prArrayDesc[indexPath.row], image: prArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 0 {
                    if (UserDefaults.standard.object(forKey: "boostpro3") == nil) || (UserDefaults.standard.object(forKey: "boostpro3") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectBoost3), for: .touchUpInside)
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
        } else if indexPath.section == 2 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse234", for: indexPath) as! SettingsCellToggle
                cell.configure(status: toArray[indexPath.row], status2: toArrayDesc[indexPath.row], image: toArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 1 {
                    if (UserDefaults.standard.object(forKey: "emotisug") == nil) || (UserDefaults.standard.object(forKey: "emotisug") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleEmotiSug), for: .touchUpInside)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                cell.configure(status: toArray[indexPath.row], status2: toArrayDesc[indexPath.row], image: toArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse2345", for: indexPath) as! SettingsCellToggle
                cell.configure(status: meArray[indexPath.row], status2: meArrayDesc[indexPath.row], image: meArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 3 {
                    if (UserDefaults.standard.object(forKey: "linkcards") == nil) || (UserDefaults.standard.object(forKey: "linkcards") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleLinkcards), for: .touchUpInside)
                }
                return cell
            } else {
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
            }
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
            cell.configure(status: keArray[indexPath.row], status2: keArrayDesc[indexPath.row], image: keArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell
        } else if indexPath.section == 5 {
            if indexPath.row == 2 || indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse23456", for: indexPath) as! SettingsCellToggle
                cell.configure(status: geArray[indexPath.row], status2: geArrayDesc[indexPath.row], image: geArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 2 {
                    if (UserDefaults.standard.object(forKey: "selectSwipe") == nil) || (UserDefaults.standard.object(forKey: "selectSwipe") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectSwipe), for: .touchUpInside)
                }
                if indexPath.row == 3 {
                    if (UserDefaults.standard.object(forKey: "depthToggle") == nil) || (UserDefaults.standard.object(forKey: "depthToggle") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleDepth), for: .touchUpInside)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                cell.configure(status: geArray[indexPath.row], status2: geArrayDesc[indexPath.row], image: geArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        } else if indexPath.section == 6 {
            if indexPath.row == 0 || indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse234567", for: indexPath) as! SettingsCellToggle
                cell.configure(status: otArray[indexPath.row], status2: otArrayDesc[indexPath.row], image: otArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 0 {
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleHaptic), for: .touchUpInside)
                }
                if indexPath.row == 2 {
                    if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleThumbsc), for: .touchUpInside)
                }
                return cell
            } else {
                if indexPath.row == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse1", for: indexPath) as! SettingsCell2
                    cell.configure(status: otArray[indexPath.row], status2: otArrayDesc[indexPath.row], image: otArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
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
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse3", for: indexPath) as! SettingsCell3
            cell.configure(status: "Reset App", status2: "Resetting the app will clear all content and data, remove all accounts, and return you to the log-in screen.")
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
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "posset") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Retain Scroll Position".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "posset")
                    }
                    .action(.default("Scroll to the Top".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "posset")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 3 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "lmore1") == nil) || (UserDefaults.standard.object(forKey: "lmore1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "lmore1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Retain Scroll Position".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "lmore1")
                    }
                    .action(.default("Jump Below New Toots".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "lmore1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 5 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "inittimeline") == nil) || (UserDefaults.standard.object(forKey: "inittimeline") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "inittimeline") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "inittimeline") as! Int == 2) {
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
                    .action(.default("Home".localized), image: filledSet1) { (action, ind) in
                        
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(0, forKey: "inittimeline")
                    }
                    .action(.default("Local".localized), image: filledSet2) { (action, ind) in
                        
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(1, forKey: "inittimeline")
                    }
                    .action(.default("All".localized), image: filledSet3) { (action, ind) in
                        
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(2, forKey: "inittimeline")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 6 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "mentdef2") == nil) || (UserDefaults.standard.object(forKey: "mentdef2") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "mentdef2") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("@You".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "mentdef2")
                    }
                    .action(.default("Activity".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "mentdef2")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "likepin") == nil) || (UserDefaults.standard.object(forKey: "likepin") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "likepin") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "likepin") as! Int == 2) {
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
                    .action(.default("Liked".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "likepin")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    }
                    .action(.default("Pinned".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "likepin")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    }
                    .action(.default("Edit Profile".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "likepin")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "privToot") == nil) || (UserDefaults.standard.object(forKey: "privToot") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 3) {
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
                    .action(.default("Public".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "privToot")
                    }
                    .action(.default("Unlisted".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "privToot")
                    }
                    .action(.default("Private".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "privToot")
                    }
                    .action(.default("Direct".localized), image: filledSet4) { (action, ind) in
                        
                        UserDefaults.standard.set(3, forKey: "privToot")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "imqual") == nil) || (UserDefaults.standard.object(forKey: "imqual") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "imqual") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "imqual") as! Int == 2) {
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
                    .action(.default("Low".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "imqual")
                    }
                    .action(.default("Average".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "imqual")
                    }
                    .action(.default("High".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "imqual")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 1 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "swrece") == nil) || (UserDefaults.standard.object(forKey: "swrece") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "swrece") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Swipe Attached Images".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "swrece")
                    }
                    .action(.default("Swipe Recent Media".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "swrece")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 2 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "vidgif") == nil) || (UserDefaults.standard.object(forKey: "vidgif") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "vidgif") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Stock Video Player".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "vidgif")
                    }
                    .action(.default("Custom Picture-in-Picture".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "vidgif")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "keyb") == nil) || (UserDefaults.standard.object(forKey: "keyb") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "keyb") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Social".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "keyb")
                    }
                    .action(.default("Default".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "keyb")
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
                if (UserDefaults.standard.object(forKey: "keyhap") == nil) || (UserDefaults.standard.object(forKey: "keyhap") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 2) {
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
                    .action(.default("Disabled".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "keyhap")
                    }
                    .action(.default("Mild".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "keyhap")
                    }
                    .action(.default("Wild".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "keyhap")
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
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "shakegest") == nil) || (UserDefaults.standard.object(forKey: "shakegest") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "shakegest") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "shakegest") as! Int == 2) {
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
                    .action(.default("Hide Sensitive Content".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "shakegest")
                    }
                    .action(.default("Rain Confetti".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "shakegest")
                    }
                    .action(.default("Do Nothing".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "shakegest")
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
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                var filledSet6 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "longToggle") == nil) || (UserDefaults.standard.object(forKey: "longToggle") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 6) {
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
                    .action(.default("Cycle Through Themes".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "longToggle")
                    }
                    .action(.default("Invoke Share Sheet".localized), image: filledSet4) { (action, ind) in
                        
                        UserDefaults.standard.set(3, forKey: "longToggle")
                    }
                    .action(.default("Invoke Lists".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "longToggle")
                    }
                    .action(.default("Invoke Search".localized), image: filledSet5) { (action, ind) in
                        
                        UserDefaults.standard.set(4, forKey: "longToggle")
                    }
                    .action(.default("Invoke Toot Composer".localized), image: filledSet3) { (action, ind) in
                        
                        UserDefaults.standard.set(2, forKey: "longToggle")
                    }
                    .action(.default("Do Nothing".localized), image: filledSet6) { (action, ind) in
                        
                        UserDefaults.standard.set(6, forKey: "longToggle")
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
        if indexPath.section == 6 {
            if indexPath.row == 1 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "searchsco") == nil) || (UserDefaults.standard.object(forKey: "searchsco") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "searchsco") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("All".localized), image: filledSet1) { (action, ind) in
                        
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(0, forKey: "searchsco")
                    }
                    .action(.default("Local".localized), image: filledSet2) { (action, ind) in
                        
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(1, forKey: "searchsco")
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
            if indexPath.row == 3 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "linkdest") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("In-app".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "linkdest")
                    }
                    .action(.default("Safari".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "linkdest")
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
            if indexPath.row == 4 {
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "dmchats") == nil) || (UserDefaults.standard.object(forKey: "dmchats") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "dmchats") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Chat Style".localized), image: filledSet1) { (action, ind) in
                        
                        UserDefaults.standard.set(0, forKey: "dmchats")
                    }
                    .action(.default("Toot Style".localized), image: filledSet2) { (action, ind) in
                        
                        UserDefaults.standard.set(1, forKey: "dmchats")
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
            if indexPath.row == 5 {
                let controller = SchemesSettingsViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        if indexPath.section == 7 {
            Alertift.actionSheet(title: "Are you sure?", message: "Resetting the app will clear all content and data, remove all accounts, and return you to the log-in screen.")
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.destructive("Reset App".localized), image: nil) { (action, ind) in
                    self.clearAll()
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
    
    func clearAll() {
        let appDomain: String? = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key == "PushNotificationState" || key == "PushNotificationReceiver" {} else {
                defaults.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(nil, forKey: "onb")
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
        StoreStruct.allLikes = []
        StoreStruct.allBoosts = []
        StoreStruct.allPins = []
        StoreStruct.photoNew = UIImage()
        StoreStruct.spoilerText = ""
        StoreStruct.typeOfSearch = 0
        StoreStruct.curID = ""
        StoreStruct.curIDNoti = ""
        StoreStruct.doOnce = true
        StoreStruct.isSplit = false
        StoreStruct.gapLastHomeID = ""
        StoreStruct.gapLastLocalID = ""
        StoreStruct.gapLastFedID = ""
        StoreStruct.gapLastHomeStat = nil
        StoreStruct.gapLastLocalStat = nil
        StoreStruct.gapLastFedStat = nil
        StoreStruct.newIDtoGoTo = ""
        StoreStruct.maxChars = 500
        StoreStruct.initTimeline = false
        StoreStruct.savedComposeText = ""
        StoreStruct.savedInReplyText = ""
        StoreStruct.hexCol = UIColor.white
        StoreStruct.historyBool = false
        StoreStruct.currentInstanceDetails = []
        StoreStruct.currentImageURL = URL(string: "www.google.com")
        StoreStruct.containsPoll = false
        StoreStruct.pollHeight = 0
        StoreStruct.currentPollSelection = []
        StoreStruct.currentPollSelectionTitle = ""
        StoreStruct.newPollPost = []
        StoreStruct.currentOptions = []
        StoreStruct.expiresIn = 86400
        StoreStruct.allowsMultiple = false
        StoreStruct.totalsHidden = false
        StoreStruct.pollPickerDate = Date()
        StoreStruct.composedTootText = ""
        StoreStruct.holdOnTempText = ""
        StoreStruct.tappedSignInCheck = false
        StoreStruct.markedReadIDs = []
        StoreStruct.newdrafts = []
        StoreStruct.notTypes = []
        
        do {
            try Disk.clear(.documents)
        } catch {
            print("couldn't clear disk")
        }
        
        let loginController = ViewController()
        loginController.createLoginView(newInstance: false)
        self.present(loginController, animated: true, completion: {
            loginController.textField.becomeFirstResponder()
        })
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
