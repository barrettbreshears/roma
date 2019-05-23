//
//  NewFilterViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 03/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import StatusAlert

class NewFilterViewController: UIViewController, UITextViewDelegate {
    
    var closeButton = MNGExpandedTouchAreaButton()
    var tootLabel = UIButton()
    var textView = UITextView()
    var keyHeight = 0
    var bgView = UIView()
    var titleV = UILabel()
    var editListName = ""
    var listID = ""
    var fromWhich = 0
    var context1 = UIButton()
    var context2 = UIButton()
    var context3 = UIButton()
    var context4 = UIButton()
    var context1Type = true
    var context2Type = true
    var context3Type = true
    var context4Type = true
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        tootLabel.frame = CGRect(x: CGFloat(self.view.bounds.width - 175), y: CGFloat(closeB), width: CGFloat(150), height: CGFloat(36))
        tootLabel.setTitle("Add", for: .normal)
        tootLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        tootLabel.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        tootLabel.contentHorizontalAlignment = .right
        tootLabel.addTarget(self, action: #selector(didTouchUpInsideTootButton), for: .touchUpInside)
        self.view.addSubview(tootLabel)
        
        titleV.frame = CGRect(x: 24, y: offset + 6, width: Int(self.view.bounds.width), height: 30)
        titleV.text = "Add New Filter".localized
        titleV.textColor = Colours.grayDark2
        titleV.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        self.view.addSubview(titleV)
        
        textView.frame = CGRect(x:20, y: offset + 45, width:Int(self.view.bounds.width - 40), height: 30)
        textView.font = UIFont.systemFont(ofSize: Colours.fontSize1 + 2)
        textView.tintColor = Colours.tabSelected
        textView.delegate = self
        textView.becomeFirstResponder()
        if (UserDefaults.standard.object(forKey: "keyb") == nil) || (UserDefaults.standard.object(forKey: "keyb") as! Int == 0) {
            textView.keyboardType = .twitter
        } else {
            textView.keyboardType = .default
        }
        textView.keyboardAppearance = Colours.keyCol
        textView.backgroundColor = Colours.white
        textView.textColor = Colours.grayDark
        textView.text = self.editListName
        self.view.addSubview(textView)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        context1.frame = CGRect(x: 15, y: offset + 100, width: 50, height: 50)
        context1.setImage(UIImage(named: "filledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        context1.backgroundColor = UIColor.clear
        context1.addTarget(self, action: #selector(context1Tapped), for: .touchUpInside)
        let context1Text = UILabel()
        context1Text.frame = CGRect(x: 55, y: 0, width: 200, height: 50)
        context1Text.text = "Home"
        context1Text.textColor = Colours.grayDark
        context1Text.textAlignment = .left
        context1Text.font = UIFont.systemFont(ofSize: 16)
        context1.addSubview(context1Text)
        self.view.addSubview(context1)
        
        context2.frame = CGRect(x: 15, y: offset + 155, width: 50, height: 50)
        context2.setImage(UIImage(named: "filledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        context2.backgroundColor = UIColor.clear
        context2.addTarget(self, action: #selector(context2Tapped), for: .touchUpInside)
        let context2Text = UILabel()
        context2Text.frame = CGRect(x: 55, y: 0, width: 200, height: 50)
        context2Text.text = "Mentions"
        context2Text.textColor = Colours.grayDark
        context2Text.textAlignment = .left
        context2Text.font = UIFont.systemFont(ofSize: 16)
        context2.addSubview(context2Text)
        self.view.addSubview(context2)
        
        context3.frame = CGRect(x: 15, y: offset + 210, width: 50, height: 50)
        context3.setImage(UIImage(named: "filledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        context3.backgroundColor = UIColor.clear
        context3.addTarget(self, action: #selector(context3Tapped), for: .touchUpInside)
        let context3Text = UILabel()
        context3Text.frame = CGRect(x: 55, y: 0, width: 200, height: 50)
        context3Text.text = "Public"
        context3Text.textColor = Colours.grayDark
        context3Text.textAlignment = .left
        context3Text.font = UIFont.systemFont(ofSize: 16)
        context3.addSubview(context3Text)
        self.view.addSubview(context3)
        
        context4.frame = CGRect(x: 15, y: offset + 265, width: 50, height: 50)
        context4.setImage(UIImage(named: "filledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        context4.backgroundColor = UIColor.clear
        context4.addTarget(self, action: #selector(context4Tapped), for: .touchUpInside)
        let context4Text = UILabel()
        context4Text.frame = CGRect(x: 55, y: 0, width: 200, height: 50)
        context4Text.text = "Threads"
        context4Text.textColor = Colours.grayDark
        context4Text.textAlignment = .left
        context4Text.font = UIFont.systemFont(ofSize: 16)
        context4.addSubview(context4Text)
        self.view.addSubview(context4)
    }
    
    @objc func context1Tapped() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        if context1Type == true {
            context1.setImage(UIImage(named: "unfilledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.context1Type = false
        } else if context1Type == false {
            context1.setImage(UIImage(named: "filledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.context1Type = true
        }
    }
    
    @objc func context2Tapped() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        if context2Type == true {
            context2.setImage(UIImage(named: "unfilledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.context2Type = false
        } else  if context2Type == false {
            context2.setImage(UIImage(named: "filledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.context2Type = true
        }
    }
    
    @objc func context3Tapped() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        if context3Type == true {
            context3.setImage(UIImage(named: "unfilledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.context3Type = false
        } else if context3Type == false {
            context3.setImage(UIImage(named: "filledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.context3Type = true
        }
    }
    
    @objc func context4Tapped() {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        if context4Type == true {
            context4.setImage(UIImage(named: "unfilledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.context4Type = false
        } else if context4Type == false {
            context4.setImage(UIImage(named: "filledset")?.maskWithColor(color: Colours.tabSelected), for: .normal)
            self.context4Type = true
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyHeight = Int(keyboardHeight)
            self.updateTweetView()
        }
    }
    
    func updateTweetView() {
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
            case 2436, 1792:
                offset = 88
                closeB = 47
            default:
                offset = 64
                closeB = 24
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        bgView.frame = CGRect(x:0, y:Int(self.view.bounds.height) - 50 - Int(self.keyHeight), width:Int(self.view.bounds.width), height:Int(self.keyHeight) + 50)
        textView.frame = CGRect(x:20, y:offset + 45, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(120) - Int(self.keyHeight))
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            self.textView.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTouchUpInsideCloseButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        self.textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if (UserDefaults.standard.object(forKey: "keyhap") == nil) || (UserDefaults.standard.object(forKey: "keyhap") as! Int == 0) {
            
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 1) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 2) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        if (textView.text?.count)! > 0 {
            tootLabel.setTitleColor(Colours.tabSelected, for: .normal)
        } else {
            tootLabel.setTitleColor(Colours.grayDark.withAlphaComponent(0.38), for: .normal)
        }
    }
    
    
    @objc func didTouchUpInsideTootButton(_ sender: AnyObject) {
        if self.textView.text == "" { return }
        
        var con: [Context2] = [.home, .notifications, .public, .thread]
        if self.context1Type == false {
            con = con.filter { if case .home = $0 { return false } else { return true } }
        }
        if self.context2Type == false {
            con = con.filter { if case .notifications = $0 { return false } else { return true } }
        }
        if self.context3Type == false {
            con = con.filter { if case .public = $0 { return false } else { return true } }
        }
        if self.context4Type == false {
            con = con.filter { if case .thread = $0 { return false } else { return true } }
        }
        
        let request = FilterToots.create(phrase: self.textView.text, context: con)
        StoreStruct.client.run(request) { (statuses) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshfilter"), object: nil)
            }
        }
        
        self.textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}
