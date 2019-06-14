//
//  NewInstanceViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 15/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import StatusAlert

class NewInstanceViewController: UIViewController, UITextFieldDelegate {
    
    var closeButton = MNGExpandedTouchAreaButton()
    var tootLabel = UIButton()
    var textView = UITextField()
    var keyHeight = 0
    var bgView = UIView()
    var titleV = UILabel()
    var editListName = ""
    var listID = ""
    var tagListView = DLTagView()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        if self.editListName == "" {
            tootLabel.setTitle("Go", for: .normal)
        } else {
            tootLabel.setTitle("Go", for: .normal)
        }
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tappedOnTag), name: NSNotification.Name(rawValue: "tappedOnTag"), object: nil)
        
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
        
        titleV.frame = CGRect(x: 24, y: offset + 6, width: Int(self.view.bounds.width), height: 30)
        if self.editListName == "" {
            titleV.text = "Enter Instance Name".localized
        } else {
            titleV.text = "Enter Instance Name".localized
        }
        titleV.textColor = Colours.grayDark2
        titleV.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        self.view.addSubview(titleV)
        
        textView.frame = CGRect(x:20, y: offset + 45, width:Int(self.view.bounds.width - 40), height:Int(50))
        textView.font = UIFont.systemFont(ofSize: Colours.fontSize1 + 2)
        textView.tintColor = Colours.tabSelected
        textView.autocorrectionType = .no
        textView.delegate = self
        textView.becomeFirstResponder()
        if (UserDefaults.standard.object(forKey: "keyb") == nil) || (UserDefaults.standard.object(forKey: "keyb") as! Int == 0) {
            textView.keyboardType = .twitter
        } else {
            textView.keyboardType = .default
        }
        textView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textView.attributedPlaceholder = NSAttributedString(string: "e.g. mastodon.social",
                                                            attributes: [NSAttributedString.Key.foregroundColor: Colours.tabUnselected])
        textView.keyboardAppearance = Colours.keyCol
        textView.backgroundColor = Colours.white
        textView.textColor = Colours.grayDark
        textView.text = self.editListName
        self.view.addSubview(textView)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        self.tagListView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tagListView.frame = CGRect(x: 0, y: Int(self.view.bounds.height) - self.keyHeight - 70, width: Int(self.view.bounds.width), height: 60)
        self.view.addSubview(tagListView)
        
        let urlStr = "https://instances.social/api/1.0/instances/list?count=\(100)&include_closed=\(false)&include_down=\(false)"
        let url: URL = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer 8gVQzoU62VFjvlrdnBUyAW8slAekA5uyuwdMi0CBzwfWwyStkqQo80jTZemuSGO8QomSycdD1JYgdRUnJH0OVT3uYYUilPMenrRZupuMQLl9hVt6xnhV6bwdXVSAT1wR", forHTTPHeaderField: "Authorization")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: request) { (data, response, err) in
            do {
                let json = try JSONDecoder().decode(tagInstances.self, from: data ?? Data())
                for x in json.instances {
                    DispatchQueue.main.async {
                        var tag = DLTag(text: "\(x.name)")
                        tag.fontSize = 15
                        tag.backgroundColor = Colours.grayLight2
                        tag.borderWidth = 0
                        tag.textColor = UIColor.white
                        tag.cornerRadius = 12
                        tag.enabled = true
                        tag.altText = "\(x.name)"
                        tag.padding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
                        self.tagListView.addTag(tag: tag)
                        self.tagListView.singleLine = true
                        springWithDelay(duration: 0.5, delay: 0, animations: {
                            self.tagListView.alpha = 0
                        })
                    }
                }
            } catch {
                print("err")
            }
        }
        task.resume()
    }
    
    @objc func tappedOnTag() {
        
        self.textView.text = StoreStruct.tappedTag
        tootLabel.setTitleColor(Colours.tabSelected, for: .normal)
        
        //        print(StoreStruct.tappedTag)
        //        StoreStruct.client = Client(baseURL: "http://\(StoreStruct.tappedTag)")
        //        let request = Clients.register(
        //            clientName: "Mast",
        //            redirectURI: "com.shi.mastodon://success",
        //            scopes: [.read, .write, .follow, .push],
        //            website: "https://twitter.com/jpeguin"
        //        )
        //        StoreStruct.client.run(request) { (application) in
        //
        //            print("the application: \(application)")
        //
        //            if application.value == nil {
        //
        //
        //                var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        //                var offset = 88
        //                var newoff = 45
        //                if UIDevice().userInterfaceIdiom == .phone {
        //                    switch UIScreen.main.nativeBounds.height {
        //                    case 2688:
        //                        offset = 88
        //                        newoff = 45
        //                    case 2436, 1792:
        //                        offset = 88
        //                        newoff = 45
        //                    default:
        //                        offset = 64
        //                        newoff = 24
        //                        tabHeight = Int(UITabBarController().tabBar.frame.size.height)
        //                    }
        //                }
        //
        //
        //                DispatchQueue.main.async {
        //                    let statusAlert = StatusAlert()
        //                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
        //                    statusAlert.title = "Not a valid Instance".localized
        //                    statusAlert.contentColor = Colours.grayDark
        //                    statusAlert.message = "Please enter an Instance name like mastodon.technology"
        //                    statusAlert.show(in: self.view, withVerticalPosition: .top(offset: CGFloat(offset + 10)))
        //                }
        //
        //            } else {
        //
        //
        //                DispatchQueue.main.async {
        //                    // go to next view
        //                    StoreStruct.currentInstance.instanceText = self.textView.text ?? ""
        //
        //                    if StoreStruct.instanceLocalToAdd.contains(StoreStruct.currentInstance.instanceText.lowercased()) {} else {
        //                        StoreStruct.instanceLocalToAdd.append(StoreStruct.currentInstance.instanceText.lowercased())
        //                        UserDefaults.standard.set(StoreStruct.instanceLocalToAdd, forKey: "instancesLocal")
        //                    }
        //                    self.textView.resignFirstResponder()
        //                    self.dismiss(animated: true, completion: nil)
        //
        //                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadLists"), object: nil)
        //                    if StoreStruct.currentPage == 0 {
        //                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance"), object: self)
        //                    } else if StoreStruct.currentPage == 1 {
        //                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance2"), object: self)
        //                    } else {
        //                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance3"), object: self)
        //                    }
        //                }
        //
        //            }
        //        }
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
        textView.frame = CGRect(x:20, y:offset + 45, width:Int(self.view.bounds.width - 40), height:Int(50))
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
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
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
//        StoreStruct.client = Client(baseURL: "https://\(self.textView.text!)")
//        let request = Clients.register(
//            clientName: "Mast",
//            redirectURI: "com.shi.mastodon://success",
//            scopes: [.read, .write, .follow, .push],
//            website: "https://twitter.com/jpeguin"
//        )
        
        
//        let testClient = Client(
//            baseURL: "https://\(self.textView.text!)",
//            accessToken: StoreStruct.currentInstance.accessToken
//        )
//
//        let request = Timelines.public(local: true, range: .max(id: self.textView.text ?? "", limit: nil))
//
//        testClient.run(request) { (application) in
//
//
//            DispatchQueue.main.async {
//
//                if application.value == nil {
//
//
//                    var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
//                    var offset = 88
//                    var newoff = 45
//                    if UIDevice().userInterfaceIdiom == .phone {
//                        switch UIScreen.main.nativeBounds.height {
//                        case 2688:
//                            offset = 88
//                            newoff = 45
//                        case 2436, 1792:
//                            offset = 88
//                            newoff = 45
//                        default:
//                            offset = 64
//                            newoff = 24
//                            tabHeight = Int(UITabBarController().tabBar.frame.size.height)
//                        }
//                    }
//
//
//                    DispatchQueue.main.async {
//                        let statusAlert = StatusAlert()
//                        statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
//                        statusAlert.title = "Not a valid Instance (may be closed or dead)".localized
//                        statusAlert.contentColor = Colours.grayDark
//                        statusAlert.message = "Please enter an Instance name like mastodon.technology"
//                        statusAlert.show(in: self.view, withVerticalPosition: .top(offset: CGFloat(offset + 10)))
//                    }
//
//                } else {
        
                    
                    DispatchQueue.main.async {
                        // go to next view
                        StoreStruct.currentInstance.instanceText = self.textView.text ?? ""
                        StoreStruct.instanceText = self.textView.text ?? ""
                        
                        if StoreStruct.instanceLocalToAdd.contains(StoreStruct.currentInstance.instanceText.lowercased()) {} else {
                            StoreStruct.instanceLocalToAdd.append(StoreStruct.currentInstance.instanceText.lowercased())
                            UserDefaults.standard.set(StoreStruct.instanceLocalToAdd, forKey: "instancesLocal")
                        }
                        self.textView.resignFirstResponder()
                        self.dismiss(animated: true, completion: nil)
                        
                        if StoreStruct.currentPage == 0 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance"), object: self)
                        } else if StoreStruct.currentPage == 1 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance2"), object: self)
                        } else if StoreStruct.currentPage == 101010 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance3"), object: self)
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance4"), object: self)
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadLists"), object: nil)
                    }
                    
//                }
//            }
//        }
        
        
        
        
        
    }
}



