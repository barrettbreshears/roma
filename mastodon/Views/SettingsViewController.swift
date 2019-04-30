//
//  SettingsViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 25/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SJFluidSegmentedControl
import SafariServices
import StatusAlert
import SAConfettiView
import StoreKit
import UserNotifications

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPhotoBrowserDelegate, UIGestureRecognizerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, UNUserNotificationCenterDelegate {

    var tap: UITapGestureRecognizer!
    var safariVC: SFSafariViewController?
    var segmentedControl: SJFluidSegmentedControl!
    var tableView = UITableView()
    var currentIndex = 0
    var vc: ViewController?

    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var price1 = ""
    var price2 = ""
    var price3 = ""
    var price4 = ""

    @objc func load() {
        DispatchQueue.main.async {
            self.loadLoadLoad()
        }
    }

    @objc func search() {
        let controller = DetailViewController()
        controller.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
        self.navigationController?.pushViewController(controller, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }






    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {

                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)

                    let array = ["May a thousand kittens bless your day.", "Your generosity knows no bounds.", "You're as awesome as they come.", "All the kittens love you."]
                    UIAlertView(title: "Thank you!",
                                message: array.randomElement(),
                                delegate: nil,
                                cancelButtonTitle: "Dismiss").show()

                    let confettiView = SAConfettiView(frame: self.view.bounds)
                    confettiView.isUserInteractionEnabled = true
                    self.view.addSubview(confettiView)
                    confettiView.intensity = 0.9
                    confettiView.startConfetti()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        confettiView.stopConfetti()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                            confettiView.removeFromSuperview()
                        }
                    }


                    break

                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break

                default: break
                }}}
    }




    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)

            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier


            // IAP Purchases dsabled on the Device
        } else {
            UIAlertView(title: "Oops!",
                        message: "Purchases are disabled on your device!",
                        delegate: nil, cancelButtonTitle: "Dismiss").show()
        }
    }

    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products

            let firstProduct = response.products[0] as SKProduct
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = firstProduct.priceLocale
            self.price1 = numberFormatter.string(from: firstProduct.price) ?? ""

            let secondProd = response.products[1] as SKProduct
            numberFormatter.locale = secondProd.priceLocale
            self.price2 = numberFormatter.string(from: secondProd.price) ?? ""

            let thirdProd = response.products[2] as SKProduct
            numberFormatter.locale = thirdProd.priceLocale
            self.price3 = numberFormatter.string(from: thirdProd.price) ?? ""

            let fourthProd = response.products[3] as SKProduct
            numberFormatter.locale = fourthProd.priceLocale
            self.price4 = numberFormatter.string(from: fourthProd.price) ?? ""

            self.tableView.reloadData()
        }
    }


    func fetchAvailableProducts()  {

        let productIdentifiers = NSSet(objects: "com.vm.roma.calf", "com.vm.roma.elephant", "com.vm.roma.mammoth", "com.vm.roma.mastodon")

        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }

    @objc func hexNew() {
        Alertift.actionSheet(title: nil, message: nil)
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("Hue Picker Wheel".localized), image: nil) { (action, ind) in
                 
                let controller = NewHuePickerViewController()
                self.present(controller, animated: true, completion: nil)
            }
            .action(.default("Enter Hex Value Manually".localized), image: nil) { (action, ind) in
                 
                let controller = NewHexViewController()
                self.present(controller, animated: true, completion: nil)
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .show(on: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.hexNew), name: NSNotification.Name(rawValue: "hexnew"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.goLists), name: NSNotification.Name(rawValue: "goLists"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)

        self.view.backgroundColor = Colours.white

        self.fetchAvailableProducts()

        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
            case 2436, 1792:
                offset = 88
            default:
                offset = 64
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }

        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 5), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
        case .pad:
            self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        default:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 5), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
        }
        self.tableView.register(ColourCells.self, forCellReuseIdentifier: "colcell")
        self.tableView.register(AppIconsCells.self, forCellReuseIdentifier: "appcell")
        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellse")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse25")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse2")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse22")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse23")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse231")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse099")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse0991")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse0992")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse0993")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse09936")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse099367")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse0993678")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse09936781")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse099309")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse0993091")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse0993092")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse0993093")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse09930936")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse0993093999")
        self.tableView.register(SettingsCellToggle.self, forCellReuseIdentifier: "cellse09930939995")
        self.tableView.register(AddInstanceCell.self, forCellReuseIdentifier: "addInstanceCell")
        self.tableView.alpha = 1
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)

        self.loadLoadLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

//        self.navigationController?.navigationBar.tintColor = Colours.tabUnselected
//        self.navigationController?.navigationBar.barTintColor = Colours.tabUnselected
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = Colours.tabUnselected


        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom

        switch (deviceIdiom) {
        case .pad:
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        default:
            print("nothing")
        }

        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.window?.addGestureRecognizer(tap)

        StoreStruct.currentPage = 90
    }

    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.view)

        if self.view.point(inside: location, with: nil) {
            return false
        }
        else {
            return true
        }
    }

    @objc private func onTap(sender: UITapGestureRecognizer) {

        self.view.window?.removeGestureRecognizer(sender)
        self.dismiss(animated: true, completion: nil)
    }


    // Table stuff

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            return 40
        case .pad:
            if section == 0 {
                return 40
            } else {
                return 40
            }
        default:
            return 40
        }

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 8, width: self.view.bounds.width, height: 30)
        if section == 0 {
            title.text = "App Icon".localized
        } else if section == 1 {
            title.text = "General".localized
        } else if section == 2 {
            title.text = "Appearance".localized
        } else if section == 3 {
            title.text = "Biometric Lock".localized
        } else {
            title.text = "Accounts".localized
        }
        title.textColor = Colours.grayDark2
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white

        return vw
    }
    
    var generalArray = ["Realtime Updates", "Push Notifications", "Haptic Feedback", "Always Display Sensitive Content", "Default Status Privacy", "Default Keyboard Style", "Long-Hold Anywhere Action", "Image Upload Quality", "Post Load Position", "Default Video Container", "Long Swipe Selection", "Swipe Action Order", "Default Mentions Tab", "Activity Graph", "Activity Graph Animation", "Status Actions Placement", "Display Reposts in Profiles", "Shake Gesture", "Initial Timeline", "User Search Scope", "Keyboard Haptics", "Jump to Top With New Post", "Thumb Scroller", "Link Previews", "Load More Order", "Automatically Load Gaps", "Default Profile Secondary Button", "Recent Media Swipe Type", "In-app Mentions Badge", "Direct Messages View Style", "Links Destination", "Emoticon Suggestions"]
    var generalArrayDesc = ["No need to refresh manually, you'll get the latest posts and notifications pushed to you.", "Realtime push notifications for mentions/follows/boosts/likes. Select which type of activities you'd like to receive notifications for.", "Get a responsive little vibration when tapping buttons and other on-screen elements.", "Sensitive content will always be displayed without a content warning overlay.", "Select a default privacy state for you posts, from public (everyone can see), unlisted (everyone apart from local and federated timelines can see), private (followers and mentioned users can see), and direct (only to the mentioned user).", "Choose from a convenient social keyboard that puts the @ and # keys front and centre, or the default keyboard with a return key.", "Select what happens when you long-hold anywhere in the app.", "Pick the quality of images uploaded when composing status. A higher quality image may take longer to upload.", "Choose whether to retain the timeline scroll position when streaming and pulling to refresh, or to scroll to the top.", "Choose whether to show videos and GIFs in a custom Picture-in-Picture container which can be swiped down to keep the view around, or in the stock media player, where swiping down dismisses the content.", "Swipe all the way left or right on a status to select the action on the edge.", "Select the order of swipe action elements.", "Switch to either show mentions or activity by default.", "Display an activity graph showing recent activity in the mentions tab.", "Animate the activity graph when showing it.", "Choose whether to display status actions on the status cell or behind a swipe. This will require restarting the app to take effect.", "Display reposted statuses  in the Posts & Replies section of user profiles.", "Select whether to hide sensitive content, rain confetti, or do nothing when shaking your device.", "Pick the initial timeline to be displayed, whether it's home, local, or all.", "Pick whether searching for users is across all of Mastodon or just local.", "Set haptic feedback for key presses on the keyboard.", "Pick whether posting a new stauts jumps the timeline to the top.", "Display a circular thumb scroller on timelines, which allows you to rotate the scroller with your thumb to navigate through timelines without lifting a finger. This may require restarting the app to take effect.", "Choose whether to display link preview cards in status details for all links within the status.", "Select whether tapping the 'load more' button in timelines retains the current scroll position (allowing the new posts to be read downwards), or whether it shifts you to just below the newly loaded posts (allowing the new posts to be read upwards).", "Automatically fetch gaps in between timelines, removing the need to tap the 'load more' buttons.", "Select what action the secondary profile button (on the left of the profile image) should do: View liked statuses or view pinned statuses.", "Pick whether swiping enlarged recent media images scrolls through all attached media in the specified post and does nothing if there's a single image, or whether it scrolls through all recent media.", "Display a badge on the mentions tab icon when receiving a new notification whilst in the app.", "Choose whether to open direct messages in the mentions tab in a chat-style view or a status-style view.", "Pick whether to open links in-app, or in Safari.", "Choose whether to allow emoticon suggestions when composing statuses."]
    var generalArrayIm = ["setreal", "notifs", "sethap", "setsensitivec", "priv", "keybse", "holdse", "comse", "posse", "setvid", "swipeact", "swipeact3", "actdef", "setgraph", "setgraph2", "like", "boost", "setshake", "segse", "searchscope", "keyhap", "jumptop", "circscroll", "linkcard", "lmore", "autol", "likepin", "comse", "notifs0", "direct2",  "schemes", "setemot"]
    
    var appearanceArray = ["", "Theme", "Text Size", "Profiles Corner Radius", "Images Corner Radius", "Hide Images in Timelines", "Full Usernames", "Confetti", "Gallery Grid Size", "Time Style", "Profile Header Background", "Segments Size", "Segments Transition Style", "Subtle Activity Notifications", "Profile Display Picture Border", "Pinch and History View Background Theme", "Media Captions", "Status Progress Indicator", "Highlight Direct Messages", "Post Bar Hue", "Activity Graph Hue", "Segments Hue", "Instances and Lists Icon", "Profile Display Picture in Status Composition", "Popup Alerts", "Full Usernames in Boosts"]
    var appearanceArrayDesc = ["", "Select from a white day theme, a dark dusk theme, an even darker night theme, or a truly black OLED-friendly theme.", "Always be able to read posts with adjustable text sizing.", "Circle or square, your choice.", "Rounded or not, your choice.", "Timelines with some plain old text, for a distraction-free browsing experience.", "Display the user's full username, with the instance, in posts.", "Add some fun to posting statuses, following users, reposting statuses, and liking statuses.", "Set the amount of columns in the status composition section's photo picker gallery.", "Pick between absolute or relative time to display in timelines.", "Change the style of the profile header background.", "Choose from larger home and notification screen segments, or tinier ones.", "Pick between a static and linear transition, or a playful liquid one.", "Dims activity notifications, while keeping mentions untouched.", "Select a size for the border around profile view display pictures.", "Select a theme for the background when pinching to status a screenshot, or when long-holding a back button to enter the history view.", "Pick whether to display the status text or the image's alt text in media captions.", "Choose whether to show the status progress indicator or not.", "Highlight direct messages in timelines with a subtle, distinct, or theme background.", "Select the hue for the keyboard bar when composing statuses.", "Select the hue for the activity graph columns.", "Select the hue for segments. This may require restarting the app to take effect.", "Select an icon to use for the top-left instances and list section icon.", "Choose whether to display the current account's display picture in the top-left when composing statuses.", "Pick whether to display popup alerts for a variety of actions including posting, liking, and reposting.", "Display the user's full username in boosts."]
    var appearanceArrayIm = ["", "setnight", "settext", "setpro", "setima", "setima2", "userat", "confett", "gridse", "timese", "headbgse", "segse", "segse2", "subtleno" , "bordset", "pinchset", "heavyse", "indic", "direct2", "barcol", "acthue", "seghue", "barcol10", "compav", "popupset", "userat2"]
    
    var bioArray = ["Lock App", "Lock Notifications"]
    var bioArrayDesc = ["Add a biometric lock to the app.", "Add a biometric lock to the notifications section."]
    var bioArrayIm = ["biolock1", "biolock2"]

    var aboutArray = ["Roma \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")", "Review Roma", "Get in Touch", "URL Schemes"]
    var aboutArrayDesc = ["Let us tell you a little bit about ourselves.", "If you enjoy using Roma, please consider leaving a review on the App Store.", "Keep in touch, and get progress updates about what we're up to.", "Use these to do specific actions within the app from outside the app."]
    var aboutArrayIm = ["setmas", "like", "intouch", "schemes"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return self.generalArray.count
        } else if section == 2 {
            return self.appearanceArray.count
        } else if section == 3 {
            return self.bioArray.count
        } else {
            let z1 = Account.getAccounts().count
            let z2 = InstanceData.getAllInstances().count

            
            if z1 == z2 {
                return InstanceData.getAllInstances().count + 1
            } else {
                showAccountError()
                return 1
            }
        }
    }
    
    func showAccountError(){
        
        let alert = UIAlertController(title: "Looks like we encountered an error please log in again", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut"), object: nil)
            case .pad:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "logBackOut"), object: nil)
            default:
                NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut"), object: nil)
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {

            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                return 130
            case .pad:
                return 130
            default:
                return 130
            }

        } else {
            if indexPath.section == 2 && indexPath.row == 0 {
                return 105
            } else {
                return UITableView.automaticDimension
            }
        }
    }


    @objc func handleToggleStream(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "streamToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "streamToggle")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleNotifsStream(sender: UISwitch) {
        if sender.isOn {
            sender.setOn(true, animated: true)
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            sender.setOn(false, animated: true)
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    @objc func handleToggleHaptic(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "hapticToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "hapticToggle")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleHide(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "mentionToggle")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        } else {
            UserDefaults.standard.set(1, forKey: "mentionToggle")
            sender.setOn(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        }
    }
    @objc func handleToggleNotif(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "notifToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "notifToggle")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleSubtle1(sender: UISwitch) {

        print("in subtle tog")

        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "subtleToggle")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "subtleToggle")
            sender.setOn(false, animated: true)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
    }

    @objc func handleToggleDM(sender: UISwitch) {

        print("in dm tog")

        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "dmTog")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "dmTog")
            sender.setOn(false, animated: true)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
    }

    @objc func handleToggleCompav(sender: UISwitch) {

        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "compav")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "compav")
            sender.setOn(false, animated: true)
        }
    }

    @objc func handleTogglePopupset(sender: UISwitch) {

        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "popupset")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "popupset")
            sender.setOn(false, animated: true)
        }
    }





    @objc func handleToggleBio(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "biometrics")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "biometrics")
            sender.setOn(false, animated: true)
        }
    }

    @objc func handleToggleBioNot(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "biometricsnot")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "biometricsnot")
            sender.setOn(false, animated: true)
        }
    }





    @objc func handleToggleSensitiveMain(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "senseTog")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        } else {
            UserDefaults.standard.set(0, forKey: "senseTog")
            sender.setOn(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        }
    }
    @objc func handleToggleSensitive(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "sensitiveToggle")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        } else {
            UserDefaults.standard.set(0, forKey: "sensitiveToggle")
            sender.setOn(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
        }
    }
    @objc func handleToggleSelectSwipe(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "selectSwipe")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "selectSwipe")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleSelectGraph(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "setGraph")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refrefref"), object: self)
        } else {
            UserDefaults.standard.set(1, forKey: "setGraph")
            sender.setOn(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refrefref"), object: self)
        }
    }
    @objc func handleToggleSelectGraph2(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "setGraph2")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "setGraph2")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleSelectBoost3(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "boostpro3")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "boostpro3")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleSelectJump(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "juto")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "juto")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleThumbsc(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "thumbsc")
            sender.setOn(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "activateCrown"), object: self)
        } else {
            UserDefaults.standard.set(0, forKey: "thumbsc")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleLinkcards(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "linkcards")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "linkcards")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleAutol(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "autol1")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "autol1")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleBadgeMent(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "badgeMent")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "badgeMent")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleEmotiSug(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "emotisug")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(1, forKey: "emotisug")
            sender.setOn(false, animated: true)
        }
    }
    @objc func handleToggleBoostusern(sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(1, forKey: "boostusern")
            sender.setOn(true, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: "boostusern")
            sender.setOn(false, animated: true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appcell", for: indexPath) as! AppIconsCells

            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                cell.configure()
            case .pad:
                print("nothing")
                cell.configure()
            default:
                cell.configure()
            }

            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            cell.frame.size.width = 60
            cell.frame.size.height = 60
            return cell
        } else if indexPath.section == 1 {
            
            if indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 15 || indexPath.row == 17 || indexPath.row == 18 || indexPath.row == 19 || indexPath.row == 20 || indexPath.row == 24 || indexPath.row == 26 || indexPath.row == 27 || indexPath.row == 29 || indexPath.row == 30 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }  else {


                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse25", for: indexPath) as! SettingsCellToggle
                cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                if indexPath.row == 0 {
                    // realtime stream
                    if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleStream), for: .touchUpInside)
                }
//                if indexPath.row == 1 {
//                    // notifs
//
//                    if UIApplication.shared.isRegisteredForRemoteNotifications {
//                        cell.switchView.setOn(true, animated: false)
//                    } else {
//                        cell.switchView.setOn(false, animated: false)
//                    }
//                    cell.switchView.addTarget(self, action: #selector(self.handleNotifsStream), for: .touchUpInside)
//                }
                if indexPath.row == 2 {
                    // haptics
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleHaptic), for: .touchUpInside)
                }
                if indexPath.row == 3 {
                    // sensitive
                    if (UserDefaults.standard.object(forKey: "senseTog") == nil) || (UserDefaults.standard.object(forKey: "senseTog") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSensitiveMain), for: .touchUpInside)
                }
                if indexPath.row == 10 {
                    // select swipe

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse099", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "selectSwipe") == nil) || (UserDefaults.standard.object(forKey: "selectSwipe") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectSwipe), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 13 {
                    // select graph

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse0991", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "setGraph") == nil) || (UserDefaults.standard.object(forKey: "setGraph") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectGraph), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 14 {
                    // select graph animation

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse0992", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "setGraph2") == nil) || (UserDefaults.standard.object(forKey: "setGraph2") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectGraph2), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 16 {
                    // select boost

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse0993", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "boostpro3") == nil) || (UserDefaults.standard.object(forKey: "boostpro3") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectBoost3), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 21 {
                    // select jump top

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse099309", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "juto") == nil) || (UserDefaults.standard.object(forKey: "juto") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleSelectJump), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 22 {
                    // thumb scroller

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse0993091", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "thumbsc") == nil) || (UserDefaults.standard.object(forKey: "thumbsc") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleThumbsc), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 23 {
                    // link cards

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse0993092", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "linkcards") == nil) || (UserDefaults.standard.object(forKey: "linkcards") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleLinkcards), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 25 {
                    // auto load

                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse0993093", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "autol1") == nil) || (UserDefaults.standard.object(forKey: "autol1") as! Int == 0) {
                        cell.switchView.setOn(false, animated: false)
                    } else {
                        cell.switchView.setOn(true, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleAutol), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 28 {
                    // mentions badge
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse0993093999", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "badgeMent") == nil) || (UserDefaults.standard.object(forKey: "badgeMent") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleBadgeMent), for: .touchUpInside)
                    return cell
                }
                if indexPath.row == 31 {
                    // emoti suggestions
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse09930939995", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.generalArray[indexPath.row], status2: self.generalArrayDesc[indexPath.row], image: self.generalArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    if (UserDefaults.standard.object(forKey: "emotisug") == nil) || (UserDefaults.standard.object(forKey: "emotisug") as! Int == 0) {
                        cell.switchView.setOn(true, animated: false)
                    } else {
                        cell.switchView.setOn(false, animated: false)
                    }
                    cell.switchView.addTarget(self, action: #selector(self.handleToggleEmotiSug), for: .touchUpInside)
                    return cell
                }
                return cell

            }
        } else if indexPath.section == 2 {

            if indexPath.row == 0 {

                let cell = tableView.dequeueReusableCell(withIdentifier: "colcell", for: indexPath) as! ColourCells
                cell.configure()
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                cell.frame.size.width = 60
                cell.frame.size.height = 60
                return cell
            } else {
                
                
                if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 13 || indexPath.row == 23 || indexPath.row == 24 || indexPath.row == 25 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse2", for: indexPath) as! SettingsCellToggle
                    cell.configure(status: self.appearanceArray[indexPath.row], status2: self.appearanceArrayDesc[indexPath.row], image: self.appearanceArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView

                    if indexPath.row == 5 {
                        // realtime stream
                        if (UserDefaults.standard.object(forKey: "sensitiveToggle") == nil) || (UserDefaults.standard.object(forKey: "sensitiveToggle") as! Int == 0) {
                            cell.switchView.setOn(false, animated: false)
                        } else {
                            cell.switchView.setOn(true, animated: false)
                        }
                        cell.switchView.addTarget(self, action: #selector(self.handleToggleSensitive), for: .touchUpInside)
                    }
                    if indexPath.row == 6 {
                        // haptics
                        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil) || (UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
                            cell.switchView.setOn(true, animated: false)
                        } else {
                            cell.switchView.setOn(false, animated: false)
                        }
                        cell.switchView.addTarget(self, action: #selector(self.handleToggleHide), for: .touchUpInside)
                    }
                    if indexPath.row == 7 {
                        // haptics
                        if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                            cell.switchView.setOn(true, animated: false)
                        } else {
                            cell.switchView.setOn(false, animated: false)
                        }
                        cell.switchView.addTarget(self, action: #selector(self.handleToggleNotif), for: .touchUpInside)
                    }
                    if indexPath.row == 13 {
                        // subtle
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cellse23", for: indexPath) as! SettingsCellToggle
                        cell.configure(status: self.appearanceArray[indexPath.row], status2: self.appearanceArrayDesc[indexPath.row], image: self.appearanceArrayIm[indexPath.row])
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                        cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView

                        if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                            cell.switchView.setOn(false, animated: false)
                        } else {
                            cell.switchView.setOn(true, animated: false)
                        }
                        cell.switchView.addTarget(self, action: #selector(self.handleToggleSubtle1), for: .touchUpInside)

                        return cell
                    }
//                    if indexPath.row == 18 {
//                        // dm
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "cellse231", for: indexPath) as! SettingsCellToggle
//                        cell.configure(status: self.appearanceArray[indexPath.row], status2: self.appearanceArrayDesc[indexPath.row], image: self.appearanceArrayIm[indexPath.row])
//                        cell.backgroundColor = Colours.white
//                        cell.userName.textColor = Colours.black
//                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
//                        cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
//                        let bgColorView = UIView()
//                        bgColorView.backgroundColor = Colours.white
//                        cell.selectedBackgroundView = bgColorView
//
//                        if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
//                            cell.switchView.setOn(false, animated: false)
//                        } else {
//                            cell.switchView.setOn(true, animated: false)
//                        }
//                        cell.switchView.addTarget(self, action: #selector(self.handleToggleDM), for: .touchUpInside)
//
//                        return cell
//                    }
                    if indexPath.row == 23 {
                        // comp av
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cellse09936", for: indexPath) as! SettingsCellToggle
                        cell.configure(status: self.appearanceArray[indexPath.row], status2: self.appearanceArrayDesc[indexPath.row], image: self.appearanceArrayIm[indexPath.row])
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                        cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView

                        if (UserDefaults.standard.object(forKey: "compav") == nil) || (UserDefaults.standard.object(forKey: "compav") as! Int == 0) {
                            cell.switchView.setOn(false, animated: false)
                        } else {
                            cell.switchView.setOn(true, animated: false)
                        }
                        cell.switchView.addTarget(self, action: #selector(self.handleToggleCompav), for: .touchUpInside)

                        return cell
                    }
                    if indexPath.row == 24 {
                        // popup
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cellse099367", for: indexPath) as! SettingsCellToggle
                        cell.configure(status: self.appearanceArray[indexPath.row], status2: self.appearanceArrayDesc[indexPath.row], image: self.appearanceArrayIm[indexPath.row])
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                        cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView

                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {
                            cell.switchView.setOn(true, animated: false)
                        } else {
                            cell.switchView.setOn(false, animated: false)
                        }
                        cell.switchView.addTarget(self, action: #selector(self.handleTogglePopupset), for: .touchUpInside)

                        return cell
                    }
                    if indexPath.row == 25 {
                        // boost username
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cellse09936781", for: indexPath) as! SettingsCellToggle
                        cell.configure(status: self.appearanceArray[indexPath.row], status2: self.appearanceArrayDesc[indexPath.row], image: self.appearanceArrayIm[indexPath.row])
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                        cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        
                        if (UserDefaults.standard.object(forKey: "boostusern") == nil) || (UserDefaults.standard.object(forKey: "boostusern") as! Int == 0) {
                            cell.switchView.setOn(false, animated: false)
                        } else {
                            cell.switchView.setOn(true, animated: false)
                        }
                        cell.switchView.addTarget(self, action: #selector(self.handleToggleBoostusern), for: .touchUpInside)
                        
                        return cell
                    }
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                    cell.configure(status: self.appearanceArray[indexPath.row], status2: self.appearanceArrayDesc[indexPath.row], image: self.appearanceArrayIm[indexPath.row])
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    return cell
                }

            }


        } else if indexPath.section == 3 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse2", for: indexPath) as! SettingsCellToggle
            cell.configure(status: self.bioArray[indexPath.row], status2: self.bioArrayDesc[indexPath.row], image: self.bioArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView

            if indexPath.row == 0 {
                if (UserDefaults.standard.object(forKey: "biometrics") == nil) || (UserDefaults.standard.object(forKey: "biometrics") as! Int == 0) {
                    cell.switchView.setOn(false, animated: false)
                } else {
                    cell.switchView.setOn(true, animated: false)
                }
                cell.switchView.addTarget(self, action: #selector(self.handleToggleBio), for: .touchUpInside)
            } else {
                if (UserDefaults.standard.object(forKey: "biometricsnot") == nil) || (UserDefaults.standard.object(forKey: "biometricsnot") as! Int == 0) {
                    cell.switchView.setOn(false, animated: false)
                } else {
                    cell.switchView.setOn(true, animated: false)
                }
                cell.switchView.addTarget(self, action: #selector(self.handleToggleBioNot), for: .touchUpInside)
            }

            return cell

        } else if indexPath.section == 4 {

            if indexPath.row == InstanceData.getAllInstances().count  {

                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                cell.configure(status: "Add Account", status2: "Add a new account from any instance.", image: "newac1", imageURL: nil)
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                print("count--")
                print(Account.getAccounts().count)
                let z1 = Account.getAccounts()
                let z2 = InstanceData.getAllInstances()
                let instance = z2[indexPath.row]
                let account = z1[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
                let instanceAndAccount = "\(instance.returnedText) "

                let instances = InstanceData.getAllInstances()
                let curr = InstanceData.getCurrentInstance()
                if curr?.clientID == z2[indexPath.row].clientID {
                    cell.configure(status: "• \(account.username ?? "")", status2: instanceAndAccount, image: "", imageURL: account.avatarStatic ?? "")
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.tabSelected
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                } else {
                    cell.configure(status: account.username ?? "", status2: instanceAndAccount, image: "", imageURL: account.avatarStatic ?? "")
                    cell.backgroundColor = Colours.white
                    cell.userName.textColor = Colours.black
                    cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
                    cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
                }
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellse", for: indexPath) as! SettingsCell
            cell.configure(status: self.aboutArray[indexPath.row], status2: self.aboutArrayDesc[indexPath.row], image: self.aboutArrayIm[indexPath.row])
            cell.backgroundColor = Colours.white
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.8)
            cell.toot.textColor = Colours.black.withAlphaComponent(0.5)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 1 {

            if indexPath.row == 1 {

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "pnmentions") == nil) || (UserDefaults.standard.object(forKey: "pnmentions") as! Bool == true) {
                    filledSet1 = UIImage(named: "filledset")
                } else {
                    filledSet1 = UIImage(named: "unfilledset")
                }
                if (UserDefaults.standard.object(forKey: "pnlikes") == nil) || (UserDefaults.standard.object(forKey: "pnlikes") as! Bool == true) {
                    filledSet2 = UIImage(named: "filledset")
                } else {
                    filledSet2 = UIImage(named: "unfilledset")
                }
                if (UserDefaults.standard.object(forKey: "pnboosts") == nil) || (UserDefaults.standard.object(forKey: "pnboosts") as! Bool == true) {
                    filledSet3 = UIImage(named: "filledset")
                } else {
                    filledSet3 = UIImage(named: "unfilledset")
                }
                if (UserDefaults.standard.object(forKey: "pnfollows") == nil) || (UserDefaults.standard.object(forKey: "pnfollows") as! Bool == true) {
                    filledSet4 = UIImage(named: "filledset")
                } else {
                    filledSet4 = UIImage(named: "unfilledset")
                }


                // push not
                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Mentions".localized), image: filledSet1) { (action, ind) in
                         
                        if (UserDefaults.standard.object(forKey: "pnmentions") == nil) || (UserDefaults.standard.object(forKey: "pnmentions") as! Bool == true) {
                            UserDefaults.standard.set(false, forKey: "pnmentions")
                            UIApplication.shared.registerForRemoteNotifications()
                        } else {
                            UserDefaults.standard.set(true, forKey: "pnmentions")
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    .action(.default("Likes".localized), image: filledSet2) { (action, ind) in
                         
                        if (UserDefaults.standard.object(forKey: "pnlikes") == nil) || (UserDefaults.standard.object(forKey: "pnlikes") as! Bool == true) {
                            UserDefaults.standard.set(false, forKey: "pnlikes")
                            UIApplication.shared.registerForRemoteNotifications()
                        } else {
                            UserDefaults.standard.set(true, forKey: "pnlikes")
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    .action(.default("Boosts".localized), image: filledSet3) { (action, ind) in
                         
                        if (UserDefaults.standard.object(forKey: "pnboosts") == nil) || (UserDefaults.standard.object(forKey: "pnboosts") as! Bool == true) {
                            UserDefaults.standard.set(false, forKey: "pnboosts")
                            UIApplication.shared.registerForRemoteNotifications()
                        } else {
                            UserDefaults.standard.set(true, forKey: "pnboosts")
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    .action(.default("Follows".localized), image: filledSet4) { (action, ind) in
                         
                        if (UserDefaults.standard.object(forKey: "pnfollows") == nil) || (UserDefaults.standard.object(forKey: "pnfollows") as! Bool == true) {
                            UserDefaults.standard.set(false, forKey: "pnfollows")
                            UIApplication.shared.registerForRemoteNotifications()
                        } else {
                            UserDefaults.standard.set(true, forKey: "pnfollows")
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }

            if indexPath.row == 4 {

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "privToot") == nil) || (UserDefaults.standard.object(forKey: "privToot") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                }


                // privacy
                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Public - Post to public timelines".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "privToot")
                    }
                    .action(.default("Unlisted - Do not post to public timelines".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "privToot")
                    }
                    .action(.default("Private - Post only to followers".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "privToot")
                    }
                    .action(.default("Direct - Post to mentioned users only".localized), image: filledSet4) { (action, ind) in
                         
                        UserDefaults.standard.set(3, forKey: "privToot")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }

            if indexPath.row == 5 {
                // keyboard



                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "keyb") == nil) || (UserDefaults.standard.object(forKey: "keyb") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "keyb") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }



                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Social".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "keyb")
                    }
                    .action(.default("Default".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "keyb")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 6 {
                // long


                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                var filledSet6 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "longToggle") == nil) || (UserDefaults.standard.object(forKey: "longToggle") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 6) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "filledset")
                }


                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Cycle Through Themes".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "longToggle")
                    }
                    .action(.default("Invoke Lists".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "longToggle")
                    }
                    .action(.default("Invoke Search".localized), image: filledSet5) { (action, ind) in
                         
                        UserDefaults.standard.set(4, forKey: "longToggle")
                    }
                    .action(.default("Invoke Toot Composer".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "longToggle")
                    }
                    .action(.default("Rain Confetti".localized), image: filledSet4) { (action, ind) in
                         
                        UserDefaults.standard.set(3, forKey: "longToggle")
                    }
                    .action(.default("Do Nothing".localized), image: filledSet6) { (action, ind) in
                         
                        UserDefaults.standard.set(6, forKey: "longToggle")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 7 {
                // quality


                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "imqual") == nil) || (UserDefaults.standard.object(forKey: "imqual") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "imqual") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "imqual") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }



                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Low".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "imqual")
                    }
                    .action(.default("Average".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "imqual")
                    }
                    .action(.default("High".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "imqual")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 8 {
                // pos
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "posset") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Retain Scroll Position".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "posset")
                    }
                    .action(.default("Scroll to the Top".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "posset")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 9 {
                // vid
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "vidgif") == nil) || (UserDefaults.standard.object(forKey: "vidgif") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "vidgif") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Stock Video Player".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "vidgif")
                    }
                    .action(.default("Custom Picture-in-Picture".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "vidgif")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 11 {
                // swipe order
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                var filledSet6 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "sworder") == nil) || (UserDefaults.standard.object(forKey: "sworder") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                    filledSet6 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "sworder") as! Int == 5) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Reply Like Boost".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "sworder")
                    }
                    .action(.default("Reply Boost Like".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "sworder")
                    }
                    .action(.default("Boost Reply Like".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "sworder")
                    }
                    .action(.default("Boost Like Reply".localized), image: filledSet4) { (action, ind) in
                         
                        UserDefaults.standard.set(3, forKey: "sworder")
                    }
                    .action(.default("Like Reply Boost".localized), image: filledSet5) { (action, ind) in
                         
                        UserDefaults.standard.set(4, forKey: "sworder")
                    }
                    .action(.default("Like Boost Reply".localized), image: filledSet6) { (action, ind) in
                         
                        UserDefaults.standard.set(5, forKey: "sworder")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 12 {
                // mentions default
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "mentdef2") == nil) || (UserDefaults.standard.object(forKey: "mentdef2") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "mentdef2") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("@You".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "mentdef2")
                    }
                    .action(.default("Activity".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "mentdef2")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 15 {
                // toot action placement

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "tootpl") as? Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "tootpl") == nil) || (UserDefaults.standard.object(forKey: "tootpl") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Swipe Cells to Display Actions".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "tootpl")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Actions on Status Cells".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "tootpl")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 17 {
                // shake gesture

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "shakegest") == nil) || (UserDefaults.standard.object(forKey: "shakegest") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "shakegest") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "shakegest") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Hide Sensitive Content".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "shakegest")
                    }
                    .action(.default("Rain Confetti".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "shakegest")
                    }
                    .action(.default("Do Nothing".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "shakegest")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 18 {
                // initial timeline

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "inittimeline") == nil) || (UserDefaults.standard.object(forKey: "inittimeline") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "inittimeline") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "inittimeline") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Home".localized), image: filledSet1) { (action, ind) in
                         
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(0, forKey: "inittimeline")
                    }
                    .action(.default("Local".localized), image: filledSet2) { (action, ind) in
                         
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(1, forKey: "inittimeline")
                    }
                    .action(.default("All".localized), image: filledSet3) { (action, ind) in
                         
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(2, forKey: "inittimeline")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 19 {
                // search scope

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "searchsco") == nil) || (UserDefaults.standard.object(forKey: "searchsco") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "searchsco") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("All".localized), image: filledSet1) { (action, ind) in
                         
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(0, forKey: "searchsco")
                    }
                    .action(.default("Local".localized), image: filledSet2) { (action, ind) in
                         
                        StoreStruct.initTimeline = false
                        UserDefaults.standard.set(1, forKey: "searchsco")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 20 {
                // key haptics

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "keyhap") == nil) || (UserDefaults.standard.object(forKey: "keyhap") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Disabled".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "keyhap")
                    }
                    .action(.default("Mild".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "keyhap")
                    }
                    .action(.default("Wild".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "keyhap")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 24 {
                // load more

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "lmore1") == nil) || (UserDefaults.standard.object(forKey: "lmore1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "lmore1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Retain Scroll".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "lmore1")
                    }
                    .action(.default("Jump Below New Toots".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "lmore1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 26 {
                // profile secondary button

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "likepin") == nil) || (UserDefaults.standard.object(forKey: "likepin") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "likepin") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "likepin") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Liked".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "likepin")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    }
                    .action(.default("Pinned".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "likepin")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    }
                    .action(.default("Edit Profile".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "likepin")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 27 {
                // swipe recent media

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "swrece") == nil) || (UserDefaults.standard.object(forKey: "swrece") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "swrece") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Swipe Attached Images".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "swrece")
                    }
                    .action(.default("Swipe Recent Media".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "swrece")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 29 {
                // dm style
                
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "dmchats") == nil) || (UserDefaults.standard.object(forKey: "dmchats") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "dmchats") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Chat Style".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "dmchats")
                    }
                    .action(.default("Toot Style".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "dmchats")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 30 {
                // link destination
                
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "linkdest") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }
                
                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("In-app".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "linkdest")
                    }
                    .action(.default("Safari".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "linkdest")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                    .show(on: self)
            }
            
            
        }

        if indexPath.section == 2 {
            if indexPath.row == 1 {
                // theme

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "theme") == nil) || (UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "theme") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "theme") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "theme") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                }


                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Day".localized), image: filledSet1) { (action, ind) in
                         
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "light"), object: self)
                    }
                    .action(.default("Dusk".localized), image: filledSet2) { (action, ind) in
                         
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "night"), object: self)
                    }
                    .action(.default("Night".localized), image: filledSet3) { (action, ind) in
                         
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "night2"), object: self)
                    }
                    .action(.default("Midnight".localized), image: filledSet4) { (action, ind) in
                         
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "black"), object: self)
                    }
                    .action(.default("Midnight Blue".localized), image: filledSet5) { (action, ind) in
                         
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "midblue"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 2 {
                // text size


                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                var filledSet6 = UIImage(named: "unfilledset")
                var filledSet7 = UIImage(named: "unfilledset")
                var filledSet8 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "systemText") == nil) || (UserDefaults.standard.object(forKey: "systemText") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 0) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "filledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 5) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "filledset")
                    filledSet8 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 6) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                    filledSet6 = UIImage(named: "unfilledset")
                    filledSet7 = UIImage(named: "unfilledset")
                    filledSet8 = UIImage(named: "filledset")
                }


                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("System Text Size".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "systemText")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("8 Points".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(0, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("9 Points".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(1, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("10 Points".localized), image: filledSet4) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(2, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("11 Points".localized), image: filledSet5) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(3, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("12 Points".localized), image: filledSet6) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(4, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("13 Points".localized), image: filledSet7) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(5, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("14 Points".localized), image: filledSet8) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "systemText")
                        UserDefaults.standard.set(6, forKey: "fontSize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 3 {
                // profile radius



                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "proCorner") == nil) || (UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }


                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Circle".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "proCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.default("Rounded Square".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "proCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.default("Square".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "proCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 4 {
                // image radius
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "imCorner") == nil) || (UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Rounded Rectangle".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "imCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.default("Rectangle".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "imCorner")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 8 {
                // gallery size

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "colgrid") == nil) || (UserDefaults.standard.object(forKey: "colgrid") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "colgrid") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "colgrid") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("2 Column Grid".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "colgrid")
                    }
                    .action(.default("3 Column Grid".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "colgrid")
                    }
                    .action(.default("4 Column Grid".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "colgrid")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 9 {
                // time relative
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "timerel") == nil) || (UserDefaults.standard.object(forKey: "timerel") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "timerel") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Absolute".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "timerel")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.default("Relative".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "timerel")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 10 {
                // bg header
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "headbg1") == nil) || (UserDefaults.standard.object(forKey: "headbg1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "headbg1") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "headbg1") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Light".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "headbg1")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Regular".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "headbg1")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Dark".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(3, forKey: "headbg1")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 11 {
                // segments size

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "segsize") == nil) || (UserDefaults.standard.object(forKey: "segsize") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "segsize") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Small".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "segsize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSeg"), object: self)
                    }
                    .action(.default("Large".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "segsize")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSeg"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 12 {
                // segments style
                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "segstyle") == nil) || (UserDefaults.standard.object(forKey: "segstyle") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "segstyle") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Static".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "segstyle")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSeg"), object: self)
                    }
                    .action(.default("Liquid".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "segstyle")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSeg"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 14 {
                // border



                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "bord") == nil) || (UserDefaults.standard.object(forKey: "bord") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "bord") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "bord") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }



                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("None".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "bord")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Mild".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "bord")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.default("Wild".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "bord")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 15 {
                // pinch


                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                var filledSet5 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "screenshotcol") == nil) || (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                    filledSet5 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 4) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                    filledSet5 = UIImage(named: "filledset")
                }


                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Theme".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "screenshotcol")
                    }
                    .action(.default("Dusk".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "screenshotcol")
                    }
                    .action(.default("Night".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "screenshotcol")
                    }
                    .action(.default("Midnight".localized), image: filledSet4) { (action, ind) in
                         
                        UserDefaults.standard.set(3, forKey: "screenshotcol")
                    }
                    .action(.default("Midnight Blue".localized), image: filledSet5) { (action, ind) in
                         
                        UserDefaults.standard.set(4, forKey: "screenshotcol")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 16 {
                // caption

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "captionset") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "captionset") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                }


                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Status Text".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "captionset")
                    }
                    .action(.default("Image Alt Text".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "captionset")
                    }
                    .action(.default("No Caption".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "captionset")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 17 {
                // progress

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "progprogprogprog") == nil) || (UserDefaults.standard.object(forKey: "progprogprogprog") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "progprogprogprog") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Hidden".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "progprogprogprog")
                    }
                    .action(.default("Displayed".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "progprogprogprog")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 18 {
                // dmtog

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                var filledSet3 = UIImage(named: "unfilledset")
                var filledSet4 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "dmTog") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "dmTog") as! Int == 2) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "filledset")
                    filledSet4 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "dmTog") as! Int == 3) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "unfilledset")
                    filledSet3 = UIImage(named: "unfilledset")
                    filledSet4 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("None".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "dmTog")
                    }
                    .action(.default("Subtle".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "dmTog")
                    }
                    .action(.default("Distinct".localized), image: filledSet3) { (action, ind) in
                         
                        UserDefaults.standard.set(2, forKey: "dmTog")
                    }
                    .action(.default("Theme".localized), image: filledSet4) { (action, ind) in
                         
                        UserDefaults.standard.set(3, forKey: "dmTog")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 19 {
                // bar hue

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "barhue1") == nil) || (UserDefaults.standard.object(forKey: "barhue1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "barhue1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Theme Hue".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "barhue1")
                    }
                    .action(.default("Subtle".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "barhue1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 20 {
                // activity hue

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "acthue1") == nil) || (UserDefaults.standard.object(forKey: "acthue1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "acthue1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Theme Hue".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "acthue1")
                    }
                    .action(.default("Subtle".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "acthue1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 21 {
                // segments hue

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "seghue1") == nil) || (UserDefaults.standard.object(forKey: "seghue1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "seghue1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Theme Hue".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "seghue1")
                    }
                    .action(.default("Subtle".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "seghue1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 22 {
                // instance icon

                var filledSet1 = UIImage(named: "unfilledset")
                var filledSet2 = UIImage(named: "unfilledset")
                if (UserDefaults.standard.object(forKey: "insicon1") == nil) || (UserDefaults.standard.object(forKey: "insicon1") as! Int == 0) {
                    filledSet1 = UIImage(named: "filledset")
                    filledSet2 = UIImage(named: "unfilledset")
                } else if (UserDefaults.standard.object(forKey: "insicon1") as! Int == 1) {
                    filledSet1 = UIImage(named: "unfilledset")
                    filledSet2 = UIImage(named: "filledset")
                }

                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("List Icon".localized), image: filledSet1) { (action, ind) in
                         
                        UserDefaults.standard.set(0, forKey: "insicon1")
                    }
                    .action(.default("Profile Icon".localized), image: filledSet2) { (action, ind) in
                         
                        UserDefaults.standard.set(1, forKey: "insicon1")
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 2))?.contentView ?? self.view)
                    .show(on: self)
            }
        }




        if indexPath.section == 5 {
            if indexPath.row == 0 {
                // about
                Alertift.actionSheet(title: "Mast \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")", message: "A beautiful Mastodon client\nMade with the intention to be reliant\nIt's fast, it's fluid, it's fun\nBut most of all, it's built with love for everyone\n\nDesigned and created by @JPEG@mastodon.technology".localized)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 4))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 1 {
//                SKStoreReviewController.requestReview()
                if let reviewURL = URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/1437429129?action=write-review&mt=8"), UIApplication.shared.canOpenURL(reviewURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(reviewURL)
                    }
                }
            }
            if indexPath.row == 2 {
                // follow
                Alertift.actionSheet(title: title, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Developer Mastodon".localized)) { (action, ind) in
                         
                        
                        
//                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
//                            let notification = UINotificationFeedbackGenerator()
//                            notification.notificationOccurred(.success)
//                        }
//                        let statusAlert = StatusAlert()
//                        statusAlert.image = UIImage(named: "profilelarge")?.maskWithColor(color: Colours.grayDark)
//                        statusAlert.title = "Followed".localized
//                        statusAlert.contentColor = Colours.grayDark
//                        statusAlert.message = "Mastodon Developer"
//                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
//                        statusAlert.show()
//                    }
//
//                        if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
//                            NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
//                        }
                        
                        let controller = ThirdViewController()
                        controller.fromOtherUser = true
                        controller.userIDtoUse = "107304"
                        self.navigationController?.pushViewController(controller, animated: true)
                        
//                        let request = Accounts.follow(id: "107304")
//                        StoreStruct.client.run(request) { (statuses) in
//                            if let _ = (statuses.value) {
//                                
//                            }
//                        }
                    }
                    .action(.default("Developer Twitter".localized)) { (action, ind) in
                         
                        let twUrl = URL(string: "twitter://user?screen_name=JPEGuin")!
                        let twUrlWeb = URL(string: "https://www.twitter.com/JPEGuin")!
                        if UIApplication.shared.canOpenURL(twUrl) {
                            UIApplication.shared.open(twUrl, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.open(twUrlWeb, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: twUrlWeb)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(twUrlWeb)
                                    }
                                }
                            }
                        }
                    }
                    .action(.default("Mast Twitter".localized)) { (action, ind) in
                         
                        let twUrl = URL(string: "twitter://user?screen_name=TheMastApp")!
                        let twUrlWeb = URL(string: "https://www.twitter.com/TheMastApp")!
                        if UIApplication.shared.canOpenURL(twUrl) {
                            UIApplication.shared.open(twUrl, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.open(twUrlWeb, options: [.universalLinksOnly: true]) { (success) in
                                if !success {
                                    if (UserDefaults.standard.object(forKey: "linkdest") == nil) || (UserDefaults.standard.object(forKey: "linkdest") as! Int == 0) {
                                    self.safariVC = SFSafariViewController(url: twUrlWeb)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                    } else {
                                        UIApplication.shared.openURL(twUrlWeb)
                                    }
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
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 4))?.contentView ?? self.view)
                    .show(on: self)
            }
            if indexPath.row == 3 {
                // schemes
                Alertift.actionSheet(title: nil, message: "com.shi.mastodon://light : Switch to the light white theme\n\ncom.shi.mastodon://dark : Switch to the dark theme\n\ncom.shi.mastodon://darker : Switch to the darker theme\n\ncom.shi.mastodon://black : Switch to the black OLED theme\n\ncom.shi.mastodon://blue : Switch to the midnight blue theme\n\ncom.shi.mastodon://confetti : Make it rain confetti\n\ncom.shi.mastodon://onboard : Present the onboarding pop-up again\n\ncom.shi.mastodon://home : Switch to the home tab\n\ncom.shi.mastodon://mentions : Switch to the mentions tab\n\ncom.shi.mastodon://direct : Switch to the direct messages tab\n\ncom.shi.mastodon://profile : Switch to the profile tab\n\ncom.shi.mastodon://toot : Present the toot composer screen\n\ncom.shi.mastodon://settings : Present the settings section\n\ncom.shi.mastodon://toot=hello : Post a toot with the text 'hello'\n\ncom.shi.mastodon://id=123 : Go to a toot with the ID 123\n\ncom.shi.mastodon://instance=mastodon.technology : Go to an instance with the url mastodon.technology")
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 4))?.contentView ?? self.view)
                    .show(on: self)
            }
        }
        
        
        //tjar
        
        if indexPath.section == 6 {
            if indexPath.row == 0 {
                purchaseMyProduct(product: iapProducts[0])
            }
            if indexPath.row == 1 {
                purchaseMyProduct(product: iapProducts[1])
            }
            if indexPath.row == 2 {
                purchaseMyProduct(product: iapProducts[2])
            }
            if indexPath.row == 3 {
                purchaseMyProduct(product: iapProducts[3])
            }
        }
        
        if indexPath.section == 4 {
            let instances = InstanceData.getAllInstances()
            if indexPath.row == instances.count {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "signOut2"), object: nil)
            } else {

                //bhere3


                let curr = InstanceData.getCurrentInstance()
                if curr?.clientID == instances[indexPath.row].clientID {



                    Alertift.actionSheet(title: "Already selected", message: "Pick another account, or add a new one.")
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .show(on: self)


                } else {


                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Switch".localized), image: UIImage(named: "profile")) { (action, ind) in
                         
                        
                        
                        
                        DispatchQueue.main.async {
                            
                            InstanceData.setCurrentInstance(instance: instances[indexPath.row])
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.reloadApplication()
                            
                        }

                    }
                    .action(.default("Remove".localized), image: UIImage(named: "block")) { (action, ind) in
                         
                        
                        var instance = InstanceData.getAllInstances()
                        var account = Account.getAccounts()
                        account.remove(at: indexPath.row)
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(account), forKey:"allAccounts")
                        instance.remove(at: indexPath.row)
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(instance), forKey:"instances")

                        self.tableView.reloadSections([5], with: .none)

                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .show(on: self)


                }


            }
        }

    }


    func loadLoadLoad() {
        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            Colours.white = UIColor.white
            Colours.white2 = UIColor(red: 203/255.0, green: 202/255.0, blue: 206/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 40/250, green: 40/250, blue: 40/250, alpha: 1.0)
            Colours.grayDark2 = UIColor(red: 110/250, green: 113/250, blue: 121/250, alpha: 1.0)
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.black = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
            Colours.white = UIColor(red: 46/255.0, green: 46/255.0, blue: 52/255.0, alpha: 1.0)
            Colours.white2 = UIColor(red: 28/255.0, green: 28/255.0, blue: 38/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 33/255.0, green: 33/255.0, blue: 43/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 80/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 2) {
            Colours.white = UIColor(red: 36/255.0, green: 33/255.0, blue: 37/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 33/255.0, green: 33/255.0, blue: 43/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 80/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 4) {
            Colours.white = UIColor(red: 41/255.0, green: 50/255.0, blue: 78/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 20/255.0, green: 20/255.0, blue: 29/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 80/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            Colours.white = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            Colours.white2 = UIColor(red: 36/255.0, green: 36/255.0, blue: 46/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 10/255.0, green: 10/255.0, blue: 20/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        }

        self.view.backgroundColor = Colours.white

        if (UserDefaults.standard.object(forKey: "systemText") == nil) || (UserDefaults.standard.object(forKey: "systemText") as! Int == 0) {
            Colours.fontSize1 = CGFloat(UIFont.systemFontSize)
            Colours.fontSize3 = CGFloat(UIFont.systemFontSize)
        } else {
            if (UserDefaults.standard.object(forKey: "fontSize") == nil) {
                Colours.fontSize0 = 14
                Colours.fontSize2 = 10
                Colours.fontSize1 = 14
                Colours.fontSize3 = 10
            } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 0) {
                Colours.fontSize0 = 12
                Colours.fontSize2 = 8
                Colours.fontSize1 = 12
                Colours.fontSize3 = 8
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 1) {
                Colours.fontSize0 = 13
                Colours.fontSize2 = 9
                Colours.fontSize1 = 13
                Colours.fontSize3 = 9
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 2) {
                Colours.fontSize0 = 14
                Colours.fontSize2 = 10
                Colours.fontSize1 = 14
                Colours.fontSize3 = 10
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 3) {
                Colours.fontSize0 = 15
                Colours.fontSize2 = 11
                Colours.fontSize1 = 15
                Colours.fontSize3 = 11
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 4) {
                Colours.fontSize0 = 16
                Colours.fontSize2 = 12
                Colours.fontSize1 = 16
                Colours.fontSize3 = 12
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 5) {
                Colours.fontSize0 = 17
                Colours.fontSize2 = 13
                Colours.fontSize1 = 17
                Colours.fontSize3 = 13
            } else {
                Colours.fontSize0 = 18
                Colours.fontSize2 = 14
                Colours.fontSize1 = 18
                Colours.fontSize3 = 14
            }
        }

        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        //        var customStyle = VolumeBarStyle.likeInstagram
        //        customStyle.trackTintColor = Colours.cellQuote
        //        customStyle.progressTintColor = Colours.grayDark
        //        customStyle.backgroundColor = Colours.cellNorm
        //        volumeBar.style = customStyle
        //        volumeBar.start()
        //
        //        self.missingView.image = UIImage(named: "missing")?.maskWithColor(color: Colours.tabUnselected)
        //
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.grayDark]
        //        self.collectionView.backgroundColor = Colours.white
        //        self.removeTabbarItemsText()
    }



}
