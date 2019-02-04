//
//  TermsController.swift
//  mastodon
//
//  Created by Barrett Breshears on 2/3/19.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit
class TermsController:UIViewController{
    
    let webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissTerms))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.frame = self.view.frame
        view.addSubview(webView)
        let url = Bundle.main.url(forResource: "terms", withExtension: "rtf")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    @objc func dismissTerms(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
