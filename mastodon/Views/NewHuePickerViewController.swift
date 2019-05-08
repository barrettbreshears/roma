//
//  NewHuePicker.swift
//  mastodon
//
//  Created by Shihab Mehboob on 03/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import StatusAlert

class NewHuePickerViewController: UIViewController, ChromaColorPickerDelegate {
    
    var closeButton = MNGExpandedTouchAreaButton()
    var tootLabel = UIButton()
    var keyHeight = 0
    var bgView = UIView()
    var titleV = UILabel()
    var editListName = ""
    var listID = ""
    var fromWhich = 0
    var hex = ""
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.white
        
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
        
        self.closeButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 20, y: closeB, width: 32, height: 32)))
        self.closeButton.setImage(UIImage(named: "block")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.closeButton.adjustsImageWhenHighlighted = false
        self.closeButton.addTarget(self, action: #selector(didTouchUpInsideCloseButton), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        
        titleV.frame = CGRect(x: 24, y: offset + 6, width: Int(self.view.bounds.width), height: 30)
        titleV.text = "Hue Picker Wheel".localized
        titleV.textColor = Colours.grayDark2
        titleV.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        self.view.addSubview(titleV)
        
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height/2 - 150, width: 300, height: 300))
        neatColorPicker.delegate = self
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 5
        neatColorPicker.hexLabel.font = UIFont.boldSystemFont(ofSize: 16)
        neatColorPicker.hexLabel.textColor = Colours.grayDark
        
        view.addSubview(neatColorPicker)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTouchUpInsideCloseButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        StoreStruct.hexCol = color
        let stringHex = StoreStruct.hexCol.toHexString()
        Colours.tabSelected = StoreStruct.hexCol
        UIApplication.shared.keyWindow?.tintColor = Colours.tabSelected
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "themeTopStuff"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "segTheme"), object: self)
        UserDefaults.standard.set(500, forKey: "themeaccent")
        
        UserDefaults.standard.set(stringHex.replacingOccurrences(of: "#", with: ""), forKey: "hexhex")
        
        self.dismiss(animated: true, completion: nil)
    }
}
