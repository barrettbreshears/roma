//
//  VerticalTabBarController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 09/06/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class VerticalTabBarController: UIViewController {
    
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    var button4 = UIButton()
    var button5 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.white
        
        let offset = self.navigationController?.navigationBar.frame.size.height ?? 100
        
        self.button1.frame = CGRect(x: 10, y: offset + 10, width: 60, height: 60)
        self.button1.backgroundColor = .clear
        self.button1.setImage(UIImage(named: "toot")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.button1.addTarget(self, action: #selector(self.compose), for: .touchUpInside)
        self.view.addSubview(self.button1)
        
        self.button2.frame = CGRect(x: 10, y: offset + 80, width: 60, height: 60)
        self.button2.backgroundColor = .clear
        self.button2.setImage(UIImage(named: "list")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.view.addSubview(self.button2)
        
        self.button3.frame = CGRect(x: 10, y: offset + 150, width: 60, height: 60)
        self.button3.backgroundColor = .clear
        self.button3.setImage(UIImage(named: "search2")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.view.addSubview(self.button3)
        
        self.button4.frame = CGRect(x: 10, y: offset + 220, width: 60, height: 60)
        self.button4.backgroundColor = .clear
        self.button4.setImage(UIImage(named: "direct")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.view.addSubview(self.button4)
        
        self.button5.frame = CGRect(x: 10, y: offset + 290, width: 60, height: 60)
        self.button5.backgroundColor = .clear
        self.button5.setImage(UIImage(named: "sett")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.button5.addTarget(self, action: #selector(self.settings), for: .touchUpInside)
        self.view.addSubview(self.button5)
    }
    
    @objc func compose() {
        let controller = ComposeViewController()
        controller.inReply = []
        controller.inReplyText = ""
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func settings() {
        let controller = UINavigationController(rootViewController: MainSettingsViewController())
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
    }
}
