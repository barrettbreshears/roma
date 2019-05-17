//
//  EndorsedViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 27/01/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SJFluidSegmentedControl
import StatusAlert

class EndorsedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .ballRotateChase, color: Colours.tabSelected)
    var segmentedControl: SJFluidSegmentedControl!
    var tableView = UITableView()
    var currentIndex = 0
    var profileStatus = ""
    var statusFollows: [Account] = []
    var doOnce = false
    var doOnce2 = false
    var newLast: RequestRange = .max(id: "", limit: nil)
    var newLast2: RequestRange = .max(id: "", limit: nil)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Endorsed"
        self.removeTabbarItemsText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        self.ai.frame = CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2, width: 40, height: 40)
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
        
        self.tableView.register(FollowersCell.self, forCellReuseIdentifier: "cellf")
        self.tableView.frame = CGRect(x: 0, y: Int(offset + 0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 0)
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
        
//        self.fetchFollows()
        self.loadLoadLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
        case .pad:
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            
            let request = Accounts.allEndorsements()
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        self.statusFollows = stat
                        self.loadLoadLoad()
                    }
                }
            }
        default:
            print("nothing")
        }
        
        StoreStruct.currentPage = 87
    }
    
    
    // Table stuff
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let title = UILabel()
        title.frame = CGRect(x: 10, y: 8, width: self.view.bounds.width, height: 30)
        if self.statusFollows.count == 0 {
            title.text = "No Endorsed Accounts"
        } else {
            title.text = "Endorsed Accounts"
        }
        title.textColor = Colours.grayDark2
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusFollows.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.statusFollows.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellf", for: indexPath) as! FollowersCell
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
            cell.selectedBackgroundView = bgColorView
            return cell
        } else {
            
            if indexPath.row == self.statusFollows.count - 1 {
                self.fetchFollows()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellf", for: indexPath) as! FollowersCell
            cell.configure(self.statusFollows[indexPath.row])
            cell.profileImageView.tag = indexPath.row
            cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.grayDark.withAlphaComponent(0.38)
            cell.toot.textColor = Colours.grayDark.withAlphaComponent(0.74)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
            cell.selectedBackgroundView = bgColorView
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var sto = self.statusFollows
        
        if orientation == .right {
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
                    .action(.default("Pinned".localized), image: UIImage(named: "pinned")) { (action, ind) in
                        
                        
                        let controller = PinnedViewController()
                        controller.currentTagTitle = "Pinned"
                        controller.curID = sto[indexPath.row].id
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    .action(.default("Mention".localized), image: UIImage(named: "reply2")) { (action, ind) in
                        
                        
                        let controller = ComposeViewController()
                        controller.inReplyText = sto[indexPath.row].acct
                        self.present(controller, animated: true, completion: nil)
                    }
                    .action(.default("Direct Message".localized), image: UIImage(named: "direct3")) { (action, ind) in
                        
                        
                        let controller = ComposeViewController()
                        controller.inReplyText = sto[indexPath.row].acct
                        controller.profileDirect = true
                        self.present(controller, animated: true, completion: nil)
                    }
                    .action(.default("Follow/Unfollow"), image: UIImage(named: "profile")) { (action, ind) in
                        
                        let chosen = sto[indexPath.row]
                        let request02 = Accounts.relationships(ids: [StoreStruct.currentUser.id, chosen.id])
                        StoreStruct.client.run(request02) { (statuses) in
                            if let stat = (statuses.value) {
                                if stat[1].following {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Unfollowed".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = sto[indexPath.row].displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }
                                    
                                    let request = Accounts.unfollow(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            
                                        }
                                    }
                                } else {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    
                                    if sto[indexPath.row].locked {
                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Follow Request Sent".localized
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = sto[indexPath.row].displayName
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                            statusAlert.show()
                                        }
                                    } else {
                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Followed".localized
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = sto[indexPath.row].displayName
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                            statusAlert.show()
                                        }
                                    }
                                    
                                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                                    }
                                    
                                    let request = Accounts.follow(id: sto[indexPath.row].id, reblogs: true)
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    // change below endorse
                    .action(.default("Endorse"), image: UIImage(named: "endo")) { (action, ind) in
                        
                        let request00 = Accounts.allEndorsements()
                        StoreStruct.client.run(request00) { (statuses) in
                            if let stat = (statuses.value) {
                                let chosen = sto[indexPath.row]
                                let s = stat.filter { $0.id == chosen.id }
                                if s.isEmpty {
                                    let request = Accounts.endorse(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            DispatchQueue.main.async {
                                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                    let notification = UINotificationFeedbackGenerator()
                                                    notification.notificationOccurred(.success)
                                                }
                                                let statusAlert = StatusAlert()
                                                statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                                                statusAlert.title = "Endorsed".localized
                                                statusAlert.contentColor = Colours.grayDark
                                                statusAlert.message = sto[indexPath.row].displayName
                                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                                    statusAlert.show()
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    let request = Accounts.endorseRemove(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            DispatchQueue.main.async {
                                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                    let notification = UINotificationFeedbackGenerator()
                                                    notification.notificationOccurred(.success)
                                                }
                                                let statusAlert = StatusAlert()
                                                statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                                                statusAlert.title = "Removed Endorsement".localized
                                                statusAlert.contentColor = Colours.grayDark
                                                statusAlert.message = sto[indexPath.row].displayName
                                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                                    statusAlert.show()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .action(.default("Add to a List".localized), image: UIImage(named: "list")) { (action, ind) in
                        
                        let request = Lists.all()
                        StoreStruct.client.run(request) { (statuses) in
                            if let stat = (statuses.value) {
                                StoreStruct.allLists = stat
                                StoreStruct.allLists.map({
                                    var zzz: [String:String] = [:]
                                    zzz[$0.title] = $0.id
                                    
                                    let z1 = Alertift.actionSheet()
                                        .backgroundColor(Colours.white)
                                        .titleTextColor(Colours.grayDark)
                                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                                        .messageTextAlignment(.left)
                                        .titleTextAlignment(.left)
                                        .action(.cancel("Dismiss"))
                                        .finally { action, index in
                                            if action.style == .cancel {
                                                return
                                            }
                                    }
                                    zzz.map({
                                        let aa = $0
                                        z1.action(.default($0.key), image: nil) { (action, ind) in
                                            let request = Lists.add(accountIDs: [sto[indexPath.row].id], toList: aa.value)
                                            StoreStruct.client.run(request) { (statuses) in
                                                DispatchQueue.main.async {
                                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                        let notification = UINotificationFeedbackGenerator()
                                                        notification.notificationOccurred(.success)
                                                    }
                                                    let statusAlert = StatusAlert()
                                                    statusAlert.image = UIImage(named: "listbig")?.maskWithColor(color: Colours.grayDark)
                                                    statusAlert.title = "Added".localized
                                                    statusAlert.contentColor = Colours.grayDark
                                                    statusAlert.message = sto[indexPath.row].displayName
                                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                                        statusAlert.show()
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    })
                                    
                                    if zzz.count == 0 {
                                        z1.action(.default("Create New List"), image: nil) { (action, ind) in
                                            let controller = NewListViewController()
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                    }
                                    
                                    z1.popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
                                    z1.show(on: self, completion: nil)
                                })
                            }
                        }
                        
                    }
                    .action(.default("Mute/Unmute"), image: UIImage(named: "block")) { (action, ind) in
                        
                        let request0 = Mutes.all()
                        StoreStruct.client.run(request0) { (statuses) in
                            if let stat = (statuses.value) {
                                let chosen = sto[indexPath.row]
                                let s = stat.filter { $0.id == chosen.id }
                                if s.isEmpty {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Muted".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = sto[indexPath.row].displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }
                                    
                                    let request = Accounts.mute(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            
                                            
                                        }
                                    }
                                } else {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Unmuted".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = sto[indexPath.row].displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }
                                    
                                    let request = Accounts.unmute(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .action(.default("Block/Unblock"), image: UIImage(named: "block2")) { (action, ind) in
                        
                        let request01 = Blocks.all()
                        StoreStruct.client.run(request01) { (statuses) in
                            if let stat = (statuses.value) {
                                let chosen = sto[indexPath.row]
                                let s = stat.filter { $0.id == chosen.id }
                                if s.isEmpty {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "block2large")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Blocked".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = sto[indexPath.row].displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }
                                    
                                    let request = Accounts.block(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            
                                            
                                        }
                                    }
                                } else {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "block2large")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Unblocked".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = sto[indexPath.row].displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }
                                    
                                    let request = Accounts.unblock(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .action(.default("Share Profile".localized), image: UIImage(named: "share")) { (action, ind) in
                        
                        
                        
                        Alertift.actionSheet()
                            .backgroundColor(Colours.white)
                            .titleTextColor(Colours.grayDark)
                            .messageTextColor(Colours.grayDark)
                            .messageTextAlignment(.left)
                            .titleTextAlignment(.left)
                            .action(.default("Share Link".localized), image: UIImage(named: "share")) { (action, ind) in
                                
                                
                                let objectsToShare = [sto[indexPath.row].url]
                                let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                vc.popoverPresentationController?.sourceView = self.view
                                vc.previewNumberOfLines = 5
                                vc.previewFont = UIFont.systemFont(ofSize: 14)
                                self.present(vc, animated: true, completion: nil)
                            }
                            .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                                
                                
                                let controller = NewQRViewController()
                                controller.ur = sto[indexPath.row].displayName
                                self.present(controller, animated: true, completion: nil)
                                
                            }
                            .action(.cancel("Dismiss"))
                            .finally { action, index in
                                if action.style == .cancel {
                                    return
                                }
                            }
                            .show(on: self)
                        
                        
                        
                        
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
                    .show(on: self)
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! FollowersCell
                    cell.hideSwipe(animated: true)
                }
                
            }
            
            more.backgroundColor = Colours.white
            more.image = UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected)
            more.transitionDelegate = ScaleTransition.default
            more.textColor = Colours.tabUnselected
            return [more]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        if (UserDefaults.standard.object(forKey: "selectSwipe") == nil) || (UserDefaults.standard.object(forKey: "selectSwipe") as! Int == 0) {
            options.expansionStyle = .selection
        } else {
            options.expansionStyle = .none
        }
        options.transitionStyle = .drag
        options.buttonSpacing = 0
        options.buttonPadding = 0
        options.maximumButtonWidth = 60
        options.backgroundColor = Colours.white
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = ThirdViewController()
        controller.fromOtherUser = true
        controller.userIDtoUse = self.statusFollows[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didTouchProfile(sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
    }
    
    var lastThing = ""
    func fetchFollows() {
        if self.newLast == RequestRange.max(id: "0", limit: nil) {
            return
        }
        let request = Accounts.following(id: self.profileStatus, range: self.newLast)
        StoreStruct.client.run(request) { (statuses) in
            self.newLast = statuses.pagination?.next ?? RequestRange.max(id: "0", limit: nil) as! RequestRange
            if let stat = (statuses.value) {
                
                if stat.isEmpty {} else {
                    self.lastThing = stat.first?.id ?? ""
                    self.statusFollows = self.statusFollows + stat
                    DispatchQueue.main.async {
                        self.statusFollows = self.statusFollows.removeDuplicates()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    var lastThing2 = ""
    func fetchFollowers() {
        if self.newLast2 == RequestRange.max(id: "0", limit: nil) {
            return
        }
        let request = Accounts.followers(id: self.profileStatus, range: self.newLast2)
        StoreStruct.client.run(request) { (statuses) in
            self.newLast2 = statuses.pagination?.next ?? RequestRange.max(id: "0", limit: nil) as! RequestRange
            if let stat = (statuses.value) {
                
                if stat.isEmpty {} else {
                    self.lastThing2 = stat.first?.id ?? ""
                    self.statusFollows = self.statusFollows + stat
                    DispatchQueue.main.async {
                        self.statusFollows = self.statusFollows.removeDuplicates()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    
    
    func loadLoadLoad() {
        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            Colours.white = UIColor.white
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
        
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.grayDark.withAlphaComponent(0.21)
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        //        var customStyle = VolumeBarStyle.likeInstagram
        //        customStyle.trackTintColor = Colours.cellQuote
        //        customStyle.progressTintColor = Colours.grayDark
        //        customStyle.backgroundColor = Colours.cellNorm
        //        volumeBar.style = customStyle
        //        volumeBar.start()
        //
        //        self.missingView.image = UIImage(named: "missing")?.maskWithColor(color: Colours.tabUnselected)
        //
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.grayDark]
        //        self.collectionView.backgroundColor = Colours.white
        //        self.removeTabbarItemsText()
    }
    
    
}


