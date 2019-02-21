//
//  PadLogInViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 29/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import StatusAlert

class PadLogInViewController: UIViewController, UITextFieldDelegate {
    
    var loginBG = UIView()
    var loginLogo = UIImageView()
    var loginLabel = UILabel()
    var textField = PaddedTextField()
    var safariVC: SFSafariViewController?
    var statusBarView = UIView()
    var searcherView = UIView()
    var searchTextField = UITextField()
    var backgroundView = UIButton()
    let volumeBar = VolumeBar.shared
    var newInstance = false
    var loadingAdditionalInstance = false
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            print("Swipe Down")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.logged), name: NSNotification.Name(rawValue: "logged2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newInstanceLogged), name: NSNotification.Name(rawValue: "newInstancelogged2"), object: nil)
        self.view.backgroundColor = Colours.white
        print("didload123")
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.loginBG.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.loginBG.backgroundColor = Colours.tabSelected
        self.view.addSubview(self.loginBG)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.createLoginView()
    }
    
    func createLoginView(newInstance:Bool = false) {
        self.newInstance = newInstance
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.loginBG.addGestureRecognizer(swipeDown)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.loginBG.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.loginBG.backgroundColor = Colours.tabSelected
                self.view.addSubview(self.loginBG)
//        window.addSubview(self.loginBG)
        
        self.loginLogo.frame = CGRect(x: self.view.bounds.width/2 - 40, y: self.view.bounds.height/4 - 40, width: 80, height: 80)
        self.loginLogo.image = UIImage(named: "logLogo")
        self.loginLogo.contentMode = .scaleAspectFit
        self.loginLogo.backgroundColor = UIColor.clear
                self.view.addSubview(self.loginLogo)
//        window.addSubview(self.loginLogo)
        
        self.loginLabel.frame = CGRect(x: 50, y: self.view.bounds.height/2 - 57.5, width: self.view.bounds.width - 80, height: 35)
        self.loginLabel.text = "Pelorma instance:".localized
        self.loginLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        self.loginLabel.font = UIFont.systemFont(ofSize: 14)
                self.view.addSubview(self.loginLabel)
//        window.addSubview(self.loginLabel)
        
        self.textField.frame = CGRect(x: 40, y: self.view.bounds.height/2 - 22.5, width: self.view.bounds.width - 80, height: 45)
        self.textField.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        self.textField.borderStyle = .none
        self.textField.layer.cornerRadius = 10
        self.textField.textColor = UIColor.white
        self.textField.spellCheckingType = .no
        self.textField.returnKeyType = .done
        self.textField.autocapitalizationType = .none
        self.textField.delegate = self
        self.textField.attributedPlaceholder = NSAttributedString(string: "mastodon.technology",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: Colours.tabSelected])
                self.view.addSubview(self.textField)
//        window.addSubview(self.textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436:
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
        
        //        if textField.text == "" {} else {
        //            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
        //            springWithDelay(duration: 0.5, delay: 0, animations: {
        //                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
        //            })
        //            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
        //            springWithDelay(duration: 0.5, delay: 0, animations: {
        //                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
        //            })
        //        }
    }
    
    //    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        return true
    //    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        if textField == self.searchTextField {
//
//            return true
//
//            //            var fromTop = 45
//            //            if UIDevice().userInterfaceIdiom == .phone {
//            //                switch UIScreen.main.nativeBounds.height {
//            //                case 2688:
//            //                    print("iPhone Xs Max")
//            //                    fromTop = 45
//            //                case 2436:
//            //                    print("iPhone X")
//            //                    fromTop = 45
//            //                default:
//            //                    fromTop = 22
//            //                }
//            //            }
//            //
//            //            let wid = self.view.bounds.width - 20
//            //            let he = Int(self.view.bounds.height) - fromTop - fromTop
//            //
//            //            textField.resignFirstResponder()
//            //
//            //            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
//            //            springWithDelay(duration: 0.5, delay: 0, animations: {
//            //                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
//            //            })
//            //            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
//            //            springWithDelay(duration: 0.5, delay: 0, animations: {
//            //                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
//            //            })
//            //
//            //            return true
//
//
//        } else {
//
//            let returnedText = textField.text ?? ""
//            if returnedText == "" || returnedText == " " || returnedText == "  " {
//
//            } else {
//
//
//                DispatchQueue.main.async {
//                    self.textField.resignFirstResponder()
//                }
//
//                // Send off returnedText to client
//                StoreStruct.client = Client(baseURL: "https://\(returnedText)")
//                let request = Clients.register(
//                    clientName: "Mast",
//                    redirectURI: "com.shi.mastodon://success",
//                    scopes: [.read, .write, .follow, .push],
//                    website: "https://twitter.com/jpeguin"
//                )
//                StoreStruct.client.run(request) { (application) in
//
//                    if application.value == nil {
//
//                        DispatchQueue.main.async {
//                            let statusAlert = StatusAlert()
//                            statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
//                            statusAlert.title = "Not a valid Instance".localized
//                            statusAlert.contentColor = Colours.grayDark
//                            statusAlert.message = "Please enter an Instance name like mastodon.technology"
//                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
//                        statusAlert.show()
//                    }
//                        }
//
//                    } else {
//                        let application = application.value!
//
//                        StoreStruct.shared.currentInstance.clientID = application.clientID
//                        StoreStruct.shared.currentInstance.clientSecret = application.clientSecret
//                        StoreStruct.shared.currentInstance.returnedText = returnedText
//
//                        DispatchQueue.main.async {
//                            StoreStruct.shared.currentInstance.redirect = "com.shi.mastodon://success".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//                            let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.shared.currentInstance.redirect)&scope=read%20write%20follow&client_id=\(application.clientID)")!
//                            self.safariVC = SFSafariViewController(url: queryURL)
//                            self.present(self.safariVC!, animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//            return true
//
//        }
//    }
    
    
    
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.searchTextField {
            
//            var fromTop = 45
//            if UIDevice().userInterfaceIdiom == .phone {
//                switch UIScreen.main.nativeBounds.height {
//                case 2688:
//                    print("iPhone Xs Max")
//                    fromTop = 45
//                case 2436, 1792:
//                    print("iPhone X")
//                    fromTop = 45
//                default:
//                    fromTop = 22
//                }
//            }
//
//            let wid = self.view.bounds.width - 20
//            let he = Int(self.view.bounds.height) - fromTop - fromTop
//
//            textField.resignFirstResponder()
//
//            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
//            springWithDelay(duration: 0.5, delay: 0, animations: {
//                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
//            })
//            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
//            springWithDelay(duration: 0.5, delay: 0, animations: {
//                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
//            })
            
            return true
            
            
        } else {
            
            let returnedText = textField.text ?? ""
            if returnedText == "" || returnedText == " " || returnedText == "  " {
                
            } else {
                
                
                DispatchQueue.main.async {
                    self.textField.resignFirstResponder()
                }
                
                
                // Send off returnedText to client
                if newInstance {
                    
                    StoreStruct.shared.newInstance = InstanceData()
                    StoreStruct.shared.newClient = Client(baseURL: "https://\(returnedText)")
                    let request = Clients.register(
                        clientName: "Roma",
                        redirectURI: "com.vm.roma://addNewInstance",
                        scopes: [.read, .write, .follow],
                        website: "https://twitter.com/jpeguin"
                    )
                    StoreStruct.shared.newClient.run(request) { (application) in
                        
                        if application.value == nil {
                            
                            DispatchQueue.main.async {
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Not a valid Instance".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = "Please enter an Instance name like mastodon.technology"
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                            }
                            
                        } else {
                            let application = application.value!
                            
                            StoreStruct.shared.newInstance?.clientID = application.clientID
                            StoreStruct.shared.newInstance?.clientSecret = application.clientSecret
                            StoreStruct.shared.newInstance?.returnedText = returnedText
                            
                            DispatchQueue.main.async {
                                StoreStruct.shared.newInstance?.redirect = "com.vm.roma://addNewInstance".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                                let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.shared.newInstance!.redirect)&scope=read%20write%20follow&client_id=\(application.clientID)")!
                                self.safariVC = SFSafariViewController(url: queryURL)
                                self.present(self.safariVC!, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    StoreStruct.client = Client(baseURL: "https://\(returnedText)")
                    let request = Clients.register(
                        clientName: "Mast",
                        redirectURI: "com.vm.roma://success",
                        scopes: [.read, .write, .follow],
                        website: "https://twitter.com/jpeguin"
                    )
                    StoreStruct.client.run(request) { (application) in
                        
                        if application.value == nil {
                            
                            DispatchQueue.main.async {
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Not a valid Instance".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = "Please enter an Instance name like mastodon.technology"
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                            }
                            
                        } else {
                            let application = application.value!
                            
                            StoreStruct.shared.currentInstance.clientID = application.clientID
                            StoreStruct.shared.currentInstance.clientSecret = application.clientSecret
                            StoreStruct.shared.currentInstance.returnedText = returnedText
                            
                            DispatchQueue.main.async {
                                StoreStruct.shared.currentInstance.redirect = "com.vm.roma://success".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                                let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.shared.currentInstance.redirect)&scope=read%20write%20follow&client_id=\(application.clientID)")!
                                self.safariVC = SFSafariViewController(url: queryURL)
                                self.present(self.safariVC!, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
                
                
            }
            return true
            
        }
    }
    
    
    
    
    
    
    
//    @objc func logged() {
//
//        self.loginBG.removeFromSuperview()
//        self.loginLogo.removeFromSuperview()
//        self.loginLabel.removeFromSuperview()
//        self.textField.removeFromSuperview()
////        self.safariVC!.dismiss(animated: true, completion: nil)
//
//        var request = URLRequest(url: URL(string: "https://\(StoreStruct.shared.currentInstance.returnedText)/oauth/token?grant_type=authorization_code&code=\(StoreStruct.shared.currentInstance.authCode)&redirect_uri=\(StoreStruct.shared.currentInstance.redirect)&client_id=\(StoreStruct.shared.currentInstance.clientID)&client_secret=\(StoreStruct.shared.currentInstance.clientSecret)")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//            guard error == nil else { return }
//            guard let data = data else { return }
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                    print(json)
//
//                    DispatchQueue.main.async {
//                        var customStyle = VolumeBarStyle.likeInstagram
//                        customStyle.trackTintColor = Colours.cellQuote
//                        customStyle.progressTintColor = Colours.grayDark
//                        customStyle.backgroundColor = Colours.white
//                        self.volumeBar.style = customStyle
//                        //self.volumeBar.start()
//                        //self.volumeBar.showInitial()
//
//                        StoreStruct.shared.currentInstance.accessToken = (json["access_token"] as! String)
//                        StoreStruct.client.accessToken = StoreStruct.shared.currentInstance.accessToken
//
//                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.clientID, forKey: "clientID")
//                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.clientSecret, forKey: "clientSecret")
//                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.authCode, forKey: "authCode")
//                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.accessToken, forKey: "accessToken2")
//                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.returnedText, forKey: "returnedText")
//                    }
//
//
//
//                    let request = Timelines.home()
//                    StoreStruct.client.run(request) { (statuses) in
//                        if let stat = (statuses.value) {
//                            StoreStruct.statusesHome = stat
//                            StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
//                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
//                        }
//                    }
//
//
//
//                    print("fetchingall09")
//
//                        if StoreStruct.statusesLocal.isEmpty {
//                            let request = Timelines.public(local: true, range: .default)
//                            StoreStruct.client.run(request) { (statuses) in
//                                if let stat = (statuses.value) {
//                                    StoreStruct.statusesLocal = stat
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
//                                }
//                            }
//                        }
//
//
//                        if StoreStruct.statusesFederated.isEmpty {
//                            let request = Timelines.public(local: false, range: .default)
//                            StoreStruct.client.run(request) { (statuses) in
//                                if let stat = (statuses.value) {
//                                    StoreStruct.statusesFederated = stat
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
//                                }
//                            }
//                        }
//
//
//
//
//                    let request2 = Accounts.currentUser()
//                    StoreStruct.client.run(request2) { (statuses) in
//                        if let stat = (statuses.value) {
//                            StoreStruct.currentUser = stat
//
//                            DispatchQueue.main.async {
//                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
//                            }
//                        }
//                    }
//
//
//                    self.dismiss(animated: true, completion: nil)
//                    self.dismiss(animated: true, completion: nil)
//
//                    // onboarding
//                    //                    if (UserDefaults.standard.object(forKey: "onb") == nil) || (UserDefaults.standard.object(forKey: "onb") as! Int == 0) {
//                    //                        DispatchQueue.main.async {
//                    //                            self.bulletinManager.prepare()
//                    //                            self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
//                    //                        }
//                    //                    }
//
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
//
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        })
//        task.resume()
//
//    }
    
    
    
    
    @objc func logged() {
        
        self.loginBG.removeFromSuperview()
        self.loginLogo.removeFromSuperview()
        self.loginLabel.removeFromSuperview()
        self.textField.removeFromSuperview()
        self.safariVC?.dismiss(animated: true, completion: nil)
        
        print("11111")
        print(StoreStruct.shared.currentInstance.returnedText)
        print(StoreStruct.shared.currentInstance.authCode)
        print(StoreStruct.shared.currentInstance.redirect)
        print(StoreStruct.shared.currentInstance.clientID)
        print(StoreStruct.shared.currentInstance.clientSecret)
        
        var request = URLRequest(url: URL(string: "https://\(StoreStruct.shared.currentInstance.returnedText)/oauth/token?grant_type=authorization_code&code=\(StoreStruct.shared.currentInstance.authCode)&redirect_uri=\(StoreStruct.shared.currentInstance.redirect)&client_id=\(StoreStruct.shared.currentInstance.clientID)&client_secret=\(StoreStruct.shared.currentInstance.clientSecret)&scope=read%20write%20follow%20push")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else { print(error);return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print("00000")
                    print(json)
                    
                    if StoreStruct.doOnce {
                    DispatchQueue.main.async {
                        var customStyle = VolumeBarStyle.likeInstagram
                        customStyle.trackTintColor = Colours.cellQuote
                        customStyle.progressTintColor = Colours.grayDark
                        customStyle.backgroundColor = Colours.white
                        self.volumeBar.style = customStyle
                        //self.volumeBar.start()
                        //self.volumeBar.showInitial()
                        print("000")
                        print(json["access_token"])
                        StoreStruct.shared.currentInstance.accessToken = (json["access_token"]! as! String)
                        StoreStruct.client.accessToken = StoreStruct.shared.currentInstance.accessToken
                        print(StoreStruct.shared.currentInstance.accessToken)
                        
                        let currentInstance = InstanceData(clientID: StoreStruct.shared.currentInstance.clientID, clientSecret: StoreStruct.shared.currentInstance.clientSecret, authCode: StoreStruct.shared.currentInstance.authCode, accessToken: StoreStruct.shared.currentInstance.accessToken, returnedText: StoreStruct.shared.currentInstance.returnedText, redirect:StoreStruct.shared.currentInstance.redirect)
                        
                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.clientID, forKey: "clientID")
                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.clientSecret, forKey: "clientSecret")
                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.authCode, forKey: "authCode")
                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.accessToken, forKey: "accessToken2")
                        UserDefaults.standard.set(StoreStruct.shared.currentInstance.returnedText, forKey: "returnedText")
                        
                        var instances = InstanceData.getAllInstances()
                        instances.append(currentInstance)
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(instances), forKey:"instances")
                        InstanceData.setCurrentInstance(instance: currentInstance)
                        let request = Timelines.home()
                        StoreStruct.client.run(request) { (statuses) in
                            if let stat = (statuses.value) {
                                StoreStruct.statusesHome = stat
                                StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                            }
                        }
                        
                        
                        let request2 = Accounts.currentUser()
                        StoreStruct.client.run(request2) { (statuses) in
                            if let stat = (statuses.value) {
                                StoreStruct.currentUser = stat
                                Account.addAccountToList(account: stat)
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                                }
                            }
                        }
                        
                        self.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                        StoreStruct.doOnce = false
                    }
                    
                    
                    // onboarding
//                    if (UserDefaults.standard.object(forKey: "onb") == nil) || (UserDefaults.standard.object(forKey: "onb") as! Int == 0) {
//                        DispatchQueue.main.async {
//                            self.bulletinManager.prepare()
//                            self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
//                        }
//                    }
                    
                    
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    @objc func newInstanceLogged(){
        
        self.loginBG.removeFromSuperview()
        self.loginLogo.removeFromSuperview()
        self.loginLabel.removeFromSuperview()
        self.textField.removeFromSuperview()
        //        self.safariVC?.dismiss(animated: true, completion: nil)
        
        var request = URLRequest(url: URL(string: "https://\(StoreStruct.shared.newInstance!.returnedText)/oauth/token?grant_type=authorization_code&code=\(StoreStruct.shared.newInstance!.authCode)&redirect_uri=\(StoreStruct.shared.newInstance!.redirect)&client_id=\(StoreStruct.shared.newInstance!.clientID)&client_secret=\(StoreStruct.shared.newInstance!.clientSecret)&scope=read%20write%20follow%20push")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else { print(error);return }
            guard let data = data else { return }
            guard let newInsatnce = StoreStruct.shared.newInstance else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    
                    newInsatnce.accessToken = (json["access_token"] as! String)
                    
                    InstanceData.setCurrentInstance(instance: newInsatnce)
                    var instances = InstanceData.getAllInstances()
                    instances.append(newInsatnce)
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(instances), forKey:"instances")
                    
                    
                    let request = Timelines.home()
                    StoreStruct.shared.newClient.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.statusesHome = stat
                            StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                        }
                    }
                    
                    
                    let request2 = Accounts.currentUser()
                    StoreStruct.shared.newClient.run(request2) { (statuses) in
                        print("THIS IS THE STATUS \(statuses)")
                        if let stat = (statuses.value) {
                            StoreStruct.currentUser = stat
                            Account.addAccountToList(account: stat)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                            }
                        }
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                    
                    
                    // onboarding
//                    if (UserDefaults.standard.object(forKey: "onb") == nil) || (UserDefaults.standard.object(forKey: "onb") as! Int == 0) {
//                        DispatchQueue.main.async {
//                            self.bulletinManager.prepare()
//                            self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
//                        }
//                    }
                    
                    
                    DispatchQueue.main.async {
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.reloadApplication()
                        
                    }
                    
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    
    
    
}
