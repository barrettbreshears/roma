//
//  PadLoginViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 13/06/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class PadLoginViewController: UIViewController, UITextFieldDelegate {
    
    var newInstance = false
    var closeButton = MNGExpandedTouchAreaButton()
    var loginLogo = UIImageView()
    var loginLabel = UILabel()
    var textField = PaddedTextField()
    var safariVC: SFSafariViewController?
    var tagListView = DLTagView()
    var keyHeight = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.loginLogo.frame = CGRect(x: self.view.bounds.width/2 - 40, y: self.view.bounds.height/4 - 40, width: 80, height: 80)
        self.loginLogo.image = UIImage(named: "logLogo")
        self.loginLogo.contentMode = .scaleAspectFit
        self.loginLogo.backgroundColor = UIColor.clear
        self.view.addSubview(self.loginLogo)
        
        self.loginLogo.translatesAutoresizingMaskIntoConstraints = false
        self.loginLogo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(110)).isActive = true
        self.loginLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.loginLogo.width(80).isActive = true
        self.loginLogo.height(80).isActive = true
        
        self.loginLabel.frame = CGRect(x: 50, y: Int(self.view.bounds.height) - self.keyHeight - 180, width: Int(self.view.bounds.width - 100), height: 35)
        self.loginLabel.text = "Instance name:".localized
        self.loginLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        self.loginLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(self.loginLabel)
        
        self.textField.frame = CGRect(x: 40, y: Int(self.view.bounds.height) - self.keyHeight - 140, width: Int(self.view.bounds.width - 80), height: 45)
        self.textField.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        self.textField.borderStyle = .none
        self.textField.layer.cornerRadius = 10
        self.textField.textColor = UIColor.white
        self.textField.spellCheckingType = .no
        self.textField.returnKeyType = .done
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.textField.delegate = self
        self.textField.attributedPlaceholder = NSAttributedString(string: "mastodon.social",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: Colours.tabSelected])
        self.view.addSubview(self.textField)
        
        tagListView.alpha = 1
        tagListView.frame = CGRect(x: 0, y: Int(self.view.bounds.height) - self.keyHeight - 70, width: Int(self.view.bounds.width), height: 60)
        self.view.addSubview(tagListView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.textField.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyHeight = Int(keyboardHeight)
            self.tagListView.frame = CGRect(x: 0, y: Int(self.view.bounds.height) - self.keyHeight - 70, width: Int(self.view.bounds.width), height: 60)
            self.textField.frame = CGRect(x: 40, y: Int(self.view.bounds.height) - self.keyHeight - 140, width: Int(self.view.bounds.width - 80), height: 45)
            self.loginLabel.frame = CGRect(x: 50, y: Int(self.view.bounds.height) - self.keyHeight - 180, width: Int(self.view.bounds.width - 100), height: 35)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.keyHeight = Int(0)
        self.tagListView.frame = CGRect(x: 0, y: Int(self.view.bounds.height) - self.keyHeight - 70, width: Int(self.view.bounds.width), height: 60)
        self.textField.frame = CGRect(x: 40, y: Int(self.view.bounds.height) - self.keyHeight - 140, width: Int(self.view.bounds.width - 80), height: 45)
        self.loginLabel.frame = CGRect(x: 50, y: Int(self.view.bounds.height) - self.keyHeight - 180, width: Int(self.view.bounds.width - 100), height: 35)
    }
    
    @objc func tappedOnTag() {
        self.textField.text = StoreStruct.tappedTag
    }
    
    @objc func padIsLogged() {
        self.safariVC?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refpush1"), object: nil)
        
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "presentIntro00"), object: nil)
        })
    }
    
    @objc func didTouchUpInsideCloseButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colours.tabSelected
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tappedOnTag), name: NSNotification.Name(rawValue: "tappedOnTag"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.padIsLogged), name: NSNotification.Name(rawValue: "padIsLogged"), object: nil)
        
        if self.newInstance {
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
            self.closeButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 15, y: 20, width: 32, height: 32)))
            self.closeButton.setImage(UIImage(named: "block")?.maskWithColor(color: Colours.grayLight2), for: .normal)
            self.closeButton.alpha = 0.3
            self.closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.closeButton.adjustsImageWhenHighlighted = false
            self.closeButton.addTarget(self, action: #selector(didTouchUpInsideCloseButton), for: .touchUpInside)
            self.view.addSubview(self.closeButton)
        }
        
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
                        tag.backgroundColor = Colours.grayLight2.withAlphaComponent(0.3)
                        tag.borderWidth = 0
                        tag.textColor = UIColor.white
                        tag.cornerRadius = 12
                        tag.enabled = true
                        tag.altText = "\(x.name)"
                        tag.padding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
                        self.tagListView.addTag(tag: tag)
                        self.tagListView.singleLine = true
                    }
                }
            } catch {
                print("err")
            }
        }
        task.resume()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        let wid = self.view.bounds.width - 20
        let he = Int(self.view.bounds.height) - fromTop - fromTop
        
        
        springWithDelay(duration: 0.75, delay: 0.02, animations: {
            self.textField.transform = CGAffineTransform(translationX: 0, y: -40)
        })
        springWithDelay(duration: 0.6, delay: 0, animations: {
            self.loginLabel.transform = CGAffineTransform(translationX: 0, y: -40)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            let returnedText = textField.text ?? ""
            if returnedText == "" || returnedText == " " || returnedText == "  " {
                
            } else {
                
                DispatchQueue.main.async {
                    self.textField.resignFirstResponder()
                    
                    if self.newInstance {
                        
                        StoreStruct.newInstance = InstanceData()
                        StoreStruct.newClient = Client(baseURL: "https://\(returnedText)")
                        let request = Clients.register(
                            clientName: "Mast",
                            redirectURI: "com.shi.mastodon://addNewInstance",
                            scopes: [.read, .write, .follow, .push],
                            website: "https://twitter.com/jpeguin"
                        )
                        StoreStruct.newClient.run(request) { (application) in
                            if application.value == nil {
                                
                                DispatchQueue.main.async {
                                    
                                    
                                    Alertift.actionSheet(title: "Not a valid instance (may be closed or dead)", message: "Please enter an instance name like mastodon.social or mastodon.technology, or use one from the list to get started. You can sign in if you already have an account registered with the instance, or you can choose to sign up with a new account.")
                                        .backgroundColor(Colours.white)
                                        .titleTextColor(Colours.grayDark)
                                        .messageTextColor(Colours.grayDark)
                                        .messageTextAlignment(.left)
                                        .titleTextAlignment(.left)
                                        .action(.default("Find out more".localized), image: UIImage(named: "share")) { (action, ind) in
                                            
                                            let queryURL = URL(string: "https://joinmastodon.org")!
                                            UIApplication.shared.open(queryURL, options: [.universalLinksOnly: true]) { (success) in
                                                if !success {
                                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                                        self.safariVC = SFSafariViewController(url: queryURL)
                                                        self.present(self.safariVC!, animated: true, completion: nil)
                                                    } else {
                                                        UIApplication.shared.open(queryURL)
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
                                        .popover(anchorView: self.view)
                                        .show(on: self)
                                    
                                    
                                }
                                
                            } else {
                                
                                
                                
                                let application = application.value!
                                
                                StoreStruct.newInstance?.clientID = application.clientID
                                StoreStruct.newInstance?.clientSecret = application.clientSecret
                                StoreStruct.newInstance?.returnedText = returnedText
                                
                                DispatchQueue.main.async {
                                    StoreStruct.newInstance?.redirect = "com.shi.mastodon://addNewInstance".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                                    let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.newInstance!.redirect)&scope=read%20write%20follow%20push&client_id=\(application.clientID)")!
                                    UIApplication.shared.open(queryURL, options: [.universalLinksOnly: true]) { (success) in
                                        if !success {
                                            if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                                self.safariVC = SFSafariViewController(url: queryURL)
                                                self.present(self.safariVC!, animated: true, completion: nil)
                                            } else {
                                                UIApplication.shared.openURL(queryURL)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        StoreStruct.client = Client(baseURL: "https://\(returnedText)")
                        let request = Clients.register(
                            clientName: "Mast",
                            redirectURI: "com.shi.mastodon://success",
                            scopes: [.read, .write, .follow, .push],
                            website: "https://twitter.com/jpeguin"
                        )
                        StoreStruct.client.run(request) { (application) in
                            if application.value == nil {
                                
                                DispatchQueue.main.async {
                                    
                                    
                                    Alertift.actionSheet(title: "Not a valid instance (may be closed or dead)", message: "Please enter an instance name like mastodon.social or mastodon.technology, or use one from the list to get started. You can sign in if you already have an account registered with the instance, or you can choose to sign up with a new account.")
                                        .backgroundColor(Colours.white)
                                        .titleTextColor(Colours.grayDark)
                                        .messageTextColor(Colours.grayDark)
                                        .messageTextAlignment(.left)
                                        .titleTextAlignment(.left)
                                        .action(.default("Find out more".localized), image: UIImage(named: "share")) { (action, ind) in
                                            
                                            let queryURL = URL(string: "https://joinmastodon.org")!
                                            UIApplication.shared.open(queryURL, options: [.universalLinksOnly: true]) { (success) in
                                                if !success {
                                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                                        self.safariVC = SFSafariViewController(url: queryURL)
                                                        self.present(self.safariVC!, animated: true, completion: nil)
                                                    } else {
                                                        UIApplication.shared.openURL(queryURL)
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
                                        .popover(anchorView: self.view)
                                        .show(on: self)
                                    
                                }
                                
                            } else {
                                let application = application.value!
                                
                                StoreStruct.currentInstance.clientID = application.clientID
                                StoreStruct.currentInstance.clientSecret = application.clientSecret
                                StoreStruct.currentInstance.returnedText = returnedText
                                
                                DispatchQueue.main.async {
                                    
                                    self.tagListView.alpha = 0
                                    
                                    StoreStruct.currentInstance.redirect = "com.shi.mastodon://success".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                                    let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.currentInstance.redirect)&scope=read%20write%20follow%20push&client_id=\(application.clientID)")!
                                    UIApplication.shared.open(queryURL, options: [.universalLinksOnly: true]) { (success) in
                                        if !success {
                                            if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                                self.safariVC = SFSafariViewController(url: queryURL)
                                                self.present(self.safariVC!, animated: true, completion: nil)
                                            } else {
                                                UIApplication.shared.openURL(queryURL)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return true
    }
    
}
