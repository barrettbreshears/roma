//
//  NewPollViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 05/03/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class NewPollViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var closeButton = MNGExpandedTouchAreaButton()
    var tootLabel = UIButton()
    var textField = UITextField()
    var keyHeight = 0
    var bgView = UIView()
    var tableView = UITableView()
    let timePicker = UIDatePicker()
    let toolBar = UIToolbar()
    var hiddenTextField = UITextField()
    var titlesOp = ["Allow Multiple Selections", "Hide Totals"]
    var descriptionsOp = ["Allow users to select multiple options when voting.", "Hide the running vote count from users."]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        var botbot = 20
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
                botbot = 40
            case 2436, 1792:
                offset = 88
                closeB = 47
                botbot = 40
            default:
                offset = 64
                closeB = 24
                botbot = 20
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        tootLabel.frame = CGRect(x: CGFloat(self.view.bounds.width - 175), y: CGFloat(closeB), width: CGFloat(150), height: CGFloat(36))
        tootLabel.setTitle("Create", for: .normal)
        tootLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        tootLabel.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        tootLabel.contentHorizontalAlignment = .right
        tootLabel.addTarget(self, action: #selector(didTouchUpInsideTootButton), for: .touchUpInside)
        self.view.addSubview(tootLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        var botbot = 20
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
                botbot = 40
            case 2436, 1792:
                offset = 88
                closeB = 47
                botbot = 40
            default:
                offset = 64
                closeB = 24
                botbot = 20
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        bgView.frame = CGRect(x:0, y:Int(self.view.bounds.height) - 40 - Int(self.keyHeight), width:Int(self.view.bounds.width), height:Int(self.keyHeight) + 40)
        bgView.backgroundColor = Colours.tabSelected
        bgView.alpha = 0
        self.view.addSubview(bgView)
        
        self.closeButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 15, y: closeB, width: 32, height: 32)))
        self.closeButton.setImage(UIImage(named: "block")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.closeButton.adjustsImageWhenHighlighted = false
        self.closeButton.addTarget(self, action: #selector(didTouchUpInsideCloseButton), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        
        textField.frame = CGRect(x: 20, y: offset + 6, width: Int(self.view.bounds.width - 40), height: 30)
        textField.font = UIFont.systemFont(ofSize: Colours.fontSize1 + 2)
        textField.tintColor = Colours.tabSelected
        textField.delegate = self
        textField.keyboardType = .default
        textField.attributedPlaceholder = NSAttributedString(string: "Add at least two poll options...".localized,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: Colours.tabUnselected])
        textField.keyboardAppearance = Colours.keyCol
        textField.backgroundColor = Colours.white
        textField.textColor = Colours.grayDark
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.returnKeyType = .done
        self.view.addSubview(textField)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        textField.addGestureRecognizer(swipeDown)
        
        self.hiddenTextField.frame = CGRect.zero
        self.view.addSubview(self.hiddenTextField)
        
        self.tableView.register(PollOptionCell.self, forCellReuseIdentifier: "PollOptionCell")
        self.tableView.register(PollOptionCell.self, forCellReuseIdentifier: "PollOptionCell2")
        self.tableView.register(PollOptionCellToggle.self, forCellReuseIdentifier: "PollOptionCellToggle")
        self.tableView.frame = CGRect(x: 0, y: Int(offset + 40), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 45)
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
        
        self.openTimePicker()
        
        self.closeButton.frame = CGRect(x: 15, y: closeB, width: 32, height: 32)
    }
    
    func openTimePicker()  {
        self.timePicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250)
        self.timePicker.tintColor = Colours.grayDark
        self.timePicker.datePickerMode = .dateAndTime
        self.timePicker.minimumDate = Date()
        
        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            toolBar.barStyle = .default
            self.timePicker.backgroundColor = UIColor.white
            self.timePicker.setValue(UIColor.black, forKeyPath: "textColor")
            self.timePicker.setValue(false, forKeyPath: "highlightsToday")
        } else {
            toolBar.barStyle = .blackOpaque
            self.timePicker.backgroundColor = UIColor.black
            self.timePicker.setValue(UIColor.white, forKeyPath: "textColor")
            self.timePicker.setValue(false, forKeyPath: "highlightsToday")
        }
        
        toolBar.isTranslucent = false
        toolBar.tintColor = Colours.tabUnselected
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(timeChanged))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        self.hiddenTextField.inputView = timePicker
        self.hiddenTextField.inputAccessoryView = toolBar
    }
    
    @objc func cancelDatePicker() {
        self.hiddenTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.textField.resignFirstResponder()
        self.hiddenTextField.resignFirstResponder()
    }
    
    @objc func timeChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PollOptionCell {
            cell.configure(formatter.string(from: self.timePicker.date), count: "This poll will expire on:")
        }
        
        StoreStruct.pollPickerDate = self.timePicker.date
        StoreStruct.expiresIn = Calendar.current.dateComponents([.second], from: Date(), to: self.timePicker.date).second ?? 0
        
        self.hiddenTextField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.textField.becomeFirstResponder()
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        var botbot = 20
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
                botbot = 40
            case 2436, 1792:
                offset = 88
                closeB = 47
                botbot = 40
            default:
                offset = 64
                closeB = 24
                botbot = 20
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            self.closeButton.frame = CGRect(x: 15, y: closeB, width: 32, height: 32)
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(closeB + 40)).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        default:
            print("nothing")
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyHeight = Int(keyboardHeight)
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            self.textField.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTouchUpInsideCloseButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        self.textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" || textField.text == " " {
            self.textField.resignFirstResponder()
        } else {
            StoreStruct.currentOptions.append(textField.text ?? "")
            self.textField.text = ""
            self.tableView.reloadData()
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (UserDefaults.standard.object(forKey: "keyhap") == nil) || (UserDefaults.standard.object(forKey: "keyhap") as! Int == 0) {
            
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 1) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 2) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        if (textField.text?.count)! > 0 && StoreStruct.currentOptions.count < 2 {
            tootLabel.setTitleColor(Colours.tabSelected, for: .normal)
        } else {
            tootLabel.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        }
    }
    
    @objc func didTouchUpInsideTootButton(_ sender: AnyObject) {
        if StoreStruct.currentOptions.count < 2 { return }
        if StoreStruct.currentOptions.isEmpty && self.textField.text == "" { return }
        
        StoreStruct.newPollPost = [StoreStruct.currentOptions, StoreStruct.expiresIn, StoreStruct.allowsMultiple, StoreStruct.totalsHidden]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addedPoll"), object: self)
        
        self.textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return StoreStruct.currentOptions.count
        } else if section == 1 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollOptionCell", for: indexPath) as! PollOptionCell
            cell.configure(StoreStruct.currentOptions[indexPath.row], count: "Option \(indexPath.row + 1)")
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
            cell.selectedBackgroundView = bgColorView
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollOptionCell2", for: indexPath) as! PollOptionCell
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            var dText = formatter.string(from: StoreStruct.pollPickerDate)
            if StoreStruct.pollPickerDate == Date() {
                dText = "Tomorrow"
            }
            cell.configure(dText, count: "This poll will expire on:")
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
            cell.selectedBackgroundView = bgColorView
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollOptionCellToggle", for: indexPath) as! PollOptionCellToggle
            cell.configure(status: self.titlesOp[indexPath.row], status2: self.descriptionsOp[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.grayDark.withAlphaComponent(0.1)
            cell.selectedBackgroundView = bgColorView
            cell.switchView.setOn(false, animated: false)
            if indexPath.row == 0 {
                cell.switchView.addTarget(self, action: #selector(self.handleToggle1), for: .touchUpInside)
            } else {
                cell.switchView.addTarget(self, action: #selector(self.handleToggle2), for: .touchUpInside)
            }
            return cell
        }
    }
    
    @objc func handleToggle1(sender: UISwitch) {
        if sender.isOn {
            StoreStruct.allowsMultiple = true
            sender.setOn(true, animated: true)
        } else {
            StoreStruct.allowsMultiple = false
            sender.setOn(false, animated: true)
        }
    }
    
    @objc func handleToggle2(sender: UISwitch) {
        if sender.isOn {
            StoreStruct.totalsHidden = true
            sender.setOn(true, animated: true)
        } else {
            StoreStruct.totalsHidden = false
            sender.setOn(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
            }
            Alertift.actionSheet(title: nil, message: nil)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default("Remove Option".localized), image: UIImage(named: "block")) { (action, ind) in
                     
                    StoreStruct.currentOptions = StoreStruct.currentOptions.filter { $0 != StoreStruct.currentOptions[indexPath.row] }
                    self.tableView.reloadData()
                    if StoreStruct.currentOptions.count < 2 {
                        self.tootLabel.setTitleColor(Colours.tabSelected, for: .normal)
                    } else {
                        self.tootLabel.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
                    }
                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
                .popover(anchorView: self.tableView.cellForRow(at: indexPath) ?? self.view)
                .show(on: self)
        } else if indexPath.section == 1 {
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
            }
            self.textField.resignFirstResponder()
            self.hiddenTextField.becomeFirstResponder()
        } else {
            
        }
    }
}
