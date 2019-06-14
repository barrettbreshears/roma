//
//  PadListsViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 14/06/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import StatusAlert

class PadListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    var tableViewLists = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colours.white
        self.title = "Accounts and Lists"
        
        let wid = self.view.bounds.width
        self.tableViewLists.frame = CGRect(x: 0, y: 0, width: Int(wid), height: Int(0))
        self.tableViewLists.alpha = 1
        self.tableViewLists.delegate = self
        self.tableViewLists.dataSource = self
        self.tableViewLists.separatorStyle = .singleLine
        self.tableViewLists.backgroundColor = Colours.white
        self.tableViewLists.separatorColor = Colours.grayDark.withAlphaComponent(0.21)
        self.tableViewLists.layer.masksToBounds = true
        self.tableViewLists.estimatedRowHeight = UITableView.automaticDimension
        self.tableViewLists.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableViewLists)
        self.tableViewLists.tableFooterView = UIView()
        
        self.tableViewLists.register(ListCell.self, forCellReuseIdentifier: "cell002l")
        self.tableViewLists.register(ListCell2.self, forCellReuseIdentifier: "cell002l2")
        self.tableViewLists.register(ProCells.self, forCellReuseIdentifier: "colcell2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableViewLists.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            self.tableViewLists.translatesAutoresizingMaskIntoConstraints = false
            self.tableViewLists.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableViewLists.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableViewLists.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            self.tableViewLists.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        default:
            print("nothing")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 34
        } else if section == 2 {
            if StoreStruct.allLists.isEmpty {
                return 0
            } else {
                return 34
            }
        } else if section == 3 {
            if StoreStruct.instanceLocalToAdd.isEmpty {
                return 0
            } else {
                return 34
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 34)
        let title = UILabel()
        title.frame = CGRect(x: 10, y: 8, width: self.view.bounds.width, height: 26)
        if section == 0 {
            title.text = "Your Accounts"
        } else if section == 2 {
            title.text = "Your Lists"
        } else if section == 3 {
            title.text = "Your Instances"
        }
        title.textColor = UIColor(red: 67/255.0, green: 67/255.0, blue: 75/255.0, alpha: 1.0)
        title.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if StoreStruct.instanceLocalToAdd.count > 0 {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return StoreStruct.allLists.count
        } else {
            return StoreStruct.instanceLocalToAdd.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableViewLists {
            if indexPath.section == 0 {
                return 100
            } else {
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "colcell2", for: indexPath) as? ProCells {
                cell.configure()
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                cell.frame.size.width = 60
                cell.frame.size.height = 80
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                return cell
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as? ListCell {
                    cell.userName.text = "View Other Instance's Timelines"
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.tabSelected
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                    return cell
                }
            } else {
                if let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as? ListCell {
                    cell.userName.text = "Create New List +"
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.tabSelected
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                    return cell
                }
            }
        } else if indexPath.section == 2 {
            if let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as? ListCell {
                cell.delegate = self
                cell.configure(StoreStruct.allLists[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                return cell
            }
        } else {
            
            if let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l2", for: indexPath) as? ListCell2 {
                cell.delegate = self
                cell.configure(StoreStruct.instanceLocalToAdd[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cc", for: indexPath)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        guard indexPath.section > 1 else { return nil }
        
        if indexPath.section == 2 {
            
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
                    .action(.default("Edit List Name".localized), image: UIImage(named: "list")) { (action, ind) in
                        
                        let controller = NewListViewController()
                        controller.listID = StoreStruct.allLists[indexPath.row].id
                        controller.editListName = StoreStruct.allLists[indexPath.row].title
                        self.present(controller, animated: true, completion: nil)
                    }
                    .action(.default("View List Members".localized), image: UIImage(named: "profile")) { (action, ind) in
                        
                        StoreStruct.allListRelID = StoreStruct.allLists[indexPath.row].id
                        if StoreStruct.currentPage == 0 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers"), object: self)
                        } else if StoreStruct.currentPage == 1 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers2"), object: self)
                        } else if StoreStruct.currentPage == 101010 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers3"), object: self)
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers3"), object: self)
                        }
                    }
                    .action(.default("Delete List".localized), image: UIImage(named: "block")) { (action, ind) in
                        
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Deleted".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = StoreStruct.allLists[indexPath.row].title
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
                        }
                        
                        let request = Lists.delete(id: StoreStruct.allLists[indexPath.row].id)
                        StoreStruct.client.run(request) { (statuses) in
                            DispatchQueue.main.async {
                                StoreStruct.allLists.remove(at: indexPath.row)
                                self.tableViewLists.reloadData()
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
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.white
            more.image = UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected)
            more.transitionDelegate = ScaleTransition.default
            more.textColor = Colours.tabUnselected
            return [more]
            
            
            
        } else if indexPath.section == 1 {
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
                    .action(.default("Remove".localized), image: UIImage(named: "block")) { (action, ind) in
                        
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Removed".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = StoreStruct.allLists[indexPath.row].title
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
                        }
                        
                        let request = Lists.delete(id: StoreStruct.allLists[indexPath.row].id)
                        StoreStruct.client.run(request) { (statuses) in
                            DispatchQueue.main.async {
                                StoreStruct.allLists.remove(at: indexPath.row)
                                self.tableViewLists.reloadData()
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
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.white
            more.image = UIImage(named: "more2")?.maskWithColor(color: Colours.tabSelected)
            more.transitionDelegate = ScaleTransition.default
            more.textColor = Colours.tabUnselected
            return [more]
            
            
        } else {
            
            
            
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
                    .action(.default("Remove".localized), image: UIImage(named: "block")) { (action, ind) in
                        
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Removed".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = StoreStruct.instanceLocalToAdd[indexPath.row]
                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            statusAlert.show()
                        }
                        
                        StoreStruct.instanceLocalToAdd.remove(at: indexPath.row)
                        UserDefaults.standard.set(StoreStruct.instanceLocalToAdd, forKey: "instancesLocal")
                        //cbackhere
                        self.tableViewLists.reloadData()
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .show(on: self)
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
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
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        options.buttonSpacing = 0
        options.buttonPadding = 0
        options.maximumButtonWidth = 60
        options.backgroundColor = Colours.white
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                // other instance
                let controller = NewInstanceViewController()
                controller.modalPresentationStyle = .pageSheet
                controller.editListName = ""
                self.present(controller, animated: true, completion: nil)
            } else {
                // create new list
                let controller = NewListViewController()
                controller.modalPresentationStyle = .pageSheet
                self.present(controller, animated: true, completion: nil)
            }
        } else if indexPath.section == 2 {
            
            // go to list
            StoreStruct.currentList = []
            let request = Lists.accounts(id: StoreStruct.allLists[indexPath.row].id)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    stat.map({
                        let request1 = Accounts.statuses(id: $0.id)
                        StoreStruct.client.run(request1) { (statuses) in
                            if let stat = (statuses.value) {
                                StoreStruct.currentList = StoreStruct.currentList + stat
                                StoreStruct.currentList = StoreStruct.currentList.sorted(by: { $0.createdAt > $1.createdAt })
                                StoreStruct.currentListTitle = StoreStruct.allLists[indexPath.row].title
                                StoreStruct.currentListIID = StoreStruct.allLists[indexPath.row].id
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                            }
                        }
                    })
                    if StoreStruct.currentPage == 0 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists"), object: self)
                    } else if StoreStruct.currentPage == 1 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists2"), object: self)
                    } else if StoreStruct.currentPage == 101010 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists3"), object: self)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists4"), object: self)
                    }
                }
            }
            
        } else {
            
            if (UserDefaults.standard.object(forKey: "instancesLocal") == nil) {
                
            } else {
                StoreStruct.instanceLocalToAdd = UserDefaults.standard.object(forKey: "instancesLocal") as! [String]
                StoreStruct.instanceText = StoreStruct.instanceLocalToAdd[indexPath.row]
            }
            
            if StoreStruct.currentPage == 0 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance"), object: self)
            } else if StoreStruct.currentPage == 1 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance2"), object: self)
            } else if StoreStruct.currentPage == 101010 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance3"), object: self)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance4"), object: self)
            }
        }
    }
    
    
}
