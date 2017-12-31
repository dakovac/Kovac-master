//
//  HomeViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 29/06/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView
import SafariServices
import WebKit

class HomeViewController: UIViewController,UIWebViewDelegate,SFSafariViewControllerDelegate {
    @IBOutlet weak var webView: WKWebView!
    var webViewCustom: WKWebView!
    
    @IBOutlet weak var webViewWK: UIView!
    var loginUsername: NSString!
    var password: NSString!
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.scrollView.contentInset = UIEdgeInsets.zero;
        self.automaticallyAdjustsScrollViewInsets = false
        webView.load(NSURLRequest(url: NSURL(string: "https://appw.xplan.iress.com.au/client/main#client_dashboard") as! URL) as URLRequest)
    }
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController();
        let userScript = WKUserScript(
            source: "redHeader()",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        contentController.add(
            self as! WKScriptMessageHandler,
            name: "callbackHandler"
        )
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.webView = WKWebView(
            frame: self.webViewWK.bounds,
            configuration: config
        )
        self.webViewWK = self.webView!
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let savedUsername = loginUsername!
        let savedPassword = password!
        
        let fillForm = String(format: "document.getElementById('username').value = '\(savedUsername)';document.getElementById('password').value = '\(savedPassword)';")
        webView.stringByEvaluatingJavaScript(from: fillForm)
        
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('login-button').checked = true;")

        let deadlineTime = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let jsString = "$(cid).prop(\"checked\", true);"
            webView.stringByEvaluatingJavaScript(from: jsString)
            webView.stringByEvaluatingJavaScript(from: "document.getElementById('login-button').click();")
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        URLCache.shared.removeAllCachedResponses()

        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad: Bool){
        print("load")
        //        let savedUsername = loginUsername!
        //        let savedPassword = password!
        //
        //        let fillForm = String(format: "document.getElementById('username').value = '\(loginUsername)';document.getElementById('password').value = '\(password!)';")
        //        svc.stringByEvaluatingJavaScript(from: fillForm)
        //
        //        //        //check checkboxes
        //        svc.stringByEvaluatingJavaScript(from: "document.getElementById('login-button').checked = true;")
        //
        
    }
}
