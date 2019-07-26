//
//  ThirdViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage
import SafariServices
import StatusAlert
import SAConfettiView
import AVKit
import AVFoundation
import SJFluidSegmentedControl
import MessageUI
import CropViewController
import MobileCoreServices

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SKPhotoBrowserDelegate, UIViewControllerPreviewingDelegate, SJFluidSegmentedControlDataSource, SJFluidSegmentedControlDelegate, CrownControlDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, CropViewControllerDelegate, UITableViewDragDelegate {
    
    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .ballRotateChase, color: Colours.tabSelected)
    var safariVC: SFSafariViewController?
    var profileImageView = UIImageView()
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    var maybeDoOnce = false
    var searchButton = MNGExpandedTouchAreaButton()
    var chosenUser: Account!
    var profileStatuses: [Status] = []
    var profileStatuses2: [Status] = []
    var profileStatusesHasImage: [Status] = []
    var userIDtoUse = ""
    var fromOtherUser = false
    var isMuted = false
    var isBlocked = false
    var isFollowing = false
    var isFollowed = false
    var fo = "Follow".localized
    var isPeeking = false
    var segmentedControl: SJFluidSegmentedControl!
    var currentIndex = 0
    var isEndorsed = false
    var isShowingBoosts = true
    var zzz: [String:String] = [:]
    private var crownControl: CrownControl!
    var buttonCenter = CGPoint.zero
    var inArea = 0
    var cropViewController = CropViewController(image: UIImage())
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        var string = ""
        
        if self.currentIndex == 0 {
            string = self.profileStatuses[indexPath.row].url?.absoluteString ?? self.profileStatuses[indexPath.row].content.stripHTML()
        } else {
            string = self.profileStatuses2[indexPath.row].url?.absoluteString ?? self.profileStatuses2[indexPath.row].content.stripHTML()
        }
        
        guard let data = string.data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }
        guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
        guard indexPath.section == 2 else {return nil}
        let detailVC = DetailViewController()
        if self.currentIndex == 0 {
            detailVC.mainStatus.append(self.profileStatuses[indexPath.row])
        } else {
            detailVC.mainStatus.append(self.profileStatuses2[indexPath.row])
        }
        detailVC.isPeeking = true
        previewingContext.sourceRect = cell.frame
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }

    @objc func scrollTop3() {
        DispatchQueue.main.async {
            //if StoreStruct.profileStatuses.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            //}
        }
    }

    @objc func load() {
        DispatchQueue.main.async {
            self.loadLoadLoad()
        }
    }

    @objc func search() {
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone :
        let controller = DetailViewController()
        controller.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
        self.navigationController?.pushViewController(controller, animated: true)
            case .pad:
                let controller = DetailViewController()
                controller.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
                self.splitViewController?.showDetailViewController(controller, sender: self)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "splitload"), object: nil)
            default:
                print("nothing")
            }
    }

    @objc func searchUser() {
        let controller = ThirdViewController()
        controller.fromOtherUser = true
        controller.userIDtoUse = StoreStruct.statusSearchUser[StoreStruct.searchIndex].id
        self.navigationController?.pushViewController(controller, animated: true)
    }


    @objc func goLists() {
        DispatchQueue.main.async {
            let controller = ListViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @objc func goInstance() {
        let request = Timelines.public(local: true, range: .max(id: StoreStruct.newInstanceTags.last?.id ?? "", limit: 5000))
        let testClient = Client(
            baseURL: "https://\(StoreStruct.instanceText)",
            accessToken: StoreStruct.currentInstance.accessToken ?? ""
        )
        testClient.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    StoreStruct.newInstanceTags = stat
                    let controller = InstanceViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }

    @objc func updateProfileHere() {
        let request2 = Accounts.currentUser()
        StoreStruct.client.run(request2) {[weak self] (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.currentUser = stat
                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
                self?.chosenUser = stat
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    @objc func goMembers() {
        let request = Lists.accounts(id: StoreStruct.allListRelID)
        StoreStruct.client.run(request) {[weak self] (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    let controller = ListMembersViewController()
                    controller.currentTagTitle = "List Members".localized
                    controller.currentTags = stat
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }

    @objc func confettiCreate() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = true
        self.view.addSubview(confettiView)
        confettiView.intensity = 0.9
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                confettiView.removeFromSuperview()
            }
        }
    }

    @objc func confettiCreateRe() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = true
        self.view.addSubview(confettiView)
        confettiView.intensity = 0.9
        confettiView.colors = [UIColor(red: 89/250, green: 207/250, blue: 99/250, alpha: 1.0), UIColor(red: 84/250, green: 202/250, blue: 94/250, alpha: 1.0), UIColor(red: 79/250, green: 97/250, blue: 89/250, alpha: 1.0)]
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                confettiView.removeFromSuperview()
            }
        }
    }

    @objc func confettiCreateLi() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = true
        self.tableView.addSubview(confettiView)
        confettiView.intensity = 0.9
        confettiView.colors = [UIColor(red: 255/250, green: 177/250, blue: 61/250, alpha: 1.0), UIColor(red: 250/250, green: 172/250, blue: 56/250, alpha: 1.0), UIColor(red: 245/250, green: 168/250, blue: 51/250, alpha: 1.0)]
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                confettiView.removeFromSuperview()
            }
        }
    }

    @objc func fetchAllNewest() {
        self.setupProfile()
        self.refreshCont()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if let indexPath = tableView.indexPathForSelectedRow {
//            self.tableView.deselectRow(at: indexPath, animated: true)
//        }
        
        self.ai.startAnimating()
    }

    @objc func tappedOnTag() {
        if StoreStruct.tappedTag.contains("https") || StoreStruct.tappedTag.contains("http") || StoreStruct.tappedTag.contains("www.") {
            
            var theUR = StoreStruct.tappedTag
            if StoreStruct.tappedTag.contains("href=") {
                var x = StoreStruct.tappedTag.split(separator: "\"")
                theUR = String(x[1])
            }
            
            
            if let ur = URL(string: String(theUR)) {
                
                
                
                Alertift.actionSheet(title: nil, message: theUR)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark)
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)

                    .action(.default("Visit Link"), image: UIImage(named: "share")) { (action, ind) in
                         
                        
                        if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                        self.safariVC = SFSafariViewController(url: ur)
                        self.safariVC?.preferredBarTintColor = Colours.white
                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                        self.present(self.safariVC!, animated: true, completion: nil)
                        } else {
                            UIApplication.shared.openURL(ur)
                        }
                    }

                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
                    .show(on: self)


            }

        } else {
            
            Alertift.actionSheet(title: nil, message: StoreStruct.tappedTag)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark)
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
                .show(on: self)
        }
    }

    @objc func touchList() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "touchList"), object: nil)
    }

    @objc func setLeft() {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone :
                var settingsButton = MNGExpandedTouchAreaButton()
                settingsButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 15, y: 47, width: 32, height: 32)))
                settingsButton.setImage(UIImage(named: "list")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                settingsButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                settingsButton.adjustsImageWhenHighlighted = false
                settingsButton.addTarget(self, action: #selector(self.touchList), for: .touchUpInside)
        
                let done = UIBarButtonItem.init(customView: settingsButton)
                self.navigationItem.setLeftBarButton(done, animated: false)
        default:
            print("nil")
        }
        
    }

    @objc func refProf() {
        
        var tabHeight = 132
        var offset = 88
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
            case 2436, 1792:
                offset = 88
            default:
                offset = 64
                tabHeight = 98
            }
        }
        
        
        
        let request = Accounts.statuses(id: StoreStruct.currentUser.id, mediaOnly: true, pinnedOnly: nil, excludeReplies: true, excludeReblogs: true, range: .since(id: "", limit: 5000))
        StoreStruct.client.run(request) {[weak self] (statuses) in
            
            guard let ref = self else {
                return
            }
            
            if let stat = (statuses.value) {
                if stat.isEmpty {
                    DispatchQueue.main.async {
                        ref.profileStatusesHasImage = []
                        ref.tableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        ref.profileStatusesHasImage = stat
                        ref.tableView.reloadData()
                    }
                    let request2 = Accounts.statuses(id: StoreStruct.currentUser.id, mediaOnly: true, pinnedOnly: nil, excludeReplies: true, excludeReblogs: true, range: .max(id: stat.last?.id ?? "", limit: 5000))
                    StoreStruct.client.run(request2) { (statuses) in
                        if let stat = (statuses.value) {
                            if stat.isEmpty {
                                DispatchQueue.main.async {
                                    ref.profileStatusesHasImage = []
                                    ref.tableView.reloadData()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    ref.profileStatusesHasImage = ref.profileStatusesHasImage + stat
                                    ref.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        if self.fromOtherUser == true {
            let request = Accounts.statuses(id: self.userIDtoUse)
            StoreStruct.client.run(request) {[weak self] (statuses) in
                guard let ref = self else {
                    return
                }
                if let stat = (statuses.value) {
                    if stat.isEmpty {
                        
                        let request09 = Accounts.account(id: ref.userIDtoUse)
                        StoreStruct.client.run(request09) { (statuses) in
                            if let stat = (statuses.value) {
                                DispatchQueue.main.async {
                                    ref.chosenUser = stat
                                    ref.tableView.reloadData()
                                }
                            }
                        }

                    } else {
                        DispatchQueue.main.async {
                            ref.profileStatuses = stat
                            ref.chosenUser = ref.profileStatuses.first?.account ?? nil
                            
                            ref.ai.alpha = 0
                            ref.ai.removeFromSuperview()
                            ref.tableView.reloadData()
                            
                            if ref.chosenUser == nil {
                                let request9 = Accounts.account(id: ref.userIDtoUse)
                                StoreStruct.client.run(request9) { (statuses) in
                                    if let stat = (statuses.value) {
                                        DispatchQueue.main.async {
                                            ref.chosenUser = stat
                                            ref.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        } else {

            if StoreStruct.currentUser == nil {
                let request2 = Accounts.currentUser()
                StoreStruct.client.run(request2) {[weak self](statuses) in
                    if let stat = (statuses.value) {
                        StoreStruct.currentUser = stat
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
                        
                        guard let ref = self else {
                            return
                        }
                        
                        ref.userIDtoUse = StoreStruct.currentUser.id
                        let request = Accounts.statuses(id: StoreStruct.currentUser.id)
                        StoreStruct.client.run(request) { (statuses) in
                            if let stat = (statuses.value) {

                                if stat.isEmpty {

                                    DispatchQueue.main.async {
                                        ref.chosenUser = StoreStruct.currentUser
                                        ref.tableView.reloadData()
                                    }

                                } else {
                                    
                                    DispatchQueue.main.async {
                                        ref.profileStatuses = stat
                                        ref.chosenUser = ref.profileStatuses.first?.account ?? nil
                                        
                                        ref.ai.alpha = 0
                                        ref.ai.removeFromSuperview()
                                        ref.tableView.reloadData()
                                        
                                        if ref.chosenUser == nil {
                                            let request9 = Accounts.account(id: ref.userIDtoUse)
                                            StoreStruct.client.run(request9) { (statuses) in
                                                if let stat = (statuses.value) {
                                                    DispatchQueue.main.async {
                                                        ref.chosenUser = stat
                                                        ref.tableView.reloadData()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }

                            }
                        }

                    }
                }
            } else {


                self.userIDtoUse = StoreStruct.currentUser.id
                let request = Accounts.statuses(id: self.userIDtoUse)
                StoreStruct.client.run(request) { [weak self] (statuses) in
                    if let stat = (statuses.value) {

                        guard let ref = self else {
                            return
                        }
                        if stat.isEmpty {

                            DispatchQueue.main.async {
                                ref.chosenUser = StoreStruct.currentUser
                                ref.tableView.reloadData()
                            }

                        } else {
                            
                            DispatchQueue.main.async {
                                ref.profileStatuses = stat
                                ref.chosenUser = ref.profileStatuses.first?.account ?? nil
                                
                                ref.ai.alpha = 0
                                ref.ai.removeFromSuperview()
                                ref.tableView.reloadData()
                                
                                if ref.chosenUser == nil {
                                    let request9 = Accounts.account(id: ref.userIDtoUse)
                                    StoreStruct.client.run(request9) { (statuses) in
                                        if let stat = (statuses.value) {
                                            DispatchQueue.main.async {
                                                ref.chosenUser = stat
                                                ref.tableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }

                    }
                }


            }
        }
        
        self.tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func goToIDNoti() {
        sleep(2)
        let request = Notifications.notification(id: StoreStruct.curIDNoti)
        StoreStruct.client.run(request) {[weak self] (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    if let x = stat.status {
                        let controller = DetailViewController()
                        controller.mainStatus.append(x)
                        self?.navigationController?.pushViewController(controller, animated: true)
                    } else {
                        let controller = ThirdViewController()
                        controller.userIDtoUse = stat.account.id
                        self?.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
        }
    }

    @objc func goToID() {
        sleep(2)
        let request = Statuses.status(id: StoreStruct.curID)
        StoreStruct.client.run(request) {[weak self] (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    let controller = DetailViewController()
                    controller.mainStatus.append(stat)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if (UserDefaults.standard.object(forKey: "shakegest") == nil) || (UserDefaults.standard.object(forKey: "shakegest") as! Int == 0) {
                self.tableView.reloadData()

            } else if (UserDefaults.standard.object(forKey: "shakegest") as! Int == 1) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
            } else {

            }
        }
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
            crownControl?.spinToMatchScrollViewOffset()
        }
    }

    @objc func searchPro() {
        let controller = ThirdViewController()
        if StoreStruct.statusSearch[StoreStruct.searchIndex].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }
        controller.userIDtoUse = StoreStruct.statusSearch[StoreStruct.searchIndex].account.id
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func goToSettings() {
        let controller = MainSettingsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func currentSegIndex(_ notification: NSNotification) {
        if let index = notification.userInfo?["index"] as? Int {
            if index == 0 {
                if self.profileStatuses.isEmpty {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                } else {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
                }
            }
            if index == 1 {
                if self.profileStatuses2.isEmpty {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                } else {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
                }
            }
        }
    }
    
    @objc func longAction(sender: UILongPressGestureRecognizer) {
        if (UserDefaults.standard.object(forKey: "longToggle") == nil) || (UserDefaults.standard.object(forKey: "longToggle") as! Int == 0) {
            
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 3) {
            if sender.state == .began {
                var theTable = self.tableView
                var sto = self.profileStatuses
                if self.currentIndex == 0 {
                    sto = self.profileStatuses
                    theTable = self.tableView
                } else if self.currentIndex == 1 {
                    sto = self.profileStatuses2
                    theTable = self.tableView
                }
                let touchPoint = sender.location(in: theTable)
                if let indexPath = theTable.indexPathForRow(at: touchPoint) {
                    if let myWebsite = sto[indexPath.row].url {
                        let objectsToShare = [myWebsite]
                        let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                        vc.popoverPresentationController?.sourceView = self.view
                        vc.previewNumberOfLines = 5
                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func panProfile(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            if self.fromOtherUser == true {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileHeaderCell {
                    self.buttonCenter = cell.profileImageView.center
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        cell.more.alpha = 0
                        cell.settings.alpha = 0
                        cell.settings2.alpha = 0
                        cell.blurEffectView.alpha = 0
                    })
                } else {
                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileHeaderCell2
                    self.buttonCenter = cell.profileImageView.center
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        cell.more.alpha = 0
                        cell.settings.alpha = 0
                        cell.settings2.alpha = 0
                        cell.blurEffectView.alpha = 0
                    })
                }
            } else {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileHeaderCellOwn {
                    self.buttonCenter = cell.profileImageView.center
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        cell.more.alpha = 0
                        cell.settings.alpha = 0
                        cell.settings2.alpha = 0
                        cell.blurEffectView.alpha = 0
                    })
                } else {
                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileHeaderCellOwn2
                    self.buttonCenter = cell.profileImageView.center
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        cell.more.alpha = 0
                        cell.settings.alpha = 0
                        cell.settings2.alpha = 0
                        cell.blurEffectView.alpha = 0
                    })
                }
            }
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                if self.fromOtherUser == true {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileHeaderCell {
                        cell.profileImageView.center = self.buttonCenter
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            cell.more.alpha = 1
                            cell.settings.alpha = 1
                            cell.settings2.alpha = 1
                            cell.blurEffectView.alpha = 1
                        })
                    } else {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileHeaderCell2
                        cell.profileImageView.center = self.buttonCenter
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            cell.more.alpha = 1
                            cell.settings.alpha = 1
                            cell.settings2.alpha = 1
                            cell.blurEffectView.alpha = 1
                        })
                    }
                } else {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileHeaderCellOwn {
                        cell.profileImageView.center = self.buttonCenter
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            cell.more.alpha = 1
                            cell.settings.alpha = 1
                            cell.settings2.alpha = 1
                            cell.blurEffectView.alpha = 1
                        })
                    } else {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileHeaderCellOwn2
                        cell.profileImageView.center = self.buttonCenter
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            cell.more.alpha = 1
                            cell.settings.alpha = 1
                            cell.settings2.alpha = 1
                            cell.blurEffectView.alpha = 1
                        })
                    }
                }
            })
        } else {
            let location = pan.location(in: self.navigationController?.view ?? self.view)
            springWithDelay(duration: 0.5, delay: 0, animations: {
                if self.fromOtherUser == true {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileHeaderCell {
                        cell.profileImageView.center = CGPoint(x: location.x, y: location.y - 80)
                    } else {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileHeaderCell2
                        cell.profileImageView.center = CGPoint(x: location.x, y: location.y - 80)
                    }
                } else {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileHeaderCellOwn {
                        cell.profileImageView.center = CGPoint(x: location.x, y: location.y - 80)
                    } else {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileHeaderCellOwn2
                        cell.profileImageView.center = CGPoint(x: location.x, y: location.y - 80)
                    }
                }
            })
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        self.cropViewController.dismiss(animated: true, completion: nil)
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        var compression: CGFloat = 1
        if (UserDefaults.standard.object(forKey: "imqual") == nil) || (UserDefaults.standard.object(forKey: "imqual") as! Int == 0) {
            compression = 1
        } else if UserDefaults.standard.object(forKey: "imqual") as! Int == 1 {
            compression = 0.78
        } else {
            compression = 0.5
        }
        
        if self.inArea == 0 {
            
            let imageData = image.jpegData(compressionQuality: compression)
            let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: .jpeg(imageData), header: nil)
            StoreStruct.client.run(request) {[weak self](statuses) in
                
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        self?.updateProfileHere()
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Updated Display Picture".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = StoreStruct.currentUser.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
                        }
                    }
                }
            }
            
        } else {
            
            let imageData = image.jpegData(compressionQuality: compression)
            let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: .jpeg(imageData))
            StoreStruct.client.run(request) {[weak self] (statuses) in
                
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        self?.updateProfileHere()
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Updated Header".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = StoreStruct.currentUser.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
                        }
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colours.white
        self.title = "Profile"
        self.removeTabbarItemsText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currentSegIndex), name: NSNotification.Name(rawValue: "setCurrentSegmentIndex"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToID), name: NSNotification.Name(rawValue: "gotoid4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToIDNoti), name: NSNotification.Name(rawValue: "gotoidnoti4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goMembers), name: NSNotification.Name(rawValue: "goMembers4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goLists), name: NSNotification.Name(rawValue: "goLists4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goInstance), name: NSNotification.Name(rawValue: "goInstance4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchPro), name: NSNotification.Name(rawValue: "searchPro4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchUser), name: NSNotification.Name(rawValue: "searchUser4"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTop3), name: NSNotification.Name(rawValue: "scrollTop3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchAllNewest), name: NSNotification.Name(rawValue: "fetchAllNewest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProfileHere), name: NSNotification.Name(rawValue: "updateProfileHere"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tappedOnTag), name: NSNotification.Name(rawValue: "tappedOnTag"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLeft), name: NSNotification.Name(rawValue: "setLeft"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refProf), name: NSNotification.Name(rawValue: "refProf"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToSettings), name: NSNotification.Name(rawValue: "goToSettings4"), object: nil)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
            self?.player.rate = self?.playerRate ?? 1
        }
        
        
        UserDefaults.standard.set(1, forKey: "onb")
        
        UINavigationBar.appearance().barTintColor = Colours.black
        UINavigationBar.appearance().tintColor = Colours.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
        
        var settingsButton = MNGExpandedTouchAreaButton()
        settingsButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 15, y: 47, width: 36, height: 36)))
        settingsButton.setImage(UIImage(named: "sett")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        settingsButton.adjustsImageWhenHighlighted = false
        settingsButton.addTarget(self, action: #selector(self.setTop1), for: .touchUpInside)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            if self.fromOtherUser {} else {
                let done = UIBarButtonItem.init(customView: settingsButton)
                self.navigationItem.setLeftBarButton(done, animated: false)
            }
        default:
            print("nil")
        }
        
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

        if self.isPeeking == true {
            offset = -5
        }
        
        let deviceIdiom0 = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom0) {
        case .phone:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 0)
        case .pad:
//            print("nothing")
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 60), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 60)
        default:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 0)
        }
        self.tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: "ProfileHeaderCell")
        self.tableView.register(ProfileHeaderCellOwn.self, forCellReuseIdentifier: "ProfileHeaderCellOwn")
        self.tableView.register(ProfileHeaderCellOwn2.self, forCellReuseIdentifier: "ProfileHeaderCellOwn2")
        self.tableView.register(ProfileHeaderCellImage.self, forCellReuseIdentifier: "ProfileHeaderCellImage")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell5")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell6")
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
        
        self.tableView.dragDelegate = self
        
        self.setupProfile()
        
        self.ai = NVActivityIndicatorView(frame: CGRect(x: CGFloat(self.view.bounds.width/2 - 20), y: CGFloat(offset + 60), width: 40, height: 40), type: .ballRotateChase, color: Colours.tabSelected)
        self.view.addSubview(self.ai)
        self.loadLoadLoad()
        switch (deviceIdiom) {
        case .phone:
            tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    let selection = UISelectionFeedbackGenerator()
                    selection.selectionChanged()
                }
                self?.refreshCont()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self?.tableView.cr.endHeaderRefresh()
                })
            }
        case .pad:
//            print("nothing")
            tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    let selection = UISelectionFeedbackGenerator()
                    selection.selectionChanged()
                }
                self?.refreshCont()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self?.tableView.cr.endHeaderRefresh()
                })
            }
        default:
            tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    let selection = UISelectionFeedbackGenerator()
                    selection.selectionChanged()
                }
                self?.refreshCont()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self?.tableView.cr.endHeaderRefresh()
                })
            }
        }
        
        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: self.tableView)
        }


        if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
            self.crownScroll()
        }
    }

    func crownScroll() {
        var attributes = CrownAttributes(scrollView: self.tableView, scrollAxis: .vertical)
        attributes.backgroundStyle.content = .gradient(gradient: .init(colors: [UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0), UIColor(red: 20/255.0, green: 20/255.0, blue: 29/255.0, alpha: 1.0)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.backgroundStyle.border = .value(color: UIColor(red: 34/255.0, green: 34/255.0, blue: 35/255.0, alpha: 1.0), width: 1)
        attributes.foregroundStyle.content = .gradient(gradient: .init(colors: [Colours.tabSelected, Colours.tabSelected], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.foregroundStyle.border = .value(color: UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0), width: 0)
        attributes.feedback.leading.backgroundFlash = .active(color: .clear, fadeDuration: 0)
        attributes.feedback.trailing.backgroundFlash = .active(color: .clear, fadeDuration: 0)
        let verticalConstraint = CrownAttributes.AxisConstraint(crownEdge: .bottom, anchorView: self.tableView, anchorViewEdge: .bottom, offset: -50)
        let horizontalConstraint = CrownAttributes.AxisConstraint(crownEdge: .trailing, anchorView: self.tableView, anchorViewEdge: .trailing, offset: -50)
        crownControl = CrownControl(attributes: attributes, delegate: self)
        crownControl.layout(in: view, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
    }

    func setupProfile() {
        var zzz = false
        if (UserDefaults.standard.object(forKey: "boostpro3") == nil) || (UserDefaults.standard.object(forKey: "boostpro3") as! Int == 0) {
            zzz = false
        } else {
            zzz = true
        }
        
        if self.fromOtherUser == true {
            let request = Accounts.statuses(id: self.userIDtoUse, mediaOnly: false, pinnedOnly: false, excludeReplies: true, excludeReblogs: true, range: .default)
            StoreStruct.client.run(request) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    
                    guard let ref = self else {
                        return
                    }
                    
                    if stat.isEmpty {
                        let request9 = Accounts.account(id: ref.userIDtoUse)
                        StoreStruct.client.run(request9) { (statuses) in
                            if let stat = (statuses.value) {
                                DispatchQueue.main.async {
                                    ref.chosenUser = stat
                                    ref.ai.alpha = 0
                                    ref.ai.removeFromSuperview()
                                    ref.tableView.reloadData()
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            ref.tableView.reloadData()
                            if ref.chosenUser == nil {
                                let request9 = Accounts.account(id: ref.userIDtoUse)
                                StoreStruct.client.run(request9) { (statuses) in
                                    if let stat = (statuses.value) {
                                        DispatchQueue.main.async {
                                            ref.chosenUser = stat
                                            ref.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            let request8 = Accounts.statuses(id: self.userIDtoUse, mediaOnly: false, pinnedOnly: false, excludeReplies: false, excludeReblogs: zzz, range: .default)
            StoreStruct.client.run(request8) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    if stat.isEmpty {} else {
                        self?.profileStatuses2 = stat
                    }
                }
            }
        } else {
            if StoreStruct.currentUser == nil {
                let request2 = Accounts.currentUser()
                StoreStruct.client.run(request2) {[weak self] (statuses) in
                    if let stat = (statuses.value) {
                        DispatchQueue.main.async {
                            StoreStruct.currentUser = stat
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
                            self?.userIDtoUse = StoreStruct.currentUser.id
                            self?.chosenUser = StoreStruct.currentUser
                            self?.tableView.reloadData()
                        }
                        
                        let request = Accounts.statuses(id: stat.id, mediaOnly: false, pinnedOnly: false, excludeReplies: true, excludeReblogs: true, range: .default)
                        StoreStruct.client.run(request) { (statuses) in
                            if let stat = (statuses.value) {
                                if stat.isEmpty {} else {
                                    DispatchQueue.main.async {
                                        self?.profileStatuses = stat
                                        self?.ai.alpha = 0
                                        self?.ai.removeFromSuperview()
                                        self?.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                self.profileStatusesHasImage = StoreStruct.profileStatusesHasImage0
                self.userIDtoUse = StoreStruct.currentUser.id
                DispatchQueue.main.async {
                    self.chosenUser = StoreStruct.currentUser
                    self.profileStatuses = StoreStruct.profileStatuses0
                    self.tableView.reloadData()
                }
                
                if StoreStruct.profileStatuses0.isEmpty {
                    let request = Accounts.statuses(id: StoreStruct.currentUser.id, mediaOnly: false, pinnedOnly: false, excludeReplies: true, excludeReblogs: true, range: .default)
                    StoreStruct.client.run(request) {[weak self] (statuses) in
                        if let stat = (statuses.value) {
                            if stat.isEmpty {} else {
                                DispatchQueue.main.async {
                                    self?.profileStatuses = stat
                                    self?.ai.alpha = 0
                                    self?.ai.removeFromSuperview()
                                    self?.tableView.reloadData()
                                }
                            }
                            
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.profileStatuses = StoreStruct.profileStatuses0
                        self.ai.alpha = 0
                        self.ai.removeFromSuperview()
                        self.tableView.reloadData()
                    }
                }
                
                let request8 = Accounts.statuses(id: self.userIDtoUse, mediaOnly: false, pinnedOnly: false, excludeReplies: false, excludeReblogs: zzz, range: .default)
                StoreStruct.client.run(request8) {[weak self] (statuses) in
                    if let stat = (statuses.value) {
                        if stat.isEmpty {} else {
                            self?.profileStatuses2 = stat
                        }
                    }
                }
            }
        }
        
//        DispatchQueue.global(qos: .userInitiated).async {
            let request = Accounts.statuses(id: self.userIDtoUse, mediaOnly: true, pinnedOnly: nil, excludeReplies: nil, excludeReblogs: true, range: .default)
            StoreStruct.client.run(request) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    if stat.isEmpty {} else {
                        DispatchQueue.main.async {
                            self?.profileStatusesHasImage = stat
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
//        }
    }
    
    @objc func search9() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchthething"), object: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            self.ai.startAnimating()
            
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(self.navigationController?.navigationBar.frame.size.height ?? 0)).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: CGFloat(0)).isActive = true
            
            if self.maybeDoOnce == false {
                self.searchButton = MNGExpandedTouchAreaButton()
                self.searchButton.setImage(UIImage(named: "search")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                self.searchButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                self.searchButton.adjustsImageWhenHighlighted = false
                self.searchButton.addTarget(self, action: #selector(search9), for: .touchUpInside)
                
                let deviceIdiom2 = UIScreen.main.traitCollection.userInterfaceIdiom
                switch (deviceIdiom2) {
                case .phone:
                    self.navigationController?.view.addSubview(self.searchButton)
                    
                    self.searchButton.translatesAutoresizingMaskIntoConstraints = false
                    self.searchButton.widthAnchor.constraint(equalToConstant: CGFloat(32)).isActive = true
                    self.searchButton.heightAnchor.constraint(equalToConstant: CGFloat(32)).isActive = true
                    self.searchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                    self.searchButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 5).isActive = true
                default:
                    print("nil")
                }
                self.maybeDoOnce = true
            }
        default:
            print("nothing")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        var zzz = self.profileStatuses
        if self.currentIndex == 0 {
            zzz = self.profileStatuses
        } else {
            zzz = self.profileStatuses2
        }
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        if let indexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
            let request = Statuses.status(id: zzz[indexPath.row].reblog?.id ?? zzz[indexPath.row].id)
            StoreStruct.client.run(request) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        if let cell = self?.tableView.cellForRow(at: indexPath) as? MainFeedCell {
                            cell.configure0(stat)
                        }
                        if let cell2 = self?.tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                            cell2.configure0(stat)
                        }
                    }
                }
            }
        }
        
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = Colours.tabUnselected

        StoreStruct.currentPage = 2
        
//        if StoreStruct.currentUser == nil {
//            let request2 = Accounts.currentUser()
//            StoreStruct.client.run(request2) { (statuses) in
//                if let stat = (statuses.value) {
//                    StoreStruct.currentUser = stat
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }
        
        
        if self.fromOtherUser && (self.isPeeking == false) && (self.userIDtoUse != StoreStruct.currentUser.id) {
            let request00 = Accounts.allEndorsements()
            StoreStruct.client.run(request00) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    guard let chosen = self?.chosenUser else { return }
                    let s = stat.filter { $0.id == chosen.id }
                    if s.isEmpty {
                        self?.isEndorsed = false
                    } else {
                        self?.isEndorsed = true
                    }
                }
            }
            let request0 = Mutes.all()
            StoreStruct.client.run(request0) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    guard let chosen = self?.chosenUser else { return }
                    let s = stat.filter { $0.id == chosen.id }
                    if s.isEmpty {
                        self?.isMuted = false
                    } else {
                        self?.isMuted = true
                    }
                }
            }
            let request01 = Blocks.all()
            StoreStruct.client.run(request01) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    guard let chosen = self?.chosenUser else { return }
                    let s = stat.filter { $0.id == chosen.id }
                    if s.isEmpty {
                        self?.isBlocked = false
                    } else {
                        self?.isBlocked = true
                    }
                }
            }
            let request2 = Accounts.currentUser()
            StoreStruct.client.run(request2) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    
                    guard let self = self else {
                        return
                    }
                    StoreStruct.currentUser = stat
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
                    guard let chosen = self.chosenUser else { return }
                    let request02 = Accounts.relationships(ids: [StoreStruct.currentUser.id, chosen.id])
                    StoreStruct.client.run(request02) { (statuses) in
                        if let stat = (statuses.value) {
                            if stat[1].following {
                                self.isFollowing = true
                                self.fo = "Unfollow".localized
                            } else {
                                self.isFollowing = false
                                self.fo = "Follow".localized
                            }

                            if stat[1].followedBy {
                                self.isFollowed = true
                            } else {
                                self.isFollowed = false
                            }
                            
                            if stat[1].showingReblogs {
                                self.isShowingBoosts = true
                            } else {
                                self.isShowingBoosts = false
                            }
                        }
                    }
                }
            }
        }
        
        let request = Lists.all()
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.allLists = stat
                StoreStruct.allLists.map({
                    self.zzz[$0.title] = $0.id
                })
            }
        }
        
        // refProf()
    }



    // Table stuff


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            if self.profileStatusesHasImage.isEmpty {
                return 0
            } else {
                return 40
            }
        } else {
            return 65
        }
    }
    
    
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 2
    }

    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        if index == 0 {
            var amount = ""
            if self.profileStatuses.count > 0 {
                let c = self.profileStatuses.first?.account.statusesCount ?? 0
                if self.profileStatuses.count == 1 {
                    amount = "1 Post"
                } else {

                    let numberFormatter2 = NumberFormatter()
                    numberFormatter2.numberStyle = NumberFormatter.Style.decimal
                    let formattedNumber2 = numberFormatter2.string(from: NSNumber(value: c))

                    amount = "\(formattedNumber2 ?? "No") Posts"
                }
            } else {
                amount = "No Posts"
            }

            return amount
        } else {
            return "Posts & Replies".localized
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
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as? Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        if toIndex == 0 {
            DispatchQueue.main.async {
                self.currentIndex = 0
                self.tableView.beginUpdates()
                self.tableView.reloadSections([2], with: .none)
                self.tableView.endUpdates()
            }
        }
        if toIndex == 1 {
            DispatchQueue.main.async {
                self.currentIndex = 1
                self.tableView.beginUpdates()
                self.tableView.reloadSections([2], with: .none)
                self.tableView.endUpdates()
            }
        }
    }







    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        let title = UILabel()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        if section == 0 {
            return nil
        } else if section == 1 {
            let title = UILabel()
            title.frame = CGRect(x: 10, y: 8, width: self.view.bounds.width, height: 30)
            title.textColor = Colours.grayDark2
            title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            vw.addSubview(title)
            if self.profileStatusesHasImage.isEmpty {
                return nil
            } else {
                title.text = "Recent Media".localized
                let moreB = UIButton()
                moreB.frame = CGRect(x: self.view.bounds.width - 50, y: 5, width: 40, height: 40)
                moreB.setImage(UIImage(named: "more")?.maskWithColor(color: Colours.grayDark), for: .normal)
                moreB.backgroundColor = UIColor.clear
                moreB.addTarget(self, action: #selector(self.tapMoreImages), for: .touchUpInside)
                vw.addSubview(moreB)
            }
        } else if section == 2 {
            if self.profileStatuses.count > 0 {
                let c = self.profileStatuses[0].account.statusesCount
                if self.profileStatuses.count == 1 {
                    title.text = "1 Status"
                } else {

                    let numberFormatter2 = NumberFormatter()
                    numberFormatter2.numberStyle = NumberFormatter.Style.decimal
                    let formattedNumber2 = numberFormatter2.string(from: NSNumber(value: c))

                    title.text = "\(formattedNumber2 ?? "No") Statuses"
                }
            } else {
                title.text = "No Statuses"
            }

            segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(20), y: CGFloat(10), width: CGFloat(self.view.bounds.width - 40), height: CGFloat(40)))
            segmentedControl.dataSource = self
            segmentedControl.shapeStyle = .roundedRect
            segmentedControl.textFont = .systemFont(ofSize: 15, weight: .heavy)
            segmentedControl.cornerRadius = 12
            segmentedControl.shadowsEnabled = false
            segmentedControl.transitionStyle = .slide
            segmentedControl.delegate = self
            vw.addSubview(segmentedControl)
            if self.currentIndex == 0 && segmentedControl.currentSegment != 0 {
                segmentedControl.setCurrentSegmentIndex(0, animated: false)
            } else if self.currentIndex == 1 && segmentedControl.currentSegment != 1 {
                segmentedControl.setCurrentSegmentIndex(1, animated: false)
            }
        }
        vw.backgroundColor = Colours.white

        return vw
    }
    
    @objc func tapMoreImages() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let imp = UIImpactFeedbackGenerator(style: .light)
            imp.impactOccurred()
        }
        
        let controller = AllMediaViewController()
        controller.profileStatusesHasImage = self.profileStatusesHasImage
        controller.chosenUser = self.chosenUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if self.profileStatusesHasImage.isEmpty {
                return 0
            } else {
                return 1
            }
        } else {
            return self.profileStatuses.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 1 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 293
            } else {
                return 193
            }
        } else {
            return UITableView.automaticDimension
        }
    }





    @objc func setTop1() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        let controller = MainSettingsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func setTop() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }

        if (UserDefaults.standard.object(forKey: "likepin") == nil) || (UserDefaults.standard.object(forKey: "likepin") as! Int == 0) {
            let controller = LikedViewController()
            controller.currentTagTitle = "Liked"
            let request = Favourites.all()
//            StoreStruct.client.run(request) { (statuses) in
//                if let stat = (statuses.value) {
//                    DispatchQueue.main.async {
//                        controller.currentTags = stat
                        self.navigationController?.pushViewController(controller, animated: true)
//                    }
//                }
//            }
        } else if (UserDefaults.standard.object(forKey: "likepin") as! Int == 1) {
            
            let controller = PinnedViewController()
            controller.currentTagTitle = "Pinned"
            controller.curID = self.chosenUser.id
//            let request = Accounts.statuses(id: StoreStruct.currentUser.id, mediaOnly: nil, pinnedOnly: true, excludeReplies: nil, excludeReblogs: false, range: .min(id: "", limit: 5000))
//            StoreStruct.client.run(request) { (statuses) in
//                if let stat = (statuses.value) {
//                    DispatchQueue.main.async {
//                        controller.currentTags = stat
                        self.navigationController?.pushViewController(controller, animated: true)
//                    }
//                }
//            }
        } else {
            
            self.editProfileDetails()
            
        }
    }
    
    func editProfileDetails() {
        
        StoreStruct.avaFile = "\(StoreStruct.avaFile)\(Int.random(in: 10...5000000))"
        StoreStruct.heaFile = "\(StoreStruct.heaFile)\(Int.random(in: 10...5000000))"
        
        let isItLocked = StoreStruct.currentUser.locked
        var lockText = "Lock Account"
        var isItGoingToLock = false
        var isItGoingToLockText = "Locked Account"
        if isItLocked {
            isItGoingToLock = false
            lockText = "Unlock Account"
            isItGoingToLockText = "Unlocked Account"
        } else {
            isItGoingToLock = true
            isItGoingToLockText = "Locked Account"
        }
        
        
        var compression: CGFloat = 1
        if (UserDefaults.standard.object(forKey: "imqual") == nil) || (UserDefaults.standard.object(forKey: "imqual") as! Int == 0) {
            compression = 1
        } else if UserDefaults.standard.object(forKey: "imqual") as! Int == 1 {
            compression = 0.78
        } else {
            compression = 0.5
        }
        
        Alertift.actionSheet()
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark)
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
        .action(.default("Edit Avatar"), image: nil) { (action, ind) in
            
            StoreStruct.medType = 1
            self.inArea = 0
            
            let pickerController = DKImagePickerController()
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                if assets.count == 0 {
                    return
                }
                if assets.count > 0 {
                    assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                        self.cropViewController = CropViewController(image: image ?? UIImage())
                        self.cropViewController.delegate = self
                        self.cropViewController.aspectRatioPreset = .presetSquare
                        self.cropViewController.aspectRatioLockEnabled = true
                        self.cropViewController.resetAspectRatioEnabled = false
                        self.cropViewController.aspectRatioPickerButtonHidden = true
                        self.cropViewController.title = "Resize Avatar"
                        self.present(self.cropViewController, animated: true, completion: nil)
                    })
                }
            }
            pickerController.showsCancelButton = true
            pickerController.maxSelectableCount = 1
            pickerController.allowMultipleTypes = false
            pickerController.assetType = .allPhotos
            self.present(pickerController, animated: true) {}
            }
            
            .action(.default("Edit Header"), image: nil) { (action, ind) in
                
                StoreStruct.medType = 2
                self.inArea = 1
                
                let pickerController = DKImagePickerController()
                pickerController.didSelectAssets = { (assets: [DKAsset]) in
                    if assets.count == 0 {
                        return
                    }
                    if assets.count > 0 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.cropViewController = CropViewController(image: image ?? UIImage())
                            self.cropViewController.delegate = self
                            self.cropViewController.aspectRatioPreset = .preset3x1
                            self.cropViewController.aspectRatioLockEnabled = true
                            self.cropViewController.resetAspectRatioEnabled = false
                            self.cropViewController.aspectRatioPickerButtonHidden = true
                            self.cropViewController.title = "Resize Header"
                            self.present(self.cropViewController, animated: true, completion: nil)
                        })
                    }
                }
                pickerController.showsCancelButton = true
                pickerController.maxSelectableCount = 1
                pickerController.allowMultipleTypes = false
                pickerController.assetType = .allPhotos
                self.present(pickerController, animated: true) {}
            }
            
            
            .action(.default("Edit Display Name"), image: nil) { (action, ind) in
                 
                
                let controller = NewProfileViewController()
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                switch (deviceIdiom) {
                case .pad:
                    controller.modalPresentationStyle = .pageSheet
                default:
                    print("nil")
                }
                controller.editListName = self.chosenUser.displayName
                self.present(controller, animated: true, completion: nil)
                
            }
            .action(.default("Edit Bio"), image: nil) { (action, ind) in
                 
                
                let controller = NewProfileNoteViewController()
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                switch (deviceIdiom) {
                case .pad:
                    controller.modalPresentationStyle = .pageSheet
                default:
                    print("nil")
                }
                controller.editListName = self.chosenUser.note.stripHTML()
                self.present(controller, animated: true, completion: nil)
                
            }
            .action(.default("Edit Links"), image: nil) { (action, ind) in
                 
                
                var field1 = "Link 1"
                var field2 = "Link 2"
                var field3 = "Link 3"
                var field4 = "Link 4"
                var field01: String? = ""
                var field02: String? = ""
                var field03: String? = ""
                var field04: String? = ""
                var fieldVal1: String? = ""
                var fieldVal2: String? = ""
                var fieldVal3: String? = ""
                var fieldVal4: String? = ""
                
                if self.chosenUser.fields.count > 0 {
                    field1 = self.chosenUser.fields[0].name
                    field01 = field1
                    fieldVal1 = self.chosenUser.fields[0].value
                    if field1 == "" {
                        field1 = "Link 1"
                        field01 = nil
                        fieldVal1 = nil
                    }
                    if self.chosenUser.fields.count > 1 {
                        field2 = self.chosenUser.fields[1].name
                        field02 = field2
                        fieldVal2 = self.chosenUser.fields[1].value
                        if field2 == "" {
                            field2 = "Link 2"
                            field02 = nil
                            fieldVal2 = nil
                        }
                        if self.chosenUser.fields.count > 2 {
                            field3 = self.chosenUser.fields[2].name
                            field03 = field3
                            fieldVal3 = self.chosenUser.fields[2].value
                            if field3 == "" {
                                field3 = "Link 3"
                                field03 = nil
                                fieldVal3 = nil
                            }
                            if self.chosenUser.fields.count > 3 {
                                field4 = self.chosenUser.fields[3].name
                                field04 = field4
                                fieldVal4 = self.chosenUser.fields[3].value
                                if field4 == "" {
                                    field4 = "Link 4"
                                    field04 = nil
                                    fieldVal4 = nil
                                }
                            }
                        }
                    }
                }

        Alertift.actionSheet()
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark)
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default(field1), image: nil) { (action, ind) in
                 
                
                Alertift.alert(title: field4, message: "Input the link name and URL")
                    .textField { textField in
                        textField.placeholder = "Name"
                    }
                    .textField { textField in
                        textField.placeholder = "URL"
                    }
                    .action(.cancel("Cancel"))
                    .action(.default("Update")) { _, _, textFields in
                        let name = textFields?.first?.text ?? ""
                        let url = textFields?.last?.text ?? ""
                        
                        let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: name, fieldValue1: url, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: field04, fieldValue4: fieldVal4)
                        StoreStruct.client.run(request) {[weak self] (statuses) in
                            if let stat = (statuses.value) {
                                
                                DispatchQueue.main.async {
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
                                    self?.updateProfileHere()
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .show()
                
            }
            .action(.default(field2), image: nil) { (action, ind) in
                 
                
                Alertift.alert(title: field4, message: "Input the link name and URL")
                    .textField { textField in
                        textField.placeholder = "Name"
                    }
                    .textField { textField in
                        textField.placeholder = "URL"
                    }
                    .action(.cancel("Cancel"))
                    .action(.default("Update")) { _, _, textFields in
                        let name = textFields?.first?.text ?? ""
                        let url = textFields?.last?.text ?? ""
                        
                        let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: name, fieldValue2: url, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: field04, fieldValue4: fieldVal4)
                        StoreStruct.client.run(request) {[weak self] (statuses) in
                            if let stat = (statuses.value) {
                                
                                DispatchQueue.main.async {
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
                                    self?.updateProfileHere()
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .show()
                
            }
            .action(.default(field3), image: nil) { (action, ind) in
                 
                
                Alertift.alert(title: field4, message: "Input the link name and URL")
                    .textField { textField in
                        textField.placeholder = "Name"
                    }
                    .textField { textField in
                        textField.placeholder = "URL"
                    }
                    .action(.cancel("Cancel"))
                    .action(.default("Update")) { _, _, textFields in
                        let name = textFields?.first?.text ?? ""
                        let url = textFields?.last?.text ?? ""
                        
                        let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: name, fieldValue3: url, fieldName4: field04, fieldValue4: fieldVal4)
                        StoreStruct.client.run(request) {[weak self] (statuses) in
                            if let stat = (statuses.value) {
                                
                                DispatchQueue.main.async {
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
                                    self?.updateProfileHere()
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .show()
                
            }
            .action(.default(field4), image: nil) { (action, ind) in
                 
                
                Alertift.alert(title: field4, message: "Input the link name and URL")
                    .textField { textField in
                        textField.placeholder = "Name"
                    }
                    .textField { textField in
                        textField.placeholder = "URL"
                    }
                    .action(.cancel("Cancel"))
                    .action(.default("Update")) { _, _, textFields in
                        let name = textFields?.first?.text ?? ""
                        let url = textFields?.last?.text ?? ""
                        
                        let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: name, fieldValue4: url)
                        StoreStruct.client.run(request) {[weak self] (statuses) in
                            if let stat = (statuses.value) {
                                
                                DispatchQueue.main.async {
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
                                    self?.updateProfileHere()
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .show()
                
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
            .show(on: self)

                

            }
            .action(.default(lockText), image: nil) { (action, ind) in
                
                //bh2
                
                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: isItGoingToLock)
                StoreStruct.client.run(request) {[weak self] (statuses) in
                    if let stat = (statuses.value) {
                        DispatchQueue.main.async {
//                            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
                            self?.updateProfileHere()
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let notification = UINotificationFeedbackGenerator()
                                notification.notificationOccurred(.success)
                            }
                            let statusAlert = StatusAlert()
                            if stat.locked {
                                statusAlert.image = UIImage(named: "largelock")?.maskWithColor(color: Colours.grayDark)
                            } else {
                                statusAlert.image = UIImage(named: "largeunlock")?.maskWithColor(color: Colours.grayDark)
                            }
                            statusAlert.title = isItGoingToLockText.localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = StoreStruct.currentUser.displayName
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                statusAlert.show()
                            }
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
            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
            .show(on: self)
    }
    
    @objc func didTouchToFol() {
        if self.isFollowing == false {
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }

            if self.chosenUser.locked {
                let statusAlert = StatusAlert()
                statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                statusAlert.title = "Follow Request Sent".localized
                statusAlert.contentColor = Colours.grayDark
                statusAlert.message = self.chosenUser.displayName
                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                    statusAlert.show()
                }
            } else {
                let statusAlert = StatusAlert()
                statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                statusAlert.title = "Followed".localized
                statusAlert.contentColor = Colours.grayDark
                statusAlert.message = self.chosenUser.displayName
                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                    statusAlert.show()
                }
            }

            if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
            }

            self.isFollowing = true
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileHeaderCell
            cell.changeFollowStatus(self.isFollowing)
            
        } else {

            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Unfollowed".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = self.chosenUser.displayName
            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                statusAlert.show()
            }

            self.isFollowing = false
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileHeaderCell
            cell.changeFollowStatus(self.isFollowing)
            
        }
    }


    @objc func moreTop() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        if self.fromOtherUser {

            var title = "Fetching follow status".localized
            if self.isFollowing {
                self.fo = " Unfollow".localized
            } else {
                self.fo = " Follow".localized
            }
            var endoTitle = " Endorse"
            if self.isEndorsed {
                endoTitle = " Remove Endorsement"
            } else {
                endoTitle = " Endorse"
            }
            var muteTitle = " Mute"
            if self.isMuted {
                muteTitle = " Unmute"
            } else {
                muteTitle = " Mute"
            }
            var blockText = " Block"
            if self.isBlocked {
                blockText = " Unblock"
            } else {
                blockText = " Block"
            }
            var rebText = " Disable Boosts"
            var rebImage = UIImage(named: "block")
            if self.isShowingBoosts {
                rebText = " Disable Boosts"
                rebImage = UIImage(named: "block")
            } else {
                rebText = " Enable Boosts"
                rebImage = UIImage(named: "boost3")
            }
            
            Alertift.actionSheet(title: nil, message: nil)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default(" Pinned".localized), image: UIImage(named: "pinned")) { (action, ind) in
                     
                    
                    let controller = PinnedViewController()
                    controller.currentTagTitle = "Pinned"
                    controller.curID = self.chosenUser.id
//                    let request = Accounts.statuses(id: self.chosenUser.id, mediaOnly: nil, pinnedOnly: true, excludeReplies: nil, excludeReblogs: false, range: .min(id: "", limit: 5000))
//                    StoreStruct.client.run(request) { (statuses) in
//                        if let stat = (statuses.value) {
//                            DispatchQueue.main.async {
//                                controller.currentTags = stat
                                self.navigationController?.pushViewController(controller, animated: true)
//                            }
//                        }
//                    }
                }
                .action(.default(" Mention".localized), image: UIImage(named: "reply2")) { (action, ind) in
                     
                    
                    let controller = ComposeViewController()
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    switch (deviceIdiom) {
                    case .pad:
                        controller.modalPresentationStyle = .pageSheet
                    default:
                        print("nil")
                    }
                    controller.inReplyText = self.chosenUser.acct
                    self.present(controller, animated: true, completion: nil)
                }
                .action(.default("Direct Message".localized), image: UIImage(named: "sendm")) { (action, ind) in
                     
                    
                    let controller = ComposeViewController()
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    switch (deviceIdiom) {
                    case .pad:
                        controller.modalPresentationStyle = .pageSheet
                    default:
                        print("nil")
                    }
                    controller.inReplyText = self.chosenUser.acct
                    controller.profileDirect = true
                    self.present(controller, animated: true, completion: nil)
                }
                .action(.default(fo), image: UIImage(named: "profile")) { (action, ind) in
                     
                    
                    if self.isFollowing == false {
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }



                        if self.chosenUser.locked {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Follow Request Sent".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = self.chosenUser.displayName
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                statusAlert.show()
                            }
                        } else {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Followed".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = self.chosenUser.displayName
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                statusAlert.show()
                            }
                        }




                        if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                        }

                        self.isFollowing = true
                        
                    } else {
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Unfollowed".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = self.chosenUser.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
                        }

                        self.isFollowing = false
                       
                    }

                }

                // change below endorse
                .action(.default(endoTitle), image: UIImage(named: "endo")) { (action, ind) in
                     
                    
                    if self.isEndorsed {
                        let request = Accounts.endorseRemove(id: self.chosenUser.id)
                        StoreStruct.client.run(request) { [weak self] (statuses) in
                            if let stat = (statuses.value) {
                                guard let self = self else {
                                    return
                                }
                                DispatchQueue.main.async {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Removed Endorsement".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = self.chosenUser.displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }

                                    self.isEndorsed = false
                                }
                            }
                        }
                    } else {
                        let request = Accounts.endorse(id: self.chosenUser.id)
                        StoreStruct.client.run(request) {[weak self] (statuses) in
                            if let stat = (statuses.value) {
                                guard let self = self else {
                                    return
                                }
                                DispatchQueue.main.async {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Endorsed".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = self.chosenUser.displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }

                                    self.isEndorsed = true
                                }
                            }
                        }
                    }

                }
                .action(.default(" Follows/Followers".localized), image: UIImage(named: "profile")) { (action, ind) in
                    
                    DispatchQueue.main.async {
                        let controller = FollowersViewController()
                        controller.profileStatus = self.chosenUser.id
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                
                
                .action(.default(rebText), image: rebImage) { (action, ind) in
                     
                    
                    if self.isFollowing == false {
                        
                        Alertift.actionSheet(title: nil, message: "You must be following this user to choose whether to display their reposted toots on the home timeline.")
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
                            .show(on: self)
                        
                    } else {
                        
                        if self.isShowingBoosts {
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let notification = UINotificationFeedbackGenerator()
                                notification.notificationOccurred(.success)
                            }
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Disabled Boosts".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = self.chosenUser.displayName
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                statusAlert.show()
                            }
                            let request = Accounts.follow(id: self.chosenUser.id, reblogs: false)
                            StoreStruct.client.run(request) {[weak self] (statuses) in
                                if let _ = (statuses.value) {
                                    self?.isShowingBoosts = false
                                }
                            }
                        } else {
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let notification = UINotificationFeedbackGenerator()
                                notification.notificationOccurred(.success)
                            }
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "boostlarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Enabled Boosts".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = self.chosenUser.displayName
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                statusAlert.show()
                            }
                            let request = Accounts.follow(id: self.chosenUser.id, reblogs: true)
                            StoreStruct.client.run(request) {[weak self] (statuses) in
                                if let _ = (statuses.value) {
                                    self?.isShowingBoosts = true
                                }
                            }
                        }
                        
                    }
                    
                }
                
                
                
                .action(.default(" Add to a List".localized), image: UIImage(named: "list")) { (action, ind) in
                     
                    
                    
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
                    self.zzz.map({
                        let aa = $0
                        z1.action(.default($0.key), image: nil) { (action, ind) in
                            let request = Lists.add(accountIDs: [self.chosenUser.id], toList: aa.value)
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
                                    statusAlert.message = self.chosenUser.displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }

                                }
                            }
                        }
                    })
                    
                    
                    if self.zzz.count == 0 {
                        _ = z1.action(.default("Create New List"), image: nil) { (action, ind) in
                            let controller = NewListViewController()
                            self.present(controller, animated: true, completion: nil)
                        }
                    }


                    _ = z1.popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
                    z1.show(on: self, completion: nil)


                }
                .action(.default(muteTitle), image: UIImage(named: "block")) { (action, ind) in
                     
                    
                    if self.isMuted == false {
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Muted".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = self.chosenUser.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
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
                        statusAlert.message = self.chosenUser.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
                        }

                       
                    }
                }
                .action(.default(blockText), image: UIImage(named: "block2")) { (action, ind) in
                     
                    
                    if self.isBlocked == false {
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "block2large")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Blocked".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = self.chosenUser.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
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
                        statusAlert.message = self.chosenUser.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
                        }

                       
                    }

                }
                .action(.default(" Share Profile".localized), image: UIImage(named: "share")) { (action, ind) in
                     
                    
                    
                    Alertift.actionSheet()
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark)
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Share Link".localized), image: UIImage(named: "share")) { (action, ind) in
                             
                            
                            let objectsToShare = [self.chosenUser.url]
                            let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            vc.popoverPresentationController?.sourceView = self.view
                            vc.previewNumberOfLines = 5
                            vc.previewFont = UIFont.systemFont(ofSize: 14)
                            self.present(vc, animated: true, completion: nil)
                        }
                        .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                             
                            
                            let controller = NewQRViewController()
                            controller.ur = self.chosenUser.url
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


        } else {

            let isItLocked = StoreStruct.currentUser.locked
            var lockText = "Lock Account"
            var isItGoingToLock = false
            var isItGoingToLockText = "Locked Account"
            if isItLocked {
                isItGoingToLock = false
                lockText = "Unlock Account"
                isItGoingToLockText = "Unlocked Account"
            } else {
                isItGoingToLock = true
                isItGoingToLockText = "Locked Account"
            }

            //            var imim = UIImage()
            //            let url = URL(string: self.chosenUser.header ?? "")
            //            if url != nil {
            //                do {
            //                    let data = try? Data(contentsOf: url!)
            //                    imim = UIImage(data: data!)!
            //                } catch {
            //                    print("err")
            //                }
            //            }

            let z1 = Alertift.actionSheet(title: nil, message: nil)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                //.image(imim)
                .action(.default("Pinned".localized), image: UIImage(named: "pinned")) { (action, ind) in
                     
                    
                    let controller = PinnedViewController()
                    controller.currentTagTitle = "Pinned"
                    controller.curID = self.chosenUser.id
//                    let request = Accounts.statuses(id: StoreStruct.currentUser.id, mediaOnly: nil, pinnedOnly: true, excludeReplies: nil, excludeReblogs: false, range: .min(id: "", limit: 5000))
//                    StoreStruct.client.run(request) { (statuses) in
//                        if let stat = (statuses.value) {
//                            DispatchQueue.main.async {
//                                controller.currentTags = stat
                                self.navigationController?.pushViewController(controller, animated: true)
//                            }
//                        }
//                    }
                }
                .action(.default("Liked".localized), image: UIImage(named: "like2")) { (action, ind) in
                     
                    
                    let controller = LikedViewController()
                    controller.currentTagTitle = "Liked"
                    let request = Favourites.all()
//                    StoreStruct.client.run(request) { (statuses) in
//                        if let stat = (statuses.value) {
//                            DispatchQueue.main.async {
//                                controller.currentTags = stat
                                self.navigationController?.pushViewController(controller, animated: true)
//                            }
//                        }
//                    }
                }
                .action(.default("Muted".localized), image: UIImage(named: "block")) { (action, ind) in
                     
                    
//                    let request = Mutes.all()
//                    StoreStruct.client.run(request) { (statuses) in
//                        if let stat = (statuses.value) {
//                            DispatchQueue.main.async {
                                let controller = MutedViewController()
                                controller.currentTagTitle = "Muted"
//                                controller.currentTags = stat
                                self.navigationController?.pushViewController(controller, animated: true)
//                            }
//                        }
//                    }
                }
                .action(.default("Blocked".localized), image: UIImage(named: "block2")) { (action, ind) in
                     
                    
//                    let request = Blocks.all()
//                    StoreStruct.client.run(request) { (statuses) in
//                        if let stat = (statuses.value) {
//                            DispatchQueue.main.async {
                                let controller = BlockedViewController()
                                controller.currentTagTitle = "Blocked"
//                                controller.currentTags = stat
                                self.navigationController?.pushViewController(controller, animated: true)
//                            }
//                        }
//                    }
                }
                .action(.default("Status Filters".localized), image: UIImage(named: "filters")) { (action, ind) in
                     
                    
                    let request = FilterToots.all()
                    StoreStruct.client.run(request) {[weak self] (statuses) in
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {
                                let controller = FiltersViewController()
                                controller.currentTagTitle = "Status Filters"
                                controller.currentTags = stat
                                self?.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }
                }
                .action(.default("Scheduled Posts"), image: UIImage(named: "scheduled")) { (action, ind) in
                     
                    
                    let request = Statuses.allScheduled()
                    StoreStruct.client.run(request) {[weak self] (statuses) in
                        print("scheduled stats")
                         
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {
                                let controller = ScheduledStatusesViewController()
                                controller.statuses = stat
                                self?.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }
                }
                .action(.default("Search".localized), image: UIImage(named: "search2")) { (action, ind) in
                     
                    DispatchQueue.main.async {
                        let controller = SearchViewController()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                .action(.default(" Follows/Followers".localized), image: UIImage(named: "profile")) { (action, ind) in
                    
                    DispatchQueue.main.async {
                        let controller = FollowersViewController()
                        controller.profileStatus = self.chosenUser.id
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                .action(.default(" Follow Suggestions".localized), image: UIImage(named: "folsug")) { (action, ind) in
                     
                    
                    let request = Accounts.followSuggestions()
                    StoreStruct.client.run(request) {[weak self] (statuses) in
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {
                                let controller = FollowSuggestionsViewController()
                                controller.statusFollows = stat
                                self?.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }
                }
                .action(.default(" Endorsed Accounts".localized), image: UIImage(named: "endo")) { (action, ind) in
                     
                    
                    let request = Accounts.allEndorsements()
                    StoreStruct.client.run(request) {[weak self] (statuses) in
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {
                                let controller = EndorsedViewController()
                                controller.statusFollows = stat
                                self?.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }
                }
                .action(.default(" Instance Details".localized), image: UIImage(named: "instats")) { (action, ind) in
                     
                    var instImage = UIImage()
                    if StoreStruct.currentInstanceDetails.first?.thumbnail != nil {
                        if let url = URL(string: StoreStruct.currentInstanceDetails.first?.thumbnail ?? "https://mastodon.social/") {
                            let data = try? Data(contentsOf: url)
                            instImage = UIImage(data: data!) ?? UIImage()
                        }
                    }
                    Alertift.actionSheet(title: "\(StoreStruct.currentInstanceDetails.first?.title.stripHTML() ?? "Instance") (\(StoreStruct.currentInstanceDetails.first?.version ?? "1.0.0"))", message: "\(StoreStruct.currentInstanceDetails.first?.stats.userCount ?? 0) users\n\(StoreStruct.currentInstanceDetails.first?.stats.statusCount ?? 0) statuses\n\(StoreStruct.currentInstanceDetails.first?.stats.domainCount ?? 0) domains\n\n\(StoreStruct.currentInstanceDetails.first?.description.stripHTML() ?? "")")
                        .image(instImage)
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Instance Admin Contact".localized), image: nil) { (action, ind) in
                            if MFMailComposeViewController.canSendMail() {
                                let mail = MFMailComposeViewController()
                                mail.mailComposeDelegate = self
                                mail.setToRecipients([StoreStruct.currentInstanceDetails.first?.email ?? "shihab.mehboob@hotmail.com"])

                                self.present(mail, animated: true)
                            } else {
                                // show failure alert
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
                .action(.default(" Edit Profile".localized), image: UIImage(named: "profile")) { (action, ind) in
                     
                    
                        self.editProfileDetails()
                    
                }
                .action(.default(" Add Account".localized), image: UIImage(named: "addac1")) { (action, ind) in
                     
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut2"), object: nil)
                }
                .action(.default(" Share Profile".localized), image: UIImage(named: "share")) { (action, ind) in
                     
                    
                    
                    
                    Alertift.actionSheet()
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark)
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Share Link".localized), image: UIImage(named: "share")) { (action, ind) in
                             
                            
                            let objectsToShare = [self.chosenUser.url]
                            let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            vc.popoverPresentationController?.sourceView = self.view
                            vc.previewNumberOfLines = 5
                            vc.previewFont = UIFont.systemFont(ofSize: 14)
                            self.present(vc, animated: true, completion: nil)
                        }
                        .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                             
                            
                            let controller = NewQRViewController()
                            controller.ur = self.chosenUser.url
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
                .action(.default("Entertainment".localized), image: UIImage(named: "game")) { (action, ind) in
                    let z1 = Alertift.actionSheet(title: nil, message: "Find some new jokes to laugh at or play a quick arcade game to relieve your boredom.")
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Tell Me A Joke!".localized), image: nil) { (action, ind) in
                            
                            let urlStr = "https://official-joke-api.appspot.com/jokes/random"
                            let url: URL = URL(string: urlStr)!
                            var request = URLRequest(url: url)
                            request.httpMethod = "GET"
                            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                            request.addValue("application/json", forHTTPHeaderField: "Accept")
                            let sessionConfig = URLSessionConfiguration.default
                            let session = URLSession(configuration: sessionConfig)
                            let task = session.dataTask(with: request) { (data, response, err) in
                                do {
                                    let json = try JSONDecoder().decode(Joke.self, from: data ?? Data())
                                    self.tellJoke(json)
                                } catch {
                                    print("err")
                                }
                            }
                            task.resume()
                            
                            
                        }
                        .action(.default("Save Yourself!".localized), image: nil) { (action, ind) in
                            
                            let vc = GameViewController()
                            self.present(vc, animated: true, completion: nil)
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                    z1.popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
                    z1.show(on: self)
                }
//                .action(.default(" Log Out".localized), image: UIImage(named: "lout")) { (action, ind) in
//                     
//
//                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//                    switch (deviceIdiom) {
//                    case .phone:
//                        NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut"), object: nil)
//                    case .pad:
//                        NotificationCenter.default.post(name: Notification.Name(rawValue: "logBackOut"), object: nil)
//                    default:
//                        NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut"), object: nil)
//                    }
//
//                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
            }

            if self.chosenUser.locked {
                z1.action(.default("Follow Requests"), image: UIImage(named: "profile")) { (action, ind) in
                    
                    let request = FollowRequests.all()
                    StoreStruct.client.run(request) { [weak self](statuses) in
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {

                                let controller = FollowRequestsViewController()
                                controller.currentTags = stat
                                self?.navigationController?.pushViewController(controller, animated: true)

                            }
                        }
                    }
                    
                }
            }





            _ = z1.popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
            z1.show(on: self)

        }


    }
    
    func tellJoke(_ json: Joke) {
        DispatchQueue.main.async {
            let z2 = Alertift.actionSheet(title: json.setup, message: json.punchline)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default("Tell Me Another Joke!".localized), image: nil) { (action, ind) in
                    
                    let urlStr = "https://official-joke-api.appspot.com/jokes/random"
                    let url: URL = URL(string: urlStr)!
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig)
                    let task = session.dataTask(with: request) { (data, response, err) in
                        do {
                            let json = try JSONDecoder().decode(Joke.self, from: data ?? Data())
                            self.tellJoke(json)
                        } catch {
                            print("err")
                        }
                    }
                    task.resume()
                    
                    
                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
            }
            z2.popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
            z2.show(on: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            if self.profileStatuses.isEmpty {

                if self.chosenUser == nil {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
                    cell.backgroundColor = Colours.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {

                    self.ai.stopAnimating()
                    self.ai.removeFromSuperview()

                    if self.fromOtherUser == true {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
                        cell.configure(self.chosenUser)
                        cell.profileImageView.addTarget(self, action: #selector(self.touchProfileImage(_:)), for: .touchUpInside)
                        cell.headerImageView.addTarget(self, action: #selector(self.touchHeaderImage(_:)), for: .touchUpInside)
                        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(self.panProfile(pan:)))
                        cell.profileImageView.addGestureRecognizer(pan1)
                        cell.follows.addTarget(self, action: #selector(self.didTouchFollows), for: .touchUpInside)
                        cell.follows.tag = indexPath.row
                        cell.follows.titleLabel?.textColor = Colours.tabSelected
                        cell.follows.setTitleColor(Colours.tabSelected, for: .normal)
                        cell.more.addTarget(self, action: #selector(self.moreTop), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
                        
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            let controller = ThirdViewController()
                            if string == StoreStruct.currentUser.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: string)
                            StoreStruct.client.run(request) {[weak self] (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        DispatchQueue.main.async {
                                            controller.userIDtoUse = stat[0].id
                                            self?.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                        cell.toot.handleURLTap { (url) in
                            // safari
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            if url.absoluteString.hasPrefix(".") {
                                let z = URL(string: String(url.absoluteString.dropFirst()))!
                                UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                        } else {
                                            UIApplication.shared.openURL(z)
                                        }
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                        } else {
                                            UIApplication.shared.openURL(url)
                                        }
                                    }
                                }
                            }
                        }
                        cell.toot.handleHashtagTap { (string) in
                            // hash
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            let controller = HashtagViewController()
                            controller.currentTagTitle = string
//                            let request = Timelines.tag(string)
//                            StoreStruct.client.run(request) { (statuses) in
//                                if let stat = (statuses.value) {
//                                    DispatchQueue.main.async {
//                                        controller.currentTags = stat
                                        self.navigationController?.pushViewController(controller, animated: true)
//                                    }
//                                }
//                            }
                        }


                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    } else {


//                        if self.chosenUser.fields.count > 0 {
                        
                            
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCellOwn", for: indexPath) as! ProfileHeaderCellOwn
                            cell.configure(self.chosenUser)
                            cell.profileImageView.addTarget(self, action: #selector(self.touchProfileImage(_:)), for: .touchUpInside)
                            cell.headerImageView.addTarget(self, action: #selector(self.touchHeaderImage(_:)), for: .touchUpInside)
                        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(self.panProfile(pan:)))
                        cell.profileImageView.addGestureRecognizer(pan1)
                            cell.follows.addTarget(self, action: #selector(self.didTouchFollows), for: .touchUpInside)
                            cell.follows.tag = indexPath.row
                        cell.follows.titleLabel?.textColor = Colours.tabSelected
                        cell.follows.setTitleColor(Colours.tabSelected, for: .normal)
                            cell.more.addTarget(self, action: #selector(self.moreTop), for: .touchUpInside)
                            cell.settings.addTarget(self, action: #selector(self.setTop), for: .touchUpInside)
                            cell.backgroundColor = Colours.white
                            
                            cell.toot.handleMentionTap { (string) in
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }

                                let controller = ThirdViewController()
                                if string == StoreStruct.currentUser.username {} else {
                                    controller.fromOtherUser = true
                                }
                                let request = Accounts.search(query: string)
                                StoreStruct.client.run(request) {[weak self] (statuses) in
                                    if let stat = (statuses.value) {
                                        if stat.count > 0 {
                                            DispatchQueue.main.async {
                                                controller.userIDtoUse = stat[0].id
                                                self?.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                            cell.toot.handleURLTap { (url) in
                                // safari
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }

                                if url.absoluteString.hasPrefix(".") {
                                    let z = URL(string: String(url.absoluteString.dropFirst()))!
                                    UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                                        if !success {
                                            if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                            self.safariVC = SFSafariViewController(url: z)
                                            self.safariVC?.preferredBarTintColor = Colours.white
                                            self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                            self.present(self.safariVC!, animated: true, completion: nil)
                                            } else {
                                                UIApplication.shared.openURL(z)
                                            }
                                        }
                                    }
                                } else {
                                    UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                        if !success {
                                            if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                            self.safariVC = SFSafariViewController(url: url)
                                            self.safariVC?.preferredBarTintColor = Colours.white
                                            self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                            self.present(self.safariVC!, animated: true, completion: nil)
                                            } else {
                                                UIApplication.shared.openURL(url)
                                            }
                                        }
                                    }
                                }
                            }
                            cell.toot.handleHashtagTap { (string) in
                                // hash
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }

                                let controller = HashtagViewController()
                                controller.currentTagTitle = string
//                                let request = Timelines.tag(string)
//                                StoreStruct.client.run(request) { (statuses) in
//                                    if let stat = (statuses.value) {
//                                        DispatchQueue.main.async {
//                                            controller.currentTags = stat
                                            self.navigationController?.pushViewController(controller, animated: true)
//                                        }
//                                    }
//                                }
                            }

                            let bgColorView = UIView()
                            bgColorView.backgroundColor = Colours.white
                            cell.selectedBackgroundView = bgColorView
                            return cell
                    }
                }
            } else {


                if self.fromOtherUser == true {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
                    cell.configure(self.chosenUser)
                    cell.profileImageView.addTarget(self, action: #selector(self.touchProfileImage(_:)), for: .touchUpInside)
                    cell.headerImageView.addTarget(self, action: #selector(self.touchHeaderImage(_:)), for: .touchUpInside)
                    let pan1 = UIPanGestureRecognizer(target: self, action: #selector(self.panProfile(pan:)))
                    cell.profileImageView.addGestureRecognizer(pan1)
                    cell.follows.addTarget(self, action: #selector(self.didTouchFollows), for: .touchUpInside)
                    cell.follows.tag = indexPath.row
                    cell.follows.titleLabel?.textColor = Colours.tabSelected
                    cell.follows.setTitleColor(Colours.tabSelected, for: .normal)
                    cell.more.addTarget(self, action: #selector(self.moreTop), for: .touchUpInside)
                    cell.settings.addTarget(self, action: #selector(self.didTouchToFol), for: .touchUpInside)
                    cell.backgroundColor = Colours.white
                    
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }

                        let controller = ThirdViewController()
                        if string == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                        let request = Accounts.search(query: string)
                        StoreStruct.client.run(request) {[weak self] (statuses) in
                            if let stat = (statuses.value) {
                                if stat.count > 0 {
                                    DispatchQueue.main.async {
                                        controller.userIDtoUse = stat[0].id
                                        self?.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                    }
                    cell.toot.handleURLTap { (url) in
                        // safari
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }

                        if url.absoluteString.hasPrefix(".") {
                            let z = URL(string: String(url.absoluteString.dropFirst()))!
                            UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: z)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(z)
                                    }
                                }
                            }
                        } else {
                            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: url)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                            }
                        }
                    }
                    cell.toot.handleHashtagTap { (string) in
                        // hash
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }

                        let controller = HashtagViewController()
                        controller.currentTagTitle = string
//                        let request = Timelines.tag(string)
//                        StoreStruct.client.run(request) { (statuses) in
//                            if let stat = (statuses.value) {
//                                DispatchQueue.main.async {
//                                    controller.currentTags = stat
                                    self.navigationController?.pushViewController(controller, animated: true)
//                                }
//                            }
//                        }
                    }

                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {


                    if self.chosenUser != nil || self.chosenUser.fields.count > 0 {


                        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCellOwn", for: indexPath) as! ProfileHeaderCellOwn
                        cell.configure(self.chosenUser)
                        cell.profileImageView.addTarget(self, action: #selector(self.touchProfileImage(_:)), for: .touchUpInside)
                        cell.headerImageView.addTarget(self, action: #selector(self.touchHeaderImage(_:)), for: .touchUpInside)
                        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(self.panProfile(pan:)))
                        cell.profileImageView.addGestureRecognizer(pan1)
                        cell.follows.addTarget(self, action: #selector(self.didTouchFollows), for: .touchUpInside)
                        cell.follows.tag = indexPath.row
                        cell.follows.titleLabel?.textColor = Colours.tabSelected
                        cell.follows.setTitleColor(Colours.tabSelected, for: .normal)
                        cell.more.addTarget(self, action: #selector(self.moreTop), for: .touchUpInside)
                        cell.settings.addTarget(self, action: #selector(self.setTop), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
                        
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            let controller = ThirdViewController()
                            if string == StoreStruct.currentUser.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: string)
                            StoreStruct.client.run(request) {[weak self] (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        DispatchQueue.main.async {
                                            controller.userIDtoUse = stat[0].id
                                            self?.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                        cell.toot.handleURLTap { (url) in
                            // safari
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            if url.absoluteString.hasPrefix(".") {
                                let z = URL(string: String(url.absoluteString.dropFirst()))!
                                UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                        } else {
                                            UIApplication.shared.openURL(z)
                                        }
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                        } else {
                                            UIApplication.shared.openURL(url)
                                        }
                                    }
                                }
                            }
                        }
                        cell.toot.handleHashtagTap { (string) in
                            // hash
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            let controller = HashtagViewController()
                            controller.currentTagTitle = string
//                            let request = Timelines.tag(string)
//                            StoreStruct.client.run(request) { (statuses) in
//                                if let stat = (statuses.value) {
//                                    DispatchQueue.main.async {
//                                        controller.currentTags = stat
                                        self.navigationController?.pushViewController(controller, animated: true)
//                                    }
//                                }
//                            }
                        }

                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell

                    } else {



                        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCellOwn2", for: indexPath) as! ProfileHeaderCellOwn2
                        cell.configure(self.chosenUser)
                        cell.profileImageView.addTarget(self, action: #selector(self.touchProfileImage(_:)), for: .touchUpInside)
                        cell.headerImageView.addTarget(self, action: #selector(self.touchHeaderImage(_:)), for: .touchUpInside)
                        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(self.panProfile(pan:)))
                        cell.profileImageView.addGestureRecognizer(pan1)
                        cell.follows.addTarget(self, action: #selector(self.didTouchFollows), for: .touchUpInside)
                        cell.follows.tag = indexPath.row
                        cell.follows.titleLabel?.textColor = Colours.tabSelected
                        cell.follows.setTitleColor(Colours.tabSelected, for: .normal)
                        cell.more.addTarget(self, action: #selector(self.moreTop), for: .touchUpInside)
                        cell.settings.addTarget(self, action: #selector(self.setTop), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
                        
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            let controller = ThirdViewController()
                            if string == StoreStruct.currentUser.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: string)
                            StoreStruct.client.run(request) {[weak self] (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        DispatchQueue.main.async {
                                            controller.userIDtoUse = stat[0].id
                                            self?.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                        cell.toot.handleURLTap { (url) in
                            // safari
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            if url.absoluteString.hasPrefix(".") {
                                let z = URL(string: String(url.absoluteString.dropFirst()))!
                                UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                        } else {
                                            UIApplication.shared.openURL(z)
                                        }
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                        } else {
                                            UIApplication.shared.openURL(url)
                                        }
                                    }
                                }
                            }
                        }
                        cell.toot.handleHashtagTap { (string) in
                            // hash
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            let controller = HashtagViewController()
                            controller.currentTagTitle = string
//                            let request = Timelines.tag(string)
//                            StoreStruct.client.run(request) { (statuses) in
//                                if let stat = (statuses.value) {
//                                    DispatchQueue.main.async {
//                                        controller.currentTags = stat
                                        self.navigationController?.pushViewController(controller, animated: true)
//                                    }
//                                }
//                            }
                        }

                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell


                    }
                }
            }
        } else if indexPath.section == 1 {
            if self.profileStatusesHasImage.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCellImage", for: indexPath) as! ProfileHeaderCellImage
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCellImage", for: indexPath) as! ProfileHeaderCellImage
                cell.configure(self.profileStatuses, status2: self.profileStatusesHasImage)
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        } else {

            var zzz = self.profileStatuses
            if self.currentIndex == 0 {
                zzz = self.profileStatuses
            } else {
                zzz = self.profileStatuses2
            }
            
            if zzz.isEmpty {

                let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! MainFeedCell
                cell.delegate = self

                cell.rep1.tag = indexPath.row
                cell.like1.tag = indexPath.row
                cell.boost1.tag = indexPath.row
                cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)

                //cell.configure(zzz[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.grayDark
                cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                cell.date.textColor = Colours.grayDark.withAlphaComponent(0.38)
                cell.toot.textColor = Colours.grayDark
                cell.toot.handleMentionTap { (string) in
                    // mention
                    //                    let selection = UISelectionFeedbackGenerator()
                    //                    selection.selectionChanged()
                    
                    var newString = string
                    zzz[indexPath.row].mentions.map({
                        if $0.acct.contains(string) {
                            newString = $0.id
                        }
                    })
                    
                    let controller = ThirdViewController()
                    if string == StoreStruct.currentUser.username {} else {
                        controller.fromOtherUser = true
                    }
                    controller.userIDtoUse = newString
                                DispatchQueue.main.async {
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }
                }
                cell.toot.handleURLTap { (url) in
                    // safari
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let selection = UISelectionFeedbackGenerator()
                        selection.selectionChanged()
                    }
                    if url.absoluteString.hasPrefix(".") {
                        let z = URL(string: String(url.absoluteString.dropFirst()))!
                        UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                            if !success {
                                if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                self.safariVC = SFSafariViewController(url: z)
                                self.safariVC?.preferredBarTintColor = Colours.white
                                self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                self.present(self.safariVC!, animated: true, completion: nil)
                                } else {
                                    UIApplication.shared.openURL(z)
                                }
                            }
                        }
                    } else {
                        UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                            if !success {
                                if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                self.safariVC = SFSafariViewController(url: url)
                                self.safariVC?.preferredBarTintColor = Colours.white
                                self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                self.present(self.safariVC!, animated: true, completion: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }
                    }
                }
                cell.toot.handleHashtagTap { (string) in
                    // hash
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let selection = UISelectionFeedbackGenerator()
                        selection.selectionChanged()
                    }
                    let controller = HashtagViewController()
                    controller.currentTagTitle = string
//                    let request = Timelines.tag(string)
//                    StoreStruct.client.run(request) { (statuses) in
//                        if let stat = (statuses.value) {
//                            DispatchQueue.main.async {
//                                controller.currentTags = stat
                                self.navigationController?.pushViewController(controller, animated: true)
//                            }
//                        }
//                    }
                }
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
                cell.selectedBackgroundView = bgColorView
                return cell

            } else {
                
                if indexPath.row == zzz.count - 1 {
                    self.fetchMoreProfile()
                }
                
                if indexPath.row <= zzz.count {
                
                if zzz[indexPath.row].reblog?.mediaAttachments.isEmpty ?? zzz[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! MainFeedCell
                    cell.delegate = self

                    cell.rep1.tag = indexPath.row
                    cell.like1.tag = indexPath.row
                    cell.boost1.tag = indexPath.row
                    cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                    cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                    cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)

                    cell.configure(zzz[indexPath.row])
                    cell.profileImageView.tag = indexPath.row
                    cell.userTag.tag = indexPath.row
                    cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.userTag.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.grayDark
                    cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                    cell.date.textColor = Colours.grayDark.withAlphaComponent(0.38)
                    cell.toot.textColor = Colours.grayDark
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }

                        var newString = string
                        zzz[indexPath.row].mentions.map({
                            if $0.acct.contains(string) {
                                newString = $0.id
                            }
                        })
                        
                        
                        let controller = ThirdViewController()
                        if newString == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                                    controller.userIDtoUse = newString
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                    }
                    cell.toot.handleURLTap { (url) in
                        // safari
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        if url.absoluteString.hasPrefix(".") {
                            let z = URL(string: String(url.absoluteString.dropFirst()))!
                            UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: z)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(z)
                                    }
                                }
                            }
                        } else {
                            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: url)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                            }
                        }
                    }
                    cell.toot.handleHashtagTap { (string) in
                        // hash
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        let controller = HashtagViewController()
                        controller.currentTagTitle = string
//                        let request = Timelines.tag(string)
//                        StoreStruct.client.run(request) { (statuses) in
//                            if let stat = (statuses.value) {
//                                DispatchQueue.main.async {
//                                    controller.currentTags = stat
                                    self.navigationController?.pushViewController(controller, animated: true)
//                                }
//                            }
//                        }
                    }
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! MainFeedCellImage
                    cell.delegate = self

                    cell.rep1.tag = indexPath.row
                    cell.like1.tag = indexPath.row
                    cell.boost1.tag = indexPath.row
                    cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                    cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                    cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)

                    cell.configure(zzz[indexPath.row])
                    cell.mainImageView.addTarget(self, action: #selector(self.tappedImage(_:)), for: .touchUpInside)
                    cell.smallImage1.addTarget(self, action: #selector(self.tappedImageS1(_:)), for: .touchUpInside)
                    cell.smallImage2.addTarget(self, action: #selector(self.tappedImageS2(_:)), for: .touchUpInside)
                    cell.smallImage3.addTarget(self, action: #selector(self.tappedImageS3(_:)), for: .touchUpInside)
                    cell.smallImage4.addTarget(self, action: #selector(self.tappedImageS4(_:)), for: .touchUpInside)
                    cell.mainImageView.tag = indexPath.row
                    cell.smallImage1.tag = indexPath.row
                    cell.smallImage2.tag = indexPath.row
                    cell.smallImage3.tag = indexPath.row
                    cell.smallImage4.tag = indexPath.row
                    cell.backgroundColor = Colours.white
                    cell.profileImageView.tag = indexPath.row
                    cell.userTag.tag = indexPath.row
                    cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.userTag.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.userName.textColor = Colours.grayDark
                    cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                    cell.date.textColor = Colours.grayDark.withAlphaComponent(0.38)
                    cell.toot.textColor = Colours.grayDark
                    cell.mainImageView.backgroundColor = Colours.white
                    cell.mainImageViewBG.backgroundColor = Colours.white
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }

                        var newString = string
                        zzz[indexPath.row].mentions.map({
                            if $0.acct.contains(string) {
                                newString = $0.id
                            }
                        })
                        
                        
                        let controller = ThirdViewController()
                        if newString == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                        controller.userIDtoUse = newString
                        DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                    }
                    cell.toot.handleURLTap { (url) in
                        // safari
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        if url.absoluteString.hasPrefix(".") {
                            let z = URL(string: String(url.absoluteString.dropFirst()))!
                            UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: z)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(z)
                                    }
                                }
                            }
                        } else {
                            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: url)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                            }
                        }
                    }
                    cell.toot.handleHashtagTap { (string) in
                        // hash
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        let controller = HashtagViewController()
                        controller.currentTagTitle = string
//                        let request = Timelines.tag(string)
//                        StoreStruct.client.run(request) { (statuses) in
//                            if let stat = (statuses.value) {
//                                DispatchQueue.main.async {
//                                    controller.currentTags = stat
                                    self.navigationController?.pushViewController(controller, animated: true)
//                                }
//                            }
//                        }
                    }
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
                    cell.selectedBackgroundView = bgColorView
                    return cell
                }
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! MainFeedCellImage
                    cell.delegate = self
                    
                    cell.rep1.tag = indexPath.row
                    cell.like1.tag = indexPath.row
                    cell.boost1.tag = indexPath.row
                    cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                    cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                    cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                    
                    cell.configure(zzz[indexPath.row])
                    cell.mainImageView.addTarget(self, action: #selector(self.tappedImage(_:)), for: .touchUpInside)
                    cell.smallImage1.addTarget(self, action: #selector(self.tappedImageS1(_:)), for: .touchUpInside)
                    cell.smallImage2.addTarget(self, action: #selector(self.tappedImageS2(_:)), for: .touchUpInside)
                    cell.smallImage3.addTarget(self, action: #selector(self.tappedImageS3(_:)), for: .touchUpInside)
                    cell.smallImage4.addTarget(self, action: #selector(self.tappedImageS4(_:)), for: .touchUpInside)
                    cell.mainImageView.tag = indexPath.row
                    cell.smallImage1.tag = indexPath.row
                    cell.smallImage2.tag = indexPath.row
                    cell.smallImage3.tag = indexPath.row
                    cell.smallImage4.tag = indexPath.row
                    cell.backgroundColor = Colours.white
                    cell.profileImageView.tag = indexPath.row
                    cell.userTag.tag = indexPath.row
                    cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.userTag.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.userName.textColor = Colours.grayDark
                    cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                    cell.date.textColor = Colours.grayDark.withAlphaComponent(0.38)
                    cell.toot.textColor = Colours.grayDark
                    cell.mainImageView.backgroundColor = Colours.white
                    cell.mainImageViewBG.backgroundColor = Colours.white
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        
                        var newString = string
                        zzz[indexPath.row].mentions.map({
                            if $0.acct.contains(string) {
                                newString = $0.id
                            }
                        })
                        
                        
                        let controller = ThirdViewController()
                        if newString == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                        controller.userIDtoUse = newString
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                    cell.toot.handleURLTap { (url) in
                        // safari
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        if url.absoluteString.hasPrefix(".") {
                            let z = URL(string: String(url.absoluteString.dropFirst()))!
                            UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: z)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(z)
                                    }
                                }
                            }
                        } else {
                            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: url)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                            }
                        }
                    }
                    cell.toot.handleHashtagTap { (string) in
                        // hash
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        let controller = HashtagViewController()
                        controller.currentTagTitle = string
//                        let request = Timelines.tag(string)
//                        StoreStruct.client.run(request) { (statuses) in
//                            if let stat = (statuses.value) {
//                                DispatchQueue.main.async {
//                                    controller.currentTags = stat
                                    self.navigationController?.pushViewController(controller, animated: true)
//                                }
//                            }
//                        }
                    }
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
                    cell.selectedBackgroundView = bgColorView
                    return cell
                }
            }
        }
    }


    @objc func didTouchProfile(sender: UIButton) {

        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        
        if sto[sender.tag].reblog?.account.username != nil {
            
//            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                let selection = UISelectionFeedbackGenerator()
//                selection.selectionChanged()
//            }
            
            let controller = ThirdViewController()
            if sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username == StoreStruct.currentUser.username {} else {
                controller.fromOtherUser = true
            }
            controller.userIDtoUse = sto[sender.tag].reblog?.account.id ?? sto[sender.tag].account.id
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }



    @objc func didTouchFollows(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UIImpactFeedbackGenerator(style: .light)
            selection.impactOccurred()
        }
        
        let controller = FollowersViewController()
        controller.profileStatus = self.chosenUser.id
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func touchHeaderImage(_ sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        
        StoreStruct.currentImageURL = URL(string: self.chosenUser.header)
        
        if self.fromOtherUser {
            if self.chosenUser.fields.count > 0 {
                
                if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCell {
                    var images = [SKPhoto]()
                    
                    let photo = SKPhoto.photoWithImageURL(self.chosenUser.header)
                    photo.shouldCachePhotoURLImage = true
                    images.append(photo)

                    let originImage = sender.currentImage
                    if originImage != nil {
                        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.headerImageView)
                        browser.displayToolbar = true
                        browser.displayAction = true
                        browser.delegate = self
                        browser.initializePageIndex(0)
                        present(browser, animated: true, completion: nil)
                    }
                }

            } else {
            if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCell2 {
            var images = [SKPhoto]()
            
            let photo = SKPhoto.photoWithImageURL(self.chosenUser.header)
            photo.shouldCachePhotoURLImage = true
            images.append(photo)

            let originImage = sender.currentImage
            if originImage != nil {
                let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.headerImageView)
                browser.displayToolbar = true
                browser.displayAction = true
                browser.delegate = self
                browser.initializePageIndex(0)
                present(browser, animated: true, completion: nil)
            }
            }
            }
        } else {

            if self.chosenUser.fields.count > 0 {

                if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCellOwn {
                var images = [SKPhoto]()
                
                let photo = SKPhoto.photoWithImageURL(self.chosenUser.header)
                photo.shouldCachePhotoURLImage = true
                images.append(photo)

                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.headerImageView)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: nil)
                }
                }

            } else {



                if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCellOwn2 {
                var images = [SKPhoto]()
                
                let photo = SKPhoto.photoWithImageURL(self.chosenUser.header)
                photo.shouldCachePhotoURLImage = true
                images.append(photo)

                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.headerImageView)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: nil)
                }
                }
            }

        }

    }

    @objc func touchProfileImage(_ sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        
        
        StoreStruct.currentImageURL = URL(string: self.chosenUser.avatar)
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCell {
            var images = [SKPhoto]()

            let photo = SKPhoto.photoWithImageURL(self.chosenUser.avatar, holder: cell.profileImageView.currentImage ?? nil)
            photo.shouldCachePhotoURLImage = true
            images.append(photo)

            let originImage = sender.currentImage
            if originImage != nil {
                let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.profileImageView)
                browser.displayToolbar = true
                browser.displayAction = true
                browser.delegate = self
                browser.initializePageIndex(0)
                present(browser, animated: true, completion: nil)
            }
            
        } else if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCell2 {
            var images = [SKPhoto]()
            
            let photo = SKPhoto.photoWithImageURL(self.chosenUser.avatar, holder: cell.profileImageView.currentImage ?? nil)
            photo.shouldCachePhotoURLImage = true
            images.append(photo)
            
            let originImage = sender.currentImage
            if originImage != nil {
                let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.profileImageView)
                browser.displayToolbar = true
                browser.displayAction = true
                browser.delegate = self
                browser.initializePageIndex(0)
                present(browser, animated: true, completion: nil)
            }
            
        } else {
            if self.chosenUser.fields.count > 0 {
                if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCellOwn {
                var images = [SKPhoto]()

                let photo = SKPhoto.photoWithImageURL(self.chosenUser.avatar, holder: nil)
                photo.shouldCachePhotoURLImage = true
                images.append(photo)

                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.profileImageView)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: nil)
                }
                } else if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCellOwn2 {
                    var images = [SKPhoto]()
                    
                    let photo = SKPhoto.photoWithImageURL(self.chosenUser.avatar, holder: nil)
                    photo.shouldCachePhotoURLImage = true
                    images.append(photo)
                    
                    let originImage = sender.currentImage
                    if originImage != nil {
                        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.profileImageView)
                        browser.displayToolbar = true
                        browser.displayAction = true
                        browser.delegate = self
                        browser.initializePageIndex(0)
                        present(browser, animated: true, completion: nil)
                    }
                }
            } else {


                if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCellOwn2 {
                var images = [SKPhoto]()

                let photo = SKPhoto.photoWithImageURL(self.chosenUser.avatar, holder: nil)
                photo.shouldCachePhotoURLImage = true
                images.append(photo)

                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.profileImageView)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: nil)
                }
                } else if let cell = tableView.cellForRow(at: indexPath) as? ProfileHeaderCellOwn {
                    var images = [SKPhoto]()
                    
                    let photo = SKPhoto.photoWithImageURL(self.chosenUser.avatar, holder: nil)
                    photo.shouldCachePhotoURLImage = true
                    images.append(photo)
                    
                    let originImage = sender.currentImage
                    if originImage != nil {
                        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.profileImageView)
                        browser.displayToolbar = true
                        browser.displayAction = true
                        browser.delegate = self
                        browser.initializePageIndex(0)
                        present(browser, animated: true, completion: nil)
                    }
                }

            }
        }
    }
    
    @objc func longVid(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if (UserDefaults.standard.object(forKey: "otherhaptics") == nil) || (UserDefaults.standard.object(forKey: "otherhaptics") as! Int == 0) {
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    let selection = UISelectionFeedbackGenerator()
                    selection.selectionChanged()
                }
            }
            let z = Alertift.actionSheet(title: nil, message: nil)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default("Speed Up 2x".localized), image: nil) { (action, ind) in
                    self.playerRate = 2
                    self.player.rate = 2
                }
                .action(.default("Speed Up 3x".localized), image: nil) { (action, ind) in
                    self.playerRate = 3
                    self.player.rate = 3
                }
                .action(.default("Speed Up 4x".localized), image: nil) { (action, ind) in
                    self.playerRate = 4
                    self.player.rate = 4
                }
                .action(.default("Slow Down".localized), image: nil) { (action, ind) in
                    self.playerRate = 0.5
                    self.player.rate = 0.5
                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
            if self.player.rate != 1 {
                z.action(.default("Regular Speed".localized), image: nil) { (action, ind) in
                    self.playerRate = 1
                    self.player.rate = 1
                }
            }
            z.show(on: self.playerViewController)
        }
    }
    
    let playerViewController = AVPlayerViewController()
    var playerRate: Float = 1
    var player = AVPlayer()
    @objc func tappedImage(_ sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        
        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        StoreStruct.newIDtoGoTo = sto[sender.tag].id

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
            
            if let videoURL = URL(string: sto[sender.tag].reblog?.mediaAttachments[0].url ?? sto[sender.tag].mediaAttachments[0].url) {
            if (UserDefaults.standard.object(forKey: "vidgif") == nil) || (UserDefaults.standard.object(forKey: "vidgif") as! Int == 0) {
                XPlayer.play(videoURL)
            } else {
                self.player = AVPlayer(url: videoURL)
                
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longVid(sender:)))
                longPress.minimumPressDuration = 0.5
                longPress.delegate = self
                self.playerViewController.view.addGestureRecognizer(longPress)
                self.playerViewController.player = self.player
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player!.play()
                }
            }
            }
            
            
        } else {

            let indexPath = IndexPath(row: sender.tag, section: 2)
            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
            var images = [SKPhoto]()
            var coun = 0
            (sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments).map({
                if coun == 0 {
                    let photo = SKPhoto.photoWithImageURL($0.url, holder: cell.mainImageView.currentImage ?? nil)
                    photo.shouldCachePhotoURLImage = true
                    if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                        photo.caption = cell.toot.text ?? ""
                    } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                        photo.caption = $0.description ?? ""
                    } else {
                        photo.caption = ""
                    }
                    images.append(photo)
                } else {
                    let photo = SKPhoto.photoWithImageURL($0.url, holder: nil)
                    photo.shouldCachePhotoURLImage = true
                    if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                        photo.caption = cell.toot.text ?? ""
                    } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                        photo.caption = $0.description ?? ""
                    } else {
                        photo.caption = ""
                    }
                    images.append(photo)
                }
                coun += 1
            })
            let originImage = sender.currentImage
            if originImage != nil {
                let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.mainImageView)
                browser.displayToolbar = true
                browser.displayAction = true
                browser.delegate = self
                browser.initializePageIndex(0)
                present(browser, animated: true, completion: nil)
            }
        }
        }
    }




    @objc func tappedImageS1(_ sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        
        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        StoreStruct.newIDtoGoTo = sto[sender.tag].id

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                let indexPath = IndexPath(row: sender.tag, section: 2)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? MainFeedCellImage else { return }
                var images = [SKPhoto]()
                var coun = 0
                (sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments).map({
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL($0.url, holder: cell.smallImage1.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = cell.toot.text ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = $0.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    } else {
                        let photo = SKPhoto.photoWithImageURL($0.url, holder: nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = cell.toot.text ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = $0.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
                    coun += 1
                })
                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.smallImage1)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: nil)
                }

            }

        }
    }

    @objc func tappedImageS2(_ sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        
        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        StoreStruct.newIDtoGoTo = sto[sender.tag].id

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                let indexPath = IndexPath(row: sender.tag, section: 2)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? MainFeedCellImage else { return }
                var images = [SKPhoto]()
                var coun = 0
                (sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments).map({
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL($0.url, holder: cell.smallImage2.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = cell.toot.text ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = $0.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    } else {
                        let photo = SKPhoto.photoWithImageURL($0.url, holder: nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = cell.toot.text ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = $0.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
                    coun += 1
                })
                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.smallImage2)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(1)
                    present(browser, animated: true, completion: nil)
                }

            }

        }
    }


    @objc func tappedImageS3(_ sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        
        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        StoreStruct.newIDtoGoTo = sto[sender.tag].id

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                let indexPath = IndexPath(row: sender.tag, section: 2)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? MainFeedCellImage else { return }
                var images = [SKPhoto]()
                var coun = 0
                (sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments).map({
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL($0.url, holder: cell.smallImage3.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = cell.toot.text ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = $0.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    } else {
                        let photo = SKPhoto.photoWithImageURL($0.url, holder: nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = cell.toot.text ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = $0.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
                    coun += 1
                })
                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.smallImage3)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(2)
                    present(browser, animated: true, completion: nil)
                }

            }

        }
    }



    @objc func tappedImageS4(_ sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }
        
        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        StoreStruct.newIDtoGoTo = sto[sender.tag].id

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                let indexPath = IndexPath(row: sender.tag, section: 2)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? MainFeedCellImage else { return }
                var images = [SKPhoto]()
                var coun = 0
                (sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments).map({
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL($0.url, holder: cell.smallImage4.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = cell.toot.text ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = $0.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    } else {
                        let photo = SKPhoto.photoWithImageURL($0.url, holder: nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = cell.toot.text ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = $0.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
                    coun += 1
                })
                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.smallImage4)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(3)
                    present(browser, animated: true, completion: nil)
                }

            }

        }
    }



    @objc func didTouchBoost(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }

        let theTable = self.tableView
        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        
        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
            StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[sender.tag].reblog?.id ?? sto[sender.tag].id }
            let request2 = Statuses.unreblog(id: sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            StoreStruct.client.run(request2) {[weak self] (statuses) in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    if sto[sender.tag].account.username == self.chosenUser.username {} else {
                        self.profileStatuses = self.profileStatuses.filter { $0 != self.profileStatuses[sender.tag] }
                        theTable.deleteRows(at: [IndexPath(row: sender.tag, section: 2)], with: .none)
                    }

                    if let cell = theTable.cellForRow(at:IndexPath(row: sender.tag, section: 2)) as? MainFeedCell {
                        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        } else {
            StoreStruct.allBoosts.append(sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            let request2 = Statuses.reblog(id: sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            StoreStruct.client.run(request2) { [weak self] (statuses) in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {

                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                    }

                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as? MainFeedCell {
                        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
                        } else {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
                            cell.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
                        } else {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
                            cell.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        }
    }



    @objc func didTouchLike(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }

        var theTable = self.tableView
        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        
        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
            StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[sender.tag].reblog?.id ?? sto[sender.tag].id }
            let request2 = Statuses.unfavourite(id: sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            StoreStruct.client.run(request2) { [weak self] (statuses) in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as? MainFeedCell {
                        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        } else {
            StoreStruct.allLikes.append(sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            let request2 = Statuses.favourite(id: sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            StoreStruct.client.run(request2) {(statuses) in
                
                DispatchQueue.main.async {
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                    }

                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as? MainFeedCell {
                        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
                        } else {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
                            cell.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.grayDark.withAlphaComponent(0.21)), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
                        } else {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
                            cell.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        }
    }



    @objc func didTouchReply(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }

        var theTable = self.tableView
        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }
        
        let controller = ComposeViewController()
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            controller.modalPresentationStyle = .pageSheet
        default:
            print("nil")
        }
        StoreStruct.spoilerText = sto[sender.tag].reblog?.spoilerText ?? sto[sender.tag].spoilerText
        controller.inReply = [sto[sender.tag].reblog ?? sto[sender.tag]]
        controller.prevTextReply = sto[sender.tag].reblog?.content.stripHTML() ?? sto[sender.tag].content.stripHTML()
        controller.inReplyText = sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username
        self.present(controller, animated: true, completion: nil)
    }




    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        var sto = self.profileStatuses
        if self.currentIndex == 0 {
            sto = self.profileStatuses
        } else {
            sto = self.profileStatuses2
        }

        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {} else {
            return nil
        }

        if indexPath.section == 2 {
            if orientation == .left {
                let impact = UIImpactFeedbackGenerator(style: .medium)

                let boost = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    
                    
                    
                    
                    
                    
                    if sto[indexPath.row].reblog?.reblogged ?? sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                        StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id }
                        let request2 = Statuses.unreblog(id: sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                    if sto[indexPath.row].reblog?.favourited ?? sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                                    } else {
                                        cell.moreImage.image = nil
                                    }
                                    cell.hideSwipe(animated: true)
                                } else {
                                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                                    if sto[indexPath.row].reblog?.favourited ?? sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                                    } else {
                                        cell.moreImage.image = nil
                                    }
                                    cell.hideSwipe(animated: true)
                                }
                            }
                        }
                    } else {
                        StoreStruct.allBoosts.append(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                        let request2 = Statuses.reblog(id: sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                                }

                                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                    if sto[indexPath.row].reblog?.favourited ?? sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
                                    } else {
                                        cell.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                                    }
                                    cell.hideSwipe(animated: true)
                                } else {
                                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                                    if sto[indexPath.row].reblog?.favourited ?? sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
                                    } else {
                                        cell.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                                    }
                                    cell.hideSwipe(animated: true)
                                }
                            }
                        }
                    }







                    if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                        cell.hideSwipe(animated: true)
                    }
                }
                boost.backgroundColor = Colours.white
                boost.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                boost.transitionDelegate = ScaleTransition.default
                boost.textColor = Colours.tabUnselected

                let like = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    
                    
                    
                    
                    
                    
                    if sto[indexPath.row].reblog?.favourited ?? sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                        StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id }
                        let request2 = Statuses.unfavourite(id: sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                    if sto[indexPath.row].reblog?.reblogged ?? sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                                    } else {
                                        cell.moreImage.image = nil
                                    }
                                    cell.hideSwipe(animated: true)
                                } else {
                                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                                    if sto[indexPath.row].reblog?.reblogged ?? sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "boost0")?.maskWithColor(color: Colours.green)
                                    } else {
                                        cell.moreImage.image = nil
                                    }
                                    cell.hideSwipe(animated: true)
                                }
                            }
                        }
                    } else {
                        StoreStruct.allLikes.append(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                        let request2 = Statuses.favourite(id: sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                                }
                                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                    if sto[indexPath.row].reblog?.reblogged ?? sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
                                    } else {
                                        cell.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                                    }
                                    cell.hideSwipe(animated: true)
                                } else {
                                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                                    if sto[indexPath.row].reblog?.reblogged ?? sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "fifty")?.maskWithColor(color: Colours.lightBlue)
                                    } else {
                                        cell.moreImage.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                                    }
                                    cell.hideSwipe(animated: true)
                                }
                            }
                        }
                    }








                    if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                        cell.hideSwipe(animated: true)
                    }
                }
                like.backgroundColor = Colours.white
                like.image = UIImage(named: "like0")?.maskWithColor(color: Colours.orange)
                like.transitionDelegate = ScaleTransition.default
                like.textColor = Colours.tabUnselected

                let reply = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    let controller = ComposeViewController()
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    switch (deviceIdiom) {
                    case .pad:
                        controller.modalPresentationStyle = .pageSheet
                    default:
                        print("nil")
                    }
                    StoreStruct.spoilerText = sto[indexPath.row].reblog?.spoilerText ?? sto[indexPath.row].spoilerText
                    controller.inReply = [sto[indexPath.row].reblog ?? sto[indexPath.row]]
                    controller.inReplyText = sto[indexPath.row].reblog?.account.username ?? sto[indexPath.row].account.username
                    controller.prevTextReply = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                    self.present(controller, animated: true, completion: nil)

                    if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                        cell.hideSwipe(animated: true)
                    }
                }
                reply.backgroundColor = Colours.white
                reply.transitionDelegate = ScaleTransition.default
                reply.textColor = Colours.tabUnselected

                if sto[indexPath.row].reblog?.visibility ?? sto[indexPath.row].visibility == .direct {
                    reply.image = UIImage(named: "direct2")?.maskWithColor(color: Colours.lightBlue)
                    if (UserDefaults.standard.object(forKey: "sworder") == nil) || (UserDefaults.standard.object(forKey: "sworder") as! Int == 0) {
                        return [reply, like]
                    } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 1) {
                        return [reply, like]
                    } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 2) {
                        return [reply, like]
                    } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 3) {
                        return [like, reply]
                    } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 4) {
                        return [like, reply]
                    } else {
                        return [like, reply]
                    }
                } else {
                    reply.image = UIImage(named: "reply0")?.maskWithColor(color: Colours.lightBlue)
                    if (UserDefaults.standard.object(forKey: "sworder") == nil) || (UserDefaults.standard.object(forKey: "sworder") as! Int == 0) {
                        return [reply, like, boost]
                    } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 1) {
                        return [reply, boost, like]
                    } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 2) {
                        return [boost, reply, like]
                    } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 3) {
                        return [boost, like, reply]
                    } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 4) {
                        return [like, reply, boost]
                    } else {
                        return [like, boost, reply]
                    }
                }

            } else {
                let impact = UIImpactFeedbackGenerator(style: .medium)

                let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }

                    var isMuted = false
                    let request0 = Mutes.all()
                    StoreStruct.client.run(request0) { (statuses) in
                        if let stat = (statuses.value) {
                            let s = stat.filter { $0.id == sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id }
                            if s.isEmpty {
                                isMuted = false
                            } else {
                                isMuted = true
                            }
                        }
                    }
                    var isBlocked = false
                    let request01 = Blocks.all()
                    StoreStruct.client.run(request01) { (statuses) in
                        if let stat = (statuses.value) {
                            let s = stat.filter { $0.id == sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id }
                            if s.isEmpty {
                                isBlocked = false
                            } else {
                                isBlocked = true
                            }
                        }
                    }





                    if sto[indexPath.row].account.id == StoreStruct.currentUser.id {



                        let wordsInThis = sto[indexPath.row].content.stripHTML().components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}.count
                        let newSeconds = Double(wordsInThis) * 0.38
                        var newSecondsText = "\(Int(newSeconds)) seconds average reading time"
                        if newSeconds >= 60 {
                            if Int(newSeconds) % 60 == 0 {
                                newSecondsText = "\(Int(newSeconds/60)) minutes average reading time"
                            } else {
                                newSecondsText = "\(Int(newSeconds/60)) minutes and \(Int(newSeconds) % 60) seconds average reading time"
                            }
                        }
                        
                        if sto[indexPath.row].spoilerText != "" {
                            newSecondsText = "\(sto[indexPath.row].spoilerText)\n\n\(newSecondsText)"
                        }
                        
                        Alertift.actionSheet(title: nil, message: newSecondsText)
                            .backgroundColor(Colours.white)
                            .titleTextColor(Colours.grayDark)
                            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                            .messageTextAlignment(.left)
                            .titleTextAlignment(.left)
                            .action(.default("Pin/Unpin".localized), image: UIImage(named: "pinned")) { (action, ind) in
                                 
                                if sto[indexPath.row].pinned ?? false || StoreStruct.allPins.contains(sto[indexPath.row].id) {
                                    StoreStruct.allPins = StoreStruct.allPins.filter { $0 != sto[indexPath.row].id }
                                    let request = Statuses.unpin(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        DispatchQueue.main.async {
                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                let notification = UINotificationFeedbackGenerator()
                                                notification.notificationOccurred(.success)
                                            }
                                            let statusAlert = StatusAlert()
                                            statusAlert.image = UIImage(named: "pinnedlarge")?.maskWithColor(color: Colours.grayDark)
                                            statusAlert.title = "Unpinned".localized
                                            statusAlert.contentColor = Colours.grayDark
                                            statusAlert.message = "This Toot"
                                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                                statusAlert.show()
                                            }
                                        }
                                    }
                                } else {
                                    StoreStruct.allPins.append(sto[indexPath.row].id)
                                    let request = Statuses.pin(id: sto[indexPath.row].id)
                                    StoreStruct.client.run(request) { (statuses) in
                                        DispatchQueue.main.async {
                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                let notification = UINotificationFeedbackGenerator()
                                                notification.notificationOccurred(.success)
                                            }
                                            let statusAlert = StatusAlert()
                                            statusAlert.image = UIImage(named: "pinnedlarge")?.maskWithColor(color: Colours.grayDark)
                                            statusAlert.title = "Pinned".localized
                                            statusAlert.contentColor = Colours.grayDark
                                            statusAlert.message = "This Toot"
                                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                                statusAlert.show()
                                            }
                                        }
                                    }
                                }
                            }
                            .action(.default("Delete and Redraft".localized), image: UIImage(named: "block")) { (action, ind) in
                                 
                                
                                let controller = ComposeViewController()
                                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                switch (deviceIdiom) {
                                case .pad:
                                    controller.modalPresentationStyle = .pageSheet
                                default:
                                    print("nil")
                                }
                                StoreStruct.spoilerText = sto[indexPath.row].reblog?.spoilerText ?? sto[indexPath.row].spoilerText
                                controller.idToDel = sto[indexPath.row].id
                                controller.filledTextFieldText = sto[indexPath.row].content.stripHTML()
                                self.present(controller, animated: true, completion: nil)

                            }
                            .action(.default("Delete".localized), image: UIImage(named: "block")) { (action, ind) in
                                 
                                
                                if self.currentIndex == 0 {
                                    self.profileStatuses = self.profileStatuses.filter { $0 != self.profileStatuses[indexPath.row] }
                                    self.tableView.deleteRows(at: [indexPath], with: .none)
                                } else if self.currentIndex == 1 {
                                    self.profileStatuses2 = self.profileStatuses2.filter { $0 != self.profileStatuses2[indexPath.row] }
                                    self.tableView.deleteRows(at: [indexPath], with: .none)
                                }


                                let request = Statuses.delete(id: sto[indexPath.row].id)
                                StoreStruct.client.run(request) { (statuses) in
                                    
                                    
                                    DispatchQueue.main.async {
                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                            let notification = UINotificationFeedbackGenerator()
                                            notification.notificationOccurred(.success)
                                        }
                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Deleted".localized
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = "Your Toot"
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                            statusAlert.show()
                                        }
                                        //sto.remove(at: indexPath.row)
                                        //self.tableView.reloadData()
                                    }
                                }
                            }
                            .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                                 
                                
                                let unreserved = "-._~/?"
                                let allowed = NSMutableCharacterSet.alphanumeric()
                                allowed.addCharacters(in: unreserved)
                                let bodyText = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                                let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
                                let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
                                var trans = bodyText.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
                                trans = trans!.replacingOccurrences(of: "\n\n", with: "%20")
                                let langStr = Locale.current.languageCode
                                let urlString = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=\(langStr ?? "en")&dt=t&q=\(trans!)&ie=UTF-8&oe=UTF-8"
                                guard let requestUrl = URL(string:urlString) else {
                                    return
                                }
                                let request = URLRequest(url:requestUrl)
                                let task = URLSession.shared.dataTask(with: request) {
                                    (data, response, error) in
                                    if error == nil, let usableData = data {
                                        do {
                                            let json = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers) as! [Any]

                                            var translatedText = ""
                                            for i in (json[0] as! [Any]) {
                                                translatedText = translatedText + ((i as! [Any])[0] as? String ?? "")
                                            }

                                            Alertift.actionSheet(title: nil, message: translatedText as? String ?? "Could not translate tweet")
                                                .backgroundColor(Colours.white)
                                                .titleTextColor(Colours.grayDark)
                                                .messageTextColor(Colours.grayDark)
                                                .messageTextAlignment(.left)
                                                .titleTextAlignment(.left)
                                                .action(.cancel("Dismiss"))
                                                .finally { action, index in
                                                    if action.style == .cancel {
                                                        return
                                                    }
                                                }
                                                .show(on: self)
                                        } catch let error as NSError {
                                            print(error)
                                        }

                                    }
                                }
                                task.resume()
                            }
                            .action(.default("Duplicate Toot".localized), image: UIImage(named: "addac1")) { (action, ind) in
                                 
                                
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
                                controller.filledTextFieldText = sto[indexPath.row].content.stripHTML()
                                self.present(controller, animated: true, completion: nil)
                            }
                            .action(.default("Share".localized), image: UIImage(named: "share")) { (action, ind) in
                                 
                                
                                
                                
                                Alertift.actionSheet()
                                    .backgroundColor(Colours.white)
                                    .titleTextColor(Colours.grayDark)
                                    .messageTextColor(Colours.grayDark)
                                    .messageTextAlignment(.left)
                                    .titleTextAlignment(.left)
                                    .action(.default("Share Link".localized), image: UIImage(named: "share")) { (action, ind) in
                                         
                                        
                                        if let myWebsite = sto[indexPath.row].url {

                                            let objectsToShare = [myWebsite]
                                            if UIDevice.current.userInterfaceIdiom == .pad {
                                                let vc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                vc.popoverPresentationController?.sourceView = self.view
                                                vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                                vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                                                self.present(vc, animated: true, completion: nil)
                                            } else {
                                                let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                vc.popoverPresentationController?.sourceView = self.view
                                                vc.previewNumberOfLines = 5
                                                vc.previewFont = UIFont.systemFont(ofSize: 14)
                                                self.present(vc, animated: true, completion: nil)
                                            }
                                        }



                                    }
                                    .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                         
                                        
                                        let bodyText = sto[indexPath.row].content.stripHTML()
                                        if UIDevice.current.userInterfaceIdiom == .pad {
                                            let vc = UIActivityViewController(activityItems: [bodyText], applicationActivities: nil)
                                            vc.popoverPresentationController?.sourceView = self.view
                                            vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                            vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                                            self.present(vc, animated: true, completion: nil)
                                        } else {
                                            let vc = VisualActivityViewController(text: bodyText)
                                            vc.popoverPresentationController?.sourceView = self.view
                                            vc.previewNumberOfLines = 5
                                            vc.previewFont = UIFont.systemFont(ofSize: 14)
                                            self.present(vc, animated: true, completion: nil)
                                        }

                                    }
                                    .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                                         
                                        
                                        let controller = NewQRViewController()
                                        controller.ur = sto[indexPath.row].reblog?.url?.absoluteString ?? sto[indexPath.row].url?.absoluteString ?? "https://www.thebluebird.app"
                                        self.present(controller, animated: true, completion: nil)

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
                            .action(.cancel("Dismiss"))
                            .finally { action, index in
                                if action.style == .cancel {
                                    return
                                }
                            }
                            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                            .show(on: self)



                    } else {




                        let wordsInThis = sto[indexPath.row].content.stripHTML().components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}.count
                        let newSeconds = Double(wordsInThis) * 0.38
                        var newSecondsText = "\(Int(newSeconds)) seconds average reading time"
                        if newSeconds >= 60 {
                            if Int(newSeconds) % 60 == 0 {
                                newSecondsText = "\(Int(newSeconds/60)) minutes average reading time"
                            } else {
                                newSecondsText = "\(Int(newSeconds/60)) minutes and \(Int(newSeconds) % 60) seconds average reading time"
                            }
                        }
                        
                        if sto[indexPath.row].spoilerText != "" {
                            newSecondsText = "\(sto[indexPath.row].spoilerText)\n\n\(newSecondsText)"
                        }
                        
                        Alertift.actionSheet(title: nil, message: newSecondsText)
                            .backgroundColor(Colours.white)
                            .titleTextColor(Colours.grayDark)
                            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                            .messageTextAlignment(.left)
                            .titleTextAlignment(.left)
                            .action(.default("Mute/Unmute".localized), image: UIImage(named: "block")) { (action, ind) in
                                 
                                
                                if isMuted == false {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Muted".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = sto[indexPath.row].reblog?.account.displayName ?? sto[indexPath.row].account.displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
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
                                    statusAlert.message = sto[indexPath.row].reblog?.account.displayName ?? sto[indexPath.row].account.displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }

                                   
                                }

                            }
                            .action(.default("Block/Unblock".localized), image: UIImage(named: "block2")) { (action, ind) in
                                 
                                
                                if isBlocked == false {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "block2large")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Blocked".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = sto[indexPath.row].reblog?.account.displayName ?? sto[indexPath.row].account.displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
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
                                    statusAlert.message = sto[indexPath.row].reblog?.account.displayName ?? sto[indexPath.row].account.displayName
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show()
                                    }

                                    
                                }

                            }
                            .action(.default("Report".localized), image: UIImage(named: "flagrep")) { (action, ind) in
                                 
                                
                                Alertift.actionSheet()
                                    .backgroundColor(Colours.white)
                                    .titleTextColor(Colours.grayDark)
                                    .messageTextColor(Colours.grayDark)
                                    .messageTextAlignment(.left)
                                    .titleTextAlignment(.left)
                                    .action(.default("Harassment"), image: nil) { (action, ind) in
                                         
                                        
                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                            let notification = UINotificationFeedbackGenerator()
                                            notification.notificationOccurred(.success)
                                        }

                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Reported".localized
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = "Harassment"
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                            statusAlert.show()
                                        }

                                        

                                    }
                                    .action(.default("No Content Warning"), image: nil) { (action, ind) in
                                         
                                        
                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                            let notification = UINotificationFeedbackGenerator()
                                            notification.notificationOccurred(.success)
                                        }

                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Reported".localized
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = "No Content Warning"
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                            statusAlert.show()
                                        }

                                        

                                    }
                                    .action(.default("Spam"), image: nil) { (action, ind) in
                                         
                                        
                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                            let notification = UINotificationFeedbackGenerator()
                                            notification.notificationOccurred(.success)
                                        }

                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Reported".localized
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = "Spam"
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                            statusAlert.show()
                                        }

                                        

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
                            .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                                 
                                
                                let unreserved = "-._~/?"
                                let allowed = NSMutableCharacterSet.alphanumeric()
                                allowed.addCharacters(in: unreserved)
                                let bodyText = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                                let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
                                let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
                                var trans = bodyText.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
                                trans = trans!.replacingOccurrences(of: "\n", with: "%20")
                                let langStr = Locale.current.languageCode
                                let urlString = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=\(langStr ?? "en")&dt=t&q=\(trans!)&ie=UTF-8&oe=UTF-8"
                                guard let requestUrl = URL(string:urlString) else {
                                    return
                                }
                                let request = URLRequest(url:requestUrl)
                                let task = URLSession.shared.dataTask(with: request) {
                                    (data, response, error) in
                                    if error == nil, let usableData = data {
                                        do {
                                            let json = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers) as! [Any]

                                            var translatedText = ""
                                            for i in (json[0] as! [Any]) {
                                                translatedText = translatedText + ((i as! [Any])[0] as? String ?? "")
                                            }

                                            Alertift.actionSheet(title: nil, message: translatedText as? String ?? "Could not translate tweet")
                                                .backgroundColor(Colours.white)
                                                .titleTextColor(Colours.grayDark)
                                                .messageTextColor(Colours.grayDark)
                                                .messageTextAlignment(.left)
                                                .titleTextAlignment(.left)
                                                .action(.cancel("Dismiss"))
                                                .finally { action, index in
                                                    if action.style == .cancel {
                                                        return
                                                    }
                                                }
                                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                                                .show(on: self)
                                        } catch let error as NSError {
                                            print(error)
                                        }

                                    }
                                }
                                task.resume()
                            }
                            .action(.default("Duplicate Toot".localized), image: UIImage(named: "addac1")) { (action, ind) in
                                 
                                
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
                                controller.filledTextFieldText = sto[indexPath.row].content.stripHTML()
                                self.present(controller, animated: true, completion: nil)
                            }
                            .action(.default("Share".localized), image: UIImage(named: "share")) { (action, ind) in
                                 
                                
                                
                                
                                
                                Alertift.actionSheet()
                                    .backgroundColor(Colours.white)
                                    .titleTextColor(Colours.grayDark)
                                    .messageTextColor(Colours.grayDark)
                                    .messageTextAlignment(.left)
                                    .titleTextAlignment(.left)
                                    .action(.default("Share Link".localized), image: UIImage(named: "share")) { (action, ind) in
                                         
                                        
                                        if let myWebsite = sto[indexPath.row].reblog?.url ?? sto[indexPath.row].url {
                                            let objectsToShare = [myWebsite]
                                            if UIDevice.current.userInterfaceIdiom == .pad {
                                                let vc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                vc.popoverPresentationController?.sourceView = self.view
                                                vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                                vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                                                self.present(vc, animated: true, completion: nil)
                                            } else {
                                                let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                vc.popoverPresentationController?.sourceView = self.view
                                                vc.previewNumberOfLines = 5
                                                vc.previewFont = UIFont.systemFont(ofSize: 14)
                                                self.present(vc, animated: true, completion: nil)
                                            }
                                        }
                                    }
                                    .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                         
                                        
                                        let bodyText = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                                        if UIDevice.current.userInterfaceIdiom == .pad {
                                            let vc = UIActivityViewController(activityItems: [bodyText], applicationActivities: nil)
                                            vc.popoverPresentationController?.sourceView = self.view
                                            vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                            vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                                            self.present(vc, animated: true, completion: nil)
                                        } else {
                                            let vc = VisualActivityViewController(text: bodyText)
                                            vc.popoverPresentationController?.sourceView = self.view
                                            vc.previewNumberOfLines = 5
                                            vc.previewFont = UIFont.systemFont(ofSize: 14)
                                            self.present(vc, animated: true, completion: nil)
                                        }

                                    }
                                    .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                                         
                                        
                                        let controller = NewQRViewController()
                                        controller.ur = sto[indexPath.row].reblog?.url?.absoluteString ?? sto[indexPath.row].url?.absoluteString ?? "https://www.thebluebird.app"
                                        self.present(controller, animated: true, completion: nil)

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
                            .action(.cancel("Dismiss"))
                            .finally { action, index in
                                if action.style == .cancel {
                                    return
                                }
                            }
                            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                            .show(on: self)

                    }

                    if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                        cell.hideSwipe(animated: true)
                    }
                }
                more.backgroundColor = Colours.white
                more.image = UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected)
                more.transitionDelegate = ScaleTransition.default
                more.textColor = Colours.tabUnselected
                return [more]
            }
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
        
        var zzz = self.profileStatuses
        if self.currentIndex == 0 {
            zzz = self.profileStatuses
        } else {
            zzz = self.profileStatuses2
        }

        if indexPath.section == 2 {
//            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//            switch (deviceIdiom) {
//            case .phone :
                let controller = DetailViewController()
                controller.mainStatus.append(zzz[indexPath.row])
                self.navigationController?.pushViewController(controller, animated: true)
//            case .pad:
//                let controller = DetailViewController()
//                controller.mainStatus.append(zzz[indexPath.row])
//                self.splitViewController?.showDetailViewController(controller, sender: self)
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "splitload"), object: nil)
//            default:
//                print("nothing")
//            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        DispatchQueue.main.async {
            self.ai.alpha = 0
            self.ai.removeFromSuperview()
        }
    }
    
    func fetchMoreProfile() {

        if self.currentIndex == 0 {
            let request = Accounts.statuses(id: self.userIDtoUse, mediaOnly: nil, pinnedOnly: false, excludeReplies: true, excludeReblogs: true, range: .max(id: self.profileStatuses.last?.id ?? "", limit: 5000))
            StoreStruct.client.run(request) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    if stat.isEmpty {} else {
                        guard let self = self else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.profileStatuses = self.profileStatuses + stat
                            self.profileStatuses = self.profileStatuses.removeDuplicates()
                            self.tableView.reloadData()
                        }
                    }
                }
            }

        } else {

            var zzz = false
            if (UserDefaults.standard.object(forKey: "boostpro3") == nil) || (UserDefaults.standard.object(forKey: "boostpro3") as! Int == 0) {
                zzz = false
            } else {
                zzz = true
            }

            let request = Accounts.statuses(id: self.userIDtoUse, mediaOnly: nil, pinnedOnly: false, excludeReplies: false, excludeReblogs: zzz, range: .max(id: self.profileStatuses2.last?.id ?? "", limit: 5000))
            StoreStruct.client.run(request) {[weak self] (statuses) in
                guard let self = self else {
                    return
                }
                if let stat = (statuses.value) {
                    if stat.isEmpty {} else {
                        DispatchQueue.main.async {
                            self.profileStatuses2 = self.profileStatuses2 + stat
                            self.profileStatuses2 = self.profileStatuses2.removeDuplicates()
                            self.tableView.reloadData()
                        }
                    }
                }
            }

        }

    }

    @objc func refreshCont() {

        if self.currentIndex == 0 {
            
            let request = Accounts.statuses(id: self.userIDtoUse, mediaOnly: nil, pinnedOnly: false, excludeReplies: true, excludeReblogs: true, range: .since(id: self.profileStatuses.first?.id ?? "", limit: 5000))
            //        DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    guard let self = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.tableView.cr.endHeaderRefresh()
                        if stat.count > 0 {
                            self.profileStatuses = stat + self.profileStatuses
                            self.profileStatuses = self.profileStatuses.removeDuplicates()
//                            self.tableView.cr.endHeaderRefresh()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            //        }

        } else {

            var zzz = false
            if (UserDefaults.standard.object(forKey: "boostpro3") == nil) || (UserDefaults.standard.object(forKey: "boostpro3") as! Int == 0) {
                zzz = false
            } else {
                zzz = true
            }
            
            let request = Accounts.statuses(id: self.userIDtoUse, mediaOnly: nil, pinnedOnly: false, excludeReplies: false, excludeReblogs: zzz, range: .since(id: self.profileStatuses2.first?.id ?? "", limit: 5000))
            //            DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request) {[weak self] (statuses) in
                if let stat = (statuses.value) {
                    guard let self = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.tableView.cr.endHeaderRefresh()
                        if stat.count > 0 {
                            self.profileStatuses2 = stat + self.profileStatuses2
                            self.profileStatuses2 = self.profileStatuses2.removeDuplicates()
//                            self.tableView.cr.endHeaderRefresh()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            //            }

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
        
        
//        self.navigationController?.navigationBar.barTintColor = Colours.grayDark
//        self.navigationController?.navigationBar.tintColor = Colours.grayDark
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.grayDark]
        
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
        self.tableView.tableHeaderView?.reloadInputViews()

        self.navigationController?.navigationBar.backgroundColor = Colours.white
        self.navigationController?.navigationBar.tintColor = Colours.black
        self.navigationController?.navigationBar.barTintColor = Colours.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
//        self.splitViewController?.view.backgroundColor = Colours.cellQuote
        
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
