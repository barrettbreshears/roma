//
//  EditProfileViewController.swift
//  mastodon
//
//  Created by Barrett Breshears on 7/30/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit
import CropViewController

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        checkUser()
        
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
        bio?.text = StoreStruct.currentUser.note
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
                assets[0].fetchOriginalImage(true, completeBlock: { image, info in
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
                assets[0].fetchOriginalImage(true, completeBlock: { image, info in
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
//    func editProfileDetails() {
//
//        StoreStruct.avaFile = "\(StoreStruct.avaFile)\(Int.random(in: 10...5000000))"
//        StoreStruct.heaFile = "\(StoreStruct.heaFile)\(Int.random(in: 10...5000000))"
//
//        let isItLocked = StoreStruct.currentUser.locked
//        var lockText = "Lock Account"
//        var isItGoingToLock = false
//        var isItGoingToLockText = "Locked Account"
//        if isItLocked {
//            isItGoingToLock = false
//            lockText = "Unlock Account"
//            isItGoingToLockText = "Unlocked Account"
//        } else {
//            isItGoingToLock = true
//            isItGoingToLockText = "Locked Account"
//        }
//
//
//        var compression: CGFloat = 1
//        if (UserDefaults.standard.object(forKey: "imqual") == nil) || (UserDefaults.standard.object(forKey: "imqual") as! Int == 0) {
//            compression = 1
//        } else if UserDefaults.standard.object(forKey: "imqual") as! Int == 1 {
//            compression = 0.78
//        } else {
//            compression = 0.5
//        }
//
//        Alertift.actionSheet()
//            .backgroundColor(Colours.white)
//            .titleTextColor(Colours.grayDark)
//            .messageTextColor(Colours.grayDark)
//            .messageTextAlignment(.left)
//            .titleTextAlignment(.left)
//            .action(.default("Edit Avatar"), image: nil) { (action, ind) in
//
//                StoreStruct.medType = 1
//                self.inArea = 0
//
//                let pickerController = DKImagePickerController()
//                pickerController.didSelectAssets = { (assets: [DKAsset]) in
//                    if assets.count == 0 {
//                        return
//                    }
//                    if assets.count > 0 {
//                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
//                            self.cropViewController = CropViewController(image: image ?? UIImage())
//                            self.cropViewController.delegate = self
//                            self.cropViewController.aspectRatioPreset = .presetSquare
//                            self.cropViewController.aspectRatioLockEnabled = true
//                            self.cropViewController.resetAspectRatioEnabled = false
//                            self.cropViewController.aspectRatioPickerButtonHidden = true
//                            self.cropViewController.title = "Resize Avatar"
//                            self.present(self.cropViewController, animated: true, completion: nil)
//                        })
//                    }
//                }
//                pickerController.showsCancelButton = true
//                pickerController.maxSelectableCount = 1
//                pickerController.allowMultipleTypes = false
//                pickerController.assetType = .allPhotos
//                self.present(pickerController, animated: true) {}
//            }
//
//            .action(.default("Edit Header"), image: nil) { (action, ind) in
//
//                StoreStruct.medType = 2
//                self.inArea = 1
//
//                let pickerController = DKImagePickerController()
//                pickerController.didSelectAssets = { (assets: [DKAsset]) in
//                    if assets.count == 0 {
//                        return
//                    }
//                    if assets.count > 0 {
//                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
//                            self.cropViewController = CropViewController(image: image ?? UIImage())
//                            self.cropViewController.delegate = self
//                            self.cropViewController.aspectRatioPreset = .preset3x1
//                            self.cropViewController.aspectRatioLockEnabled = true
//                            self.cropViewController.resetAspectRatioEnabled = false
//                            self.cropViewController.aspectRatioPickerButtonHidden = true
//                            self.cropViewController.title = "Resize Header"
//                            self.present(self.cropViewController, animated: true, completion: nil)
//                        })
//                    }
//                }
//                pickerController.showsCancelButton = true
//                pickerController.maxSelectableCount = 1
//                pickerController.allowMultipleTypes = false
//                pickerController.assetType = .allPhotos
//                self.present(pickerController, animated: true) {}
//            }
//
//
//            .action(.default("Edit Display Name"), image: nil) { (action, ind) in
//
//
//                let controller = NewProfileViewController()
//                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//                switch (deviceIdiom) {
//                case .pad:
//                    controller.modalPresentationStyle = .pageSheet
//                default:
//                    print("nil")
//                }
//                controller.editListName = self.chosenUser.displayName
//                self.present(controller, animated: true, completion: nil)
//
//            }
//            .action(.default("Edit Bio"), image: nil) { (action, ind) in
//
//
//                let controller = NewProfileNoteViewController()
//                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//                switch (deviceIdiom) {
//                case .pad:
//                    controller.modalPresentationStyle = .pageSheet
//                default:
//                    print("nil")
//                }
//                controller.editListName = self.chosenUser.note.stripHTML()
//                self.present(controller, animated: true, completion: nil)
//
//            }
//            .action(.default("Edit Links"), image: nil) { (action, ind) in
//
//
//                var field1 = "Link 1"
//                var field2 = "Link 2"
//                var field3 = "Link 3"
//                var field4 = "Link 4"
//                var field01: String? = ""
//                var field02: String? = ""
//                var field03: String? = ""
//                var field04: String? = ""
//                var fieldVal1: String? = ""
//                var fieldVal2: String? = ""
//                var fieldVal3: String? = ""
//                var fieldVal4: String? = ""
//
//                if self.chosenUser.fields.count > 0 {
//                    field1 = self.chosenUser.fields[0].name
//                    field01 = field1
//                    fieldVal1 = self.chosenUser.fields[0].value
//                    if field1 == "" {
//                        field1 = "Link 1"
//                        field01 = nil
//                        fieldVal1 = nil
//                    }
//                    if self.chosenUser.fields.count > 1 {
//                        field2 = self.chosenUser.fields[1].name
//                        field02 = field2
//                        fieldVal2 = self.chosenUser.fields[1].value
//                        if field2 == "" {
//                            field2 = "Link 2"
//                            field02 = nil
//                            fieldVal2 = nil
//                        }
//                        if self.chosenUser.fields.count > 2 {
//                            field3 = self.chosenUser.fields[2].name
//                            field03 = field3
//                            fieldVal3 = self.chosenUser.fields[2].value
//                            if field3 == "" {
//                                field3 = "Link 3"
//                                field03 = nil
//                                fieldVal3 = nil
//                            }
//                            if self.chosenUser.fields.count > 3 {
//                                field4 = self.chosenUser.fields[3].name
//                                field04 = field4
//                                fieldVal4 = self.chosenUser.fields[3].value
//                                if field4 == "" {
//                                    field4 = "Link 4"
//                                    field04 = nil
//                                    fieldVal4 = nil
//                                }
//                            }
//                        }
//                    }
//                }
//
//                Alertift.actionSheet()
//                    .backgroundColor(Colours.white)
//                    .titleTextColor(Colours.grayDark)
//                    .messageTextColor(Colours.grayDark)
//                    .messageTextAlignment(.left)
//                    .titleTextAlignment(.left)
//                    .action(.default(field1), image: nil) { (action, ind) in
//
//
//                        Alertift.alert(title: field4, message: "Input the link name and URL")
//                            .textField { textField in
//                                textField.placeholder = "Name"
//                            }
//                            .textField { textField in
//                                textField.placeholder = "URL"
//                            }
//                            .action(.cancel("Cancel"))
//                            .action(.default("Update")) { _, _, textFields in
//                                let name = textFields?.first?.text ?? ""
//                                let url = textFields?.last?.text ?? ""
//
//                                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: name, fieldValue1: url, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: field04, fieldValue4: fieldVal4)
//                                StoreStruct.client.run(request) {[weak self] (statuses) in
//                                    if let stat = (statuses.value) {
//
//                                        DispatchQueue.main.async {
//                                            //                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                                            self?.updateProfileHere()
//                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                                let notification = UINotificationFeedbackGenerator()
//                                                notification.notificationOccurred(.success)
//                                            }
//                                        }
//
//                                    }
//                                }
//
//                            }
//                            .show()
//
//                    }
//                    .action(.default(field2), image: nil) { (action, ind) in
//
//
//                        Alertift.alert(title: field4, message: "Input the link name and URL")
//                            .textField { textField in
//                                textField.placeholder = "Name"
//                            }
//                            .textField { textField in
//                                textField.placeholder = "URL"
//                            }
//                            .action(.cancel("Cancel"))
//                            .action(.default("Update")) { _, _, textFields in
//                                let name = textFields?.first?.text ?? ""
//                                let url = textFields?.last?.text ?? ""
//
//                                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: name, fieldValue2: url, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: field04, fieldValue4: fieldVal4)
//                                StoreStruct.client.run(request) {[weak self] (statuses) in
//                                    if let stat = (statuses.value) {
//
//                                        DispatchQueue.main.async {
//                                            //                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                                            self?.updateProfileHere()
//                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                                let notification = UINotificationFeedbackGenerator()
//                                                notification.notificationOccurred(.success)
//                                            }
//                                        }
//
//                                    }
//                                }
//
//                            }
//                            .show()
//
//                    }
//                    .action(.default(field3), image: nil) { (action, ind) in
//
//
//                        Alertift.alert(title: field4, message: "Input the link name and URL")
//                            .textField { textField in
//                                textField.placeholder = "Name"
//                            }
//                            .textField { textField in
//                                textField.placeholder = "URL"
//                            }
//                            .action(.cancel("Cancel"))
//                            .action(.default("Update")) { _, _, textFields in
//                                let name = textFields?.first?.text ?? ""
//                                let url = textFields?.last?.text ?? ""
//
//                                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: name, fieldValue3: url, fieldName4: field04, fieldValue4: fieldVal4)
//                                StoreStruct.client.run(request) {[weak self] (statuses) in
//                                    if let stat = (statuses.value) {
//
//                                        DispatchQueue.main.async {
//                                            //                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                                            self?.updateProfileHere()
//                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                                let notification = UINotificationFeedbackGenerator()
//                                                notification.notificationOccurred(.success)
//                                            }
//                                        }
//
//                                    }
//                                }
//
//                            }
//                            .show()
//
//                    }
//                    .action(.default(field4), image: nil) { (action, ind) in
//
//
//                        Alertift.alert(title: field4, message: "Input the link name and URL")
//                            .textField { textField in
//                                textField.placeholder = "Name"
//                            }
//                            .textField { textField in
//                                textField.placeholder = "URL"
//                            }
//                            .action(.cancel("Cancel"))
//                            .action(.default("Update")) { _, _, textFields in
//                                let name = textFields?.first?.text ?? ""
//                                let url = textFields?.last?.text ?? ""
//
//                                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: name, fieldValue4: url)
//                                StoreStruct.client.run(request) {[weak self] (statuses) in
//                                    if let stat = (statuses.value) {
//
//                                        DispatchQueue.main.async {
//                                            //                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                                            self?.updateProfileHere()
//                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                                let notification = UINotificationFeedbackGenerator()
//                                                notification.notificationOccurred(.success)
//                                            }
//                                        }
//
//                                    }
//                                }
//
//                            }
//                            .show()
//
//                    }
//                    .action(.cancel("Dismiss"))
//                    .finally { action, index in
//                        if action.style == .cancel {
//                            return
//                        }
//                    }
//                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
//                    .show(on: self)
//
//
//
//            }
//            .action(.default(lockText), image: nil) { (action, ind) in
//
//                //bh2
//
//                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: isItGoingToLock)
//                StoreStruct.client.run(request) {[weak self] (statuses) in
//                    if let stat = (statuses.value) {
//                        DispatchQueue.main.async {
//                            //                            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                            self?.updateProfileHere()
//                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                let notification = UINotificationFeedbackGenerator()
//                                notification.notificationOccurred(.success)
//                            }
//                            let statusAlert = StatusAlert()
//                            if stat.locked {
//                                statusAlert.image = UIImage(named: "largelock")?.maskWithColor(color: Colours.grayDark)
//                            } else {
//                                statusAlert.image = UIImage(named: "largeunlock")?.maskWithColor(color: Colours.grayDark)
//                            }
//                            statusAlert.title = isItGoingToLockText.localized
//                            statusAlert.contentColor = Colours.grayDark
//                            statusAlert.message = StoreStruct.currentUser.displayName
//                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
//                                statusAlert.show()
//                            }
//                        }
//                    }
//                }
//
//
//            }
//            .action(.cancel("Dismiss"))
//            .finally { action, index in
//                if action.style == .cancel {
//                    return
//                }
//            }
//            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
//            .show(on: self)
//    }
//
//    func editSheet(){
//        Alertift.actionSheet()
//            .backgroundColor(Colours.white)
//            .titleTextColor(Colours.grayDark)
//            .messageTextColor(Colours.grayDark)
//            .messageTextAlignment(.left)
//            .titleTextAlignment(.left)
//            .action(.default("Edit Avatar"), image: nil) { (action, ind) in
//
//                StoreStruct.medType = 1
//                self.inArea = 0
//
//                let pickerController = DKImagePickerController()
//                pickerController.didSelectAssets = { (assets: [DKAsset]) in
//                    if assets.count == 0 {
//                        return
//                    }
//                    if assets.count > 0 {
//                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
//                            self.cropViewController = CropViewController(image: image ?? UIImage())
//                            self.cropViewController.delegate = self
//                            self.cropViewController.aspectRatioPreset = .presetSquare
//                            self.cropViewController.aspectRatioLockEnabled = true
//                            self.cropViewController.resetAspectRatioEnabled = false
//                            self.cropViewController.aspectRatioPickerButtonHidden = true
//                            self.cropViewController.title = "Resize Avatar"
//                            self.present(self.cropViewController, animated: true, completion: nil)
//                        })
//                    }
//                }
//                pickerController.showsCancelButton = true
//                pickerController.maxSelectableCount = 1
//                pickerController.allowMultipleTypes = false
//                pickerController.assetType = .allPhotos
//                self.present(pickerController, animated: true) {}
//            }
//
//            .action(.default("Edit Header"), image: nil) { (action, ind) in
//
//                StoreStruct.medType = 2
//                self.inArea = 1
//
//                let pickerController = DKImagePickerController()
//                pickerController.didSelectAssets = { (assets: [DKAsset]) in
//                    if assets.count == 0 {
//                        return
//                    }
//                    if assets.count > 0 {
//                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
//                            self.cropViewController = CropViewController(image: image ?? UIImage())
//                            self.cropViewController.delegate = self
//                            self.cropViewController.aspectRatioPreset = .preset3x1
//                            self.cropViewController.aspectRatioLockEnabled = true
//                            self.cropViewController.resetAspectRatioEnabled = false
//                            self.cropViewController.aspectRatioPickerButtonHidden = true
//                            self.cropViewController.title = "Resize Header"
//                            self.present(self.cropViewController, animated: true, completion: nil)
//                        })
//                    }
//                }
//                pickerController.showsCancelButton = true
//                pickerController.maxSelectableCount = 1
//                pickerController.allowMultipleTypes = false
//                pickerController.assetType = .allPhotos
//                self.present(pickerController, animated: true) {}
//            }
//
//
//            .action(.default("Edit Display Name"), image: nil) { (action, ind) in
//
//
//                let controller = NewProfileViewController()
//                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//                switch (deviceIdiom) {
//                case .pad:
//                    controller.modalPresentationStyle = .pageSheet
//                default:
//                    print("nil")
//                }
//                controller.editListName = self.chosenUser.displayName
//                self.present(controller, animated: true, completion: nil)
//
//            }
//            .action(.default("Edit Bio"), image: nil) { (action, ind) in
//
//
//                let controller = NewProfileNoteViewController()
//                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//                switch (deviceIdiom) {
//                case .pad:
//                    controller.modalPresentationStyle = .pageSheet
//                default:
//                    print("nil")
//                }
//                controller.editListName = self.chosenUser.note.stripHTML()
//                self.present(controller, animated: true, completion: nil)
//
//            }
//            .action(.default("Edit Links"), image: nil) { (action, ind) in
//
//
//                var field1 = "Link 1"
//                var field2 = "Link 2"
//                var field3 = "Link 3"
//                var field4 = "Link 4"
//                var field01: String? = ""
//                var field02: String? = ""
//                var field03: String? = ""
//                var field04: String? = ""
//                var fieldVal1: String? = ""
//                var fieldVal2: String? = ""
//                var fieldVal3: String? = ""
//                var fieldVal4: String? = ""
//
//                if self.chosenUser.fields.count > 0 {
//                    field1 = self.chosenUser.fields[0].name
//                    field01 = field1
//                    fieldVal1 = self.chosenUser.fields[0].value
//                    if field1 == "" {
//                        field1 = "Link 1"
//                        field01 = nil
//                        fieldVal1 = nil
//                    }
//                    if self.chosenUser.fields.count > 1 {
//                        field2 = self.chosenUser.fields[1].name
//                        field02 = field2
//                        fieldVal2 = self.chosenUser.fields[1].value
//                        if field2 == "" {
//                            field2 = "Link 2"
//                            field02 = nil
//                            fieldVal2 = nil
//                        }
//                        if self.chosenUser.fields.count > 2 {
//                            field3 = self.chosenUser.fields[2].name
//                            field03 = field3
//                            fieldVal3 = self.chosenUser.fields[2].value
//                            if field3 == "" {
//                                field3 = "Link 3"
//                                field03 = nil
//                                fieldVal3 = nil
//                            }
//                            if self.chosenUser.fields.count > 3 {
//                                field4 = self.chosenUser.fields[3].name
//                                field04 = field4
//                                fieldVal4 = self.chosenUser.fields[3].value
//                                if field4 == "" {
//                                    field4 = "Link 4"
//                                    field04 = nil
//                                    fieldVal4 = nil
//                                }
//                            }
//                        }
//                    }
//                }
//
//                Alertift.actionSheet()
//                    .backgroundColor(Colours.white)
//                    .titleTextColor(Colours.grayDark)
//                    .messageTextColor(Colours.grayDark)
//                    .messageTextAlignment(.left)
//                    .titleTextAlignment(.left)
//                    .action(.default(field1), image: nil) { (action, ind) in
//
//
//                        Alertift.alert(title: field4, message: "Input the link name and URL")
//                            .textField { textField in
//                                textField.placeholder = "Name"
//                            }
//                            .textField { textField in
//                                textField.placeholder = "URL"
//                            }
//                            .action(.cancel("Cancel"))
//                            .action(.default("Update")) { _, _, textFields in
//                                let name = textFields?.first?.text ?? ""
//                                let url = textFields?.last?.text ?? ""
//
//                                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: name, fieldValue1: url, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: field04, fieldValue4: fieldVal4)
//                                StoreStruct.client.run(request) {[weak self] (statuses) in
//                                    if let stat = (statuses.value) {
//
//                                        DispatchQueue.main.async {
//                                            //                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                                            self?.updateProfileHere()
//                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                                let notification = UINotificationFeedbackGenerator()
//                                                notification.notificationOccurred(.success)
//                                            }
//                                        }
//
//                                    }
//                                }
//
//                            }
//                            .show()
//
//                    }
//                    .action(.default(field2), image: nil) { (action, ind) in
//
//
//                        Alertift.alert(title: field4, message: "Input the link name and URL")
//                            .textField { textField in
//                                textField.placeholder = "Name"
//                            }
//                            .textField { textField in
//                                textField.placeholder = "URL"
//                            }
//                            .action(.cancel("Cancel"))
//                            .action(.default("Update")) { _, _, textFields in
//                                let name = textFields?.first?.text ?? ""
//                                let url = textFields?.last?.text ?? ""
//
//                                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: name, fieldValue2: url, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: field04, fieldValue4: fieldVal4)
//                                StoreStruct.client.run(request) {[weak self] (statuses) in
//                                    if let stat = (statuses.value) {
//
//                                        DispatchQueue.main.async {
//                                            //                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                                            self?.updateProfileHere()
//                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                                let notification = UINotificationFeedbackGenerator()
//                                                notification.notificationOccurred(.success)
//                                            }
//                                        }
//
//                                    }
//                                }
//
//                            }
//                            .show()
//
//                    }
//                    .action(.default(field3), image: nil) { (action, ind) in
//
//
//                        Alertift.alert(title: field4, message: "Input the link name and URL")
//                            .textField { textField in
//                                textField.placeholder = "Name"
//                            }
//                            .textField { textField in
//                                textField.placeholder = "URL"
//                            }
//                            .action(.cancel("Cancel"))
//                            .action(.default("Update")) { _, _, textFields in
//                                let name = textFields?.first?.text ?? ""
//                                let url = textFields?.last?.text ?? ""
//
//                                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: name, fieldValue3: url, fieldName4: field04, fieldValue4: fieldVal4)
//                                StoreStruct.client.run(request) {[weak self] (statuses) in
//                                    if let stat = (statuses.value) {
//
//                                        DispatchQueue.main.async {
//                                            //                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                                            self?.updateProfileHere()
//                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                                let notification = UINotificationFeedbackGenerator()
//                                                notification.notificationOccurred(.success)
//                                            }
//                                        }
//
//                                    }
//                                }
//
//                            }
//                            .show()
//
//                    }
//                    .action(.default(field4), image: nil) { (action, ind) in
//
//
//                        Alertift.alert(title: field4, message: "Input the link name and URL")
//                            .textField { textField in
//                                textField.placeholder = "Name"
//                            }
//                            .textField { textField in
//                                textField.placeholder = "URL"
//                            }
//                            .action(.cancel("Cancel"))
//                            .action(.default("Update")) { _, _, textFields in
//                                let name = textFields?.first?.text ?? ""
//                                let url = textFields?.last?.text ?? ""
//
//                                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: nil, fieldName1: field01, fieldValue1: fieldVal1, fieldName2: field02, fieldValue2: fieldVal2, fieldName3: field03, fieldValue3: fieldVal3, fieldName4: name, fieldValue4: url)
//                                StoreStruct.client.run(request) {[weak self] (statuses) in
//                                    if let stat = (statuses.value) {
//
//                                        DispatchQueue.main.async {
//                                            //                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                                            self?.updateProfileHere()
//                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                                let notification = UINotificationFeedbackGenerator()
//                                                notification.notificationOccurred(.success)
//                                            }
//                                        }
//
//                                    }
//                                }
//
//                            }
//                            .show()
//
//                    }
//                    .action(.cancel("Dismiss"))
//                    .finally { action, index in
//                        if action.style == .cancel {
//                            return
//                        }
//                    }
//                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
//                    .show(on: self)
//
//
//
//            }
//            .action(.default(lockText), image: nil) { (action, ind) in
//
//                //bh2
//
//                let request = Accounts.updateCurrentUser(displayName: nil, note: nil, avatar: nil, header: nil, locked: isItGoingToLock)
//                StoreStruct.client.run(request) {[weak self] (statuses) in
//                    if let stat = (statuses.value) {
//                        DispatchQueue.main.async {
//                            //                            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProfileHere"), object: nil)
//                            self?.updateProfileHere()
//                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                                let notification = UINotificationFeedbackGenerator()
//                                notification.notificationOccurred(.success)
//                            }
//                            let statusAlert = StatusAlert()
//                            if stat.locked {
//                                statusAlert.image = UIImage(named: "largelock")?.maskWithColor(color: Colours.grayDark)
//                            } else {
//                                statusAlert.image = UIImage(named: "largeunlock")?.maskWithColor(color: Colours.grayDark)
//                            }
//                            statusAlert.title = isItGoingToLockText.localized
//                            statusAlert.contentColor = Colours.grayDark
//                            statusAlert.message = StoreStruct.currentUser.displayName
//                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
//                                statusAlert.show()
//                            }
//                        }
//                    }
//                }
//
//
//            }
//            .action(.cancel("Dismiss"))
//            .finally { action, index in
//                if action.style == .cancel {
//                    return
//                }
//            }
//            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.contentView ?? self.view)
//            .show(on: self)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
