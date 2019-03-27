//
//  DetailViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import StatusAlert
import SAConfettiView
import AVKit
import AVFoundation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SKPhotoBrowserDelegate, UIViewControllerPreviewingDelegate {

    var safariVC: SFSafariViewController?
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    var mainStatus: [Status] = []
    var allPrevious: [Status] = []
    var allReplies: [Status] = []
    var isPeeking = false
    var replyButton = UIButton()
    var likeButton = UIButton()
    var boostButton = UIButton()
    var moreButton = UIButton()
    var splitButton = UIButton()
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }
        guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
        let detailVC = DetailViewController()
        if indexPath.section == 0 {
            detailVC.mainStatus.append(self.allPrevious[indexPath.row])
        } else if indexPath.section == 1 {
            detailVC.mainStatus.append(self.mainStatus[0])
        } else if indexPath.section == 5 {
            detailVC.mainStatus.append(self.allReplies[indexPath.row])
        }
        detailVC.isPeeking = true
        previewingContext.sourceRect = cell.frame
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }

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

    @objc func goLists() {
        DispatchQueue.main.async {
            let controller = ListViewController()
            self.navigationController?.pushViewController(controller, animated: true)
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
    
    @objc func didTouchSplit() {
        
        Alertift.actionSheet(title: "Split Ratio", message: nil)
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("25 : 75".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(1, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.25
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/4)
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("30 : 70".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(2, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.3
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/10)*3
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("35 : 65".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(3, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.35
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/20)*7
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("40 : 60".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(4, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.4
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/5)*2
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("45 : 55".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(5, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.45
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/20)*9
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("50 : 50".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(0, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.5
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = minimumWidth/2
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("55 : 45".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(6, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.55
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/20)*11
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("60 : 40".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(7, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.6
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/5)*4
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("65 : 35".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(8, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.65
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/20)*13
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("70 : 30".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(9, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.7
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/10)*7
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.default("75 : 25".localized), image: nil) { (action, ind) in
                print(action, ind)
                UserDefaults.standard.set(10, forKey: "splitra")
                self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.75
                let minimumWidth = min(self.splitViewController?.view.bounds.width ?? 0, self.splitViewController?.view.bounds.height ?? 0)
                self.splitViewController?.minimumPrimaryColumnWidth = (minimumWidth/4)*3
                self.splitViewController?.maximumPrimaryColumnWidth = minimumWidth
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .popover(anchorView: self.splitButton)
            .show(on: self)
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

        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:

            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(offset)).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            
            splitButton.backgroundColor = Colours.white
            splitButton.layer.masksToBounds = true
            splitButton.setImage(UIImage(named: "splitRatio")?.maskWithColor(color: Colours.grayLight2), for: .normal)
            splitButton.addTarget(self, action: #selector(self.didTouchSplit), for: .touchUpInside)
            self.view.addSubview(self.splitButton)
            
            self.splitButton.translatesAutoresizingMaskIntoConstraints = false
            self.splitButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
            self.splitButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
            self.splitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            self.splitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 9).isActive = true
            
            if self.mainStatus.isEmpty {
                
                self.tableView.alpha = 0
                let introLogo = UIImageView()
                introLogo.contentMode = .scaleAspectFit
                self.view.addSubview(introLogo)
                introLogo.translatesAutoresizingMaskIntoConstraints = false
                introLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                introLogo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                introLogo.widthAnchor.constraint(equalToConstant: CGFloat(120)).isActive = true
                introLogo.heightAnchor.constraint(equalToConstant: CGFloat(120)).isActive = true
                introLogo.image = UIImage(named: "launcgLogo")?.maskWithColor(color: Colours.tabUnselected.withAlphaComponent(0.2))

            } else {
                
                self.tableView.alpha = 1
                replyButton.backgroundColor = Colours.white
                likeButton.backgroundColor = Colours.white
                boostButton.backgroundColor = Colours.white
                moreButton.backgroundColor = Colours.white

                replyButton.layer.cornerRadius = 20
                replyButton.layer.masksToBounds = true
                likeButton.layer.cornerRadius = 20
                likeButton.layer.masksToBounds = true
                boostButton.layer.cornerRadius = 20
                boostButton.layer.masksToBounds = true
                moreButton.layer.cornerRadius = 20
                moreButton.layer.masksToBounds = true

                replyButton.setImage(UIImage(named: "reply0"), for: .normal)
                moreButton.setImage(UIImage(named: "more2"), for: .normal)
                likeButton.setImage(UIImage(named: "like0"), for: .normal)
                boostButton.setImage(UIImage(named: "boost0"), for: .normal)

                replyButton.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                likeButton.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                boostButton.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                moreButton.addTarget(self, action: #selector(self.didTouchMore), for: .touchUpInside)

                self.view.addSubview(self.moreButton)
                self.view.addSubview(self.boostButton)
                self.view.addSubview(self.likeButton)
                self.view.addSubview(self.replyButton)

                self.moreButton.translatesAutoresizingMaskIntoConstraints = false
                self.moreButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.moreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.moreButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                self.moreButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 5).isActive = true

                self.boostButton.translatesAutoresizingMaskIntoConstraints = false
                self.boostButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.boostButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.boostButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -85).isActive = true
                self.boostButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 5).isActive = true

                self.likeButton.translatesAutoresizingMaskIntoConstraints = false
                self.likeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.likeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.likeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -150).isActive = true
                self.likeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 5).isActive = true

                self.replyButton.translatesAutoresizingMaskIntoConstraints = false
                self.replyButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.replyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.replyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -215).isActive = true
                self.replyButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + 5).isActive = true

            }
        default:
            print("nothing")
        }

        if self.mainStatus.isEmpty {} else {
            self.refDetailCount()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    @objc func tappedPoll() {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? PollCell {

            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
            }

            if let poll = self.mainStatus[0].reblog?.poll ?? self.mainStatus[0].poll {
                if self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id == StoreStruct.currentUser.id {
                    Alertift.actionSheet(title: "You can't vote on your own poll", message: nil)
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
                        .popover(anchorView: cell)
                        .show(on: self)
                } else {
                if poll.expired {
                    Alertift.actionSheet(title: "This poll is now closed", message: nil)
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
                        .popover(anchorView: cell)
                        .show(on: self)
                } else {
                    Alertift.actionSheet()
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark)
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Vote for \(StoreStruct.currentPollSelectionTitle)"), image: nil) { (action, ind) in
                            print(action, ind)

                            if let poll = self.mainStatus[0].reblog?.poll ?? self.mainStatus[0].poll {
                                let request = Polls.vote(id: poll.id, choices: StoreStruct.currentPollSelection)
                                StoreStruct.client.run(request) { (statuses) in
                                    DispatchQueue.main.async {
                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                            let notification = UINotificationFeedbackGenerator()
                                            notification.notificationOccurred(.success)
                                        }

                                        self.refDetailCountPoll()

                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "listbig")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Voted"
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = StoreStruct.currentPollSelectionTitle
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
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
                        .popover(anchorView: cell)
                        .show(on: self)
                }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//        self.mainStatus = []
//        self.allPrevious = []
//        self.allReplies = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //NotificationCenter.default.addObserver(self, selector: #selector(self.goLists), name: NSNotification.Name(rawValue: "goLists"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCont), name: NSNotification.Name(rawValue: "refreshCont"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "splitload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tappedPoll), name: NSNotification.Name(rawValue: "tappedPoll"), object: nil)

        self.view.backgroundColor = Colours.white
        splitViewController?.view.backgroundColor = Colours.cellQuote

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }


        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = Colours.white
        UINavigationBar.appearance().barTintColor = Colours.black
        UINavigationBar.appearance().tintColor = Colours.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]


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
            offset = 0
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

        self.tableView.register(DetailCell.self, forCellReuseIdentifier: "cell7")
        self.tableView.register(DetailCellImage.self, forCellReuseIdentifier: "cell70")
        self.tableView.register(ActionButtonCell.self, forCellReuseIdentifier: "cell10")
        self.tableView.register(ActionButtonCell2.self, forCellReuseIdentifier: "cell109")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell8")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell800")
        self.tableView.register(RepliesCell.self, forCellReuseIdentifier: "cell80")
        self.tableView.register(RepliesCell.self, forCellReuseIdentifier: "cell8000")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell9")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell900")
        self.tableView.register(RepliesCellImage.self, forCellReuseIdentifier: "cell90")
        self.tableView.register(PollCell.self, forCellReuseIdentifier: "PollCell")
        self.tableView.register(DetailCellLink.self, forCellReuseIdentifier: "DetailCellLink0")
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
        
        
        if self.mainStatus.isEmpty {} else {
            
            self.loadLoadLoad()
            
            let request = Statuses.context(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    self.allPrevious = (stat.ancestors)
                    self.allReplies = (stat.descendants)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.allPrevious.count == 0 {} else {
                            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
//                            self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y + 1), animated: false)
                        }
                    }
                }
            }
        }


        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: self.tableView)
        }
    }



    // Table stuff

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 0
        } else if section == 2 {
            return 0
        } else if section == 3 {
            return 0
        } else if section == 4 {
            return 0
        } else {
            if self.allReplies.isEmpty {
                return 0
            } else {
                return 40
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 8, width: self.view.bounds.width, height: 30)
        if section == 0 {
            return nil
        } else if section == 1 {
            return nil
        } else if section == 2 {
            return nil
        } else if section == 3 {
            return nil
        } else if section == 4 {
            return nil
        } else if section == 5 {
            if self.allReplies.isEmpty {
                return nil
            } else {
                let repC = self.mainStatus[0].repliesCount
                if repC == 0 || repC == 1 {
                    title.text = "1 Reply".localized
                } else {
                    title.text = "\(repC) Replies".localized
                }
            }
        }
        title.textColor = Colours.grayDark2
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white

        return vw
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.allPrevious.count
        } else if section == 1 {
            if self.mainStatus.isEmpty {
                return 0
            } else {
                return 1
            }
        } else if section == 2 {
            if self.mainStatus.isEmpty {
                return 0
            } else {
                if self.mainStatus[0].reblog?.poll ?? self.mainStatus[0].poll != nil {
                    return 1
                } else {
                    return 0
                }
            }
        } else if section == 3 {
            if self.mainStatus.isEmpty {
                return 0
            } else {
                if (UserDefaults.standard.object(forKey: "linkcards") == nil) || (UserDefaults.standard.object(forKey: "linkcards") as! Int == 0) {
                    if self.mainStatus[0].reblog?.card?.authorUrl != nil || self.mainStatus[0].card?.authorUrl != nil {
                        return 1
                    } else {
                        return 0
                    }
                } else {
                    return 0
                }
            }
        } else if section == 4 {
            return 1
        } else {
            return self.allReplies.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            if indexPath.section == 4 {
                return 0
            }
        default:
            print("nothing")
        }
        if indexPath.section == 2 {
            if self.mainStatus.isEmpty {
                return 0
            } else {
                if self.mainStatus[0].reblog?.poll ?? self.mainStatus[0].poll != nil {
                    return CGFloat(StoreStruct.pollHeight)
                } else {
                    return 0
                }
            }
        }
        if indexPath.section == 3 {
            if self.mainStatus.isEmpty {
                return 0
            } else {
                if (UserDefaults.standard.object(forKey: "linkcards") == nil) || (UserDefaults.standard.object(forKey: "linkcards") as! Int == 0) {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
            }
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {


            // All previous

            if self.allPrevious.isEmpty {

                let cell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! MainFeedCell
                cell.delegate = self
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileP), for: .touchUpInside)
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                cell.toot.textColor = Colours.black
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
                                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                switch (deviceIdiom) {
                                case .phone :
                                    self.navigationController?.pushViewController(controller, animated: true)
                                case .pad:
                                    if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                        if StoreStruct.currentPage == 0 {
                                            nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                        if StoreStruct.currentPage == 1 {
                                            nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                        if StoreStruct.currentPage == 2 {
                                            nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                default:
                                    print("nothing")
                                }
                            }
                        }
                    }
                }
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell

            } else {

                if self.allPrevious[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! MainFeedCell
                    cell.delegate = self
                    cell.configure(self.allPrevious[indexPath.row])
                    cell.profileImageView.tag = indexPath.row
                    cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileP), for: .touchUpInside)
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                    cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                    cell.toot.textColor = Colours.black


                    cell.rep1.tag = indexPath.row
                    cell.like1.tag = indexPath.row
                    cell.boost1.tag = indexPath.row
                    cell.rep1.addTarget(self, action: #selector(self.didTouchPreRep), for: .touchUpInside)
                    cell.like1.addTarget(self, action: #selector(self.didTouchPreLike), for: .touchUpInside)
                    cell.boost1.addTarget(self, action: #selector(self.didTouchPreBoost), for: .touchUpInside)

                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }

                        var newString = string
                        for z2 in self.allPrevious[indexPath.row].mentions {
                            if z2.acct.contains(string) {
                                newString = z2.id
                            }
                        }


                        let controller = ThirdViewController()
                        if newString == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                        
                                    controller.userIDtoUse = newString
//                                    DispatchQueue.main.async {
                                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                        switch (deviceIdiom) {
                                        case .phone :
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        case .pad:
                                            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                if StoreStruct.currentPage == 0 {
                                                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 1 {
                                                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 2 {
                                                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                            }
                                        default:
                                            print("nothing")
                                        }
//                                    }
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
                                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                    switch (deviceIdiom) {
                                    case .phone :
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    case .pad:
                                        if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                            if StoreStruct.currentPage == 0 {
                                                nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 1 {
                                                nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 2 {
                                                nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }
                                    default:
                                        print("nothing")
                                    }
                                }
                            }
                        }
                    }
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell9", for: indexPath) as! MainFeedCellImage
                    cell.delegate = self
                    cell.configure(self.allPrevious[indexPath.row])
                    cell.profileImageView.tag = indexPath.row
                    cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileP), for: .touchUpInside)
                    cell.mainImageView.addTarget(self, action: #selector(self.tappedImagePrev(_:)), for: .touchUpInside)
                    cell.mainImageView.tag = indexPath.row
                    cell.smallImage1.addTarget(self, action: #selector(self.tappedImagePrevS1(_:)), for: .touchUpInside)
                    cell.smallImage2.addTarget(self, action: #selector(self.tappedImagePrevS2(_:)), for: .touchUpInside)
                    cell.smallImage3.addTarget(self, action: #selector(self.tappedImagePrevS3(_:)), for: .touchUpInside)
                    cell.smallImage4.addTarget(self, action: #selector(self.tappedImagePrevS4(_:)), for: .touchUpInside)
                    cell.smallImage1.tag = indexPath.row
                    cell.smallImage2.tag = indexPath.row
                    cell.smallImage3.tag = indexPath.row
                    cell.smallImage4.tag = indexPath.row

                    cell.rep1.tag = indexPath.row
                    cell.like1.tag = indexPath.row
                    cell.boost1.tag = indexPath.row
                    cell.rep1.addTarget(self, action: #selector(self.didTouchPreRep), for: .touchUpInside)
                    cell.like1.addTarget(self, action: #selector(self.didTouchPreLike), for: .touchUpInside)
                    cell.boost1.addTarget(self, action: #selector(self.didTouchPreBoost), for: .touchUpInside)

                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                    cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                    cell.toot.textColor = Colours.black
                    cell.mainImageView.backgroundColor = Colours.white
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }

                        var newString = string
                        for z2 in self.allPrevious[indexPath.row].mentions {
                            if z2.acct.contains(string) {
                                newString = z2.id
                            }
                        }


                        let controller = ThirdViewController()
                        if newString == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                                    controller.userIDtoUse = newString
//                                    DispatchQueue.main.async {
                                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                        switch (deviceIdiom) {
                                        case .phone :
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        case .pad:
                                            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                if StoreStruct.currentPage == 0 {
                                                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 1 {
                                                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 2 {
                                                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                            }
                                        default:
                                            print("nothing")
                                        }
//                                    }
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
                                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                    switch (deviceIdiom) {
                                    case .phone :
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    case .pad:
                                        if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                            if StoreStruct.currentPage == 0 {
                                                nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 1 {
                                                nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 2 {
                                                nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }
                                    default:
                                        print("nothing")
                                    }
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






        } else if indexPath.section == 1 {

            print("testhtml")
            print(self.mainStatus[0].content)

            // Main status


            if self.mainStatus[indexPath.row].reblog?.mediaAttachments.isEmpty ?? self.mainStatus[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! DetailCell
                cell.configure(self.mainStatus[0])
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileM), for: .touchUpInside)
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                cell.toot.textColor = Colours.black
                cell.fromClient.textColor = Colours.black.withAlphaComponent(0.6)
                cell.faves.titleLabel?.textColor = Colours.tabSelected
                cell.faves.setTitleColor(Colours.tabSelected, for: .normal)
                cell.faves.addTarget(self, action: #selector(self.didTouchFaves), for: .touchUpInside)

                cell.toot.handleMentionTap { (string) in
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let selection = UISelectionFeedbackGenerator()
                        selection.selectionChanged()
                    }

                    var newString = string
                    for z2 in self.mainStatus[0].mentions {
                        if z2.acct.contains(string) {
                            newString = z2.id
                        }
                    }


                    let controller = ThirdViewController()
                    if newString == StoreStruct.currentUser.username {} else {
                        controller.fromOtherUser = true
                    }
                                controller.userIDtoUse = newString
//                                DispatchQueue.main.async {
                                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                    switch (deviceIdiom) {
                                    case .phone :
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    case .pad:
                                        if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                            if StoreStruct.currentPage == 0 {
                                                nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 1 {
                                                nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 2 {
                                                nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }
                                    default:
                                        print("nothing")
                                    }
//                                }
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
                                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                switch (deviceIdiom) {
                                case .phone :
                                    self.navigationController?.pushViewController(controller, animated: true)
                                case .pad:
                                    if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                        if StoreStruct.currentPage == 0 {
                                            nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                        if StoreStruct.currentPage == 1 {
                                            nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                        if StoreStruct.currentPage == 2 {
                                            nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                default:
                                    print("nothing")
                                }
                            }
                        }
                    }
                }
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell70", for: indexPath) as! DetailCellImage
                cell.configure(self.mainStatus[0])
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileM), for: .touchUpInside)
                cell.mainImageView.addTarget(self, action: #selector(self.tappedImageDetail(_:)), for: .touchUpInside)
                cell.smallImage1.addTarget(self, action: #selector(self.tappedImageDetailS1(_:)), for: .touchUpInside)
                cell.smallImage2.addTarget(self, action: #selector(self.tappedImageDetailS2(_:)), for: .touchUpInside)
                cell.smallImage3.addTarget(self, action: #selector(self.tappedImageDetailS3(_:)), for: .touchUpInside)
                cell.smallImage4.addTarget(self, action: #selector(self.tappedImageDetailS4(_:)), for: .touchUpInside)
                cell.mainImageView.tag = indexPath.row
                cell.smallImage1.tag = indexPath.row
                cell.smallImage2.tag = indexPath.row
                cell.smallImage3.tag = indexPath.row
                cell.smallImage4.tag = indexPath.row
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                cell.toot.textColor = Colours.black
                cell.fromClient.textColor = Colours.black.withAlphaComponent(0.6)
                cell.faves.titleLabel?.textColor = Colours.tabSelected
                cell.faves.setTitleColor(Colours.tabSelected, for: .normal)
                cell.faves.addTarget(self, action: #selector(self.didTouchFaves), for: .touchUpInside)
                cell.mainImageView.backgroundColor = Colours.white

                cell.toot.handleMentionTap { (string) in
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let selection = UISelectionFeedbackGenerator()
                        selection.selectionChanged()
                    }

                    var newString = string
                    for z2 in self.mainStatus[0].mentions {
                        if z2.acct.contains(string) {
                            newString = z2.id
                        }
                    }


                    let controller = ThirdViewController()
                    if newString == StoreStruct.currentUser.username {} else {
                        controller.fromOtherUser = true
                    }
                                controller.userIDtoUse = newString
//                                DispatchQueue.main.async {
                                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                    switch (deviceIdiom) {
                                    case .phone :
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    case .pad:
                                        if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                            if StoreStruct.currentPage == 0 {
                                                nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 1 {
                                                nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 2 {
                                                nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }
                                    default:
                                        print("nothing")
                                    }
//                                }
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
                                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                switch (deviceIdiom) {
                                case .phone :
                                    self.navigationController?.pushViewController(controller, animated: true)
                                case .pad:
                                    if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                        if StoreStruct.currentPage == 0 {
                                            nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                        if StoreStruct.currentPage == 1 {
                                            nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                        if StoreStruct.currentPage == 2 {
                                            nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                default:
                                    print("nothing")
                                }
                            }
                        }
                    }
                }
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }







        } else if indexPath.section == 2 {

            // insert poll
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath) as! PollCell
            if let poll = self.mainStatus[0].reblog?.poll ?? self.mainStatus[0].poll {
                cell.configure(thePoll: poll, theOptions: poll.options)
            }
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell

        } else if indexPath.section == 3 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCellLink\(indexPath.row)", for: indexPath) as! DetailCellLink
            if self.mainStatus[0].reblog?.card?.authorUrl != nil || self.mainStatus[0].card?.authorUrl != nil {
                cell.configure(self.mainStatus[0].reblog?.card ?? self.mainStatus[0].card!)
            }
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell

        } else if indexPath.section == 4 {

            // Action buttons

            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .pad:

                let cell = tableView.dequeueReusableCell(withIdentifier: "cell10", for: indexPath) as! ActionButtonCell
                cell.replyButton.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                cell.likeButton.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                cell.boostButton.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                cell.moreButton.addTarget(self, action: #selector(self.didTouchMore), for: .touchUpInside)
                cell.replyButton.tag = indexPath.row
                cell.likeButton.tag = indexPath.row
                cell.boostButton.tag = indexPath.row
                cell.moreButton.tag = indexPath.row
                cell.replyButton.alpha = 0
                cell.likeButton.alpha = 0
                cell.boostButton.alpha = 0
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell

            default:



                if self.mainStatus.isEmpty {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell10", for: indexPath) as! ActionButtonCell
                    cell.replyButton.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                    cell.likeButton.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                    cell.boostButton.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                    cell.moreButton.addTarget(self, action: #selector(self.didTouchMore), for: .touchUpInside)
                    cell.replyButton.tag = indexPath.row
                    cell.likeButton.tag = indexPath.row
                    cell.boostButton.tag = indexPath.row
                    cell.moreButton.tag = indexPath.row
                    cell.backgroundColor = Colours.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    return cell

                } else {

                    if self.mainStatus[0].visibility == .direct {


                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell109", for: indexPath) as! ActionButtonCell2
                        cell.configure(mainStatus: self.mainStatus[0])
                        cell.replyButton.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                        cell.likeButton.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                        cell.moreButton.addTarget(self, action: #selector(self.didTouchMore), for: .touchUpInside)
                        cell.replyButton.tag = indexPath.row
                        cell.likeButton.tag = indexPath.row
                        cell.moreButton.tag = indexPath.row
                        cell.backgroundColor = Colours.white
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell


                    } else {

                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell10", for: indexPath) as! ActionButtonCell
                        cell.configure(mainStatus: self.mainStatus[0])
                        cell.replyButton.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                        cell.likeButton.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                        cell.boostButton.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                        cell.moreButton.addTarget(self, action: #selector(self.didTouchMore), for: .touchUpInside)
                        cell.replyButton.tag = indexPath.row
                        cell.likeButton.tag = indexPath.row
                        cell.boostButton.tag = indexPath.row
                        cell.moreButton.tag = indexPath.row
                        cell.backgroundColor = Colours.white
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell

                    }
                }

            }
        } else {

            // All replies

            if self.allReplies.isEmpty {

                let cell = tableView.dequeueReusableCell(withIdentifier: "cell800", for: indexPath) as! MainFeedCell
                cell.delegate = self
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                cell.toot.textColor = Colours.black
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
                                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                switch (deviceIdiom) {
                                case .phone :
                                    self.navigationController?.pushViewController(controller, animated: true)
                                case .pad:
                                    if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                        if StoreStruct.currentPage == 0 {
                                            nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                        if StoreStruct.currentPage == 1 {
                                            nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                        if StoreStruct.currentPage == 2 {
                                            nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                default:
                                    print("nothing")
                                }
                            }
                        }
                    }
                }
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell

            } else {

                if self.allReplies[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {

                    if self.allReplies[indexPath.row].inReplyToID == self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell800", for: indexPath) as! MainFeedCell
                        cell.delegate = self
                        cell.rep1.tag = indexPath.row
                        cell.like1.tag = indexPath.row
                        cell.boost1.tag = indexPath.row
                        cell.rep1.addTarget(self, action: #selector(self.didTouchFuRep), for: .touchUpInside)
                        cell.like1.addTarget(self, action: #selector(self.didTouchFuLike), for: .touchUpInside)
                        cell.boost1.addTarget(self, action: #selector(self.didTouchFuBoost), for: .touchUpInside)
                        cell.configure(self.allReplies[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
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
                            for z2 in self.allReplies[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.id
                                }
                            }


                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser.username {} else {
                                controller.fromOtherUser = true
                            }
                                        controller.userIDtoUse = newString
//                                        DispatchQueue.main.async {
                                            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                            switch (deviceIdiom) {
                                            case .phone :
                                                self.navigationController?.pushViewController(controller, animated: true)
                                            case .pad:
                                                if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                    if StoreStruct.currentPage == 0 {
                                                        nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                    if StoreStruct.currentPage == 1 {
                                                        nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                    if StoreStruct.currentPage == 2 {
                                                        nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                }
                                            default:
                                                print("nothing")
                                            }
//                                        }
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
                                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                        switch (deviceIdiom) {
                                        case .phone :
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        case .pad:
                                            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                if StoreStruct.currentPage == 0 {
                                                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 1 {
                                                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 2 {
                                                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                            }
                                        default:
                                            print("nothing")
                                        }
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell8000", for: indexPath) as! RepliesCell
                        cell.delegate = self
                        cell.configure(self.allReplies[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
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
                            for z2 in self.allReplies[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.id
                                }
                            }


                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser.username {} else {
                                controller.fromOtherUser = true
                            }
                                        controller.userIDtoUse = newString
//                                        DispatchQueue.main.async {
                                            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                            switch (deviceIdiom) {
                                            case .phone :
                                                self.navigationController?.pushViewController(controller, animated: true)
                                            case .pad:
                                                if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                    if StoreStruct.currentPage == 0 {
                                                        nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                    if StoreStruct.currentPage == 1 {
                                                        nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                    if StoreStruct.currentPage == 2 {
                                                        nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                }
                                            default:
                                                print("nothing")
                                            }
//                                        }
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
                                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                        switch (deviceIdiom) {
                                        case .phone :
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        case .pad:
                                            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                if StoreStruct.currentPage == 0 {
                                                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 1 {
                                                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 2 {
                                                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                            }
                                        default:
                                            print("nothing")
                                        }
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell

                    }
                } else {

                    if self.allReplies[indexPath.row].inReplyToID == self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell900", for: indexPath) as! MainFeedCellImage
                        cell.delegate = self
                        cell.configure(self.allReplies[indexPath.row])
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
                        cell.rep1.tag = indexPath.row
                        cell.like1.tag = indexPath.row
                        cell.boost1.tag = indexPath.row
                        cell.rep1.addTarget(self, action: #selector(self.didTouchFuRep), for: .touchUpInside)
                        cell.like1.addTarget(self, action: #selector(self.didTouchFuLike), for: .touchUpInside)
                        cell.boost1.addTarget(self, action: #selector(self.didTouchFuBoost), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.mainImageView.backgroundColor = Colours.white
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            var newString = string
                            for z2 in self.allReplies[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.id
                                }
                            }


                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser.username {} else {
                                controller.fromOtherUser = true
                            }
                                        controller.userIDtoUse = newString
//                                        DispatchQueue.main.async {
                                            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                            switch (deviceIdiom) {
                                            case .phone :
                                                self.navigationController?.pushViewController(controller, animated: true)
                                            case .pad:
                                                if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                    if StoreStruct.currentPage == 0 {
                                                        nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                    if StoreStruct.currentPage == 1 {
                                                        nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                    if StoreStruct.currentPage == 2 {
                                                        nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                }
                                            default:
                                                print("nothing")
                                            }
//                                        }
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
                                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                        switch (deviceIdiom) {
                                        case .phone :
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        case .pad:
                                            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                if StoreStruct.currentPage == 0 {
                                                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 1 {
                                                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 2 {
                                                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                            }
                                        default:
                                            print("nothing")
                                        }
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell90", for: indexPath) as! RepliesCellImage
                        cell.delegate = self
                        cell.configure(self.allReplies[indexPath.row])
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
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.mainImageView.backgroundColor = Colours.white
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }

                            var newString = string
                            for z2 in self.allReplies[indexPath.row].mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.id
                                }
                            }


                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser.username {} else {
                                controller.fromOtherUser = true
                            }
                                        controller.userIDtoUse = newString
//                                        DispatchQueue.main.async {
                                            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                            switch (deviceIdiom) {
                                            case .phone :
                                                self.navigationController?.pushViewController(controller, animated: true)
                                            case .pad:
                                                if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                    if StoreStruct.currentPage == 0 {
                                                        nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                    if StoreStruct.currentPage == 1 {
                                                        nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                    if StoreStruct.currentPage == 2 {
                                                        nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                    }
                                                }
                                            default:
                                                print("nothing")
                                            }
//                                        }
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
                                        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                        switch (deviceIdiom) {
                                        case .phone :
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        case .pad:
                                            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                                if StoreStruct.currentPage == 0 {
                                                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 1 {
                                                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                                if StoreStruct.currentPage == 2 {
                                                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                                }
                                            }
                                        default:
                                            print("nothing")
                                        }
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

    @objc func didTouchPreRep(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }

        var theTable = self.tableView
        var sto = self.allPrevious

        let controller = ComposeViewController()
        StoreStruct.spoilerText = sto[sender.tag].reblog?.spoilerText ?? sto[sender.tag].spoilerText
        controller.inReply = [sto[sender.tag].reblog ?? sto[sender.tag]]
        controller.prevTextReply = sto[sender.tag].reblog?.content.stripHTML() ?? sto[sender.tag].content.stripHTML()
        controller.inReplyText = sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username
        print(sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username)
//        self.present(controller, animated: true, completion: nil)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone :
            self.navigationController?.pushViewController(controller, animated: true)
        case .pad:
            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                if StoreStruct.currentPage == 0 {
                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                }
                if StoreStruct.currentPage == 1 {
                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                }
                if StoreStruct.currentPage == 2 {
                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                }
            }
        default:
            print("nothing")
        }
    }

    @objc func didTouchFuRep(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }

        var theTable = self.tableView
        var sto = self.allReplies

        let controller = ComposeViewController()
        StoreStruct.spoilerText = sto[sender.tag].reblog?.spoilerText ?? sto[sender.tag].spoilerText
        controller.inReply = [sto[sender.tag].reblog ?? sto[sender.tag]]
        controller.prevTextReply = sto[sender.tag].reblog?.content.stripHTML() ?? sto[sender.tag].content.stripHTML()
        controller.inReplyText = sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username
        print(sto[sender.tag].reblog?.account.username ?? sto[sender.tag].account.username)
        self.present(controller, animated: true, completion: nil)
    }

    @objc func didTouchPreLike(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }

        var theTable = self.tableView
        var sto = self.allPrevious

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
                        cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.reblogged! ?? sto[sender.tag].reblogged! || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "boost")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
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
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
                            cell.moreImage.image = UIImage(named: "like")
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
                            cell.moreImage.image = UIImage(named: "like")
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        }
    }

    @objc func didTouchFuLike(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }

        var theTable = self.tableView
        var sto = self.allReplies

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
                        cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.reblogged! ?? sto[sender.tag].reblogged! || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "boost")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
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
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
                            cell.moreImage.image = UIImage(named: "like")
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.reblogged ?? sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.gray), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.like1.setTitle("\((Int(cell.like1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.like1.setImage(UIImage(named: "like3")?.maskWithColor(color: Colours.orange), for: .normal)
                            cell.moreImage.image = UIImage(named: "like")
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        }
    }

    @objc func didTouchPreBoost(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }

        var theTable = self.tableView
        var sto = self.allPrevious

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
                        cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.favourited! ?? sto[sender.tag].favourited! || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "like")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
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
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
                            cell.moreImage.image = UIImage(named: "boost")
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
                            cell.moreImage.image = UIImage(named: "boost")
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        }
    }

    @objc func didTouchFuBoost(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }

        var theTable = self.tableView
        var sto = self.allReplies

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
                        cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.favourited! ?? sto[sender.tag].favourited! || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "like")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                        cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
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
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
                            cell.moreImage.image = UIImage(named: "boost")
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblog?.favourited ?? sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].reblog?.id ?? sto[sender.tag].id) {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) - 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.gray), for: .normal)
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.boost1.setTitle("\((Int(cell.boost1.titleLabel?.text ?? "0") ?? 1) + 1)", for: .normal)
                            cell.boost1.setImage(UIImage(named: "boost3")?.maskWithColor(color: Colours.green), for: .normal)
                            cell.moreImage.image = UIImage(named: "boost")
                        }
                        cell.hideSwipe(animated: true)
                    }
                }
            }
        }
    }

    var player = AVPlayer()
    @objc func tappedImageDetail(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.mainStatus

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto[0].reblog?.mediaAttachments[0].type ?? sto[0].mediaAttachments[0].type == .video || sto[0].reblog?.mediaAttachments[0].type ?? sto[0].mediaAttachments[0].type == .gifv {

            let videoURL = URL(string: sto[0].reblog?.mediaAttachments[0].url ?? sto[0].mediaAttachments[0].url)!
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

            let indexPath = IndexPath(row: sender.tag, section: 1)
            let cell = tableView.cellForRow(at: indexPath) as! DetailCellImage
            var images = [SKPhoto]()
            var coun = 0
            for y in sto[0].reblog?.mediaAttachments ?? sto[0].mediaAttachments {
                if coun == 0 {
                    let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                    photo.shouldCachePhotoURLImage = true
                    if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                        photo.caption = sto[0].reblog?.content.stripHTML() ?? sto[0].content.stripHTML()
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
                        photo.caption = sto[0].reblog?.content.stripHTML() ?? sto[0].content.stripHTML()
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

    @objc func didTouchFaves(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UIImpactFeedbackGenerator()
            selection.impactOccurred()
        }
        if self.mainStatus[0].reblog?.favouritesCount ?? self.mainStatus[0].favouritesCount > 0 || self.mainStatus[0].reblog?.reblogsCount ?? self.mainStatus[0].reblogsCount > 0 {

            let request = Statuses.favouritedBy(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {


                        let request0 = Statuses.rebloggedBy(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
                        StoreStruct.client.run(request0) { (statuses) in
                            if let stat0 = (statuses.value) {


                                DispatchQueue.main.async {

                                    let controller = BoostersViewController()
                                    controller.statusLiked = stat
                                    controller.statusBoosted = stat0
                                    controller.profileStatus = self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id ?? ""
                                    
                                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                                    switch (deviceIdiom) {
                                    case .phone :
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    case .pad:
                                        if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                                            if StoreStruct.currentPage == 0 {
                                                nav.firstView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 1 {
                                                nav.secondView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                            if StoreStruct.currentPage == 2 {
                                                nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }
                                    default:
                                        print("nothing")
                                    }
                                    
                                }

                            }
                        }


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
        let controller = ComposeViewController()
        StoreStruct.spoilerText = self.mainStatus[sender.tag].reblog?.spoilerText ?? self.mainStatus[sender.tag].spoilerText
        controller.inReply = [self.mainStatus[sender.tag].reblog ?? self.mainStatus[sender.tag]]
        controller.inReplyText = self.mainStatus[sender.tag].reblog?.account.username ?? self.mainStatus[sender.tag].account.username
        print(self.mainStatus[sender.tag].reblog?.account.username ?? self.mainStatus[sender.tag].account.username)
        controller.prevTextReply = self.mainStatus[sender.tag].reblog?.content.stripHTML() ?? self.mainStatus[sender.tag].content.stripHTML()
        self.present(controller, animated: true, completion: nil)
    }

    func refDetailCount() {
        if self.mainStatus.isEmpty {} else {
            let request = Statuses.status(id: self.mainStatus[0].id)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        self.mainStatus = [stat]
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DetailCell {
                            cell.configure(stat)
                            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                        } else if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DetailCellImage {
                            cell.configure(stat)
                            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                        }
                    }
                }
            }
        }
    }

    func refDetailCountPoll() {
        if self.mainStatus.isEmpty {} else {
            let request = Statuses.status(id: self.mainStatus[0].id)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        self.mainStatus = [stat]
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? PollCell {
                            if let poll = stat.poll {
                                cell.configure(thePoll: poll, theOptions: poll.options)
                                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                            }
                        }
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
        if self.mainStatus[0].reblog?.favourited ?? self.mainStatus[0].favourited ?? false || StoreStruct.allLikes.contains(self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id) {

            if self.mainStatus[0].visibility == .direct {
                if let ce = self.tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ActionButtonCell2 {
                    ce.likeButton.setImage(UIImage(named: "like0"), for: .normal)
                }
            } else {
                if let ce = self.tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ActionButtonCell {
                    ce.likeButton.setImage(UIImage(named: "like0"), for: .normal)
                }
            }

            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "likelarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Unliked".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = "Toot"
            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                statusAlert.show()
            }

            StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id }
            let request2 = Statuses.unfavourite(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request2) { (statuses) in
                print(statuses.value)
            }

            self.refDetailCount()
        } else {
            if self.mainStatus[0].visibility == .direct {
                if let ce = self.tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ActionButtonCell2 {
                ce.likeButton.setImage(UIImage(named: "like"), for: .normal)
                }
            } else {
                if let ce = self.tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ActionButtonCell {
                ce.likeButton.setImage(UIImage(named: "like"), for: .normal)
                }
            }

            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "likelarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Liked".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = "Toot"
            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                statusAlert.show()
            }

            StoreStruct.allLikes.append(self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            let request2 = Statuses.favourite(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)

            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                    }
                }
                print(statuses.value)
            }

            self.refDetailCount()
        }

    }

    @objc func didTouchBoost(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        if self.mainStatus[0].reblog?.reblogged ?? self.mainStatus[0].reblogged ?? false || StoreStruct.allBoosts.contains(self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id) {
            if let ce = self.tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ActionButtonCell {
            ce.boostButton.setImage(UIImage(named: "boost0"), for: .normal)
            }
            
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "boostlarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Unboosted".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = "Toot"
            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                statusAlert.show()
            }

            StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id }
            let request2 = Statuses.unreblog(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request2) { (statuses) in
                print(statuses.value)
            }

            self.refDetailCount()
        } else {
            if let ce = self.tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ActionButtonCell {
            ce.boostButton.setImage(UIImage(named: "boost"), for: .normal)
            }
            
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "boostlarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Boosted".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = "Toot"
            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                statusAlert.show()
            }

            StoreStruct.allBoosts.append(self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            let request2 = Statuses.reblog(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request2) { (statuses) in

                DispatchQueue.main.async {
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                    }
                }
                print(statuses.value)
            }

            self.refDetailCount()
        }

    }

    @objc func didTouchMore(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }

        var isMuted = false
        let request0 = Mutes.all()
        StoreStruct.client.run(request0) { (statuses) in
            if let stat = (statuses.value) {
                let s = stat.filter { $0.id == self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id }
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
                let s = stat.filter { $0.id == self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id }
                if s.isEmpty {
                    isBlocked = false
                } else {
                    isBlocked = true
                }
            }
        }





        if self.mainStatus[0].account.id == StoreStruct.currentUser.id {



            let wordsInThis = self.mainStatus[0].content.stripHTML().components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}.count
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
                    if self.mainStatus[0].pinned ?? false || StoreStruct.allPins.contains(self.mainStatus[0].id) {
                        StoreStruct.allPins = StoreStruct.allPins.filter { $0 != self.mainStatus[0].id }
                        let request = Statuses.unpin(id: self.mainStatus[0].id)
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
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }
                            }
                        }
                    } else {
                        StoreStruct.allPins.append(self.mainStatus[0].id)
                        let request = Statuses.pin(id: self.mainStatus[0].id)
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
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }
                            }
                        }
                    }
                }
                .action(.default("Delete and Redraft".localized), image: UIImage(named: "block")) { (action, ind) in
                    print(action, ind)

                    let controller = ComposeViewController()
                    StoreStruct.spoilerText = self.mainStatus[0].reblog?.spoilerText ?? self.mainStatus[0].spoilerText
                    controller.idToDel = self.mainStatus[0].id
                    controller.filledTextFieldText = self.mainStatus[0].content.stripHTML()
                    self.present(controller, animated: true, completion: nil)

                }
                .action(.default("Delete".localized), image: UIImage(named: "block")) { (action, ind) in
                    print(action, ind)

                    let request = Statuses.delete(id: self.mainStatus[0].id)
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
                            statusAlert.message = "Your Toot"
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                statusAlert.show()
                            }
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
                    let bodyText = self.mainStatus[0].content.stripHTML()
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
                                    .popover(anchorView: self.moreButton ?? self.view)
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
                    controller.filledTextFieldText = self.mainStatus[0].content.stripHTML()
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

                            if let myWebsite = self.mainStatus[0].url {
                                let objectsToShare = [myWebsite]
                                let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                vc.popoverPresentationController?.sourceView = self.view
                                vc.previewNumberOfLines = 5
                                vc.previewFont = UIFont.systemFont(ofSize: 14)
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                            print(action, ind)

                            let bodyText = self.mainStatus[0].content.stripHTML()
                            let vc = VisualActivityViewController(text: bodyText)
                            vc.popoverPresentationController?.sourceView = self.view
                            vc.previewNumberOfLines = 5
                            vc.previewFont = UIFont.systemFont(ofSize: 14)
                            self.present(vc, animated: true, completion: nil)

                        }
                        .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                            print(action, ind)

                            let controller = NewQRViewController()
                            controller.ur = self.mainStatus[0].url?.absoluteString ?? "https://www.thebluebird.app"
                            self.present(controller, animated: true, completion: nil)

                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: self.moreButton ?? self.view)
                        .show(on: self)




                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
                .popover(anchorView: self.moreButton ?? self.view)
                .show(on: self)



        } else {

            let wordsInThis = self.mainStatus[0].content.stripHTML().components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}.count
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
                        statusAlert.message = self.mainStatus[0].reblog?.account.displayName ?? self.mainStatus[0].account.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                            statusAlert.show()
                        }

                        let request = Accounts.mute(id: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id)
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
                        statusAlert.message = self.mainStatus[0].reblog?.account.displayName ?? self.mainStatus[0].account.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                            statusAlert.show()
                        }

                        let request = Accounts.unmute(id: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id)
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
                        statusAlert.message = self.mainStatus[0].reblog?.account.displayName ?? self.mainStatus[0].account.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                            statusAlert.show()
                        }

                        let request = Accounts.block(id: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id)
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
                        statusAlert.message = self.mainStatus[0].reblog?.account.displayName ?? self.mainStatus[0].account.displayName
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                            statusAlert.show()
                        }

                        let request = Accounts.unblock(id: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id)
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

                            let request = Reports.report(accountID: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id, statusIDs: [self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id], reason: "Harassment")
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

                            let request = Reports.report(accountID: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id, statusIDs: [self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id], reason: "No Content Warning")
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

                            let request = Reports.report(accountID: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id, statusIDs: [self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id], reason: "Spam")
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
                        .popover(anchorView: self.moreButton ?? self.view)
                        .show(on: self)


                }
                .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                    print(action, ind)

                    let unreserved = "-._~/?"
                    let allowed = NSMutableCharacterSet.alphanumeric()
                    allowed.addCharacters(in: unreserved)
                    let bodyText = self.mainStatus[0].reblog?.content.stripHTML() ?? self.mainStatus[0].content.stripHTML()
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
                                    .popover(anchorView: self.moreButton ?? self.view)
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
                    controller.filledTextFieldText = self.mainStatus[0].content.stripHTML()
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

                            if let myWebsite = self.mainStatus[0].reblog?.url ?? self.mainStatus[0].url {
                                let objectsToShare = [myWebsite]
                                let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                vc.popoverPresentationController?.sourceView = self.view
                                vc.previewNumberOfLines = 5
                                vc.previewFont = UIFont.systemFont(ofSize: 14)
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                            print(action, ind)

                            let bodyText = self.mainStatus[0].reblog?.content.stripHTML() ?? self.mainStatus[0].content.stripHTML()
                            let vc = VisualActivityViewController(text: bodyText)
                            vc.popoverPresentationController?.sourceView = self.view
                            vc.previewNumberOfLines = 5
                            vc.previewFont = UIFont.systemFont(ofSize: 14)
                            self.present(vc, animated: true, completion: nil)

                        }
                        .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                            print(action, ind)

                            let controller = NewQRViewController()
                            controller.ur = self.mainStatus[0].url?.absoluteString ?? "https://www.thebluebird.app"
                            self.present(controller, animated: true, completion: nil)

                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: self.moreButton ?? self.view)
                        .show(on: self)



                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
                .popover(anchorView: self.moreButton ?? self.view)
                .show(on: self)

        }

    }


    @objc func didTouchProfileM(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        let controller = ThirdViewController()
        if self.mainStatus.isEmpty {} else {
        if self.mainStatus[0].reblog?.account.username ?? self.mainStatus[0].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }

        controller.userIDtoUse = self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone :
            self.navigationController?.pushViewController(controller, animated: true)
        case .pad:
            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                if StoreStruct.currentPage == 0 {
                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                }
                if StoreStruct.currentPage == 1 {
                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                }
                if StoreStruct.currentPage == 2 {
                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                }
            }
        default:
            print("nothing")
        }
        }
    }

    @objc func didTouchProfileP(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        let controller = ThirdViewController()
        if self.allPrevious[sender.tag].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }

        controller.userIDtoUse = self.allPrevious[sender.tag].account.id
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone :
            self.navigationController?.pushViewController(controller, animated: true)
        case .pad:
            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                if StoreStruct.currentPage == 0 {
                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                }
                if StoreStruct.currentPage == 1 {
                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                }
                if StoreStruct.currentPage == 2 {
                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                }
            }
        default:
            print("nothing")
        }
    }

    @objc func didTouchProfile(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        print("pp0")

        let controller = ThirdViewController()
        if self.allReplies[sender.tag].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }

        controller.userIDtoUse = self.allReplies[sender.tag].account.id
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone :
            self.navigationController?.pushViewController(controller, animated: true)
        case .pad:
            if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                if StoreStruct.currentPage == 0 {
                    nav.firstView.navigationController?.pushViewController(controller, animated: true)
                }
                if StoreStruct.currentPage == 1 {
                    nav.secondView.navigationController?.pushViewController(controller, animated: true)
                }
                if StoreStruct.currentPage == 2 {
                    nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                }
            }
        default:
            print("nothing")
        }
    }

    @objc func tappedImagePrev(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }


        var sto = self.allPrevious
        let indexPath = IndexPath(row: sender.tag, section: 0)


        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].mediaAttachments[0].type == .gifv {

            let videoURL = URL(string: sto[sender.tag].mediaAttachments[0].url)!
            XPlayer.play(videoURL)

        } else {

            if self.allPrevious[indexPath.row].inReplyToID == self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id {

                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                var coun = 0
                for y in sto[indexPath.row].mediaAttachments {
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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
                            photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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

                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                var coun = 0
                for y in sto[indexPath.row].mediaAttachments {
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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
                            photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
                        } else if UserDefaults.standard.object(forKey: "captionset") as! Int == 1 {
                            photo.caption = y.description ?? ""
                        } else {
                            photo.caption = ""
                        }
                        images.append(photo)
                    }
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

    @objc func tappedImage(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }


        var sto = self.allReplies
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        let indexPath = IndexPath(row: sender.tag, section: 5)


        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].mediaAttachments[0].type == .gifv {

            let videoURL = URL(string: sto[sender.tag].mediaAttachments[0].url)!
            XPlayer.play(videoURL)

        } else {

            if self.allReplies[indexPath.row].inReplyToID == self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id {

                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                var coun = 0
                for y in sto[indexPath.row].mediaAttachments {
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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
                            photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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

                let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
                var images = [SKPhoto]()
                var coun = 0
                for y in sto[indexPath.row].mediaAttachments {
                    if coun == 0 {
                        let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                        photo.shouldCachePhotoURLImage = true
                        if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                            photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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
                            photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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




    @objc func tappedImageS1(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.allReplies
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        let indexPath = IndexPath(row: sender.tag, section: 5)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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

        var sto = self.allReplies
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        let indexPath = IndexPath(row: sender.tag, section: 5)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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

        var sto = self.allReplies
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        let indexPath = IndexPath(row: sender.tag, section: 5)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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

        var sto = self.allReplies
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        let indexPath = IndexPath(row: sender.tag, section: 5)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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








    @objc func tappedImagePrevS1(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.allPrevious
        let indexPath = IndexPath(row: sender.tag, section: 0)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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

    @objc func tappedImagePrevS2(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.allPrevious
        let indexPath = IndexPath(row: sender.tag, section: 0)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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


    @objc func tappedImagePrevS3(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.allPrevious
        let indexPath = IndexPath(row: sender.tag, section: 0)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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



    @objc func tappedImagePrevS4(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.allPrevious
        let indexPath = IndexPath(row: sender.tag, section: 0)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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







    @objc func tappedImageDetailS1(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.mainStatus
        let indexPath = IndexPath(row: sender.tag, section: 1)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! DetailCellImage
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

    @objc func tappedImageDetailS2(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.mainStatus
        let indexPath = IndexPath(row: sender.tag, section: 1)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! DetailCellImage
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


    @objc func tappedImageDetailS3(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.mainStatus
        let indexPath = IndexPath(row: sender.tag, section: 1)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! DetailCellImage
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



    @objc func tappedImageDetailS4(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }

        var sto = self.mainStatus
        let indexPath = IndexPath(row: sender.tag, section: 1)

        StoreStruct.currentImageURL = sto[sender.tag].reblog?.url ?? sto[sender.tag].url

        if sto.count < 1 {} else {

            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {

            } else {

                //                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! DetailCellImage
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




    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        var sto = self.allReplies
        if indexPath.section == 0 {
            sto = self.allPrevious
        }

        if indexPath.section == 2 || indexPath.section == 3 {
            return nil
        }

        if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 0) {} else {
            return nil
        }

        if orientation == .left {
            let impact = UIImpactFeedbackGenerator(style: .medium)

            let boost = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("boost")
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    impact.impactOccurred()
                }
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
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



                if sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
                    StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[indexPath.row].id }
                    let request2 = Statuses.unfavourite(id: sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "boost")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                                if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "boost")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                                if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "boost")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCellImage {
                                if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
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
                    StoreStruct.allLikes.append(sto[indexPath.row].id)
                    let request2 = Statuses.favourite(id: sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                            }
                            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "like")
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                                if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "like")
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                                if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "like")
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCellImage {
                                if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
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







                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            like.backgroundColor = Colours.white
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
                controller.inReply = [sto[indexPath.row]]
                controller.inReplyText = sto[indexPath.row].account.username
                controller.prevTextReply = sto[indexPath.row].content.stripHTML()
                print(sto[indexPath.row].account.username)
                self.present(controller, animated: true, completion: nil)


                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            reply.backgroundColor = Colours.white
            reply.image = UIImage(named: "reply")
            reply.transitionDelegate = ScaleTransition.default
            reply.textColor = Colours.tabUnselected

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

                    Alertift.actionSheet(title: nil, message: newSecondsText)
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Pin/Unpin".localized), image: UIImage(named: "pinned")) { (action, ind) in
                            print(action, ind)
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
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
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
                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                            statusAlert.show()
                                        }
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

                            let request = Statuses.delete(id: sto[indexPath.row].id)
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
                                    statusAlert.message = "Your Toot"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                        statusAlert.show()
                                    }
                                    //sto.remove(at: indexPath.row)
                                    //self.tableView.reloadData()
                                }
                            }
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
                                        vc.popoverPresentationController?.sourceView = self.view
                                        vc.previewNumberOfLines = 5
                                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)

                                    let bodyText = sto[indexPath.row].content.stripHTML()
                                    let vc = VisualActivityViewController(text: bodyText)
                                    vc.popoverPresentationController?.sourceView = self.view
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)

                                }
                                .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)

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
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
                                .show(on: self)




                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
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
                                statusAlert.message = sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }

                                let request = Accounts.mute(id: sto[indexPath.row].account.id)
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
                                statusAlert.message = sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }

                                let request = Accounts.unmute(id: sto[indexPath.row].account.id)
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
                                statusAlert.message = sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }

                                let request = Accounts.block(id: sto[indexPath.row].account.id)
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
                                statusAlert.message = sto[indexPath.row].account.displayName
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                    statusAlert.show()
                                }

                                let request = Accounts.unblock(id: sto[indexPath.row].account.id)
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
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
                                .show(on: self)


                        }
                        .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                            print(action, ind)

                            let unreserved = "-._~/?"
                            let allowed = NSMutableCharacterSet.alphanumeric()
                            allowed.addCharacters(in: unreserved)
                            let bodyText = sto[indexPath.row].content.stripHTML()
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
                                            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
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
                                        vc.popoverPresentationController?.sourceView = self.view
                                        vc.previewNumberOfLines = 5
                                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)

                                    let bodyText = sto[indexPath.row].content.stripHTML()
                                    let vc = VisualActivityViewController(text: bodyText)
                                    vc.popoverPresentationController?.sourceView = self.view
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)

                                }
                                .action(.default("Share QR Code".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)

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
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
                                .show(on: self)



                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.contentView ?? self.view)
                        .show(on: self)


                }


                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.white
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
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone :
            if indexPath.section == 0 {
                let controller = DetailViewController()
                controller.mainStatus.append(self.allPrevious[indexPath.row])
                self.navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.section == 5 {
                let controller = DetailViewController()
                controller.mainStatus.append(self.allReplies[indexPath.row])
                self.navigationController?.pushViewController(controller, animated: true)
            }
        case .pad:
            if indexPath.section == 0 {
                let controller = DetailViewController()
                controller.mainStatus.append(self.allPrevious[indexPath.row])
                if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                    if StoreStruct.currentPage == 0 {
                        nav.firstView.navigationController?.pushViewController(controller, animated: true)
                    }
                    if StoreStruct.currentPage == 1 {
                        nav.secondView.navigationController?.pushViewController(controller, animated: true)
                    }
                    if StoreStruct.currentPage == 2 {
                        nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
            if indexPath.section == 5 {
                let controller = DetailViewController()
                controller.mainStatus.append(self.allReplies[indexPath.row])
                if let nav = self.splitViewController?.viewControllers[0] as? ViewController {
                    if StoreStruct.currentPage == 0 {
                        nav.firstView.navigationController?.pushViewController(controller, animated: true)
                    }
                    if StoreStruct.currentPage == 1 {
                        nav.secondView.navigationController?.pushViewController(controller, animated: true)
                    }
                    if StoreStruct.currentPage == 2 {
                        nav.thirdView.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
        default:
            print("nothing")
        }
    }


    @objc func refreshCont() {
        if self.mainStatus.isEmpty {} else {
            let request = Statuses.context(id: self.mainStatus[0].id)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    self.allReplies = (stat.descendants)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
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

        self.navigationController?.navigationBar.backgroundColor = Colours.white
        self.navigationController?.navigationBar.tintColor = Colours.black
        self.navigationController?.navigationBar.barTintColor = Colours.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
        self.splitViewController?.view.backgroundColor = Colours.cellQuote

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
