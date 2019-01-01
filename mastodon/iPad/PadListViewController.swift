//
//  PadListViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 27/12/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import StatusAlert

class PadListViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    var tableViewLists = UITableView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = Colours.grayDark3
        
        
        self.tableViewLists.frame = CGRect(x: 0, y: 0, width: Int(440), height: Int(540))
        self.tableViewLists.alpha = 0
        self.tableViewLists.delegate = self
        self.tableViewLists.dataSource = self
        self.tableViewLists.separatorStyle = .singleLine
        self.tableViewLists.backgroundColor = Colours.grayDark3
        self.tableViewLists.separatorColor = UIColor(red: 50/250, green: 53/250, blue: 63/250, alpha: 1.0)
        self.tableViewLists.layer.masksToBounds = true
        self.tableViewLists.estimatedRowHeight = 89
        self.tableViewLists.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableViewLists)
        
        self.tableViewLists.register(ListCell.self, forCellReuseIdentifier: "cell002l")
        self.tableViewLists.register(ListCell2.self, forCellReuseIdentifier: "cell002l2")
        self.tableViewLists.register(ProCells.self, forCellReuseIdentifier: "colcell2")
        
        var maxHe = (Int(52) * Int(StoreStruct.allLists.count + 2)) + (Int(52) * Int(StoreStruct.instanceLocalToAdd.count))
        if maxHe > 364 {
            maxHe = Int(364)
        }
        maxHe += 90
        self.tableViewLists.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.tableViewLists.alpha = 1
            self.tableViewLists.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
//        self.searchTextField.becomeFirstResponder()
        
        
        DispatchQueue.main.async {
            self.tableViewLists.reloadData()
        }
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
            return StoreStruct.allLists.count + 2
        } else {
            return StoreStruct.instanceLocalToAdd.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "colcell2", for: indexPath) as! ProCells
            cell.configure()
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            cell.frame.size.width = 60
            cell.frame.size.height = 60
            return cell
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as! ListCell
                cell.userName.text = "View Other Instance's Timeline"
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = Colours.tabSelected
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            } else if indexPath.row == 1 {
                let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as! ListCell
                cell.userName.text = "Create New List +"
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = Colours.tabSelected
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as! ListCell
//                cell.delegate = self
                cell.configure(StoreStruct.allLists[indexPath.row - 2])
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        } else {
            
            let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l2", for: indexPath) as! ListCell2
//            cell.delegate = self
            cell.configure(StoreStruct.instanceLocalToAdd[indexPath.row])
            cell.backgroundColor = Colours.grayDark3
            cell.userName.textColor = UIColor.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.grayDark3
            cell.selectedBackgroundView = bgColorView
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        if indexPath.section == 0 {
            
            guard indexPath.row > 1 else { return nil }
            
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
                        print(action, ind)
                        let controller = NewListViewController()
                        controller.listID = StoreStruct.allLists[indexPath.row - 2].id
                        controller.editListName = StoreStruct.allLists[indexPath.row - 2].title
                        self.present(controller, animated: true, completion: nil)
                    }
                    .action(.default("View List Members".localized), image: UIImage(named: "profile")) { (action, ind) in
                        print(action, ind)
                        StoreStruct.allListRelID = StoreStruct.allLists[indexPath.row - 2].id
//                        self.dismissOverlayProper()
                        if StoreStruct.currentPage == 0 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers"), object: self)
                        } else if StoreStruct.currentPage == 1 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers2"), object: self)
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers3"), object: self)
                        }
                    }
                    .action(.default("Delete List".localized), image: UIImage(named: "block")) { (action, ind) in
                        print(action, ind)
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Deleted".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = StoreStruct.allLists[indexPath.row - 2].title
                        statusAlert.show()
                        
                        let request = Lists.delete(id: StoreStruct.allLists[indexPath.row - 2].id)
                        StoreStruct.client.run(request) { (statuses) in
                            DispatchQueue.main.async {
                                StoreStruct.allLists.remove(at: indexPath.row - 2)
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
                    .popover(anchorView: self.tableViewLists.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) ?? self.tableViewLists)
                    .show(on: self)
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.grayDark3
            more.image = UIImage(named: "more2")
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
                        print(action, ind)
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Removed".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = StoreStruct.instanceLocalToAdd[indexPath.row]
                        statusAlert.show()
                        
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
                    .popover(anchorView: self.tableViewLists.cellForRow(at: IndexPath(row: indexPath.row, section: 1)) ?? self.tableViewLists)
                    .show(on: self)
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.grayDark3
            more.image = UIImage(named: "more2")
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
        options.backgroundColor = Colours.grayDark3
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped something")
        
//        self.dismissOverlayProper()
        
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "listP"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissThings"), object: self)
        
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                // other instance
                let controller = NewInstanceViewController()
                controller.editListName = ""
                self.present(controller, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                // create new list
                let controller = NewListViewController()
                self.present(controller, animated: true, completion: nil)
            } else {
                // go to list
                StoreStruct.currentList = []
                let request = Lists.accounts(id: StoreStruct.allLists[indexPath.row - 2].id)
                //let request = Lists.list(id: StoreStruct.allLists[indexPath.row - 2].id)
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        for z in stat {
                            
                            let request1 = Accounts.statuses(id: z.id)
                            StoreStruct.client.run(request1) { (statuses) in
                                if let stat = (statuses.value) {
                                    StoreStruct.currentList = StoreStruct.currentList + stat
                                    StoreStruct.currentList = StoreStruct.currentList.sorted(by: { $0.createdAt > $1.createdAt })
                                    StoreStruct.currentListTitle = StoreStruct.allLists[indexPath.row - 2].title
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                                }
                                
                            }
                        }
                        if StoreStruct.currentPage == 0 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists"), object: self)
                        } else if StoreStruct.currentPage == 1 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists2"), object: self)
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists3"), object: self)
                        }
                    }
                }
            }
            
            
        } else {
            
            if (UserDefaults.standard.object(forKey: "instancesLocal") == nil) {
                
            } else {
                StoreStruct.instanceLocalToAdd = UserDefaults.standard.object(forKey: "instancesLocal") as! [String]
                print(StoreStruct.instanceLocalToAdd)
                StoreStruct.instanceText = StoreStruct.instanceLocalToAdd[indexPath.row]
            }
            
            if StoreStruct.currentPage == 0 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance"), object: self)
            } else if StoreStruct.currentPage == 1 {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance2"), object: self)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance3"), object: self)
            }
            
            
        }
        
    }
    
    
    
}
