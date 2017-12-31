//
//  AboutUsViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 17/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var aboutView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://kovacadvisory.com.au/app-how-to/")
        let request = URLRequest(url :url!)
        
        aboutView.load(request)
        
        
    }


    @IBAction func backBtnAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func visitSiteAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.kovacsmartsuper.com.au")!, options: [:], completionHandler: nil)
    }
}
