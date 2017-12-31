//
//  MainViewController.swift
//  KovacAdvisory
//
//  Created by Mirko Tomic on 11/26/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import KeychainSwift

class MainViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentWebView.scrollView.bounces = false;
        
        let url = String(format: "https://kovacadvisory.com.au/login.php?username=%@&password=%@", keychain.get("username")!, keychain.get("password")!)

        contentWebView.loadRequest(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.url?.absoluteString
        
        if(url == "https://appw.xplan.iress.com.au/client/main#client_dashboard"){
            self.view.backgroundColor = UIColor(red:0.06, green:0.09, blue:0.15, alpha:1.0)
            UIApplication.shared.statusBarStyle = .lightContent
            activityIndicator.stopAnimating()
        }
        
        if(url == "https://appw.xplan.iress.com.au/client"){
            self.keychain.clear()
            UIApplication.shared.statusBarStyle = .default
            self.dismiss(animated: true, completion: nil)
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        _ = contentWebView.stringByEvaluatingJavaScript(from:"document.documentElement.style.webkitUserSelect='none'")!
        _ = contentWebView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none'")!
    }
}
