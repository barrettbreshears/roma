//
//  DMViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 29/03/2019.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SJFluidSegmentedControl
import SafariServices
import StatusAlert
import SAConfettiView
import ReactiveSSE
import ReactiveSwift
import AVKit
import AVFoundation
import UserNotifications
import SKPhotoBrowser

class DMViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SKPhotoBrowserDelegate, UIViewControllerPreviewingDelegate, CrownControlDelegate {
    
    var newUpdatesB1 = UIButton()
    var newUpdatesB2 = UIButton()
    var newUpdatesB3 = UIButton()
    var countcount1 = 0
    var countcount2 = 0
    var countcount5 = 0
    
    var notifications: [Notificationt] = []
    var maybeDoOnce = false
    var settingsButton = UIButton(type: .custom)
    var blurEffectViewMain = UIView()
    var blurEffect0 = UIBlurEffect()
    var blurEffectView0 = UIVisualEffectView()
    var hMod: [Notificationt] = []
    var dMod: [Notificationt] = []
    var nsocket: WebSocket!
    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .ballRotateChase, color: Colours.tabSelected)
    var safariVC: SFSafariViewController?
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    var currentIndex = 1
    var doOnce = false
    var doOnce2 = false
    private var crownControl: CrownControl!
    private var crownControl2: CrownControl!
    private var crownControl3: CrownControl!
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
            guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
            let detailVC = DetailViewController()
            if self.currentIndex == 5 {
                detailVC.mainStatus.append(StoreStruct.notificationsDirect[indexPath.row])
            }
            detailVC.isPeeking = true
            previewingContext.sourceRect = cell.frame
            return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    @objc func scrollTop2() {
            DispatchQueue.main.async {
                if StoreStruct.notificationsDirect.count > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
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
                StoreStruct.newInstanceTags = stat
                DispatchQueue.main.async {
                    let controller = InstanceViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
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
        self.view.addSubview(confettiView)
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
    
    @objc func changeSeg() {
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
        tableView.removeFromSuperview()
            self.tableView.register(DMFeedCell.self, forCellReuseIdentifier: "cell444")
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - 0)
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
            self.loadLoadLoad()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
        self.ai.startAnimating()
        
        
        if (UserDefaults.standard.object(forKey: "biometricsnotdm") == nil) || (UserDefaults.standard.object(forKey: "biometricsnotdm") as! Int == 0) {} else {
            self.biometricAuthenticationClicked(self)
        }
    }
    
    
    
    
    
    
    func biometricAuthenticationClicked(_ sender: Any) {
        
        let win = UIApplication.shared.keyWindow
        blurEffectViewMain.frame = UIScreen.main.bounds
        blurEffectViewMain.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        UIApplication.shared.keyWindow?.addSubview(blurEffectViewMain)
        
        blurEffect0 = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView0 = UIVisualEffectView(effect: blurEffect0)
        blurEffectView0.frame = UIScreen.main.bounds
        blurEffectView0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        UIApplication.shared.keyWindow?.addSubview(blurEffectView0)
        
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
    
    
    
    
    @objc func touchList() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "touchList"), object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func goToIDNoti() {
        sleep(2)
        let request = Notifications.notification(id: StoreStruct.curIDNoti)
        StoreStruct.client.run(request) { [weak self] (statuses) in
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
    
    @objc func updateDM() {
        self.tableView.reloadData()
    }
    
    @objc func scrollTopDM() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if StoreStruct.notificationsDirect.count > 0 {
                if self.tableView.alpha == 1 {
                    if StoreStruct.notificationsDirect.count <= 0 {
                        
                    } else {
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCont), name: NSNotification.Name(rawValue: "refpush1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTopDM), name: NSNotification.Name(rawValue: "scrollTopDM"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDM), name: NSNotification.Name(rawValue: "updateDM"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToID), name: NSNotification.Name(rawValue: "gotoid3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToIDNoti), name: NSNotification.Name(rawValue: "gotoidnoti3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goMembers), name: NSNotification.Name(rawValue: "goMembers3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goLists), name: NSNotification.Name(rawValue: "goLists3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goInstance), name: NSNotification.Name(rawValue: "goInstance3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchPro), name: NSNotification.Name(rawValue: "searchPro3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchUser), name: NSNotification.Name(rawValue: "searchUser3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTop2), name: NSNotification.Name(rawValue: "scrollTop2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSeg), name: NSNotification.Name(rawValue: "changeSeg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToSettings), name: NSNotification.Name(rawValue: "goToSettings3"), object: nil)
        
        self.view.backgroundColor = Colours.white
        self.title = "Messages"
        self.removeTabbarItemsText()
        
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
        
        self.tableView.register(DMFeedCell.self, forCellReuseIdentifier: "cell444")
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - 0 - tabHeight)
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
        
        
        self.ai = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2, width: 40, height: 40), type: .ballRotateChase, color: Colours.tabSelected)
        self.view.addSubview(self.ai)
        
        if StoreStruct.switchedNow {
            StoreStruct.notificationsDirect = []
            StoreStruct.switchedNow = false
        }
        
        if StoreStruct.notificationsDirect.isEmpty {
            self.refreshCont()
        } else {
            self.ai.stopAnimating()
            self.ai.alpha = 0
            self.tableView.reloadData()
        }
        
//        if (traitCollection.forceTouchCapability == .available) {
//            registerForPreviewing(with: self, sourceView: self.tableView)
//        }
        
        if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
            self.crownScroll()
        }
        
        
        let deviceIdiom3 = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom3) {
        case .phone:
            print("nothing")
        case .pad:
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(UIApplication.shared.statusBarFrame.height + 5)).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: CGFloat(0)).isActive = true
        default:
            print("nothing")
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
    
    @objc func search9() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchthething"), object: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        StoreStruct.currentPage = 101010
        
        StoreStruct.historyBool = false
        
        StoreStruct.badgeCount2 = 0
        self.tabBarController?.tabBar.items?[2].badgeValue = nil
        
        if StoreStruct.currentUser != nil {
            if Account.isPushSet(instance:"\(StoreStruct.currentUser.username)@\(StoreStruct.currentInstance.returnedText)") == false {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                    // Enable or disable features based on authorization.
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
            settingsButton.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 5, width: 36, height: 36)
            
            DispatchQueue.main.async {
                
                if StoreStruct.currentUser != nil {
                    self.settingsButton.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatarStatic)"))
                }
            }
            
            
            settingsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            settingsButton.imageView?.layer.cornerRadius = 18
            settingsButton.imageView?.contentMode = .scaleAspectFill
            settingsButton.layer.masksToBounds = true
        } else {
            settingsButton.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 5, width: 32, height: 32)
            settingsButton.setImage(UIImage(named: "list")?.maskWithColor(color: Colours.grayLight2), for: .normal)
            settingsButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            settingsButton.imageView?.layer.cornerRadius = 0
            settingsButton.imageView?.contentMode = .scaleAspectFill
            settingsButton.layer.masksToBounds = true
            
        }
        settingsButton.adjustsImageWhenHighlighted = false
        settingsButton.addTarget(self, action: #selector(self.touchList), for: .touchUpInside)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone :
            self.navigationController?.view.addSubview(settingsButton)
        default:
            print("nil")
        }
        
//        self.refreshCont()
        
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
        
        //bh4
        var newSize = offset + 65
        if (UserDefaults.standard.object(forKey: "segsize") == nil) || (UserDefaults.standard.object(forKey: "segsize") as! Int == 0) {
            newSize = offset + 65
        } else {
            newSize = offset + 15
        }
        
        self.settingsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.settingsButton.imageView?.layer.cornerRadius = 18
        self.settingsButton.imageView?.contentMode = .scaleAspectFill
        self.settingsButton.layer.masksToBounds = true
        
        settingsButton.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 5, width: 36, height: 36)
        
        DispatchQueue.main.async {
            if StoreStruct.currentUser != nil {
                self.settingsButton.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatarStatic)"))
            }
        }
        
        settingsButton.adjustsImageWhenHighlighted = false
        settingsButton.addTarget(self, action: #selector(self.touchList), for: .touchUpInside)
        
        let deviceIdiom3 = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom3) {
        case .phone :
            self.navigationController?.view.addSubview(settingsButton)
        default:
            print("nil")
        }
        
    }
    
    
    

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.currentIndex == 1 {
            
            
            if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
                crownControl?.spinToMatchScrollViewOffset()
            }
            
            
            
            let indexPath1 = IndexPath(row: self.countcount1 - 1, section: 0)
            if self.tableView.indexPathsForVisibleRows?.contains(indexPath1) ?? false {
                if self.countcount1 == 0 {
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                        //                        self.newUpdatesB1.transform = CGAffineTransform(translationX: 0, y: 0)
                        springWithDelay(duration: 0.5, delay: 0, animations: {
                            self.newUpdatesB1.alpha = 0
                            self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                            //                            self.newUpdatesB1.transform = CGAffineTransform(translationX: 120, y: 0)
                        })
                        self.countcount1 = 0
                    })
                } else {
                    self.countcount1 = self.countcount1 - 1
                    if self.countcount1 == 0 {
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                            //                            self.newUpdatesB1.transform = CGAffineTransform(translationX: 0, y: 0)
                            springWithDelay(duration: 0.5, delay: 0, animations: {
                                self.newUpdatesB1.alpha = 0
                                self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                //                                self.newUpdatesB1.transform = CGAffineTransform(translationX: 120, y: 0)
                            })
                            self.countcount1 = 0
                        })
                    }
                }
                self.newUpdatesB1.setTitle("\(self.countcount1)  ", for: .normal)
            }
            if (scrollView.contentOffset.y == 0) {
                springWithDelay(duration: 0.4, delay: 0, animations: {
                    self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                    //                    self.newUpdatesB1.transform = CGAffineTransform(translationX: 0, y: 0)
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.newUpdatesB1.alpha = 0
                        self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                        //                        self.newUpdatesB1.transform = CGAffineTransform(translationX: 120, y: 0)
                    })
                    self.countcount1 = 0
                })
            }
            
        } else if self.currentIndex == 5 {
            
            
            
            if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
                crownControl2?.spinToMatchScrollViewOffset()
            }
            
            
            let indexPath1 = IndexPath(row: self.countcount5 - 1, section: 1)
            if (scrollView.contentOffset.y == 0) {
                springWithDelay(duration: 0.4, delay: 0, animations: {
                    self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                    //                    self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.newUpdatesB3.alpha = 0
                        self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                        //                        self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                    })
                    self.countcount5 = 0
                })
            }
            
        } else {
            
            
            if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
                crownControl3?.spinToMatchScrollViewOffset()
            }
            
            
            
            let indexPath1 = IndexPath(row: self.countcount2 - 1, section: 1)
            if (scrollView.contentOffset.y == 0) {
                springWithDelay(duration: 0.4, delay: 0, animations: {
                    self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                    //                    self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.newUpdatesB2.alpha = 0
                        self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                        //                        self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                    })
                    self.countcount2 = 0
                })
            }
            
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        DispatchQueue.main.async {
            self.ai.alpha = 0
            self.ai.removeFromSuperview()
        }
        
        self.settingsButton.removeFromSuperview()
    }
    
    // Table stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.currentIndex == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoreStruct.notificationsDirect.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (UserDefaults.standard.object(forKey: "setGraph") == nil) || (UserDefaults.standard.object(forKey: "setGraph") as! Int == 0) {
            if self.currentIndex == 0 {
                return 40
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let title = UILabel()
        title.frame = CGRect(x: 10, y: 8, width: self.view.bounds.width, height: 30)
        if section == 0 {
            title.text = "Recent"
        } else {
            title.text = "Activity"
        }
        title.textColor = Colours.grayDark2
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            if StoreStruct.notificationsDirect.count == 0 || indexPath.row >= StoreStruct.notificationsDirect.count {
                
//                self.fetchMoreNotifications()
                
                self.ai.stopAnimating()
                self.ai.removeFromSuperview()
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell444", for: indexPath) as! DMFeedCell
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                
                if indexPath.row == StoreStruct.notificationsDirect.count - 1 {
                    self.fetchMoreNotifications()
                }
                
               // if let hasStatus = StoreStruct.notificationsDirect[indexPath.row].lastStatus {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell444", for: indexPath) as! DMFeedCell
                cell.delegate = self
                
                cell.configure2(false, id: StoreStruct.notificationsDirect[indexPath.row].id)
                cell.configure(StoreStruct.notificationsDirect[indexPath.row])
                cell.moreImage.image = nil
                cell.profileImageView.tag = indexPath.row
                cell.userTag.tag = indexPath.row
                // cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                // cell.userTag.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                cell.date.textColor = Colours.grayDark.withAlphaComponent(0.38)
                cell.toot.textColor = Colours.black
                cell.toot.handleMentionTap { (string) in
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let selection = UISelectionFeedbackGenerator()
                        selection.selectionChanged()
                    }
                    
                    var newString = string
                    StoreStruct.notificationsDirect[indexPath.row].mentions.map({
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
                bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
                cell.selectedBackgroundView = bgColorView
                return cell
                    
//                } else {
//
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell444", for: indexPath) as! DMFeedCell
//                    cell.delegate = self
//
//                    cell.configure2(StoreStruct.notificationsDirect[indexPath.row].unread, id: StoreStruct.notificationsDirect[indexPath.row].id)
//                    cell.configure(StoreStruct.notificationsDirect[indexPath.row].lastStatus!)
//                    cell.moreImage.image = nil
//                    cell.backgroundColor = Colours.white
//                    cell.userName.textColor = Colours.black
//                    cell.userTag.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
//                    cell.date.textColor = Colours.grayDark.withAlphaComponent(0.38)
//                    cell.toot.textColor = Colours.black
//                    cell.toot.handleMentionTap { (string) in
//                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                            let selection = UISelectionFeedbackGenerator()
//                            selection.selectionChanged()
//                        }
//
//                        var newString = string
//                        StoreStruct.notificationsDirect[indexPath.row].lastStatus!.mentions.map({
//                            if $0.acct.contains(string) {
//                                newString = $0.id
//                            }
//                        })
//
//
//                        let controller = ThirdViewController()
//                        if newString == StoreStruct.currentUser.username {} else {
//                            controller.fromOtherUser = true
//                        }
//                        controller.userIDtoUse = newString
//                        DispatchQueue.main.async {
//                            self.navigationController?.pushViewController(controller, animated: true)
//                        }
//                    }
//                    cell.toot.handleURLTap { (url) in
//                        // safari
//                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                            let selection = UISelectionFeedbackGenerator()
//                            selection.selectionChanged()
//                        }
//                        if url.absoluteString.hasPrefix(".") {
//                            let z = URL(string: String(url.absoluteString.dropFirst()))!
//                            UIApplication.shared.open(z, options: [.universalLinksOnly: true]) { (success) in
//                                if !success {
//                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
//                                    self.safariVC = SFSafariViewController(url: z)
//                                    self.safariVC?.preferredBarTintColor = Colours.white
//                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
//                                    self.present(self.safariVC!, animated: true, completion: nil)
//                                    } else {
//                                        UIApplication.shared.openURL(z)
//                                    }
//                                }
//                            }
//                        } else {
//                            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
//                                if !success {
//                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
//                                    self.safariVC = SFSafariViewController(url: url)
//                                    self.safariVC?.preferredBarTintColor = Colours.white
//                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
//                                    self.present(self.safariVC!, animated: true, completion: nil)
//                                    } else {
//                                        UIApplication.shared.openURL(url)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    cell.toot.handleHashtagTap { (string) in
//                        // hash
//                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                            let selection = UISelectionFeedbackGenerator()
//                            selection.selectionChanged()
//                        }
//                        let controller = HashtagViewController()
//                        controller.currentTagTitle = string
////                        let request = Timelines.tag(string)
////                        StoreStruct.client.run(request) { (statuses) in
////                            if let stat = (statuses.value) {
////                                DispatchQueue.main.async {
////                                    controller.currentTags = stat
//                                    self.navigationController?.pushViewController(controller, animated: true)
////                                }
////                            }
////                        }
//                    }
//                    let bgColorView = UIView()
//                    bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
//                    cell.selectedBackgroundView = bgColorView
//                    return cell
//
//                }
            }
        
        
        
    }
    
    
    @objc func didTouchProfile(sender: UIButton) {
//        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//            let selection = UISelectionFeedbackGenerator()
//            selection.selectionChanged()
//        }

        var sto = StoreStruct.notificationsDirect

        let controller = ThirdViewController()
        if sto[sender.tag].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }
        controller.userIDtoUse = sto[sender.tag].account.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
    
    
    @objc func didTouchBoost(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        var theTable = self.tableView
        var sto = StoreStruct.notificationsDirect
            theTable = self.tableView
        
        var rrr = 0
        if self.currentIndex == 0 {
            rrr = 1
        }
        
        if sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].id ) {
            StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[sender.tag].id }
            let request2 = Statuses.unreblog(id: sto[sender.tag].id )
            StoreStruct.client.run(request2) {(statuses) in
                DispatchQueue.main.async {
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: rrr)) as? DMFeedCell {
                        if sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].id ) {
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
            StoreStruct.allBoosts.append(sto[sender.tag].id )
            let request2 = Statuses.reblog(id: sto[sender.tag].id )
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                    }
                    
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: rrr)) as? DMFeedCell {
                        if sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].id ?? "" ) {
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
    }
    
    
    
    @objc func didTouchLike(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        var theTable = self.tableView
        var sto = StoreStruct.notificationsDirect
            theTable = self.tableView
        
        var rrr = 0
        if self.currentIndex == 0 {
            rrr = 1
        }
        
        if sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].id ) {
            StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[sender.tag].id }
            let request2 = Statuses.unfavourite(id: sto[sender.tag].id )
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: rrr)) as? DMFeedCell {
                        if sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].id ) {
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
            StoreStruct.allLikes.append(sto[sender.tag].id )
            let request2 = Statuses.favourite(id: sto[sender.tag].id )
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                    }
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: rrr)) as? DMFeedCell {
                        if sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].id ) {
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
    }
    
    
    
    @objc func didTouchReply(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        var sto = StoreStruct.notificationsDirect
        
        let controller = ComposeViewController()
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            controller.modalPresentationStyle = .pageSheet
        default:
            print("nil")
        }
        StoreStruct.spoilerText = sto[sender.tag].spoilerText ?? ""
        controller.inReply = [sto[sender.tag]]
        controller.inReplyText = sto[sender.tag].account.username
        controller.prevTextReply = sto[sender.tag].content.stripHTML()
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var theTable = self.tableView
        var sto = StoreStruct.notificationsDirect
            theTable = self.tableView
        
        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {} else {
            return nil
        }
        
            if orientation == .left {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                
                let like = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    
                    
                    
                    
                    
                    
                    
                    if sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].id  ) {
                        StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[indexPath.row].id }
                        let request2 = Statuses.unfavourite(id: sto[indexPath.row].id )
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if let cell = theTable.cellForRow(at: indexPath) as? DMFeedCell {
                                    if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
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
                        StoreStruct.allLikes.append(sto[indexPath.row].id )
                        let request2 = Statuses.favourite(id: sto[indexPath.row].id )
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                                }
                                if let cell = theTable.cellForRow(at: indexPath) as? DMFeedCell {
                                    if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id ) {
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
                    
                    
                    
                    
                    
                    
                    if let cell = theTable.cellForRow(at: indexPath) as? DMFeedCell {
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
                    StoreStruct.spoilerText = sto[indexPath.row].spoilerText ?? ""
                    controller.inReply = [sto[indexPath.row]]
                    controller.inReplyText = sto[indexPath.row].account.username
                    controller.prevTextReply = sto[indexPath.row].content.stripHTML()
                    self.present(controller, animated: true, completion: nil)
                    
                    
                    if let cell = theTable.cellForRow(at: indexPath) as? DMFeedCell {
                        cell.hideSwipe(animated: true)
                    }
                }
                reply.backgroundColor = Colours.white
                if sto[indexPath.row].visibility == .direct {
                    reply.image = UIImage(named: "direct2")?.maskWithColor(color: Colours.lightBlue)
                } else {
                    reply.image = UIImage(named: "reply0")?.maskWithColor(color: Colours.lightBlue)
                }
                reply.transitionDelegate = ScaleTransition.default
                reply.textColor = Colours.tabUnselected
                
                
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
                let impact = UIImpactFeedbackGenerator(style: .medium)
                
                let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    
                    
                    var isMuted = false
                    let request0 = Mutes.all()
                    StoreStruct.client.run(request0) { (statuses) in
                        if let stat = (statuses.value) {
                            let s = stat.filter { $0.id == sto[indexPath.row].account.id }
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
                            let s = stat.filter { $0.id == sto[indexPath.row].account.id }
                            if s.isEmpty {
                                isBlocked = false
                            } else {
                                isBlocked = true
                            }
                        }
                    }
                    
                    let wordsInThis = (sto[indexPath.row].content.stripHTML()).components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}.count
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
                                statusAlert.tintColor = Colours.grayDark
                                statusAlert.message = sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                    statusAlert.show(withOffset: CGFloat(0))
                                }
                                
                                
                            } else {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Unmuted".localized
                                statusAlert.tintColor = Colours.grayDark
                                statusAlert.message = sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                    statusAlert.show(withOffset: CGFloat(0))
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
                                statusAlert.tintColor = Colours.grayDark
                                statusAlert.message = sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                    statusAlert.show(withOffset: CGFloat(0))
                                }
                                
                            } else {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "block2large")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Unblocked".localized
                                statusAlert.tintColor = Colours.grayDark
                                statusAlert.message = sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                    statusAlert.show(withOffset: CGFloat(0))
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
                                    statusAlert.tintColor = Colours.grayDark
                                    statusAlert.message = "Harassment"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show(withOffset: CGFloat(0))
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
                                    statusAlert.tintColor = Colours.grayDark
                                    statusAlert.message = "No Content Warning"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show(withOffset: CGFloat(0))
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
                                    statusAlert.tintColor = Colours.grayDark
                                    statusAlert.message = "Spam"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                                        statusAlert.show(withOffset: CGFloat(0))
                                    }
                                    
                                    
                                    
                                }
                                .action(.cancel("Dismiss"))
                                .finally { action, index in
                                    if action.style == .cancel {
                                        return
                                    }
                                }
                                .popover(anchorView: theTable.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
                                .show(on: self)
                            
                            
                        }
                        .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                             
                            
                            let unreserved = "-._~/?"
                            let allowed = NSMutableCharacterSet.alphanumeric()
                            allowed.addCharacters(in: unreserved)
                            let bodyText = sto[indexPath.row].content.stripHTML() ?? ""
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
                                        
                                        Alertift.actionSheet(title: nil, message: translatedText as String )
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
                                            .popover(anchorView: theTable.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
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
                            controller.filledTextFieldText = sto[indexPath.row].content.stripHTML() ?? ""
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
                                        let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        vc.popoverPresentationController?.sourceView = self.view
                                        vc.previewNumberOfLines = 5
                                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                     
                                    
                                    let bodyText = sto[indexPath.row].content.stripHTML()
                                    let vc = VisualActivityViewController(text: bodyText )
                                    vc.popoverPresentationController?.sourceView = self.view
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                                .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                                     
                                    
                                    let controller = NewQRViewController()
                                    controller.ur = sto[indexPath.row].url?.absoluteString ?? "https://www.thebluebird.app"
                                    self.present(controller, animated: true, completion: nil)
                                    
                                }
                                .action(.cancel("Dismiss"))
                                .finally { action, index in
                                    if action.style == .cancel {
                                        return
                                    }
                                }
                                .popover(anchorView: theTable.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
                                .show(on: self)
                            
                            
                            
                            
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: theTable.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
                        .show(on: self)
                    
                    
                    
                    if let cell = theTable.cellForRow(at: indexPath) as? DMFeedCell {
                        cell.hideSwipe(animated: true)
                    }
                }
                more.backgroundColor = Colours.white
                more.image = UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected)
                more.transitionDelegate = ScaleTransition.default
                more.textColor = Colours.tabUnselected
                return [more]
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
//        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//        switch (deviceIdiom) {
//        case .phone :
            let controller = DMMessageViewController()
            controller.mainStatus.append(StoreStruct.notificationsDirect[indexPath.row])
            self.navigationController?.pushViewController(controller, animated: true)
//        case .pad:
//            let controller = DMMessageViewController()
//            controller.mainStatus.append(StoreStruct.notificationsDirect[indexPath.row].lastStatus!)
//            self.navigationController?.pushViewController(controller, animated: true)
//        default:
//            print("nothing")
//        }
        
        let request2 = Timelines.markRead(id: StoreStruct.notificationsDirect[indexPath.row].id)
        StoreStruct.client.run(request2) {[weak self](statuses) in
            DispatchQueue.main.async {
                StoreStruct.markedReadIDs.append(StoreStruct.notificationsDirect[indexPath.row].id)
//                self.tableView.reloadRows(at: [indexPath], with: .none)
                if let cell = self?.tableView.cellForRow(at: indexPath) as? DMFeedCell {
                    cell.configure2(false, id: StoreStruct.notificationsDirect[indexPath.row].id)
                }
            }
        }
    }
    
    func fetchMoreNotifications() {
        let request = Timelines.direct(range: .max(id: StoreStruct.notificationsDirect.last?.id ?? "", limit: 5000))
       // let request = Timelines.conversations(range: .max(id: StoreStruct.notificationsDirect.last?.id ?? "", limit: 5000))
        StoreStruct.client.run(request) {[weak self] (statuses) in
            if let stat = (statuses.value) {
                if stat.isEmpty {} else {
                    StoreStruct.notificationsDirect = StoreStruct.notificationsDirect + stat
                    DispatchQueue.main.async {
                        StoreStruct.notificationsDirect = StoreStruct.notificationsDirect.removeDuplicates()
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func refreshCont() {
        
        let request = Timelines.direct(range: .since(id: StoreStruct.notificationsDirect.first?.id ?? "", limit: 5000))
        // let request = Timelines.conversations(range: .since(id: StoreStruct.notificationsDirect.first?.id ?? "", limit: 5000))
        StoreStruct.client.run(request) {[weak self] (statuses) in
            if let stat = (statuses.value) {
                if stat.isEmpty {} else {
                    StoreStruct.notificationsDirect = stat + StoreStruct.notificationsDirect
                    StoreStruct.notificationsDirect = StoreStruct.notificationsDirect.sorted(by: { ($0.createdAt ?? Date()) > ($1.createdAt ?? Date()) })
                    DispatchQueue.main.async {
                        self?.tableView.cr.endHeaderRefresh()
                        StoreStruct.notificationsDirect = StoreStruct.notificationsDirect.removeDuplicates()
                        self?.ai.stopAnimating()
                        self?.ai.alpha = 0
                        self?.tableView.reloadData()
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
        
        self.navigationController?.navigationBar.backgroundColor = Colours.white
        
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
