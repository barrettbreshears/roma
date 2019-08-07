//
//  EditProfileViewController+TextDelegate.swift
//  mastodon
//
//  Created by Barrett Breshears on 8/6/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit

extension EditProfileViewController:UITextViewDelegate, UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == StoreStruct.currentUser.displayName {
            return
        }
        
        loadingView = LoadingViewController.initFromNib()
        _ = loadingView?.view
        loadingView?.view.frame = self.view.frame
        loadingView?.loadingMessage?.text = "Updating Display Name"
        self.view.addSubview(loadingView!.view);
        
        let request = Accounts.updateCurrentUser(displayName: textField.text, note: nil, avatar: nil, header: nil, locked: nil)
        StoreStruct.client.run(request) {[weak self] (statuses) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                self?.loadingView?.view.removeFromSuperview()
            }
            if let account = (statuses.value) {
               StoreStruct.currentUser = account
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let notification = UINotificationFeedbackGenerator()
                        notification.notificationOccurred(.success)
                    }
                    
                }
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == StoreStruct.currentUser.note {
            return
        }
        
        loadingView = LoadingViewController.initFromNib()
        _ = loadingView?.view
        loadingView?.view.frame = self.view.frame
        loadingView?.loadingMessage?.text = "Updating Bio"
        self.view.addSubview(loadingView!.view);
        
        let request = Accounts.updateCurrentUser(displayName: nil, note: textView.text, avatar: nil, header: nil, locked: nil)
        StoreStruct.client.run(request) { [weak self](statuses) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                self?.loadingView?.view.removeFromSuperview()
            }
            if let account = (statuses.value) {
                StoreStruct.currentUser = account
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let notification = UINotificationFeedbackGenerator()
                        notification.notificationOccurred(.success)
                    }
                }
            }
        }
    }
    
    
}
