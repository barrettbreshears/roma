//
//  FirstViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SJFluidSegmentedControl
import ReactiveSSE
import ReactiveSwift
import SafariServices
import StatusAlert
import UserNotifications
import SAConfettiView
import Disk
import AVKit
import AVFoundation

class FirstViewController: UIViewController, SJFluidSegmentedControlDataSource, SJFluidSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SKPhotoBrowserDelegate, URLSessionDataDelegate, UIViewControllerPreviewingDelegate, CrownControlDelegate {
    
    
    var socket: WebSocket!
    var lsocket: WebSocket!
    var fsocket: WebSocket!
    
    var hMod: [Status] = []
    var lMod: [Status] = []
    var fMod: [Status] = []
    var newUpdatesB1 = UIButton()
    var newUpdatesB2 = UIButton()
    var newUpdatesB3 = UIButton()
    var countcount1 = 0
    var countcount2 = 0
    var countcount3 = 0
    
    var settingsButton = MNGExpandedTouchAreaButton()
    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .circleStrokeSpin, color: Colours.tabSelected)
    var safariVC: SFSafariViewController?
    var segmentedControl: SJFluidSegmentedControl!
    var tableView = UITableView()
    var tableViewL = UITableView()
    var tableViewF = UITableView()
    var refreshControl = UIRefreshControl()
    var currentIndex = 0
    var hStream = false
    var lStream = false
    var fStream = false
    var previousScrollOffset: CGFloat = 0
    private var crownControl: CrownControl!
    private var crownControl2: CrownControl!
    private var crownControl3: CrownControl!
    
    var player = AVPlayer()
    var lastThing = ""
    var lastThing2 = ""
    var lastThing3 = ""

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
// MARK: - App Lifecycle and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.savedComposePresent), name: NSNotification.Name(rawValue: "savedComposePresent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToID), name: NSNotification.Name(rawValue: "gotoid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToIDNoti), name: NSNotification.Name(rawValue: "gotoidnoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goMembers), name: NSNotification.Name(rawValue: "goMembers"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goLists), name: NSNotification.Name(rawValue: "goLists"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goInstance), name: NSNotification.Name(rawValue: "goInstance"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchPro), name: NSNotification.Name(rawValue: "searchPro"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchUser), name: NSNotification.Name(rawValue: "searchUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTop1), name: NSNotification.Name(rawValue: "scrollTop1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startStream), name: NSNotification.Name(rawValue: "startStream"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.createNoti), name: NSNotification.Name(rawValue: "createNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchAllNewest), name: NSNotification.Name(rawValue: "fetchAllNewest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSeg), name: NSNotification.Name(rawValue: "changeSeg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.segTheme), name: NSNotification.Name(rawValue: "segTheme"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.activateCrown), name: NSNotification.Name(rawValue: "activateCrown"), object: nil)
        
        self.view.backgroundColor = Colours.white
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }
        
        
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
        
        
        if (UserDefaults.standard.object(forKey: "segsize") == nil) || (UserDefaults.standard.object(forKey: "segsize") as! Int == 0) {
            segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(20), y: CGFloat(offset + 5), width: CGFloat(self.view.bounds.width - 40), height: CGFloat(40)))
            
            segmentedControl.dataSource = self
            if (UserDefaults.standard.object(forKey: "segstyle") == nil) || (UserDefaults.standard.object(forKey: "segstyle") as! Int == 0) {
                segmentedControl.shapeStyle = .roundedRect
            } else {
                segmentedControl.shapeStyle = .liquid
            }
            segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
            segmentedControl.cornerRadius = 12
            segmentedControl.shadowsEnabled = false
            segmentedControl.transitionStyle = .slide
            segmentedControl.delegate = self
            view.addSubview(segmentedControl)
            
            self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell")
            self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2")
            self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellmore")
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 60), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 65)
            self.tableView.alpha = 1
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundColor = Colours.white
            self.tableView.separatorColor = Colours.cellQuote
            self.tableView.layer.masksToBounds = true
            self.tableView.estimatedRowHeight = 89
            self.tableView.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableView)
            
            self.tableViewL.register(MainFeedCell.self, forCellReuseIdentifier: "celll")
            self.tableViewL.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2l")
            self.tableViewL.register(SettingsCell.self, forCellReuseIdentifier: "cellmore1")
            self.tableViewL.frame = CGRect(x: 0, y: Int(offset + 60), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 65)
            self.tableViewL.alpha = 0
            self.tableViewL.delegate = self
            self.tableViewL.dataSource = self
            self.tableViewL.separatorStyle = .singleLine
            self.tableViewL.backgroundColor = Colours.white
            self.tableViewL.separatorColor = Colours.cellQuote
            self.tableViewL.layer.masksToBounds = true
            self.tableViewL.estimatedRowHeight = 89
            self.tableViewL.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableViewL)
            
            self.tableViewF.register(MainFeedCell.self, forCellReuseIdentifier: "cellf")
            self.tableViewF.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2f")
            self.tableViewF.register(SettingsCell.self, forCellReuseIdentifier: "cellmore2")
            self.tableViewF.frame = CGRect(x: 0, y: Int(offset + 60), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 65)
            self.tableViewF.alpha = 0
            self.tableViewF.delegate = self
            self.tableViewF.dataSource = self
            self.tableViewF.separatorStyle = .singleLine
            self.tableViewF.backgroundColor = Colours.white
            self.tableViewF.separatorColor = Colours.cellQuote
            self.tableViewF.layer.masksToBounds = true
            self.tableViewF.estimatedRowHeight = 89
            self.tableViewF.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableViewF)
        } else {
            if UIApplication.shared.isSplitOrSlideOver {
                segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(self.view.bounds.width/2 - 120), y: CGFloat(30), width: CGFloat(240), height: CGFloat(40)))
            } else {
                segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(self.view.bounds.width/2 - 120), y: CGFloat(newoff), width: CGFloat(240), height: CGFloat(40)))
            }
            segmentedControl.dataSource = self
            if (UserDefaults.standard.object(forKey: "segstyle") == nil) || (UserDefaults.standard.object(forKey: "segstyle") as! Int == 0) {
                segmentedControl.shapeStyle = .roundedRect
            } else {
                segmentedControl.shapeStyle = .liquid
            }
            segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
            segmentedControl.cornerRadius = 12
            segmentedControl.shadowsEnabled = false
            segmentedControl.transitionStyle = .slide
            segmentedControl.delegate = self
            self.navigationController?.view.addSubview(segmentedControl)
            
            self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell")
            self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2")
            self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellmore")
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 10), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset + 5 - tabHeight)
            self.tableView.alpha = 1
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundColor = Colours.white
            self.tableView.separatorColor = Colours.cellQuote
            self.tableView.layer.masksToBounds = true
            self.tableView.estimatedRowHeight = 89
            self.tableView.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableView)
            
            self.tableViewL.register(MainFeedCell.self, forCellReuseIdentifier: "celll")
            self.tableViewL.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2l")
            self.tableViewL.register(SettingsCell.self, forCellReuseIdentifier: "cellmore1")
            self.tableViewL.frame = CGRect(x: 0, y: Int(offset + 10), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
            self.tableViewL.alpha = 0
            self.tableViewL.delegate = self
            self.tableViewL.dataSource = self
            self.tableViewL.separatorStyle = .singleLine
            self.tableViewL.backgroundColor = Colours.white
            self.tableViewL.separatorColor = Colours.cellQuote
            self.tableViewL.layer.masksToBounds = true
            self.tableViewL.estimatedRowHeight = 89
            self.tableViewL.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableViewL)
            
            self.tableViewF.register(MainFeedCell.self, forCellReuseIdentifier: "cellf")
            self.tableViewF.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2f")
            self.tableViewF.register(SettingsCell.self, forCellReuseIdentifier: "cellmore2")
            self.tableViewF.frame = CGRect(x: 0, y: Int(offset + 10), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
            self.tableViewF.alpha = 0
            self.tableViewF.delegate = self
            self.tableViewF.dataSource = self
            self.tableViewF.separatorStyle = .singleLine
            self.tableViewF.backgroundColor = Colours.white
            self.tableViewF.separatorColor = Colours.cellQuote
            self.tableViewF.layer.masksToBounds = true
            self.tableViewF.estimatedRowHeight = 89
            self.tableViewF.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableViewF)
        }
        
        if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
            self.crownScroll()
            self.crownScroll2()
            self.crownScroll3()
        }
        
        refreshControl.addTarget(self, action: #selector(refreshCont), for: .valueChanged)
        //self.tableView.addSubview(refreshControl)
        
        tableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
            }
            self?.refreshCont()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableView.cr.endHeaderRefresh()
            })
        }
        tableViewL.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
                
            }
            self?.refreshCont()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableViewL.cr.endHeaderRefresh()
            })
        }
        tableViewF.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
            }
            self?.refreshCont()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableViewF.cr.endHeaderRefresh()
            })
        }
        //tableView.cr.beginHeaderRefresh()
        
        self.ai = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2, width: 40, height: 40), type: .circleStrokeSpin, color: Colours.tabSelected)
        self.view.addSubview(self.ai)
        self.loadLoadLoad()
        
        
        if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
            self.streamDataHome()
        } else {
            
        }
        
        
        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: self.tableView)
            registerForPreviewing(with: self, sourceView: self.tableViewL)
            registerForPreviewing(with: self, sourceView: self.tableViewF)
        }
        
        self.restoreScroll()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if StoreStruct.statusesHome.isEmpty {
            self.ai.startAnimating()
        }
        
        
        if (UserDefaults.standard.object(forKey: "insicon1") == nil) || (UserDefaults.standard.object(forKey: "insicon1") as! Int == 0) {
            settingsButton.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 5, width: 32, height: 32)
            settingsButton.setImage(UIImage(named: "list")?.maskWithColor(color: Colours.grayLight2), for: .normal)
            settingsButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            settingsButton.imageView?.layer.cornerRadius = 0
            settingsButton.imageView?.contentMode = .scaleAspectFill
            settingsButton.layer.masksToBounds = true
        } else {
            settingsButton.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 5, width: 36, height: 36)
            if StoreStruct.currentUser != nil {
                settingsButton.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatarStatic)"))
            }
            settingsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            settingsButton.imageView?.layer.cornerRadius = 18
            settingsButton.imageView?.contentMode = .scaleAspectFill
            settingsButton.layer.masksToBounds = true
        }
        settingsButton.adjustsImageWhenHighlighted = false
        settingsButton.addTarget(self, action: #selector(self.touchList), for: .touchUpInside)
        self.navigationController?.view.addSubview(settingsButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if (UserDefaults.standard.object(forKey: "segsize") == nil) || (UserDefaults.standard.object(forKey: "segsize") as! Int == 0) {} else {
            self.segmentedControl.alpha = 0
        }
        
        UserDefaults.standard.set(self.tableView.contentOffset.y, forKey: "savedRowHome1")
        UserDefaults.standard.set(self.tableViewL.contentOffset.y, forKey: "savedRowLocal1")
        UserDefaults.standard.set(self.tableViewF.contentOffset.y, forKey: "savedRowFed1")
        
        
        self.settingsButton.removeFromSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
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
        
        if (UserDefaults.standard.object(forKey: "insicon1") == nil) || (UserDefaults.standard.object(forKey: "insicon1") as! Int == 0) {
            settingsButton.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 5, width: 32, height: 32)
            settingsButton.setImage(UIImage(named: "list")?.maskWithColor(color: Colours.grayLight2), for: .normal)
            settingsButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            settingsButton.imageView?.layer.cornerRadius = 0
            settingsButton.imageView?.contentMode = .scaleAspectFill
            settingsButton.layer.masksToBounds = true
        } else {
            settingsButton.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 5, width: 36, height: 36)
            if StoreStruct.currentUser != nil {
                settingsButton.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatar)"))
            }
            settingsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            settingsButton.imageView?.layer.cornerRadius = 18
            settingsButton.imageView?.contentMode = .scaleAspectFill
            settingsButton.layer.masksToBounds = true
        }
        settingsButton.adjustsImageWhenHighlighted = false
        settingsButton.addTarget(self, action: #selector(self.touchList), for: .touchUpInside)
        self.navigationController?.view.addSubview(settingsButton)
        
        self.newUpdatesB1.frame = CGRect(x: CGFloat(self.view.bounds.width - 42), y: CGFloat(newSize), width: CGFloat(56), height: CGFloat(30))
        self.newUpdatesB1.backgroundColor = Colours.grayLight19
        self.newUpdatesB1.layer.cornerRadius = 10
        self.newUpdatesB1.setTitleColor(UIColor.white, for: .normal)
        self.newUpdatesB1.setTitle("", for: .normal)
        self.newUpdatesB1.alpha = 0
        self.view.addSubview(self.newUpdatesB1)
        
        self.newUpdatesB2.frame = CGRect(x: CGFloat(self.view.bounds.width - 42), y: CGFloat(newSize), width: CGFloat(56), height: CGFloat(30))
        self.newUpdatesB2.backgroundColor = Colours.grayLight19
        self.newUpdatesB2.layer.cornerRadius = 10
        self.newUpdatesB2.setTitleColor(UIColor.white, for: .normal)
        self.newUpdatesB2.setTitle("", for: .normal)
        self.newUpdatesB2.alpha = 0
        self.view.addSubview(self.newUpdatesB2)
        
        self.newUpdatesB3.frame = CGRect(x: CGFloat(self.view.bounds.width - 42), y: CGFloat(newSize), width: CGFloat(56), height: CGFloat(30))
        self.newUpdatesB3.backgroundColor = Colours.grayLight19
        self.newUpdatesB3.layer.cornerRadius = 10
        self.newUpdatesB3.setTitleColor(UIColor.white, for: .normal)
        self.newUpdatesB3.setTitle("", for: .normal)
        self.newUpdatesB3.alpha = 0
        self.view.addSubview(self.newUpdatesB3)
        
        
        springWithDelay(duration: 0.4, delay: 0, animations: {
            self.segmentedControl.alpha = 1
            self.tableView.alpha = 1
        })
        if StoreStruct.historyBool {
            self.changeSeg()
        }
        
        StoreStruct.historyBool = false
        
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = Colours.tabUnselected
        
        StoreStruct.currentPage = 0
        
        let applicationContext = [StoreStruct.client.accessToken ?? "": StoreStruct.shared.currentInstance.returnedText]
        WatchSessionManager.sharedManager.transferUserInfo(userInfo: applicationContext as [String: AnyObject])
        
        let request = Notifications.all(range: .default)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.notifications = stat
                
                for x in StoreStruct.notifications {
                    if x.type == .mention {
                        DispatchQueue.main.async {
                            StoreStruct.notificationsMentions.append(x)
                            StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
                            StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                        }
                    }
                }
                
            }
        }
        
        
        
        
        
        let request4 = Instances.current()
        StoreStruct.client.run(request4) { (statuses) in
            if let stat = (statuses.value) {
                print("max chars --")
                print(stat.max_toot_chars)
                StoreStruct.maxChars = stat.max_toot_chars ?? 500
                StoreStruct.currentInstanceDetails = [stat]
            }
        }
        
        
        
        if StoreStruct.initTimeline == false {
            StoreStruct.initTimeline = true
            if (UserDefaults.standard.object(forKey: "inittimeline") == nil) || (UserDefaults.standard.object(forKey: "inittimeline") as! Int == 0) {
                self.segmentedControl.currentSegment = 0
                if self.countcount1 == 0 {
                    self.newUpdatesB1.alpha = 0
                    self.newUpdatesB2.alpha = 0
                    self.newUpdatesB3.alpha = 0
                } else {
                    self.newUpdatesB1.alpha = 1
                    self.newUpdatesB2.alpha = 0
                    self.newUpdatesB3.alpha = 0
                }
                
                self.currentIndex = 0
                self.tableView.reloadData()
                self.tableView.alpha = 1
                self.tableViewL.alpha = 0
                self.tableViewF.alpha = 0
                if (UserDefaults.standard.object(forKey: "savedRowHome1") == nil) {} else {
                    
                }
                
                // stream
                if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
                    if self.hStream == false {
                        self.streamDataHome()
                        
                    }
                }
            } else if (UserDefaults.standard.object(forKey: "inittimeline") as! Int == 1) {
                self.segmentedControl.currentSegment = 1
                if self.countcount2 == 0 {
                    self.newUpdatesB1.alpha = 0
                    self.newUpdatesB2.alpha = 0
                    self.newUpdatesB3.alpha = 0
                } else {
                    self.newUpdatesB1.alpha = 0
                    self.newUpdatesB2.alpha = 1
                    self.newUpdatesB3.alpha = 0
                }
                
                self.currentIndex = 1
                self.tableView.alpha = 0
                self.tableViewL.alpha = 1
                self.tableViewF.alpha = 0
                
                if StoreStruct.statusesLocal.isEmpty {
                    let request = Timelines.public(local: true, range: .default)
                    StoreStruct.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.statusesLocal = stat + StoreStruct.statusesLocal
                            DispatchQueue.main.async {
                                StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                                self.tableViewL.reloadData()
                                
                            }
                        }
                    }
                } else {
                    //bbbhere
                    self.tableViewL.reloadData()
                }
                
                // stream
                if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
                    if self.lStream == false {
                        self.streamDataLocal()
                    }
                }
            } else {
                self.segmentedControl.currentSegment = 2
                if self.countcount3 == 0 {
                    self.newUpdatesB1.alpha = 0
                    self.newUpdatesB2.alpha = 0
                    self.newUpdatesB3.alpha = 0
                } else {
                    self.newUpdatesB1.alpha = 0
                    self.newUpdatesB2.alpha = 0
                    self.newUpdatesB3.alpha = 1
                }
                
                self.currentIndex = 2
                self.tableView.alpha = 0
                self.tableViewL.alpha = 0
                self.tableViewF.alpha = 1
                
                if StoreStruct.statusesFederated.isEmpty {
                    let request = Timelines.public(local: false, range: .default)
                    StoreStruct.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.statusesFederated = stat + StoreStruct.statusesFederated
                            DispatchQueue.main.async {
                                StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                                self.tableViewF.reloadData()
                                
                            }
                        }
                    }
                } else {
                    ///bbhere
                    self.tableViewF.reloadData()
                }
                // stream
                if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
                    if self.fStream == false {
                        self.streamDataFed()
                    }
                }
            }
        }
        
    }
    
    @objc func load() {
        DispatchQueue.main.async {
            self.loadLoadLoad()
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
            Colours.white3 = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
            UIApplication.shared.statusBarStyle = .default
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
            Colours.white = UIColor(red: 53/255.0, green: 53/255.0, blue: 64/255.0, alpha: 1.0)
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
            Colours.white3 = UIColor(red: 33/255.0, green: 33/255.0, blue: 44/255.0, alpha: 1.0)
            UIApplication.shared.statusBarStyle = .lightContent
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 2) {
            Colours.white = UIColor(red: 36/255.0, green: 33/255.0, blue: 37/255.0, alpha: 1.0)
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
            Colours.white3 = UIColor(red: 16/255.0, green: 13/255.0, blue: 17/255.0, alpha: 1.0)
            UIApplication.shared.statusBarStyle = .lightContent
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 4) {
            Colours.white = UIColor(red: 8/255.0, green: 28/255.0, blue: 88/255.0, alpha: 1.0)
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
            Colours.white3 = UIColor(red: 0/255.0, green: 14/255.0, blue: 69/255.0, alpha: 1.0)
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
            Colours.white3 = UIColor(red: 30/255.0, green: 34/255.0, blue: 38/255.0, alpha: 1.0)
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
        
        
        
        //        UserDefaults.standard.set(self.tableView.contentOffset.y, forKey: "savedOffsetHome")
        //        print("676767")
        //        print((UserDefaults.standard.object(forKey: "savedOffsetHome") as! CGFloat))
        
        self.ai.alpha = 0
        self.ai.removeFromSuperview()
        
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        
        self.tableViewL.backgroundColor = Colours.white
        self.tableViewL.separatorColor = Colours.cellQuote
        self.tableViewL.reloadData()
        self.tableViewL.reloadInputViews()
        
        self.tableViewF.backgroundColor = Colours.white
        self.tableViewF.separatorColor = Colours.cellQuote
        self.tableViewF.reloadData()
        self.tableViewF.reloadInputViews()
        
        //        if (UserDefaults.standard.object(forKey: "savedOffsetHome") == nil) {} else {
        //            print("787878")
        //            print((UserDefaults.standard.object(forKey: "savedOffsetHome") as! CGFloat))
        //            self.tableView.setContentOffset(CGPoint(x: 0, y: (UserDefaults.standard.object(forKey: "savedOffsetHome") as! CGFloat)), animated: false)
        //        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func segTheme() {
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
        segmentedControl.removeFromSuperview()
        if (UserDefaults.standard.object(forKey: "segsize") == nil) || (UserDefaults.standard.object(forKey: "segsize") as! Int == 0) {
            
            segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(20), y: CGFloat(offset + 5), width: CGFloat(self.view.bounds.width - 40), height: CGFloat(40)))
            
            segmentedControl.dataSource = self
            if (UserDefaults.standard.object(forKey: "segstyle") == nil) || (UserDefaults.standard.object(forKey: "segstyle") as! Int == 0) {
                segmentedControl.shapeStyle = .roundedRect
            } else {
                segmentedControl.shapeStyle = .liquid
            }
            segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
            segmentedControl.cornerRadius = 12
            segmentedControl.shadowsEnabled = false
            segmentedControl.transitionStyle = .slide
            segmentedControl.delegate = self
            view.addSubview(segmentedControl)
        } else {
            if UIApplication.shared.isSplitOrSlideOver {
                segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(self.view.bounds.width/2 - 120), y: CGFloat(30), width: CGFloat(240), height: CGFloat(40)))
            } else {
                segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(self.view.bounds.width/2 - 120), y: CGFloat(newoff), width: CGFloat(240), height: CGFloat(40)))
            }
            segmentedControl.dataSource = self
            if (UserDefaults.standard.object(forKey: "segstyle") == nil) || (UserDefaults.standard.object(forKey: "segstyle") as! Int == 0) {
                segmentedControl.shapeStyle = .roundedRect
            } else {
                segmentedControl.shapeStyle = .liquid
            }
            segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
            segmentedControl.cornerRadius = 12
            segmentedControl.shadowsEnabled = false
            segmentedControl.transitionStyle = .slide
            segmentedControl.delegate = self
            self.navigationController?.view.addSubview(segmentedControl)
        }
        
    }
    
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.ai.alpha = 0
            self.ai.removeFromSuperview()
            self.tableView.reloadData()
            if StoreStruct.statusesHome.isEmpty {
                self.refreshCont()
            }
        }
    }
    
    @objc func refreshCont() {
        
        if self.currentIndex == 0 {
            let request = Timelines.home(range: .since(id: StoreStruct.statusesHome.first?.id ?? "", limit: 5000))
            DispatchQueue.global(qos: .userInitiated).async {
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        
                        var newestC = StoreStruct.statusesHome.count
                        print("need30 \(StoreStruct.statusesHome.count)")
                        
                        
                        if let st = stat.last {
                            if StoreStruct.statusesHome.contains(st) || stat.count < 20 {
                                print("no need for load more button here")
                                StoreStruct.statusesHome = stat + StoreStruct.statusesHome
                                StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            } else {
                                print("need load more button here")
                                StoreStruct.gapLastHomeID = stat.last?.id ?? ""
                                let z = st
                                z.id = "loadmorehere"
                                StoreStruct.gapLastHomeStat = z
                                StoreStruct.statusesHome = stat + StoreStruct.statusesHome
                                StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            }
                        } else {
                            StoreStruct.statusesHome = stat + StoreStruct.statusesHome
                            StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                        }
                        
                        
                        DispatchQueue.main.async {
                            StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            
                            newestC = StoreStruct.statusesHome.count - newestC - 1
                            if newestC < 0 {
                                newestC = 0
                            }
                            print("newestC: \(newestC)")
                            
                            if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                self.newUpdatesB1.setTitle("\(newestC)  ", for: .normal)
                                self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                springWithDelay(duration: 0.5, delay: 0, animations: {
                                    self.newUpdatesB1.alpha = 1
                                    self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                })
                                self.countcount1 = newestC
                                
                                UIView.setAnimationsEnabled(false)
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                                if newestC == 0 {
                                    
                                } else if StoreStruct.statusesHome.count >= newestC + 1 {
                                    self.tableView.scrollToRow(at: IndexPath(row: newestC + 1, section: 0), at: .top, animated: false)
                                }
                                UIView.setAnimationsEnabled(true)
                            } else {
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                            do {
                                try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                            } catch {
                                print("Couldn't save")
                            }
                            
                        }
                    }
                }
            }
        } else if self.currentIndex == 1 {
            let request = Timelines.public(local: true, range: .since(id: StoreStruct.statusesLocal.first?.id ?? "", limit: 5000))
            DispatchQueue.global(qos: .userInitiated).async {
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        var newestC = StoreStruct.statusesLocal.count
                        
                        if (newestC == 0){
                            DispatchQueue.main.async {
                                self.refreshControl.endRefreshing()
                                
                            }
                            return
                        }
                        
                        if let st = stat.last {
                            if StoreStruct.statusesLocal.contains(st) || stat.count < 20 {
                                print("no need for load more button here")
                                StoreStruct.statusesLocal = stat + StoreStruct.statusesLocal
                                StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                            } else {
                                print("need load more button here")
                                StoreStruct.gapLastLocalID = stat.last?.id ?? ""
                                let z = st
                                z.id = "loadmorehere"
                                StoreStruct.gapLastLocalStat = z
                                StoreStruct.statusesLocal = stat + StoreStruct.statusesLocal
                                StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                            }
                        } else {
                            StoreStruct.statusesLocal = stat + StoreStruct.statusesLocal
                            StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                        }
                        
                        
                        DispatchQueue.main.async {
                            StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                            
                            newestC = StoreStruct.statusesLocal.count - newestC - 1
                            if newestC < 0 {
                                newestC = 0
                            }
                            
                            if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                self.newUpdatesB2.setTitle("\(newestC)  ", for: .normal)
                                //                            self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                                self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                springWithDelay(duration: 0.5, delay: 0, animations: {
                                    self.newUpdatesB2.alpha = 1
                                    self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                    //                                self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                                })
                                self.countcount2 = newestC
                                
                                UIView.setAnimationsEnabled(false)
                                self.tableViewL.reloadData()
                                self.refreshControl.endRefreshing()
                                if newestC == 0 {
                                    
                                } else if StoreStruct.statusesLocal.count >= newestC + 1 {
                                    self.tableViewL.scrollToRow(at: IndexPath(row: newestC + 1, section: 0), at: .top, animated: false)
                                }
                                UIView.setAnimationsEnabled(true)
                            } else {
                                
                                self.tableViewL.reloadData()
                                self.refreshControl.endRefreshing()
                                
                            }
                            
                            
                            do {
                                //                                self.restoreScroll()
                                try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                            } catch {
                                print("Couldn't save")
                            }
                            
                        }
                    }
                }
            }
        } else {
            let request = Timelines.public(local: false, range: .since(id: StoreStruct.statusesFederated.first?.id ?? "", limit: 5000))
            DispatchQueue.global(qos: .userInitiated).async {
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        var newestC = StoreStruct.statusesFederated.count
                        
                        if let st = stat.last {
                            if StoreStruct.statusesFederated.contains(st) || stat.count < 20 {
                                print("no need for load more button here")
                                StoreStruct.statusesFederated = stat + StoreStruct.statusesFederated
                                StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                            } else {
                                print("need load more button here")
                                StoreStruct.gapLastFedID = stat.last?.id ?? ""
                                let z = st
                                z.id = "loadmorehere"
                                StoreStruct.gapLastFedStat = z
                                print(StoreStruct.gapLastFedID)
                                StoreStruct.statusesFederated = stat + StoreStruct.statusesFederated
                                StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                            }
                        } else {
                            StoreStruct.statusesFederated = stat + StoreStruct.statusesFederated
                            StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                        }
                        
                        
                        DispatchQueue.main.async {
                            StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                            
                            newestC = StoreStruct.statusesFederated.count - newestC - 1
                            if newestC < 0 {
                                newestC = 0
                            }
                            
                            if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                self.newUpdatesB3.setTitle("\(newestC)  ", for: .normal)
                                //                            self.newUpdatesB3.transform = CGAffineTransform(translationX: 120, y: 0)
                                self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                springWithDelay(duration: 0.5, delay: 0, animations: {
                                    self.newUpdatesB3.alpha = 1
                                    self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                    //                                self.newUpdatesB3.transform = CGAffineTransform(translationX: 0, y: 0)
                                })
                                self.countcount3 = newestC
                                
                                UIView.setAnimationsEnabled(false)
                                self.tableViewF.reloadData()
                                self.refreshControl.endRefreshing()
                                if newestC == 0 {
                                    
                                } else if StoreStruct.statusesFederated.count >= newestC + 1 {
                                    self.tableViewF.scrollToRow(at: IndexPath(row: newestC + 1, section: 0), at: .top, animated: false)
                                }
                                UIView.setAnimationsEnabled(true)
                                
                            } else {
                                
                                self.tableViewF.reloadData()
                                self.refreshControl.endRefreshing()
                                
                            }
                            
                            
                            do {
                                //                                self.restoreScroll()
                                try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                            } catch {
                                print("Couldn't save")
                            }
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Data and Fetch
    
    func fetchGap() {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
        
        if self.currentIndex == 0 {
            let request = Timelines.home(range: .max(id: StoreStruct.gapLastHomeID, limit: nil))
            DispatchQueue.global(qos: .userInitiated).async {
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        
                        if stat.isEmpty {} else {
                            
                            let y = StoreStruct.statusesHome.split(separator: StoreStruct.gapLastHomeStat!)
                            print(y)
                            if StoreStruct.statusesHome.count >= y.first!.count + 1 {
                                StoreStruct.statusesHome.remove(at: y.first!.count + 1)
                            }
                            
                            if StoreStruct.statusesHome.contains(stat.last!) {
                                StoreStruct.statusesHome = y.first! + stat + y.last!
                                StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            } else {
                                StoreStruct.gapLastHomeID = stat.last?.id ?? ""
                                let z = stat.last!
                                z.id = "loadmorehere"
                                StoreStruct.gapLastHomeStat = z
                                StoreStruct.statusesHome = y.first! + stat + y.last!
                                StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            }
                            
                            
                            let newestC = y.first!.count + stat.count
                            
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                    self.newUpdatesB1.setTitle("\(newestC)  ", for: .normal)
                                    self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                    springWithDelay(duration: 0.5, delay: 0, animations: {
                                        self.newUpdatesB1.alpha = 1
                                        self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                    })
                                    self.countcount1 = newestC
                                    
                                    DispatchQueue.main.async {
                                        UIView.setAnimationsEnabled(false)
                                        self.tableView.reloadData()
                                        if newestC == 0 {
                                            
                                        } else {
                                            if (UserDefaults.standard.object(forKey: "lmore1") == nil) || (UserDefaults.standard.object(forKey: "lmore1") as! Int == 0) {} else {
                                                self.tableView.scrollToRow(at: IndexPath(row: newestC, section: 0), at: .top, animated: false)
                                                
                                                do {
                                                    try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                                    try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                                    try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                                                } catch {
                                                    print("Couldn't save")
                                                }
                                            }
                                        }
                                        UIView.setAnimationsEnabled(true)
                                    }
                                } else {
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
        } else if self.currentIndex == 1 {
            
            let request = Timelines.public(local: true, range: .max(id: StoreStruct.gapLastLocalID, limit: nil))
            DispatchQueue.global(qos: .userInitiated).async {
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        
                        if stat.isEmpty {} else {
                            let y = StoreStruct.statusesLocal.split(separator: StoreStruct.gapLastLocalStat!)
                            print(y)
                            
                            if StoreStruct.statusesLocal.count >= y.first!.count + 1 {
                                StoreStruct.statusesLocal.remove(at: y.first!.count + 1)
                            }
                            
                            if StoreStruct.statusesLocal.contains(stat.last!) {
                                StoreStruct.statusesLocal = y.first! + stat + y.last!
                                StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                            } else {
                                StoreStruct.gapLastLocalID = stat.last?.id ?? ""
                                let z = stat.last!
                                z.id = "loadmorehere"
                                StoreStruct.gapLastLocalStat = z
                                StoreStruct.statusesLocal = y.first! + stat + y.last!
                                StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                            }
                            
                            
                            let newestC = y.first!.count + stat.count
                            
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                    self.newUpdatesB1.setTitle("\(newestC)  ", for: .normal)
                                    self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                    springWithDelay(duration: 0.5, delay: 0, animations: {
                                        self.newUpdatesB1.alpha = 1
                                        self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                    })
                                    self.countcount1 = newestC
                                    
                                    DispatchQueue.main.async {
                                        UIView.setAnimationsEnabled(false)
                                        self.tableViewL.reloadData()
                                        if newestC == 0 {
                                            
                                        } else {
                                            if (UserDefaults.standard.object(forKey: "lmore1") == nil) || (UserDefaults.standard.object(forKey: "lmore1") as! Int == 0) {} else {
                                                self.tableViewL.scrollToRow(at: IndexPath(row: newestC, section: 0), at: .top, animated: false)
                                                
                                                do {
                                                    try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                                    try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                                    try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                                                } catch {
                                                    print("Couldn't save")
                                                }
                                            }
                                        }
                                        UIView.setAnimationsEnabled(true)
                                    }
                                } else {
                                    
                                    DispatchQueue.main.async {
                                        self.tableViewL.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            
        } else {
            let request = Timelines.public(local: false, range: .max(id: StoreStruct.gapLastFedID, limit: nil))
            DispatchQueue.global(qos: .userInitiated).async {
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        
                        if stat.isEmpty {} else {
                            let y = StoreStruct.statusesFederated.split(separator: StoreStruct.gapLastFedStat!)
                            print("testing")
                            print(y.first?.count ?? 0)
                            print(y.last?.count ?? 0)
                            if StoreStruct.statusesFederated.count >= y.first!.count + 1 {
                                StoreStruct.statusesFederated.remove(at: y.first!.count + 1)
                            }
                            
                            if StoreStruct.statusesFederated.contains(stat.last!) {
                                StoreStruct.statusesFederated = y.first! + stat + y.last!
                                StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                            } else {
                                StoreStruct.gapLastFedID = stat.last?.id ?? ""
                                let z = stat.last!
                                z.id = "loadmorehere"
                                StoreStruct.gapLastFedStat = z
                                StoreStruct.statusesFederated = y.first! + stat + y.last!
                                StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                            }
                            
                            
                            let newestC = y.first!.count + stat.count
                            
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                    self.newUpdatesB1.setTitle("\(newestC)  ", for: .normal)
                                    self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                    springWithDelay(duration: 0.5, delay: 0, animations: {
                                        self.newUpdatesB1.alpha = 1
                                        self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                    })
                                    self.countcount1 = newestC
                                    
                                    DispatchQueue.main.async {
                                        UIView.setAnimationsEnabled(false)
                                        self.tableViewF.reloadData()
                                        if newestC == 0 {
                                            
                                        } else {
                                            if (UserDefaults.standard.object(forKey: "lmore1") == nil) || (UserDefaults.standard.object(forKey: "lmore1") as! Int == 0) {} else {
                                                self.tableViewF.scrollToRow(at: IndexPath(row: newestC, section: 0), at: .top, animated: false)
                                                
                                                do {
                                                    try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                                    try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                                    try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                                                } catch {
                                                    print("Couldn't save")
                                                }
                                            }
                                        }
                                        UIView.setAnimationsEnabled(true)
                                    }
                                } else {
                                    
                                    DispatchQueue.main.async {
                                        self.tableViewF.reloadData()
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func fetchMoreHome() {
        let request = Timelines.home(range: .max(id: StoreStruct.statusesHome.last?.id ?? "", limit: nil))
        DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    
                    if stat.isEmpty || self.lastThing == stat.first?.id ?? "" {} else {
                        self.lastThing = stat.first?.id ?? ""
                        
                        StoreStruct.statusesHome = StoreStruct.statusesHome + stat
                        DispatchQueue.main.async {
                            StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            self.tableView.reloadData()
                            
                            do {
                                try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                            } catch {
                                print("Couldn't save")
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func fetchMoreLocal() {
        let request = Timelines.public(local: true, range: .max(id: StoreStruct.statusesLocal.last?.id ?? "", limit: nil))
        DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    
                    if stat.isEmpty || self.lastThing2 == stat.first?.id ?? "" {} else {
                        self.lastThing2 = stat.first?.id ?? ""
                        StoreStruct.statusesLocal = StoreStruct.statusesLocal + stat
                        DispatchQueue.main.async {
                            StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                            self.tableViewL.reloadData()
                            
                            do {
                                try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                            } catch {
                                print("Couldn't save")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchMoreFederated() {
        let request = Timelines.public(local: false, range: .max(id: StoreStruct.statusesFederated.last?.id ?? "", limit: nil))
        DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    
                    if stat.isEmpty || self.lastThing3 == stat.first?.id ?? "" {} else {
                        self.lastThing3 = stat.first?.id ?? ""
                        StoreStruct.statusesFederated = StoreStruct.statusesFederated + stat
                        DispatchQueue.main.async {
                            StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                            self.tableViewF.reloadData()
                            
                            do {
                                try Disk.save(StoreStruct.statusesHome, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)home.json")
                                try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)local.json")
                                try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "\(StoreStruct.shared.currentInstance.clientID)fed.json")
                            } catch {
                                print("Couldn't save")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Table View
    
    func firstRowHeight() -> CGFloat {
        return tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return StoreStruct.statusesHome.count
        } else if tableView == self.tableViewL {
            return StoreStruct.statusesLocal.count
        } else {
            return StoreStruct.statusesFederated.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            if StoreStruct.statusesHome.count <= 0 || indexPath.row >= StoreStruct.statusesHome.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainFeedCell
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                
                if StoreStruct.statusesHome[indexPath.row].id == "loadmorehere" {
                    
                    if (UserDefaults.standard.object(forKey: "autol1") == nil) || (UserDefaults.standard.object(forKey: "autol1") as! Int == 0) {} else {
                        self.fetchGap()
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellmore", for: indexPath) as! SettingsCell
                    cell.delegate = self
                    cell.backgroundColor = Colours.white3
                    cell.configure(status: "Load More", status2: "Tap to fetch more toots...")
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                    
                } else {
                    
                    if indexPath.row == StoreStruct.statusesHome.count - 14 {
                        self.fetchMoreHome()
                    }
                    print(indexPath.row)
                    print(StoreStruct.statusesHome.count)
                    if StoreStruct.statusesHome[indexPath.row].reblog?.mediaAttachments.isEmpty ?? StoreStruct.statusesHome[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainFeedCell
                        cell.delegate = self
                        cell.backgroundColor = Colours.white
                        
                        cell.rep1.tag = indexPath.row
                        cell.like1.tag = indexPath.row
                        cell.boost1.tag = indexPath.row
                        cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                        cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                        cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                        
                        cell.configure(StoreStruct.statusesHome[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in StoreStruct.statusesHome[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.acct
                                }
                            }
                            
                            print("tapmedemp")
                            print(newString)
                            
                            
                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser?.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: newString)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        controller.userIDtoUse = stat[0].id
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
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
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
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
                            let request = Timelines.tag(string)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    controller.currentTags = stat
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MainFeedCellImage
                        cell.delegate = self
                        cell.backgroundColor = Colours.white
                        
                        cell.rep1.tag = indexPath.row
                        cell.like1.tag = indexPath.row
                        cell.boost1.tag = indexPath.row
                        cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                        cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                        cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                        
                        cell.configure(StoreStruct.statusesHome[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        
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
                        
                        
                        
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.mainImageView.backgroundColor = Colours.white
                        cell.mainImageViewBG.backgroundColor = Colours.white
                        
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in StoreStruct.statusesHome[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.acct
                                }
                            }
                            
                            
                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser?.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: newString)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        controller.userIDtoUse = stat[0].id
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
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
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
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
                            let request = Timelines.tag(string)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    controller.currentTags = stat
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    }
                }
                
            }
            
        } else if tableView == self.tableViewL {
            
            if StoreStruct.statusesLocal.count <= 0 || indexPath.row >= StoreStruct.statusesLocal.count  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath) as! MainFeedCell
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
            
                if StoreStruct.statusesLocal[indexPath.row].id == "loadmorehere" {
                    
                    if (UserDefaults.standard.object(forKey: "autol1") == nil) || (UserDefaults.standard.object(forKey: "autol1") as! Int == 0) {} else {
                        self.fetchGap()
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellmore1", for: indexPath) as! SettingsCell
                    cell.delegate = self
                    cell.backgroundColor = Colours.white3
                    cell.configure(status: "Load More", status2: "Tap to fetch more toots...")
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                    
                } else {
                    
                    if indexPath.row == StoreStruct.statusesLocal.count - 14 {
                        self.fetchMoreLocal()
                    }
                    if StoreStruct.statusesLocal[indexPath.row].reblog?.mediaAttachments.isEmpty ?? StoreStruct.statusesLocal[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath) as! MainFeedCell
                        cell.delegate = self
                        cell.backgroundColor = Colours.white
                        
                        cell.rep1.tag = indexPath.row
                        cell.like1.tag = indexPath.row
                        cell.boost1.tag = indexPath.row
                        cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                        cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                        cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                        
                        cell.configure(StoreStruct.statusesLocal[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in StoreStruct.statusesLocal[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.acct
                                }
                            }
                            
                            
                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser?.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: newString)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        controller.userIDtoUse = stat[0].id
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
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
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
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
                            let request = Timelines.tag(string)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    controller.currentTags = stat
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2l", for: indexPath) as! MainFeedCellImage
                        cell.delegate = self
                        cell.backgroundColor = Colours.white
                        
                        cell.rep1.tag = indexPath.row
                        cell.like1.tag = indexPath.row
                        cell.boost1.tag = indexPath.row
                        cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                        cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                        cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                        
                        cell.configure(StoreStruct.statusesLocal[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
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
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.mainImageView.backgroundColor = Colours.white
                        cell.mainImageViewBG.backgroundColor = Colours.white
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in StoreStruct.statusesLocal[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.acct
                                }
                            }
                            
                            
                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser?.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: newString)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        controller.userIDtoUse = stat[0].id
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
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
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
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
                            let request = Timelines.tag(string)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    controller.currentTags = stat
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    }
                }
            }
        } else {
            
            
            if StoreStruct.statusesFederated.count <= 0 || indexPath.row >= StoreStruct.statusesFederated.count  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellf", for: indexPath) as! MainFeedCell
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                
                
                
                
                if StoreStruct.statusesFederated[indexPath.row].id == "loadmorehere" {
                    
                    if (UserDefaults.standard.object(forKey: "autol1") == nil) || (UserDefaults.standard.object(forKey: "autol1") as! Int == 0) {} else {
                        self.fetchGap()
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellmore2", for: indexPath) as! SettingsCell
                    cell.delegate = self
                    cell.backgroundColor = Colours.white3
                    cell.configure(status: "Load More", status2: "Tap to fetch more toots...")
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                    
                    
                    
                } else {
                    
                    
                    if indexPath.row == StoreStruct.statusesFederated.count - 14 {
                        self.fetchMoreFederated()
                    }
                    if StoreStruct.statusesFederated[indexPath.row].reblog?.mediaAttachments.isEmpty ?? StoreStruct.statusesFederated[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cellf", for: indexPath) as! MainFeedCell
                        cell.delegate = self
                        cell.backgroundColor = Colours.white
                        
                        cell.rep1.tag = indexPath.row
                        cell.like1.tag = indexPath.row
                        cell.boost1.tag = indexPath.row
                        cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                        cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                        cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                        
                        cell.configure(StoreStruct.statusesFederated[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in StoreStruct.statusesFederated[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.acct
                                }
                            }
                            
                            
                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser?.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: newString)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        controller.userIDtoUse = stat[0].id
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
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
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
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
                            let request = Timelines.tag(string)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    controller.currentTags = stat
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2f", for: indexPath) as! MainFeedCellImage
                        cell.delegate = self
                        cell.backgroundColor = Colours.white
                        
                        cell.rep1.tag = indexPath.row
                        cell.like1.tag = indexPath.row
                        cell.boost1.tag = indexPath.row
                        cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                        cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                        cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                        
                        cell.configure(StoreStruct.statusesFederated[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
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
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.mainImageView.backgroundColor = Colours.white
                        cell.mainImageViewBG.backgroundColor = Colours.white
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in StoreStruct.statusesFederated[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.acct
                                }
                            }
                            
                            
                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser?.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: newString)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        controller.userIDtoUse = stat[0].id
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
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
                                        self.safariVC = SFSafariViewController(url: z)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { (success) in
                                    if !success {
                                        self.safariVC = SFSafariViewController(url: url)
                                        self.safariVC?.preferredBarTintColor = Colours.white
                                        self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                        self.present(self.safariVC!, animated: true, completion: nil)
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
                            let request = Timelines.tag(string)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    controller.currentTags = stat
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    }
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var theTable = self.tableView
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            theTable = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            theTable = self.tableViewL
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            theTable = self.tableViewF
        }
        
        
        if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {} else {
            return nil
        }
        
        
        if sto[indexPath.row].id == "loadmorehere" {
            return nil
        }
        
        
        if orientation == .left {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            
            let boost = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("boost")
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    impact.impactOccurred()
                }
                
                
                
                
                
                
                
                
                if sto[indexPath.row].reblog?.reblogged! ?? sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                    StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id }
                    let request2 = Statuses.unreblog(id: sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if let cell = theTable.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].reblog?.favourited! ?? sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "like")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else {
                                let cell = theTable.cellForRow(at: indexPath) as! MainFeedCellImage
                                if sto[indexPath.row].reblog?.favourited! ?? sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "like")
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
                            
                            if let cell = theTable.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].reblog?.favourited ?? sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "boost")
                                }
                                cell.hideSwipe(animated: true)
                            } else {
                                let cell = theTable.cellForRow(at: indexPath) as! MainFeedCellImage
                                if sto[indexPath.row].reblog?.favourited ?? sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "boost")
                                }
                                cell.hideSwipe(animated: true)
                            }
                        }
                    }
                }
                
                
                
                
                
                
                
                if let cell = theTable.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = theTable.cellForRow(at: indexPath) as! MainFeedCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            boost.backgroundColor = Colours.white
            boost.image = UIImage(named: "boost")
            boost.transitionDelegate = ScaleTransition.default
            boost.textColor = Colours.tabUnselected
            
            let like = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("like")
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    impact.impactOccurred()
                }
                
                
                if sto[indexPath.row].reblog?.favourited! ?? sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                    StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id }
                    let request2 = Statuses.unfavourite(id: sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if let cell = theTable.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].reblog?.reblogged! ?? sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "boost")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else {
                                let cell = theTable.cellForRow(at: indexPath) as! MainFeedCellImage
                                if sto[indexPath.row].reblog?.reblogged! ?? sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "boost")
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
                            
                            if let cell = theTable.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].reblog?.reblogged ?? sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "like")
                                }
                                cell.hideSwipe(animated: true)
                            } else {
                                let cell = theTable.cellForRow(at: indexPath) as! MainFeedCellImage
                                if sto[indexPath.row].reblog?.reblogged ?? sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "like")
                                }
                                cell.hideSwipe(animated: true)
                            }
                        }
                    }
                }
                
                
                
                
                if let cell = theTable.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = theTable.cellForRow(at: indexPath) as! MainFeedCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            
            
            if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
                like.backgroundColor = Colours.white
            } else {
                if sto[indexPath.row].visibility == .direct {
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 1 {
                        like.backgroundColor = Colours.cellQuote
                    }
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 2 {
                        like.backgroundColor = Colours.tabUnselected
                    }
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 3 {
                        like.backgroundColor = Colours.tabSelected
                    }
                } else {
                    like.backgroundColor = Colours.white
                }
            }
            
            
            like.image = UIImage(named: "like")
            like.transitionDelegate = ScaleTransition.default
            like.textColor = Colours.tabUnselected
            
            let reply = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("reply")
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    impact.impactOccurred()
                }
                
                let controller = ComposeViewController()
                StoreStruct.spoilerText = sto[indexPath.row].reblog?.spoilerText ?? sto[indexPath.row].spoilerText
                controller.inReply = [sto[indexPath.row].reblog ?? sto[indexPath.row]]
                controller.prevTextReply = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                controller.inReplyText = sto[indexPath.row].reblog?.account.username ?? sto[indexPath.row].account.username
                print(sto[indexPath.row].reblog?.account.username ?? sto[indexPath.row].account.username)
                self.present(controller, animated: true, completion: nil)
                
                if let cell = theTable.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = theTable.cellForRow(at: indexPath) as! MainFeedCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            
            if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
                reply.backgroundColor = Colours.white
            } else {
                if sto[indexPath.row].visibility == .direct {
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 1 {
                        reply.backgroundColor = Colours.cellQuote
                    }
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 2 {
                        reply.backgroundColor = Colours.tabUnselected
                    }
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 3 {
                        reply.backgroundColor = Colours.tabSelected
                    }
                } else {
                    reply.backgroundColor = Colours.white
                }
            }
            
            
            reply.transitionDelegate = ScaleTransition.default
            reply.textColor = Colours.tabUnselected
            
            
            if sto[indexPath.row].reblog?.visibility ?? sto[indexPath.row].visibility == .direct {
                reply.image = UIImage(named: "direct2")
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
                reply.image = UIImage(named: "reply")
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
                print("boost")
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
                
                
                if sto[indexPath.row].account.id == StoreStruct.currentUser?.id {
                    
                    
                    
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
                    
                    Alertift.actionSheet(title: nil, message: newSecondsText)
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Pin/Unpin".localized), image: UIImage(named: "pinned")) { (action, ind) in
                            print(action, ind)
                            if sto[indexPath.row].pinned ?? false || StoreStruct.allPins.contains(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id) {
                                StoreStruct.allPins = StoreStruct.allPins.filter { $0 != sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id }
                                let request = Statuses.unpin(id: sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
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
                                        statusAlert.message = "This Status"
                                        statusAlert.show()
                                    }
                                }
                            } else {
                                StoreStruct.allPins.append(sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
                                let request = Statuses.pin(id: sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id)
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
                                        statusAlert.message = "This Status"
                                        statusAlert.show()
                                    }
                                }
                            }
                        }
                        .action(.default("Delete and Redraft".localized), image: UIImage(named: "block")) { (action, ind) in
                            print(action, ind)
                            
                            let controller = ComposeViewController()
                            StoreStruct.spoilerText = sto[indexPath.row].reblog?.spoilerText ?? sto[indexPath.row].spoilerText
                            controller.idToDel = sto[indexPath.row].id
                            controller.filledTextFieldText = sto[indexPath.row].content.stripHTML()
                            self.present(controller, animated: true, completion: nil)
                            
                        }
                        .action(.default("Delete".localized), image: UIImage(named: "block")) { (action, ind) in
                            print(action, ind)
                            
                            if self.currentIndex == 0 {
                                StoreStruct.statusesHome = StoreStruct.statusesHome.filter { $0 != StoreStruct.statusesHome[indexPath.row] }
                                theTable.deleteRows(at: [indexPath], with: .none)
                            } else if self.currentIndex == 1 {
                                StoreStruct.statusesLocal = StoreStruct.statusesLocal.filter { $0 != StoreStruct.statusesLocal[indexPath.row] }
                                theTable.deleteRows(at: [indexPath], with: .none)
                            } else if self.currentIndex == 2 {
                                StoreStruct.statusesFederated = StoreStruct.statusesFederated.filter { $0 != StoreStruct.statusesFederated[indexPath.row] }
                                theTable.deleteRows(at: [indexPath], with: .none)
                            }
                            
                            let theId = sto[indexPath.row].id
                            let request = Statuses.delete(id: theId)
                            StoreStruct.client.run(request) { (statuses) in
                                print("deleted")
                                
                                
                                DispatchQueue.main.async {
                                    
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Deleted".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Your Status"
                                    statusAlert.show()
                                    //sto.remove(at: indexPath.row)
                                    //self.tableView.reloadData()
                                }
                            }
                        }
                        .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                            print(action, ind)
                            
                            let unreserved = "-._~/?"
                            let allowed = NSMutableCharacterSet.alphanumeric()
                            allowed.addCharacters(in: unreserved)
                            let bodyText = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                            print("0001")
                            print(bodyText)
                            let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
                            let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
                            var trans = bodyText.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
                            trans = trans!.replacingOccurrences(of: "\n\n", with: "%20")
                            print("0002")
                            print(trans)
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
                            print(action, ind)
                            
                            let controller = ComposeViewController()
                            controller.inReply = []
                            controller.inReplyText = ""
                            controller.filledTextFieldText = sto[indexPath.row].content.stripHTML()
                            self.present(controller, animated: true, completion: nil)
                        }
                        .action(.default("Share".localized), image: UIImage(named: "share")) { (action, ind) in
                            print(action, ind)
                            
                            
                            
                            Alertift.actionSheet()
                                .backgroundColor(Colours.white)
                                .titleTextColor(Colours.grayDark)
                                .messageTextColor(Colours.grayDark)
                                .messageTextAlignment(.left)
                                .titleTextAlignment(.left)
                                .action(.default("Share Link".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
                                    if let myWebsite = sto[indexPath.row].url {
                                        let objectsToShare = [myWebsite]
                                        let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        vc.previewNumberOfLines = 5
                                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
                                    let bodyText = sto[indexPath.row].content.stripHTML()
                                    let vc = VisualActivityViewController(text: bodyText)
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                                .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
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
                                .show(on: self)
                            
                            
                            
                            
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
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
                    
                    Alertift.actionSheet(title: nil, message: newSecondsText)
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Mute/Unmute".localized), image: UIImage(named: "block")) { (action, ind) in
                            print(action, ind)
                            
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
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }
                                
                                let request = Accounts.mute(id: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print("muted")
                                        print(stat)
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
                                statusAlert.message = sto[indexPath.row].reblog?.account.displayName ?? sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }
                                
                                let request = Accounts.unmute(id: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print("unmuted")
                                        print(stat)
                                    }
                                }
                            }
                            
                        }
                        .action(.default("Block/Unblock".localized), image: UIImage(named: "block2")) { (action, ind) in
                            print(action, ind)
                            
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
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }
                                
                                let request = Accounts.block(id: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print("blocked")
                                        print(stat)
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
                                statusAlert.message = sto[indexPath.row].reblog?.account.displayName ?? sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }
                                
                                let request = Accounts.unblock(id: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print("unblocked")
                                        print(stat)
                                    }
                                }
                            }
                            
                        }
                        .action(.default("Report".localized), image: UIImage(named: "report")) { (action, ind) in
                            print(action, ind)
                            
                            Alertift.actionSheet()
                                .backgroundColor(Colours.white)
                                .titleTextColor(Colours.grayDark)
                                .messageTextColor(Colours.grayDark)
                                .messageTextAlignment(.left)
                                .titleTextAlignment(.left)
                                .action(.default("Harassment"), image: nil) { (action, ind) in
                                    print(action, ind)
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    
                                    
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Reported".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Harassment"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                        statusAlert.show()
                                    }
                                    
                                    let request = Reports.report(accountID: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id], reason: "Harassment")
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            print("reported")
                                            print(stat)
                                        }
                                    }
                                    
                                }
                                .action(.default("No Content Warning"), image: nil) { (action, ind) in
                                    print(action, ind)
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    
                                    
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Reported".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "No Content Warning"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                        statusAlert.show()
                                    }
                                    
                                    let request = Reports.report(accountID: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id], reason: "No Content Warning")
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            print("reported")
                                            print(stat)
                                        }
                                    }
                                    
                                }
                                .action(.default("Spam"), image: nil) { (action, ind) in
                                    print(action, ind)
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    
                                    
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Reported".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Spam"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                        statusAlert.show()
                                    }
                                    
                                    let request = Reports.report(accountID: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id], reason: "Spam")
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            print("reported")
                                            print(stat)
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
                            
                            
                        }
                        .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                            print(action, ind)
                            
                            let unreserved = "-._~/?"
                            let allowed = NSMutableCharacterSet.alphanumeric()
                            allowed.addCharacters(in: unreserved)
                            let bodyText = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                            print("0001")
                            print(bodyText)
                            let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
                            let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
                            var trans = bodyText.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
                            trans = trans!.replacingOccurrences(of: "\n\n", with: "%20")
                            print("0002")
                            print(trans)
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
                            print(action, ind)
                            
                            let controller = ComposeViewController()
                            controller.inReply = []
                            controller.inReplyText = ""
                            controller.filledTextFieldText = sto[indexPath.row].content.stripHTML()
                            self.present(controller, animated: true, completion: nil)
                        }
                        .action(.default("Share".localized), image: UIImage(named: "share")) { (action, ind) in
                            print(action, ind)
                            
                            
                            
                            Alertift.actionSheet()
                                .backgroundColor(Colours.white)
                                .titleTextColor(Colours.grayDark)
                                .messageTextColor(Colours.grayDark)
                                .messageTextAlignment(.left)
                                .titleTextAlignment(.left)
                                .action(.default("Share Link".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
                                    if let myWebsite = sto[indexPath.row].reblog?.url ?? sto[indexPath.row].url {
                                        let objectsToShare = [myWebsite]
                                        let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        vc.previewNumberOfLines = 5
                                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
                                    let bodyText = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                                    let vc = VisualActivityViewController(text: bodyText)
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                                .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
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
                                .show(on: self)
                            
                            
                            
                            
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .show(on: self)
                    
                }
                
                
                if let cell = theTable.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = theTable.cellForRow(at: indexPath) as! MainFeedCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            
            if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
                more.backgroundColor = Colours.white
            } else {
                if sto[indexPath.row].visibility == .direct {
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 1 {
                        more.backgroundColor = Colours.cellQuote
                    }
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 2 {
                        more.backgroundColor = Colours.tabUnselected
                    }
                    if UserDefaults.standard.object(forKey: "dmTog") as! Int == 3 {
                        more.backgroundColor = Colours.tabSelected
                    }
                } else {
                    more.backgroundColor = Colours.white
                }
            }
            
            more.image = UIImage(named: "more2")
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
        print(indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableViewL.deselectRow(at: indexPath, animated: true)
        self.tableViewF.deselectRow(at: indexPath, animated: true)
        
        let controller = DetailViewController()
        if self.currentIndex == 0 {
            if StoreStruct.statusesHome[indexPath.row].id == "loadmorehere" {
                self.fetchGap()
            } else {
                controller.mainStatus.append(StoreStruct.statusesHome[indexPath.row])
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else if self.currentIndex == 1 {
            if StoreStruct.statusesLocal[indexPath.row].id == "loadmorehere" {
                self.fetchGap()
            } else {
                controller.mainStatus.append(StoreStruct.statusesLocal[indexPath.row])
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            if StoreStruct.statusesFederated[indexPath.row].id == "loadmorehere" {
                self.fetchGap()
            } else {
                controller.mainStatus.append(StoreStruct.statusesFederated[indexPath.row])
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        if self.currentIndex == 0 {
            UserDefaults.standard.set(self.tableView.contentOffset.y, forKey: "savedRowHome1")
        } else if self.currentIndex == 1 {
            UserDefaults.standard.set(self.tableViewL.contentOffset.y, forKey: "savedRowLocal1")
        } else {
            UserDefaults.standard.set(self.tableViewF.contentOffset.y, forKey: "savedRowFed1")
        }
    }
    
    
    // MARK: - Notification Triggerred
    
    @objc func createNoti() {
        
        let request0 = Notifications.all(range: .min(id: StoreStruct.notifications.first?.id ?? "", limit: nil))
        //DispatchQueue.global(qos: .userInitiated).async {
        print("002")
        StoreStruct.client.run(request0) { (statuses) in
            print("003")
            print(statuses.value)
            if let stat = (statuses.value) {
                print("004")
                StoreStruct.notifications = stat + StoreStruct.notifications
                
                let st = stat.reversed()
                //DispatchQueue.main.async {
                for x in st {
                    print("005")
                    if x.type == .mention {
                        print("006")
                        
                        let content = UNMutableNotificationContent()
                        content.title =  "\(x.account.displayName) mentioned you"
                        content.body = x.status!.content.stripHTML()
                        let request = UNNotificationRequest(
                            identifier: UUID().uuidString,
                            content: content,
                            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        )
                        UNUserNotificationCenter.current().add(request)
                        
                    }
                    if x.type == .follow {
                        print("007")
                        
                        let content = UNMutableNotificationContent()
                        content.title =  "\(x.account.displayName) followed you"
                        content.body = x.account.note.stripHTML()
                        let request = UNNotificationRequest(
                            identifier: UUID().uuidString,
                            content: content,
                            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        )
                        UNUserNotificationCenter.current().add(request)
                        
                    }
                    if x.type == .reblog {
                        print("008")
                        
                        let content = UNMutableNotificationContent()
                        content.title = "\(x.account.displayName) reposted your status"
                        content.body = x.status!.content.stripHTML()
                        let request = UNNotificationRequest(
                            identifier: UUID().uuidString,
                            content: content,
                            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        )
                        UNUserNotificationCenter.current().add(request)
                        
                    }
                    if x.type == .favourite {
                        print("009")
                        
                        let content = UNMutableNotificationContent()
                        content.title = "\(x.account.displayName) liked your status"
                        content.body = x.status!.content.stripHTML()
                        let request = UNNotificationRequest(
                            identifier: UUID().uuidString,
                            content: content,
                            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        )
                        UNUserNotificationCenter.current().add(request)
                        
                    }
                }
            }
        }
        
    }
    
    @objc func goToIDNoti() {
        let request = Notifications.notification(id: StoreStruct.curIDNoti)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    let controller = DetailViewController()
                    controller.mainStatus.append(stat.status!)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    @objc func goToID() {
        sleep(2)
        let request = Statuses.status(id: StoreStruct.curID)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    let controller = DetailViewController()
                    controller.mainStatus.append(stat)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    @objc func goLists() {
        DispatchQueue.main.async {
            let controller = ListViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func goInstance() {
        let request = Timelines.public(local: true, range: .max(id: StoreStruct.newInstanceTags.last?.id ?? "", limit: nil))
        let testClient = Client(
            baseURL: "https://\(StoreStruct.instanceText)",
            accessToken: StoreStruct.shared.currentInstance.accessToken ?? ""
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
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    let controller = ListMembersViewController()
                    controller.currentTagTitle = "List Members".localized
                    controller.currentTags = stat
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    @objc func search() {
        let controller = DetailViewController()
        controller.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func searchUser() {
        let controller = ThirdViewController()
        controller.fromOtherUser = true
        controller.userIDtoUse = StoreStruct.statusSearchUser[StoreStruct.searchIndex].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func savedComposePresent() {
        DispatchQueue.main.async {
            
            Alertift.actionSheet(title: nil, message: "Oops! Looks like the app was quit while you were in the middle of a great toot. Would you like to get back to composing it?")
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default("Resume Composing Toot".localized), image: nil) { (action, ind) in
                    let controller = ComposeViewController()
                    controller.inReply = []
                    controller.inReplyText = StoreStruct.savedInReplyText
                    controller.filledTextFieldText = StoreStruct.savedComposeText
                    self.present(controller, animated: true, completion: nil)
                    StoreStruct.savedComposeText = ""
                    UserDefaults.standard.set(StoreStruct.savedComposeText, forKey: "composeSaved")
                    StoreStruct.savedInReplyText = ""
                    UserDefaults.standard.set(StoreStruct.savedInReplyText, forKey: "savedInReplyText")
                }
                .action(.cancel("Dismiss")) { (action, ind) in
                    StoreStruct.savedComposeText = ""
                    UserDefaults.standard.set(StoreStruct.savedComposeText, forKey: "composeSaved")
                    StoreStruct.savedInReplyText = ""
                    UserDefaults.standard.set(StoreStruct.savedInReplyText, forKey: "savedInReplyText")
                }
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
                .popover(anchorView: self.view)
                .show(on: self)
            
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
    
    @objc func startStream() {
        self.streamDataHome()
        self.streamDataLocal()
        self.streamDataFed()
    }
    
    @objc func fetchAllNewest() {
        self.refreshCont()
    }
    
    // MARK: - Button Actions
    
    @objc func didTouchBoost(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        
        var theTable = self.tableView
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            theTable = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            theTable = self.tableViewL
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            theTable = self.tableViewF
        }
        
        if sto[sender.tag].reblog?.reblogged! ?? sto[sender.tag].reblogged! || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
            StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[sender.tag].reblog?.id ?? sto[sender.tag].id }
            let request2 = Statuses.unreblog(id: sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if let cell = theTable.cellForRow(at:IndexPath(row: sender.tag, section: 0)) as? MainFeedCell {
                        if sto[sender.tag].reblog?.favourited! ?? sto[sender.tag].favourited! || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "like")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.favourited! ?? sto[sender.tag].favourited! || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "like")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        } else {
            StoreStruct.allBoosts.append(sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            let request2 = Statuses.reblog(id: sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                    }
                    
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? MainFeedCell {
                        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.moreImage.image = UIImage(named: "boost")
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.moreImage.image = UIImage(named: "boost")
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        }
    }
    
    
    
    @objc func didTouchLike(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        
        var theTable = self.tableView
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            theTable = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            theTable = self.tableViewL
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            theTable = self.tableViewF
        }
        
        if sto[sender.tag].reblog?.favourited! ?? sto[sender.tag].favourited! || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
            StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[sender.tag].reblog?.id ?? sto[sender.tag].id }
            let request2 = Statuses.unfavourite(id: sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? MainFeedCell {
                        if sto[sender.tag].reblog?.reblogged! ?? sto[sender.tag].reblogged! || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "boost")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.reblogged! ?? sto[sender.tag].reblogged! || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "boost")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        } else {
            StoreStruct.allLikes.append(sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            let request2 = Statuses.favourite(id: sto[sender.tag].reblog?.id ?? sto[sender.tag].id)
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                    }
                    
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? MainFeedCell {
                        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.moreImage.image = UIImage(named: "like")
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.moreImage.image = UIImage(named: "like")
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        }
    }
    
    
    
    @objc func didTouchReply(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        
        var theTable = self.tableView
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            theTable = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            theTable = self.tableViewL
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            theTable = self.tableViewF
        }
        
        let controller = ComposeViewController()
        StoreStruct.spoilerText = sto[sender.tag].reblog?.spoilerText ?? sto[sender.tag].spoilerText
        controller.inReply = [sto[sender.tag].reblog ?? sto[sender.tag]]
        controller.prevTextReply = sto[sender.tag].reblog?.content.stripHTML() ?? sto[sender.tag].content.stripHTML()
        controller.inReplyText = sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username
        print(sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username)
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func didTouchProfile(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
        }
        
        let controller = ThirdViewController()
        if sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username == StoreStruct.currentUser?.username {} else {
            controller.fromOtherUser = true
        }
        if self.currentIndex == 0 {
            controller.userIDtoUse = sto[sender.tag].reblog?.account.id ?? sto[sender.tag].account.id
            self.navigationController?.pushViewController(controller, animated: true)
        } else if self.currentIndex == 1 {
            controller.userIDtoUse = sto[sender.tag].reblog?.account.id ?? sto[sender.tag].account.id
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            controller.userIDtoUse = sto[sender.tag].reblog?.account.id ?? sto[sender.tag].account.id
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // Settings button tapped
    @objc func touchList() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "touchList"), object: nil)
    }
    
    @objc func tappedImage(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
        }
        
        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
                let videoURL = URL(string: sto[sender.tag].reblog?.mediaAttachments[0].url ?? sto[sender.tag].mediaAttachments[0].url)!
                if (UserDefaults.standard.object(forKey: "vidgif") == nil) || (UserDefaults.standard.object(forKey: "vidgif") as! Int == 0) {
                    XPlayer.play(videoURL)
                } else {
                    self.player = AVPlayer(url: videoURL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = self.player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
                
            } else {
                
                
                if self.currentIndex == 0 {
                    
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                    var images = [SKPhoto]()
                    var coun = 0
                    for y in sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments {
                        if coun == 0 {
                            let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                            photo.shouldCachePhotoURLImage = true
                            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                                photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                            } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                                photo.caption = y.description ?? ""
                            } else {
                                photo.caption = ""
                            }
                            images.append(photo)
                        } else {
                            let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                            photo.shouldCachePhotoURLImage = true
                            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                                photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                            } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                                photo.caption = y.description ?? ""
                            } else {
                                photo.caption = ""
                            }
                            images.append(photo)
                        }
                        coun += 1
                    }
                    let originImage = sender.currentImage
                    if originImage != nil {
                        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.mainImageView)
                        browser.displayToolbar = true
                        browser.displayAction = true
                        browser.delegate = self
                        browser.initializePageIndex(0)
                        present(browser, animated: true, completion: nil)
                    }
                    
                } else if self.currentIndex == 1 {
                    
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    let cell = tableViewL.cellForRow(at: indexPath) as! MainFeedCellImage
                    var images = [SKPhoto]()
                    var coun = 0
                    for y in sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments {
                        if coun == 0 {
                            let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                            photo.shouldCachePhotoURLImage = true
                            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                                photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                            } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                                photo.caption = y.description ?? ""
                            } else {
                                photo.caption = ""
                            }
                            images.append(photo)
                        } else {
                            let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                            photo.shouldCachePhotoURLImage = true
                            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                                photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                            } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                                photo.caption = y.description ?? ""
                            } else {
                                photo.caption = ""
                            }
                            images.append(photo)
                        }
                        coun += 1
                    }
                    let originImage = sender.currentImage
                    if originImage != nil {
                        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.mainImageView)
                        browser.displayToolbar = true
                        browser.displayAction = true
                        browser.delegate = self
                        browser.initializePageIndex(0)
                        present(browser, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    let cell = tableViewF.cellForRow(at: indexPath) as! MainFeedCellImage
                    var images = [SKPhoto]()
                    var coun = 0
                    for y in sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments {
                        if coun == 0 {
                            let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                            photo.shouldCachePhotoURLImage = true
                            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                                photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                            } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                                photo.caption = y.description ?? ""
                            } else {
                                photo.caption = ""
                            }
                            images.append(photo)
                        } else {
                            let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                            photo.shouldCachePhotoURLImage = true
                            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                                photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                            } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                                photo.caption = y.description ?? ""
                            } else {
                                photo.caption = ""
                            }
                            images.append(photo)
                        }
                        coun += 1
                    }
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
    }
    
    
    
    
    @objc func tappedImageS1(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        var tab = self.tableView
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableViewL
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableViewF
        }
        
        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
            } else {
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = tab.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                var coun = 0
                for y in sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments {
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.smallImage1.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    } else {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
                    coun += 1
                }
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
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        var tab = self.tableView
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableViewL
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableViewF
        }
        
        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
            } else {
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = tab.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                var coun = 0
                for y in sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments {
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.smallImage2.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    } else {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
                    coun += 1
                }
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
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        var tab = self.tableView
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableViewL
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableViewF
        }
        
        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
            } else {
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = tab.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                var coun = 0
                for y in sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments {
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.smallImage3.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    } else {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
                    coun += 1
                }
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
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        var tab = self.tableView
        var sto = StoreStruct.statusesHome
        if self.currentIndex == 0 {
            sto = StoreStruct.statusesHome
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.statusesLocal
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableViewL
        } else if self.currentIndex == 2 {
            sto = StoreStruct.statusesFederated
            StoreStruct.newIDtoGoTo = sto[sender.tag].id
            tab = self.tableViewF
        }
        
        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
            } else {
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = tab.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                var coun = 0
                for y in sto[indexPath.row].reblog?.mediaAttachments ?? sto[indexPath.row].mediaAttachments {
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.smallImage4.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    } else {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].reblog?.content.stripHTML() ?? sto[indexPath.row].content.stripHTML()
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
                    coun += 1
                }
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
    
    
    
// MARK: - Gestures
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let detailVC = DetailViewController()
        detailVC.isPeeking = true

        if self.currentIndex == 0 {
            
            guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
            detailVC.mainStatus.append(StoreStruct.statusesHome[indexPath.row])
            previewingContext.sourceRect = cell.frame
            return detailVC
            
        } else if self.currentIndex == 1 {
            
            guard let indexPath = self.tableViewL.indexPathForRow(at: location) else { return nil }
            guard let cell = self.tableViewL.cellForRow(at: indexPath) else { return nil }
            detailVC.mainStatus.append(StoreStruct.statusesLocal[indexPath.row])
            previewingContext.sourceRect = cell.frame
            return detailVC
            
        } else {
            
            guard let indexPath = self.tableViewF.indexPathForRow(at: location) else { return nil }
            guard let cell = self.tableViewF.cellForRow(at: indexPath) else { return nil }
            detailVC.mainStatus.append(StoreStruct.statusesFederated[indexPath.row])
            previewingContext.sourceRect = cell.frame
            return detailVC
            
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if (UserDefaults.standard.object(forKey: "shakegest") == nil) || (UserDefaults.standard.object(forKey: "shakegest") as! Int == 0) {
                if self.currentIndex == 0 {
                    self.tableView.reloadData()
                } else if self.currentIndex == 1 {
                    self.tableViewL.reloadData()
                } else {
                    self.tableViewF.reloadData()
                }
            } else if (UserDefaults.standard.object(forKey: "shakegest") as! Int == 1) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
            } else {
                
            }
        }
    }
    
    // MARK: - Scrolling
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.currentIndex == 0 {
            
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
            
        } else if self.currentIndex == 1 {
            
            if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
                crownControl2?.spinToMatchScrollViewOffset()
            }
            
            let indexPath1 = IndexPath(row: self.countcount2 - 1, section: 0)
            if self.tableViewL.indexPathsForVisibleRows?.contains(indexPath1) ?? false {
                if self.countcount2 == 0 {
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                        //                        self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                        springWithDelay(duration: 0.5, delay: 0, animations: {
                            self.newUpdatesB2.alpha = 0
                            self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                            //                            self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                        })
                        self.countcount2 = 0
                    })
                } else {
                    self.countcount2 = self.countcount2 - 1
                    if self.countcount2 == 0 {
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                            //                            self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                            springWithDelay(duration: 0.5, delay: 0, animations: {
                                self.newUpdatesB2.alpha = 0
                                self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                //                                self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                            })
                            self.countcount2 = 0
                        })
                    }
                }
                self.newUpdatesB2.setTitle("\(self.countcount2)  ", for: .normal)
            }
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
            
        } else {
            
            if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
                crownControl3?.spinToMatchScrollViewOffset()
            }
            
            let indexPath1 = IndexPath(row: self.countcount3 - 1, section: 0)
            if self.tableViewF.indexPathsForVisibleRows?.contains(indexPath1) ?? false {
                if self.countcount3 == 0 {
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                        //                    self.newUpdatesB3.transform = CGAffineTransform(translationX: 0, y: 0)
                        springWithDelay(duration: 0.5, delay: 0, animations: {
                            self.newUpdatesB3.alpha = 0
                            self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                            //                        self.newUpdatesB3.transform = CGAffineTransform(translationX: 120, y: 0)
                        })
                        self.countcount3 = 0
                    })
                } else {
                    self.countcount3 = self.countcount3 - 1
                    if self.countcount3 == 0 {
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                            //                        self.newUpdatesB3.transform = CGAffineTransform(translationX: 0, y: 0)
                            springWithDelay(duration: 0.5, delay: 0, animations: {
                                self.newUpdatesB3.alpha = 0
                                self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                //                            self.newUpdatesB3.transform = CGAffineTransform(translationX: 120, y: 0)
                            })
                            self.countcount3 = 0
                        })
                    }
                }
                self.newUpdatesB3.setTitle("\(self.countcount3)  ", for: .normal)
            }
            if (scrollView.contentOffset.y == 0) {
                springWithDelay(duration: 0.4, delay: 0, animations: {
                    self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                    //                self.newUpdatesB3.transform = CGAffineTransform(translationX: 0, y: 0)
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.newUpdatesB3.alpha = 0
                        self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                        //                    self.newUpdatesB3.transform = CGAffineTransform(translationX: 120, y: 0)
                    })
                    self.countcount3 = 0
                })
            }
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.currentIndex == 0 {
            UserDefaults.standard.set(self.tableView.contentOffset.y, forKey: "savedRowHome1")
        } else if self.currentIndex == 1 {
            UserDefaults.standard.set(self.tableViewL.contentOffset.y, forKey: "savedRowLocal1")
        } else {
            UserDefaults.standard.set(self.tableViewF.contentOffset.y, forKey: "savedRowFed1")
        }
    }
    
    @objc func scrollTop1() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if StoreStruct.statusesHome.count > 0 {
                if self.tableView.alpha == 1 {
                    if StoreStruct.statusesHome.count <= 0 {
                        
                    } else {
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
            
            if self.tableViewL.alpha == 1 && StoreStruct.statusesLocal.count > 0 {
                print("scrolllocal")
                if StoreStruct.statusesLocal.count <= 0 {
                    
                } else {
                    self.tableViewL.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            } else {
                if StoreStruct.statusesFederated.count > 0 {
                    print("scrollfed")
                    if StoreStruct.statusesFederated.count <= 0 {
                        
                    } else {
                        self.tableViewF.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
            
        }
    }
    
    func restoreScroll() {
        DispatchQueue.main.async {
            //            self.tableView.reloadData()
            if (UserDefaults.standard.object(forKey: "savedRowHome1") == nil) {} else {
                if StoreStruct.statusesHome.count > 0 {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: UserDefaults.standard.object(forKey: "savedRowHome1") as! CGFloat), animated: false)
                }
            }
        }
        DispatchQueue.main.async {
            //            self.tableViewL.reloadData()
            if (UserDefaults.standard.object(forKey: "savedRowLocal1") == nil) {} else {
                if StoreStruct.statusesLocal.count > 0 {
                    self.tableViewL.setContentOffset(CGPoint(x: 0, y: UserDefaults.standard.object(forKey: "savedRowLocal1") as! CGFloat), animated: false)
                }
            }
        }
        DispatchQueue.main.async {
            //            self.tableViewF.reloadData()
            if (UserDefaults.standard.object(forKey: "savedRowFed1") == nil) {} else {
                if StoreStruct.statusesFederated.count > 0 {
                    self.tableViewF.setContentOffset(CGPoint(x: 0, y: UserDefaults.standard.object(forKey: "savedRowFed1") as! CGFloat), animated: false)
                }
            }
        }
    }
    
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
    //        var offset = 88
    //        if UIDevice().userInterfaceIdiom == .phone {
    //            switch UIScreen.main.nativeBounds.height {
    //            case 2688:
    //                offset = 88
    //            case 2436, 1792:
    //                offset = 88
    //            default:
    //                offset = 64
    //                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
    //            }
    //        }
    //        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
    //
    //        if scrollDiff > 0 {
    //            // scrolling down
    //            springWithDelay(duration: 1.1, delay: 0, animations: {
    //                self.segmentedControl.frame.size.height = 0
    //                self.tableView.frame = CGRect(x: 0, y: Int(offset + 20), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 25)
    //            })
    //        } else {
    //            // scrolling up
    //            springWithDelay(duration: 1.1, delay: 0, animations: {
    //                self.segmentedControl.frame.size.height = 40
    //                self.tableView.frame = CGRect(x: 0, y: Int(offset + 60), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 65)
    //            })
    //        }
    //        self.previousScrollOffset = scrollView.contentOffset.y
    //    }
    
    
    // MARK: - Segmented Tabs
    
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 3
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        if index == 0 {
            return "Home".localized
        } else if index == 1 {
            return "Local".localized
        } else {
            if (UserDefaults.standard.object(forKey: "segsize") == nil) || (UserDefaults.standard.object(forKey: "segsize") as! Int == 0) {
                return "Federated".localized
            } else {
                return "Fed".localized
            }
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        if (UserDefaults.standard.object(forKey: "seghue1") == nil) || (UserDefaults.standard.object(forKey: "seghue1") as! Int == 0) {
            return [Colours.tabSelected, Colours.tabSelected]
        } else {
            return [Colours.grayLight2, Colours.grayLight2]
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForBounce bounce: SJFluidSegmentedControlBounce) -> [UIColor] {
        if (UserDefaults.standard.object(forKey: "seghue1") == nil) || (UserDefaults.standard.object(forKey: "seghue1") as! Int == 0) {
            return [Colours.tabSelected, Colours.tabSelected]
        } else {
            return [Colours.grayLight2, Colours.grayLight2]
        }
    }
    //backh2
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didChangeFromSegmentAtIndex fromIndex: Int, toSegmentAtIndex toIndex: Int) {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        
        
        if toIndex == 0 {
            
            if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
                crownControl.showCrown()
                crownControl2.hideCrown()
                crownControl3.hideCrown()
            }
            
            if self.countcount1 == 0 {
                self.newUpdatesB1.alpha = 0
                self.newUpdatesB2.alpha = 0
                self.newUpdatesB3.alpha = 0
            } else {
                self.newUpdatesB1.alpha = 1
                self.newUpdatesB2.alpha = 0
                self.newUpdatesB3.alpha = 0
            }
            
            self.currentIndex = 0
            self.tableView.reloadData()
            self.tableView.alpha = 1
            self.tableViewL.alpha = 0
            self.tableViewF.alpha = 0
            if (UserDefaults.standard.object(forKey: "savedRowHome1") == nil) {} else {
                
            }
            
            // stream
            if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
                if self.hStream == false {
                    self.streamDataHome()
                    
                }
            }
        }
        if toIndex == 1 {
            
            if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
                crownControl.hideCrown()
                crownControl2.showCrown()
                crownControl3.hideCrown()
            }
            
            if self.countcount2 == 0 {
                self.newUpdatesB1.alpha = 0
                self.newUpdatesB2.alpha = 0
                self.newUpdatesB3.alpha = 0
            } else {
                self.newUpdatesB1.alpha = 0
                self.newUpdatesB2.alpha = 1
                self.newUpdatesB3.alpha = 0
            }
            
            self.currentIndex = 1
            self.tableView.alpha = 0
            self.tableViewL.alpha = 1
            self.tableViewF.alpha = 0
            
            if StoreStruct.statusesLocal.isEmpty {
                let request = Timelines.public(local: true, range: .default)
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        StoreStruct.statusesLocal = stat + StoreStruct.statusesLocal
                        DispatchQueue.main.async {
                            StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                            self.tableViewL.reloadData()
                            
                        }
                    }
                }
            } else {
                //bbbhere
                self.tableViewL.reloadData()
            }
            
            // stream
            if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
                if self.lStream == false {
                    self.streamDataLocal()
                }
            }
        }
        if toIndex == 2 {
            
            if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {} else {
                crownControl.hideCrown()
                crownControl2.hideCrown()
                crownControl3.showCrown()
            }
            
            if self.countcount3 == 0 {
                self.newUpdatesB1.alpha = 0
                self.newUpdatesB2.alpha = 0
                self.newUpdatesB3.alpha = 0
            } else {
                self.newUpdatesB1.alpha = 0
                self.newUpdatesB2.alpha = 0
                self.newUpdatesB3.alpha = 1
            }
            
            self.currentIndex = 2
            self.tableView.alpha = 0
            self.tableViewL.alpha = 0
            self.tableViewF.alpha = 1
            
            if StoreStruct.statusesFederated.isEmpty {
                let request = Timelines.public(local: false, range: .default)
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        StoreStruct.statusesFederated = stat + StoreStruct.statusesFederated
                        DispatchQueue.main.async {
                            StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                            self.tableViewF.reloadData()
                            
                        }
                    }
                }
            } else {
                ///bbhere
                self.tableViewF.reloadData()
            }
            // stream
            if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
                if self.fStream == false {
                    self.streamDataFed()
                }
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
        segmentedControl.removeFromSuperview()
        tableView.removeFromSuperview()
        tableViewL.removeFromSuperview()
        tableViewF.removeFromSuperview()
        if (UserDefaults.standard.object(forKey: "segsize") == nil) || (UserDefaults.standard.object(forKey: "segsize") as! Int == 0) {
            segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(20), y: CGFloat(offset + 5), width: CGFloat(self.view.bounds.width - 40), height: CGFloat(40)))
            
            segmentedControl.dataSource = self
            if (UserDefaults.standard.object(forKey: "segstyle") == nil) || (UserDefaults.standard.object(forKey: "segstyle") as! Int == 0) {
                segmentedControl.shapeStyle = .roundedRect
            } else {
                segmentedControl.shapeStyle = .liquid
            }
            segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
            segmentedControl.cornerRadius = 12
            segmentedControl.shadowsEnabled = false
            segmentedControl.transitionStyle = .slide
            segmentedControl.delegate = self
            view.addSubview(segmentedControl)
            
            self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell")
            self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2")
            self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellmore")
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 60), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset)
            self.tableView.alpha = 1
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundColor = Colours.white
            self.tableView.separatorColor = Colours.cellQuote
            self.tableView.layer.masksToBounds = true
            self.tableView.estimatedRowHeight = 89
            self.tableView.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableView)
            
            self.tableViewL.register(MainFeedCell.self, forCellReuseIdentifier: "celll")
            self.tableViewL.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2l")
            self.tableViewL.register(SettingsCell.self, forCellReuseIdentifier: "cellmore1")
            self.tableViewL.frame = CGRect(x: 0, y: Int(offset + 60), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset)
            self.tableViewL.alpha = 0
            self.tableViewL.delegate = self
            self.tableViewL.dataSource = self
            self.tableViewL.separatorStyle = .singleLine
            self.tableViewL.backgroundColor = Colours.white
            self.tableViewL.separatorColor = Colours.cellQuote
            self.tableViewL.layer.masksToBounds = true
            self.tableViewL.estimatedRowHeight = 89
            self.tableViewL.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableViewL)
            
            self.tableViewF.register(MainFeedCell.self, forCellReuseIdentifier: "cellf")
            self.tableViewF.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2f")
            self.tableViewF.register(SettingsCell.self, forCellReuseIdentifier: "cellmore2")
            self.tableViewF.frame = CGRect(x: 0, y: Int(offset + 60), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset)
            self.tableViewF.alpha = 0
            self.tableViewF.delegate = self
            self.tableViewF.dataSource = self
            self.tableViewF.separatorStyle = .singleLine
            self.tableViewF.backgroundColor = Colours.white
            self.tableViewF.separatorColor = Colours.cellQuote
            self.tableViewF.layer.masksToBounds = true
            self.tableViewF.estimatedRowHeight = 89
            self.tableViewF.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableViewF)
            self.loadLoadLoad()
        } else {
            if UIApplication.shared.isSplitOrSlideOver {
                segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(self.view.bounds.width/2 - 120), y: CGFloat(30), width: CGFloat(240), height: CGFloat(40)))
            } else {
                segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: CGFloat(self.view.bounds.width/2 - 120), y: CGFloat(newoff), width: CGFloat(240), height: CGFloat(40)))
            }
            segmentedControl.dataSource = self
            if (UserDefaults.standard.object(forKey: "segstyle") == nil) || (UserDefaults.standard.object(forKey: "segstyle") as! Int == 0) {
                segmentedControl.shapeStyle = .roundedRect
            } else {
                segmentedControl.shapeStyle = .liquid
            }
            segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
            segmentedControl.cornerRadius = 12
            segmentedControl.shadowsEnabled = false
            segmentedControl.transitionStyle = .slide
            segmentedControl.delegate = self
            self.navigationController?.view.addSubview(segmentedControl)
            
            self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell")
            self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2")
            self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellmore")
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 10), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset)
            self.tableView.alpha = 1
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundColor = Colours.white
            self.tableView.separatorColor = Colours.cellQuote
            self.tableView.layer.masksToBounds = true
            self.tableView.estimatedRowHeight = 89
            self.tableView.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableView)
            
            self.tableViewL.register(MainFeedCell.self, forCellReuseIdentifier: "cell")
            self.tableViewL.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2")
            self.tableViewL.register(SettingsCell.self, forCellReuseIdentifier: "cellmore1")
            self.tableViewL.frame = CGRect(x: 0, y: Int(offset + 10), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset)
            self.tableViewL.alpha = 0
            self.tableViewL.delegate = self
            self.tableViewL.dataSource = self
            self.tableViewL.separatorStyle = .singleLine
            self.tableViewL.backgroundColor = Colours.white
            self.tableViewL.separatorColor = Colours.cellQuote
            self.tableViewL.layer.masksToBounds = true
            self.tableViewL.estimatedRowHeight = 89
            self.tableViewL.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableViewL)
            
            self.tableViewF.register(MainFeedCell.self, forCellReuseIdentifier: "cell")
            self.tableViewF.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2")
            self.tableViewF.register(SettingsCell.self, forCellReuseIdentifier: "cellmore2")
            self.tableViewF.frame = CGRect(x: 0, y: Int(offset + 10), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset)
            self.tableViewF.alpha = 0
            self.tableViewF.delegate = self
            self.tableViewF.dataSource = self
            self.tableViewF.separatorStyle = .singleLine
            self.tableViewF.backgroundColor = Colours.white
            self.tableViewF.separatorColor = Colours.cellQuote
            self.tableViewF.layer.masksToBounds = true
            self.tableViewF.estimatedRowHeight = 89
            self.tableViewF.rowHeight = UITableView.automaticDimension
            self.view.addSubview(self.tableViewF)
            self.loadLoadLoad()
        }
    }

    // MARK: - Crown
    
    @objc func activateCrown() {
        self.crownScroll()
        self.crownScroll2()
        self.crownScroll3()
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
        crownControl.showCrown()
    }
    
    func crownScroll2() {
        var attributes = CrownAttributes(scrollView: self.tableViewL, scrollAxis: .vertical)
        attributes.backgroundStyle.content = .gradient(gradient: .init(colors: [UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0), UIColor(red: 20/255.0, green: 20/255.0, blue: 29/255.0, alpha: 1.0)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.backgroundStyle.border = .value(color: UIColor(red: 34/255.0, green: 34/255.0, blue: 35/255.0, alpha: 1.0), width: 1)
        attributes.foregroundStyle.content = .gradient(gradient: .init(colors: [Colours.tabSelected, Colours.tabSelected], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.foregroundStyle.border = .value(color: UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0), width: 0)
        attributes.feedback.leading.backgroundFlash = .active(color: .clear, fadeDuration: 0)
        attributes.feedback.trailing.backgroundFlash = .active(color: .clear, fadeDuration: 0)
        let verticalConstraint = CrownAttributes.AxisConstraint(crownEdge: .bottom, anchorView: self.tableViewL, anchorViewEdge: .bottom, offset: -50)
        let horizontalConstraint = CrownAttributes.AxisConstraint(crownEdge: .trailing, anchorView: self.tableViewL, anchorViewEdge: .trailing, offset: -50)
        crownControl2 = CrownControl(attributes: attributes, delegate: self)
        crownControl2.layout(in: view, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
        crownControl2.hideCrown()
    }
    
    func crownScroll3() {
        var attributes = CrownAttributes(scrollView: self.tableViewF, scrollAxis: .vertical)
        attributes.backgroundStyle.content = .gradient(gradient: .init(colors: [UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0), UIColor(red: 20/255.0, green: 20/255.0, blue: 29/255.0, alpha: 1.0)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.backgroundStyle.border = .value(color: UIColor(red: 34/255.0, green: 34/255.0, blue: 35/255.0, alpha: 1.0), width: 1)
        attributes.foregroundStyle.content = .gradient(gradient: .init(colors: [Colours.tabSelected, Colours.tabSelected], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.foregroundStyle.border = .value(color: UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0), width: 0)
        attributes.feedback.leading.backgroundFlash = .active(color: .clear, fadeDuration: 0)
        attributes.feedback.trailing.backgroundFlash = .active(color: .clear, fadeDuration: 0)
        let verticalConstraint = CrownAttributes.AxisConstraint(crownEdge: .bottom, anchorView: self.tableViewF, anchorViewEdge: .bottom, offset: -50)
        let horizontalConstraint = CrownAttributes.AxisConstraint(crownEdge: .trailing, anchorView: self.tableViewF, anchorViewEdge: .trailing, offset: -50)
        crownControl3 = CrownControl(attributes: attributes, delegate: self)
        crownControl3.layout(in: view, horizontalConstaint: horizontalConstraint, verticalConstraint: verticalConstraint)
        crownControl3.hideCrown()
    }
    
    // MARK: Stream
    
    func streamDataHome() {
        if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
            self.hStream = true
            
            var sss = StoreStruct.client.baseURL.replacingOccurrences(of: "https", with: "wss")
            sss = sss.replacingOccurrences(of: "http", with: "wss")
            
            socket = WebSocket(url: URL(string: "\(sss)/api/v1/streaming?access_token=\(StoreStruct.shared.currentInstance.accessToken)&stream=user")!)
            socket.onConnect = {
                print("websocket is connected")
            }
            //websocketDidDisconnect
            socket.onDisconnect = { (error: Error?) in
                print("websocket is disconnected")
            }
            //websocketDidReceiveMessage
            socket.onText = { (text: String) in
                print("got some text: \(text)")
                
                let data0 = text.data(using: .utf8)!
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data0, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    let re = jsonResult?["payload"]
                    let te = SSEvent.init(type: "update", data: re as? String ?? "")
                    let data = te.data.data(using: .utf8)!
                    guard let model = try? Status.decode(data: data) else {
                        return
                    }
                    self.hMod.append(model)
                    if self.currentIndex == 0 {
                        DispatchQueue.main.async {
                            //self.tableView.reloadData()
                            
                            
                            if self.tableView.contentOffset.y == 0 {
                                StoreStruct.statusesHome = self.hMod.reversed() + StoreStruct.statusesHome
                                StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                                
                                if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                    self.newUpdatesB1.setTitle("\(self.hMod.count)  ", for: .normal)
                                    self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                    //                                self.newUpdatesB1.transform = CGAffineTransform(translationX: 120, y: 0)
                                    springWithDelay(duration: 0.5, delay: 0, animations: {
                                        self.newUpdatesB1.alpha = 1
                                        self.newUpdatesB1.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                        //                                    self.newUpdatesB1.transform = CGAffineTransform(translationX: 0, y: 0)
                                    })
                                    self.countcount1 = self.hMod.count
                                    
                                    UIView.setAnimationsEnabled(false)
                                    self.tableView.reloadData()
                                    self.refreshControl.endRefreshing()
                                    self.tableView.scrollToRow(at: IndexPath(row: self.hMod.count - 1, section: 0), at: .top, animated: false)
                                    UIView.setAnimationsEnabled(true)
                                } else {
                                    
                                    self.tableView.reloadData()
                                    self.refreshControl.endRefreshing()
                                    
                                }
                                
                                self.hMod = []
                            }
                            
                        }
                    }
                } catch  {
                    print("failfail")
                    return
                }
            }
            //websocketDidReceiveData
            socket.onData = { (data: Data) in
                print("got some data: \(data.count)")
            }
            socket.connect()
        }
    }
    
    func streamDataLocal() {
        if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
            self.lStream = true
            
            var sss = StoreStruct.client.baseURL.replacingOccurrences(of: "https", with: "wss")
            sss = sss.replacingOccurrences(of: "http", with: "wss")
            lsocket = WebSocket(url: URL(string: "\(sss)/api/v1/streaming?access_token=\(StoreStruct.shared.currentInstance.accessToken)&stream=public/local")!)
            lsocket.onConnect = {
                print("websocket is connected")
            }
            //websocketDidDisconnect
            lsocket.onDisconnect = { (error: Error?) in
                print("websocket is disconnected")
            }
            //websocketDidReceiveMessage
            lsocket.onText = { (text: String) in
                print("got some text: \(text)")
                
                let data0 = text.data(using: .utf8)!
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data0, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    let re = jsonResult?["payload"]
                    let te = SSEvent.init(type: "update", data: re as? String ?? "")
                    let data = te.data.data(using: .utf8)!
                    guard let model = try? Status.decode(data: data) else {
                        return
                    }
                    self.lMod.append(model)
                    if self.currentIndex == 1 {
                        DispatchQueue.main.async {
                            //self.tableView.reloadData()
                            
                            
                            if self.tableViewL.contentOffset.y == 0 {
                                StoreStruct.statusesLocal = self.lMod.reversed() + StoreStruct.statusesLocal
                                StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
                                
                                
                                if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                    self.newUpdatesB2.setTitle("\(self.lMod.count)  ", for: .normal)
                                    //                                self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                                    self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                    springWithDelay(duration: 0.5, delay: 0, animations: {
                                        self.newUpdatesB2.alpha = 1
                                        self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                        //                                    self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                                    })
                                    self.countcount2 = self.lMod.count
                                    
                                    UIView.setAnimationsEnabled(false)
                                    self.tableViewL.reloadData()
                                    self.refreshControl.endRefreshing()
                                    self.tableViewL.scrollToRow(at: IndexPath(row: self.lMod.count - 1, section: 0), at: .top, animated: false)
                                    UIView.setAnimationsEnabled(true)
                                } else {
                                    
                                    self.tableViewL.reloadData()
                                    self.refreshControl.endRefreshing()
                                    
                                }
                                self.lMod = []
                            }
                            
                        }
                    }
                } catch {
                    print("failfail")
                    return
                }
            }
            //websocketDidReceiveData
            lsocket.onData = { (data: Data) in
                print("got some data: \(data.count)")
            }
            lsocket.connect()
        }
    }
    
    func streamDataFed() {
        if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
            self.fStream = true
            
            var sss = StoreStruct.client.baseURL.replacingOccurrences(of: "https", with: "wss")
            sss = sss.replacingOccurrences(of: "http", with: "wss")
            fsocket = WebSocket(url: URL(string: "\(sss)/api/v1/streaming?access_token=\(StoreStruct.shared.currentInstance.accessToken)&stream=public")!)
            fsocket.onConnect = {
                print("websocket is connected")
            }
            //websocketDidDisconnect
            fsocket.onDisconnect = { (error: Error?) in
                print("websocket is disconnected")
            }
            //websocketDidReceiveMessage
            fsocket.onText = { (text: String) in
                print("got some text: \(text)")
                
                let data0 = text.data(using: .utf8)!
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data0, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    let re = jsonResult?["payload"]
                    let te = SSEvent.init(type: "update", data: re as? String ?? "")
                    let data = te.data.data(using: .utf8)!
                    guard let model = try? Status.decode(data: data) else {
                        return
                    }
                    
                    self.fMod.append(model)
                    
                    if self.currentIndex == 2 {
                        
                        
                        DispatchQueue.main.async {
                            
                            
                            if self.tableViewF.contentOffset.y == 0 {
                                StoreStruct.statusesFederated = self.fMod.reversed() + StoreStruct.statusesFederated
                                StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
                                
                                
                                if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                    
                                    self.newUpdatesB3.setTitle("\(self.fMod.count)  ", for: .normal)
                                    //                                            self.newUpdatesB3.transform = CGAffineTransform(translationX: 120, y: 0)
                                    self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                    springWithDelay(duration: 0.5, delay: 0, animations: {
                                        self.newUpdatesB3.alpha = 1
                                        self.newUpdatesB3.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                        //                                                self.newUpdatesB3.transform = CGAffineTransform(translationX: 0, y: 0)
                                    })
                                    self.countcount3 = self.fMod.count
                                    
                                    UIView.setAnimationsEnabled(false)
                                    self.tableViewF.reloadData()
                                    self.refreshControl.endRefreshing()
                                    self.tableViewF.scrollToRow(at: IndexPath(row: self.fMod.count - 1, section: 0), at: .top, animated: false)
                                    UIView.setAnimationsEnabled(true)
                                    
                                } else {
                                    
                                    self.tableViewF.reloadData()
                                    self.refreshControl.endRefreshing()
                                    
                                }
                                
                                self.fMod = []
                            }
                            
                            
                        }
                    }
                } catch let error as Error {
                    print(error)
                    print("failfail")
                    return
                }
                
            }
            //websocketDidReceiveData
            fsocket.onData = { (data: Data) in
                print("got some data: \(data.count)")
            }
            fsocket.connect()
        }
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if scrollView.contentOffset.y == 0 {
    //            if self.currentIndex == 0 {
    //
    ////                if self.tableView.contentOffset.y == 0 {
    ////                    StoreStruct.statusesHome = self.hMod.reversed() + StoreStruct.statusesHome
    ////                    StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
    ////                    self.tableView.reloadData()
    ////                    self.hMod = []
    ////                }
    //            } else if self.currentIndex == 1 {
    //
    //                if self.tableViewL.contentOffset.y == 0 {
    //                    StoreStruct.statusesLocal = self.lMod.reversed() + StoreStruct.statusesLocal
    //                    StoreStruct.statusesLocal = StoreStruct.statusesLocal.removeDuplicates()
    //                    self.tableViewL.reloadData()
    //                    self.lMod = []
    //                }
    //            } else {
    //
    //                if self.tableViewF.contentOffset.y == 0 {
    //                    StoreStruct.statusesFederated = self.fMod.reversed() + StoreStruct.statusesFederated
    //                    StoreStruct.statusesFederated = StoreStruct.statusesFederated.removeDuplicates()
    //                    self.tableViewF.reloadData()
    //                    self.fMod = []
    //                }
    //            }
    //        }
    //    }
    
 
    
    // MARK: - Confetti
    
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
    
}

