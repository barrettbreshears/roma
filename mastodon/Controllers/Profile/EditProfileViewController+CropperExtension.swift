//
//  EditProfileViewController+CropperExtension.swift
//  mastodon
//
//  Created by Barrett Breshears on 8/4/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import CropViewController

extension EditProfileViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        
        loadingView = LoadingViewController.initFromNib()
        _ = loadingView?.view
        loadingView?.view.frame = self.view.frame
        loadingView?.loadingMessage?.text = "Updating \(inArea == 0 ? "Avatar" : "Header")."
        self.view.addSubview(loadingView!.view);
        
        self.cropViewController.dismiss(animated: true, completion: nil)
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        
        if self.inArea == 0 {
            
            let imageData = image.jpegData(compressionQuality: 0.55)
            let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: .jpeg(imageData), header: nil)
            StoreStruct.client.run(request) {[weak self](statuses) in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    self?.loadingView?.view.removeFromSuperview()
                }
                if let account = (statuses.value) {
                    StoreStruct.currentUser = account
                    DispatchQueue.main.async {
                        self?.refreshProfile()
                        self?.avatar?.image = image
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        
                    }
                }
            }
            
        } else {
            
            let imageData = image.jpegData(compressionQuality: 0.65)
            let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: .jpeg(imageData))
            StoreStruct.client.run(request) {[weak self] (statuses) in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    self?.loadingView?.view.removeFromSuperview()
                }
                if let account = (statuses.value) {
                    StoreStruct.currentUser = account
                    DispatchQueue.main.async {
                        self?.refreshProfile()
                        self?.header?.image = image
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        
                    }
                }
            }
            
        }
    }
}
