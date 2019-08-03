//
//  EditProfileViewController.swift
//  mastodon
//
//  Created by Barrett Breshears on 7/30/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    
    @IBOutlet var avatar:UIImageView?
    @IBOutlet var header:UIImageView?
    @IBOutlet var displayName:UITextField?
    @IBOutlet var bio:UITextView?
    @IBOutlet var link:UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
