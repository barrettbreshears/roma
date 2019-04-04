//
//  SearchViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 28/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SJFluidSegmentedControl
import AVKit
import AVFoundation
import StatusAlert
import SafariServices

class SearchViewController: UIViewController, UITextFieldDelegate, SJFluidSegmentedControlDataSource, SJFluidSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource, SKPhotoBrowserDelegate, SwipeTableViewCellDelegate {
    
    var searchTextField = SearchField()
    var segmentedControl: SJFluidSegmentedControl!
    var tableView = UITableView()
    var typeOfSearch = 0
    var newestText = ""
    var safariVC: SFSafariViewController?
    var searchIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colours.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadLoadLoad), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        self.tableView.register(FollowersCell.self, forCellReuseIdentifier: "cellfs")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell00")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell002")
        
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
        
        self.tableView.frame = CGRect(x: 0, y: Int(offset + 110), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 115)
        self.tableView.alpha = 1
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.clear
        self.tableView.separatorColor = UIColor(red: 50/250, green: 53/250, blue: 63/250, alpha: 1.0)
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        
        let wid = self.view.bounds.width - 20
        searchTextField.frame = CGRect(x: 10, y: Int(offset + 5), width: Int(wid), height: 40)
        searchTextField.backgroundColor = Colours.clear
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.layer.cornerRadius = 10
        searchTextField.alpha = 1
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...".localized,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: Colours.tabUnselected])
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.textColor = Colours.grayDark
        searchTextField.keyboardAppearance = Colours.keyCol
        self.view.addSubview(searchTextField)
        
        self.searchIcon.frame = CGRect(x: 15, y: 10, width: 20, height: 20)
        self.searchIcon.backgroundColor = UIColor.clear
        self.searchIcon.image = UIImage(named: "search")?.maskWithColor(color: Colours.tabUnselected)
        self.searchTextField.addSubview(self.searchIcon)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
        segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: 20, y: Int(offset + 60), width: Int(wid), height: Int(40)))
        segmentedControl.dataSource = self
        segmentedControl.shapeStyle = .roundedRect
        segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
        segmentedControl.cornerRadius = 12
        segmentedControl.shadowsEnabled = false
        segmentedControl.transitionStyle = .slide
        segmentedControl.delegate = self
        self.view.addSubview(segmentedControl)
        default:
            print("nothing")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
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
        
        let wid = self.view.bounds.width - 20
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            self.segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: 20, y: Int(offset + 60), width: Int(wid), height: Int(40)))
            segmentedControl.dataSource = self
            segmentedControl.shapeStyle = .roundedRect
            segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
            segmentedControl.cornerRadius = 12
            segmentedControl.shadowsEnabled = false
            segmentedControl.transitionStyle = .slide
            segmentedControl.delegate = self
            self.view.addSubview(segmentedControl)
            
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(offset + 110)).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: CGFloat(offset)).isActive = true
        default:
            print("nothing")
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (UserDefaults.standard.object(forKey: "keyhap") == nil) || (UserDefaults.standard.object(forKey: "keyhap") as! Int == 0) {
            
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 1) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 2) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        
        self.newestText = textField.text ?? ""
        
        if self.typeOfSearch == 0 {
            let theText = textField.text?.replacingOccurrences(of: "#", with: "")
            let request = Timelines.tag(theText ?? "")
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat
                        self.tableView.reloadData()
                    }
                }
            }
        }
        if self.typeOfSearch == 1 {
            let request = Search.search(query: textField.text ?? "")
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat.statuses
                        self.tableView.reloadData()
                    }
                }
            }
        }
        if self.typeOfSearch == 2 {
            let request = Accounts.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearchUser = stat
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 3
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        if index == 0 {
            return "Hashtags".localized
        } else if index == 1 {
            return "Related".localized
        } else {
            return "Users".localized
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
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didChangeFromSegmentAtIndex fromIndex: Int, toSegmentAtIndex toIndex: Int) {
        
        if toIndex == 0 {
            self.typeOfSearch = 0
            let request = Timelines.tag(self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat
                        self.tableView.reloadData()
                    }
                }
            }
        }
        if toIndex == 1 {
            self.typeOfSearch = 1
            let request = Search.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat.statuses
                        self.tableView.reloadData()
                    }
                }
            }
        }
        if toIndex == 2 {
            self.typeOfSearch = 2
            let request = Accounts.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearchUser = stat
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func didTouchBoost(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        
        let theTable = self.tableView
        var sto = StoreStruct.statusSearch
        
        if sto[sender.tag].reblogged! || StoreStruct.allBoosts.contains(sto[sender.tag].id) {
            StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[sender.tag].id }
            let request2 = Statuses.unreblog(id: sto[sender.tag].id)
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if let cell = theTable.cellForRow(at:IndexPath(row: sender.tag, section: 0)) as? MainFeedCell {
                        if sto[sender.tag].favourited! || StoreStruct.allLikes.contains(sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "like")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].favourited! || StoreStruct.allLikes.contains(sto[sender.tag].id) {
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
            StoreStruct.allBoosts.append(sto[sender.tag].id)
            let request2 = Statuses.reblog(id: sto[sender.tag].id)
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                    }
                    
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? MainFeedCell {
                        if sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.moreImage.image = UIImage(named: "boost")
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].favourited ?? false || StoreStruct.allLikes.contains(sto[sender.tag].id) {
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
        
        let theTable = self.tableView
        var sto = StoreStruct.statusSearch
        
        if sto[sender.tag].favourited! || StoreStruct.allLikes.contains(sto[sender.tag].id) {
            StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[sender.tag].id }
            let request2 = Statuses.unfavourite(id: sto[sender.tag].id)
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? MainFeedCell {
                        if sto[sender.tag].reblogged! || StoreStruct.allBoosts.contains(sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "boost")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblogged! || StoreStruct.allBoosts.contains(sto[sender.tag].id) {
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
            StoreStruct.allLikes.append(sto[sender.tag].id)
            let request2 = Statuses.favourite(id: sto[sender.tag].id)
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                    if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                    }
                    
                    if let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? MainFeedCell {
                        if sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.moreImage.image = UIImage(named: "like")
                        }
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MainFeedCellImage
                        if sto[sender.tag].reblogged ?? false || StoreStruct.allBoosts.contains(sto[sender.tag].id) {
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
        var sto = StoreStruct.statusSearch
        
        let controller = ComposeViewController()
        StoreStruct.spoilerText = sto[sender.tag].spoilerText
        controller.inReply = [sto[sender.tag]]
        controller.prevTextReply = sto[sender.tag].content.stripHTML()
        controller.inReplyText = sto[sender.tag].account.username
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.typeOfSearch == 2 {
            return StoreStruct.statusSearchUser.count
        } else {
            return StoreStruct.statusSearch.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.typeOfSearch == 2 {
            if StoreStruct.statusSearchUser.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellfs", for: indexPath) as! FollowersCell
                cell.configure(StoreStruct.statusSearchUser[indexPath.row])
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.isUserInteractionEnabled = false
                cell.backgroundColor = Colours.clear
                cell.userName.textColor = UIColor.white
                cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                cell.toot.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.isUserInteractionEnabled = false
                cell.backgroundColor = Colours.clear
                cell.userName.textColor = UIColor.white
                cell.userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
                cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                cell.toot.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        } else {
            
            if StoreStruct.statusSearch.count > 0 {
                if StoreStruct.statusSearch[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                    cell.configure(StoreStruct.statusSearch[indexPath.row])
                    cell.rep1.tag = indexPath.row
                    cell.like1.tag = indexPath.row
                    cell.boost1.tag = indexPath.row
                    cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                    cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                    cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                    cell.profileImageView.tag = indexPath.row
                    cell.userTag.tag = indexPath.row
                    cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.userTag.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.backgroundColor = Colours.clear
                    cell.userName.textColor = UIColor.white
                    cell.userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    cell.delegate = self
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        
                        var newString = string
                        for z2 in StoreStruct.statusSearch[indexPath.row].mentions {
                            if z2.acct.contains(string) {
                                newString = z2.id
                            }
                        }
                        
                        
                        let controller = ThirdViewController()
                        if newString == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                        controller.userIDtoUse = newString
//                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(controller, animated: true)
//                        }
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
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell002", for: indexPath) as! MainFeedCellImage
                    cell.configure(StoreStruct.statusSearch[indexPath.row])
                    cell.rep1.tag = indexPath.row
                    cell.like1.tag = indexPath.row
                    cell.boost1.tag = indexPath.row
                    cell.rep1.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                    cell.like1.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                    cell.boost1.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
                    cell.profileImageView.tag = indexPath.row
                    cell.userTag.tag = indexPath.row
                    cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                    cell.userTag.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
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
                    cell.backgroundColor = Colours.clear
                    cell.userName.textColor = UIColor.white
                    cell.userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    cell.mainImageView.backgroundColor = Colours.white
                    cell.mainImageViewBG.backgroundColor = Colours.white
                    cell.delegate = self
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        
                        var newString = string
                        for z2 in StoreStruct.statusSearch[indexPath.row].mentions {
                            if z2.acct.contains(string) {
                                newString = z2.id
                            }
                        }
                        
                        
                        let controller = ThirdViewController()
                        if newString == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                        controller.userIDtoUse = newString
//                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(controller, animated: true)
//                        }
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
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                cell.profileImageView.tag = indexPath.row
                cell.backgroundColor = Colours.clear
                cell.userName.textColor = UIColor.white
                cell.userTag.setTitleColor(Colours.black.withAlphaComponent(0.6), for: .normal)
                cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                cell.toot.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        }
    }
    
    @objc func didTouchProfile(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        let controller = ThirdViewController()
        if StoreStruct.statusSearch[sender.tag].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }
        controller.userIDtoUse = StoreStruct.statusSearch[sender.tag].account.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    var player = AVPlayer()
    @objc func tappedImage(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        
        var sto = StoreStruct.statusSearch
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        
        
        StoreStruct.currentImageURL = sto[sender.tag].url
        
        if sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].mediaAttachments[0].type == .gifv {
            
            let videoURL = URL(string: sto[sender.tag].mediaAttachments[0].url)!
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
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
            var images = [SKPhoto]()
            var coun = 0
            for y in sto[indexPath.row].mediaAttachments {
                if coun == 0 {
                    let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.mainImageView.currentImage ?? nil)
                    photo.shouldCachePhotoURLImage = true
                    if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                        photo.caption = sto[indexPath.row].content.stripHTML()
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
                        photo.caption = sto[indexPath.row].content.stripHTML()
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
    
    @objc func tappedImageS1(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        var sto = StoreStruct.statusSearch
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        
        StoreStruct.currentImageURL = sto[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
            } else {
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
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
        
        var sto = StoreStruct.statusSearch
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        
        StoreStruct.currentImageURL = sto[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
            } else {
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
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
        
        var sto = StoreStruct.statusSearch
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        
        StoreStruct.currentImageURL = StoreStruct.statusSearch[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
            } else {
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
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
        
        var sto = StoreStruct.statusSearch
        StoreStruct.newIDtoGoTo = sto[sender.tag].id
        
        StoreStruct.currentImageURL = sto[sender.tag].url
        
        if sto.count < 1 {} else {
            
            if sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].reblog?.mediaAttachments[0].type ?? sto[sender.tag].mediaAttachments[0].type == .gifv {
                
            } else {
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var sto = StoreStruct.statusSearch
        
        
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
                
                
                
                
                
                
                if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                    StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[indexPath.row].id }
                    let request2 = Statuses.unreblog(id: sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "like")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else {
                                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                                if sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
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
                    StoreStruct.allBoosts.append(sto[indexPath.row].id)
                    let request2 = Statuses.reblog(id: sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                            }
                            
                            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "boost")
                                }
                                cell.hideSwipe(animated: true)
                            } else {
                                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                                if sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
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
                
                
                
                
                
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
                            } else {
                                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
                            } else {
                                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
                controller.inReply = [sto[indexPath.row]]
                controller.inReplyText = sto[indexPath.row].account.username
                print(sto[indexPath.row].account.username)
                controller.prevTextReply = sto[indexPath.row].content.stripHTML()
                self.present(controller, animated: true, completion: nil)
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
                            
                            StoreStruct.statusSearch = StoreStruct.statusSearch.filter { $0 != StoreStruct.statusSearch[indexPath.row] }
                            self.tableView.deleteRows(at: [indexPath], with: .none)
                            
                            
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
                                    print(action, ind)
                                    
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
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                                .show(on: self)
                            
                            
                            
                            
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
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
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
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
                                            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
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
                                    print(action, ind)
                                    
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
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                                .show(on: self)
                            
                            
                            
                            
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
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
        self.tableView.deselectRow(at: indexPath, animated: true)
        if self.typeOfSearch == 2 {
            StoreStruct.searchIndex = indexPath.row
            if StoreStruct.currentPage == 0 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser"), object: self)
            } else if StoreStruct.currentPage == 1 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser2"), object: self)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser3"), object: self)
            }
        } else {
            StoreStruct.searchIndex = indexPath.row
            if StoreStruct.currentPage == 0 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "search"), object: self)
            } else if StoreStruct.currentPage == 1 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "search2"), object: self)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "search3"), object: self)
            }
        }
    }
    
    @objc func loadLoadLoad() {
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
}




class SearchField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 43, bottom: 0, right: 15)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
