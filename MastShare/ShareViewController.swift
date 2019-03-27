//
//  ShareViewController.swift
//  MastShare
//
//  Created by Shihab Mehboob on 02/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit
import MobileCoreServices

class ShareViewController: UIViewController, UITextViewDelegate {
    
    let viewBG = UIView()
    let bgView = UIView()
    let textView = UITextView()
    let cancelLabel = UIButton()
    let tootLabel = UIButton()
    let countLabel = UILabel()
    var keyHeight = 0
    var visibilityButton = UIButton()
    var warningButton = UIButton()
    var currentVisibility: Visibility = .public
    var textField = UITextField()
    var selectedImage1 = UIImageView()
    var isDoing = false
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyHeight = Int(keyboardHeight)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setNeedsStatusBarAppearanceUpdate()
        self.setUpView()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(500 - (textView.text).count)"
        if Int(countLabel.text!)! < 1 {
            countLabel.textColor = UIColor.red
        } else if Int(countLabel.text!)! < 20 {
            countLabel.textColor = UIColor.orange
        } else {
            countLabel.textColor = UIColor.gray.withAlphaComponent(0.65)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.bringBackDrawer()
    }
    
    func bringBackDrawer() {
        self.textView.becomeFirstResponder()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(1.4),
                       initialSpringVelocity: CGFloat(3),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.visibilityButton.alpha = 1
                        self.warningButton.alpha = 1
                        self.textField.alpha = 0
        }, completion: nil)
    }
    
    @objc func didTouchUpInsideVisibilityButton() {
        self.bringBackDrawer()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Public", style: .default , handler:{ (UIAlertAction) in
            self.visibilityButton.setImage(UIImage(named: "eye")?.maskWithColor(color: UIColor.white), for: .normal)
            self.currentVisibility = .public
        }))
        alert.addAction(UIAlertAction(title: "Unlisted", style: .default , handler:{ (UIAlertAction) in
            self.visibilityButton.setImage(UIImage(named: "unlisted")?.maskWithColor(color: UIColor.white), for: .normal)
            self.currentVisibility = .unlisted
        }))
        alert.addAction(UIAlertAction(title: "Private", style: .default , handler:{ (UIAlertAction) in
            self.visibilityButton.setImage(UIImage(named: "private")?.maskWithColor(color: UIColor.white), for: .normal)
            self.currentVisibility = .private
        }))
        alert.addAction(UIAlertAction(title: "Direct", style: .default , handler:{ (UIAlertAction) in
            self.visibilityButton.setImage(UIImage(named: "direct")?.maskWithColor(color: UIColor.white), for: .normal)
            self.currentVisibility = .direct
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction) in
            
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.visibilityButton
            popoverController.sourceRect = self.visibilityButton.frame
        }
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    @objc func didTouchUpInsideWarningButton() {
        self.textField.becomeFirstResponder()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(1.4),
                       initialSpringVelocity: CGFloat(3),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.visibilityButton.alpha = 0
                        self.warningButton.alpha = 0
                        self.textField.alpha = 1
        }, completion: nil)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            textView.resignFirstResponder()
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(1.4),
                           initialSpringVelocity: CGFloat(3),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            self.viewBG.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                            self.bgView.frame = CGRect(x: 0, y: Int(UIScreen.main.bounds.size.height), width: Int(UIScreen.main.bounds.size.width), height: Int(self.keyHeight) + 50)
            }, completion: { test in
                self.extensionContext!.cancelRequest(withError: NSError())
            })
        }
    }
    
    func setUpView() {
        viewBG.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        viewBG.backgroundColor = UIColor.white
        self.view.addSubview(viewBG)
        
        let theTempText: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let theText = theTempText.attributedContentText?.string ?? ""
        
        textView.frame = CGRect(x: 20, y: 90, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 100 - CGFloat(self.keyHeight))
        textView.textColor = UIColor.black
        textView.text = "\(theText)"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.becomeFirstResponder()
        textView.delegate = self
        viewBG.addSubview(textView)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        textView.addGestureRecognizer(swipeDown)
        
        self.selectedImage1.frame = CGRect(x: 15, y: Int(self.view.bounds.height) - 90 - Int(self.keyHeight) - 55, width: 80, height: 80)
        self.selectedImage1.backgroundColor = UIColor.clear
        self.selectedImage1.layer.cornerRadius = 12
        self.selectedImage1.layer.masksToBounds = true
        self.selectedImage1.contentMode = .scaleAspectFill
        self.selectedImage1.alpha = 1
        self.viewBG.addSubview(self.selectedImage1)
        
        bgView.frame = CGRect(x: 0, y: Int(UIScreen.main.bounds.size.height), width: Int(UIScreen.main.bounds.size.width), height: Int(self.keyHeight) + 50)
        bgView.backgroundColor = UIColor(red: 107/255.0, green: 122/255.0, blue: 214/255.0, alpha: 1.0)
        self.view.addSubview(bgView)
        
        visibilityButton.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
        visibilityButton.setImage(UIImage(named: "eye")?.maskWithColor(color: UIColor.white), for: .normal)
        visibilityButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        visibilityButton.adjustsImageWhenHighlighted = false
        visibilityButton.addTarget(self, action: #selector(didTouchUpInsideVisibilityButton), for: .touchUpInside)
        bgView.addSubview(visibilityButton)
        
        warningButton.frame = CGRect(x: 75, y: -4, width: 50, height: 58)
        warningButton.setImage(UIImage(named: "reporttiny")?.maskWithColor(color: UIColor.white), for: .normal)
        warningButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 2, right: 4)
        warningButton.adjustsImageWhenHighlighted = false
        warningButton.addTarget(self, action: #selector(didTouchUpInsideWarningButton), for: .touchUpInside)
        bgView.addSubview(warningButton)
        
        textField.frame = CGRect(x: 20, y: 0, width: self.view.bounds.width - 40, height: 50)
        textField.backgroundColor = UIColor.clear
        textField.tintColor = UIColor(red: 77/255.0, green: 92/255.0, blue: 195/255.0, alpha: 1.0)
        textField.textColor = UIColor.white
        textField.placeholder = "Content warning..."
        textField.alpha = 0
        bgView.addSubview(textField)
        
        cancelLabel.frame = CGRect(x: 19, y: -50, width: 30, height: 30)
        cancelLabel.setImage(UIImage(named: "block")?.maskWithColor(color: UIColor.gray), for: .normal)
        cancelLabel.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cancelLabel.adjustsImageWhenHighlighted = false
        cancelLabel.addTarget(self, action: #selector(self.didSelectCancel), for: .touchUpInside)
        cancelLabel.titleLabel?.textAlignment = .left
        viewBG.addSubview(cancelLabel)
        
        tootLabel.frame = CGRect(x: UIScreen.main.bounds.size.width - 90, y: -50, width: 80, height: 30)
        tootLabel.setTitle("Toot", for: .normal)
        tootLabel.setTitleColor(UIColor(red: 107/255.0, green: 122/255.0, blue: 214/255.0, alpha: 1.0), for: .normal)
        tootLabel.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        tootLabel.addTarget(self, action: #selector(self.didSelectPost), for: .touchUpInside)
        tootLabel.titleLabel?.textAlignment = .right
        viewBG.addSubview(tootLabel)
        
        countLabel.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - 50, y: 44, width: 100, height: 30)
        countLabel.text = "\(500 - (theTempText.attributedContentText?.string ?? "").count)"
        countLabel.textColor = UIColor.gray.withAlphaComponent(0.65)
        countLabel.textAlignment = .center
        countLabel.alpha = 0
        viewBG.addSubview(countLabel)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(1.4),
                       initialSpringVelocity: CGFloat(3),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.viewBG.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.55,
                       delay: 0.1,
                       usingSpringWithDamping: CGFloat(1.5),
                       initialSpringVelocity: CGFloat(3),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.bgView.frame = CGRect(x: 0, y: Int(UIScreen.main.bounds.size.height) - 50 - Int(self.keyHeight), width: Int(UIScreen.main.bounds.size.width), height: Int(self.keyHeight) + 50)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: CGFloat(1.6),
                       initialSpringVelocity: CGFloat(2.4),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.countLabel.alpha = 1
                        self.cancelLabel.frame = CGRect(x: 19, y: 44, width: 30, height: 30)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.55,
                       delay: 0.3,
                       usingSpringWithDamping: CGFloat(1.8),
                       initialSpringVelocity: CGFloat(3),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.tootLabel.frame = CGRect(x: UIScreen.main.bounds.size.width - 90, y: 44, width: 80, height: 30)
        }, completion: nil)
        
        for y in extensionContext!.inputItems {
            if let inputItem = y as? NSExtensionItem {
                for x in inputItem.attachments! {
                    if x.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                        x.loadItem(forTypeIdentifier: kUTTypeImage as String) { [unowned self] (imageData, error) in
                            DispatchQueue.main.async {
                                if let item = imageData as? Data {
                                    self.selectedImage1.image = UIImage(data: item)
                                    self.textView.frame = CGRect(x: 20, y: 90, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 190 - CGFloat(self.keyHeight))
                                }  else if let url = imageData as? URL {
                                    do {
                                        let data = try? Data(contentsOf: url)
                                        self.selectedImage1.image = UIImage(data: data!)
                                        self.textView.frame = CGRect(x: 20, y: 90, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 190 - CGFloat(self.keyHeight))
                                    } catch {
                                        print("error")
                                    }
                                } else if let imageData = imageData as? UIImage {
                                    self.selectedImage1.image = imageData
                                    self.textView.frame = CGRect(x: 20, y: 90, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 190 - CGFloat(self.keyHeight))
                                }
                            }
                        }
                    } else if x.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                        x.loadItem(forTypeIdentifier: kUTTypeURL as String) { [unowned self] (url, error) in
                            DispatchQueue.main.async {
                                if let shareURL = url as? NSURL {
                                    self.textView.text = "\(theText)\n\n\(shareURL)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func didSelectCancel() {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        textView.resignFirstResponder()
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(1.4),
                       initialSpringVelocity: CGFloat(3),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.viewBG.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                        self.bgView.frame = CGRect(x: 0, y: Int(UIScreen.main.bounds.size.height), width: Int(UIScreen.main.bounds.size.width), height: Int(self.keyHeight) + 50)
        }, completion: { test in
            self.extensionContext!.cancelRequest(withError: NSError())
        })
    }
    
    @objc func didSelectPost() {
        
        if isDoing {
            return
        }
        
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        
        var client = Client(baseURL: "")
        if let userDefaults = UserDefaults(suiteName: "group.com.vm.roma.wormhole") {
            let value1 = userDefaults.string(forKey: "key1")
            let value2 = userDefaults.string(forKey: "key2")
            client = Client(
                baseURL: "https://\(value2 ?? "")",
                accessToken: value1 ?? ""
            )
        }
        
        var spoilers: String? = self.textField.text ?? ""
        var isSensitive = true
        if spoilers == "" {
            spoilers = nil
            isSensitive = false
        }
        
        isDoing = true
//        let theTempText: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let theText = self.textView.text!
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first {
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                        if let shareURL = url as? NSURL {
                            let request0 = Statuses.create(status: "\(theText)\n\n\(shareURL)", replyToID: nil, mediaIDs: [], sensitive: isSensitive, spoilerText: spoilers, visibility: self.currentVisibility)
                            client.run(request0) { (statuses) in
                                print("06")
                                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                            }
                        }
                        
                    })
                } else {
                    
                    itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil, completionHandler: { (url, error) -> Void in
                        if let data = url as? URL {
                            
                            var imageData = Data()
                            do {
                                imageData = try Data(contentsOf: data)
                            }
                            catch let error {
                                print(error)
                            }
                            
                            
                            let request = Media.upload(media: .jpeg(imageData))
                            client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    print(stat.id)
                                    var mediaIDs: [String] = []
                                    mediaIDs.append(stat.id)
                                    
                                    let request0 = Statuses.create(status: theText, replyToID: nil, mediaIDs: mediaIDs, sensitive: isSensitive, spoilerText: spoilers, visibility: self.currentVisibility)
                                    DispatchQueue.global(qos: .background).async {
                                        client.run(request0) { (statuses) in
                                            print("posted")
                                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                        }
                                    }
                                }
                            }
                            
                        } else {
                            if let z = url as? UIImage {
                                let request = Media.upload(media: .jpeg(z.pngData()))
                                client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print(stat.id)
                                        var mediaIDs: [String] = []
                                        mediaIDs.append(stat.id)
                                        
                                        let request0 = Statuses.create(status: theText, replyToID: nil, mediaIDs: mediaIDs, sensitive: isSensitive, spoilerText: spoilers, visibility: self.currentVisibility)
                                        DispatchQueue.global(qos: .background).async {
                                            client.run(request0) { (statuses) in
                                                print("posted")
                                                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                            }
                                        }
                                    }
                                }
                            } else {
                                itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                                    if let shareURL = url as? NSURL {
                                        let request0 = Statuses.create(status: "\(self.extensionContext!)\n\n\(shareURL)", replyToID: nil, mediaIDs: [], sensitive: isSensitive, spoilerText: spoilers, visibility: self.currentVisibility)
                                        client.run(request0) { (statuses) in
                                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                        }
                                    }
                                    
                                })
                            }
                        }
                        
                        
                        
                        
                        
                    })
                    
                }
            }
        }
        
    }
    
}

extension UIImage {
    
    public func maskWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
    
}
