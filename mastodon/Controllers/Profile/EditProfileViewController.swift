//
//  EditProfileViewController.swift
//  mastodon
//
//  Created by Barrett Breshears on 7/30/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit
import CropViewController
import DKImagePickerController
import DKCamera
import DKPhotoGallery
import Photos

class EditProfileViewController: UITableViewController {

    var loadingView:LoadingViewController?
    var inArea = 0
    var cropViewController = CropViewController(image: UIImage())
    var hasEdited = false;
    var user = StoreStruct.currentUser
    var originalName = ""
    var originalBio = ""
    
    @IBOutlet var avatar:UIImageView?
    @IBOutlet var header:UIImageView?
    @IBOutlet var displayName:UITextField?
    @IBOutlet var bio:UITextView?
    @IBOutlet var lock:UIButton?
    @IBOutlet var displayNameLabel:UILabel?
    @IBOutlet var bioLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        checkUser()
        setUpTheme()
        let editBar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        editBar.barStyle = .default
        editBar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEdit)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(doneWithKeyboard))]
        editBar.sizeToFit()
        displayName?.delegate = self
        displayName?.inputAccessoryView = editBar
        bio?.delegate = self
        bio?.inputAccessoryView = editBar
        
        // Do any additional setup after loading the view.
    }
    
    func setUpTheme(){
        self.view.backgroundColor = Colours.white
        displayNameLabel?.textColor = Colours.black
        displayName?.textColor = Colours.black
        bioLabel?.textColor = Colours.black
        bio?.textColor = Colours.black
    }
    
    func checkUser(){
        if user == nil {
            let userRequest = Accounts.currentUser()
            StoreStruct.client.run(userRequest) { [weak self] (statuses) in
                if let account = (statuses.value) {
                        StoreStruct.currentUser = account
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    self?.setUpView()
                }
            }
        } else {
            self.setUpView()
        }
    }
    
    func setUpView(){
        avatar?.pin_setImage(from: URL(string: StoreStruct.currentUser.avatar))
        header?.pin_setImage(from: URL(string: StoreStruct.currentUser.header))
        displayName?.text = StoreStruct.currentUser.displayName
        bio?.text = StoreStruct.currentUser.note.stripHTML()
        let title = StoreStruct.currentUser.locked ? "Unlock Account" : "Lock Account"
        lock?.setTitle(title, for: .normal)
        
        
        

        
    }
    
    @IBAction func lockUnlock(){
        
        loadingView = LoadingViewController.initFromNib()
        _ = loadingView?.view
        loadingView?.view.frame = self.view.frame
        loadingView?.loadingMessage?.text = "Updating..."
        self.view.addSubview(loadingView!.view);
        
        let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: !StoreStruct.currentUser.locked)
        StoreStruct.client.run(request) {[weak self] (statuses) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                self?.loadingView?.view.removeFromSuperview()
            }
            if let account = (statuses.value) {
                StoreStruct.currentUser = account
                DispatchQueue.main.async {
                    let title = StoreStruct.currentUser.locked ? "Unlock Account" : "Lock Account"
                    self?.lock?.setTitle(title, for: .normal)
                    //                            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let notification = UINotificationFeedbackGenerator()
                        notification.notificationOccurred(.success)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func editProfileImage(){
        StoreStruct.avaFile = "\(StoreStruct.avaFile)\(Int.random(in: 10...5000000))"
        StoreStruct.medType = 1
        self.inArea = 0
        
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 1
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count == 0 {
                return
            }
            if assets.count > 0 {
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.deliveryMode = .fastFormat
                options.resizeMode = .none
                assets[0].fetchOriginalImage(options: options, completeBlock: { image, info in
                    self.cropViewController = CropViewController(image: image ?? UIImage())
                    self.cropViewController.delegate = self
                    self.cropViewController.aspectRatioPreset = .presetSquare
                    self.cropViewController.aspectRatioLockEnabled = true
                    self.cropViewController.resetAspectRatioEnabled = false
                    self.cropViewController.aspectRatioPickerButtonHidden = true
                    self.cropViewController.title = "Resize Avatar"
                    self.present(self.cropViewController, animated: true, completion: nil)
                })
            }
        }
        pickerController.showsCancelButton = true
        pickerController.maxSelectableCount = 1
        pickerController.allowMultipleTypes = false
        pickerController.assetType = .allPhotos
        self.present(pickerController, animated: true) {}
    }
    
    @IBAction func editHeaderImage(){
        StoreStruct.heaFile = "\(StoreStruct.heaFile)\(Int.random(in: 10...5000000))"
        StoreStruct.medType = 2
        self.inArea = 1
        
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 1
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count == 0 {
                return
            }
            if assets.count > 0 {
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.deliveryMode = .fastFormat
                options.resizeMode = .none
                assets[0].fetchOriginalImage(options: options, completeBlock: { image, info in
                    self.cropViewController = CropViewController(image: image ?? UIImage())
                    self.cropViewController.delegate = self
                    self.cropViewController.aspectRatioPreset = .preset3x1
                    self.cropViewController.aspectRatioLockEnabled = true
                    self.cropViewController.resetAspectRatioEnabled = false
                    self.cropViewController.aspectRatioPickerButtonHidden = true
                    self.cropViewController.title = "Resize Header"
                    self.present(self.cropViewController, animated: true, completion: nil)
                })
            }
        }
        pickerController.showsCancelButton = true
        pickerController.maxSelectableCount = 1
        pickerController.allowMultipleTypes = false
        pickerController.assetType = .allPhotos
        self.present(pickerController, animated: true) {}
    }
    
    func refreshProfile(){
        let accountRequest = Accounts.currentUser()
        StoreStruct.client.run(accountRequest) {[weak self] (statuses) in
            if let account = (statuses.value) {
                StoreStruct.currentUser = account
                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func cancelEdit(){
        self.bio?.text = StoreStruct.currentUser.note
        self.displayName?.text = StoreStruct.currentUser.displayName
        self.view.endEditing(true)
    }
    
    @objc func doneWithKeyboard(){
        self.view.endEditing(true);
    }
    
}
