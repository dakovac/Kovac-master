//
//  DisclaimerViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class DisclaimerViewController: UIViewController {
    var transferDict = NSMutableDictionary()
    
    @IBOutlet var tickBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(transferDict)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tickAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        if !tickBtn.isSelected{
            
            alertView.showWarning("Kovac Smart Super", subTitle: "Please agree to the terms.", duration: 2)
            return
        }
        
        alertView.showWait("Kovac Smart Super", subTitle: "Please wait while we submit your details", duration: 9)
        
        transferDict.setValue("Yes", forKey:"emp_disclaimer")
        transferDict.setValue("1", forKey:"new")
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.startAnimating()
        self.view.addSubview(activityIndicatorView)
        
        do {
            
            let dataStr = try JSONSerialization.data(withJSONObject: transferDict, options:  JSONSerialization.WritingOptions(rawValue: 0))
            
            var verifyStr = NSString.init(data: dataStr, encoding: String.Encoding.utf8.rawValue)
            verifyStr = verifyStr!.replacingOccurrences(of: ":", with: "=") as NSString?
            verifyStr = verifyStr!.replacingOccurrences(of: ",", with: "&") as NSString?
            verifyStr = verifyStr!.replacingOccurrences(of: "\"", with: "") as NSString?
            verifyStr = verifyStr!.replacingOccurrences(of: "{", with: "") as NSString?
            verifyStr = verifyStr!.replacingOccurrences(of: "}", with: "") as NSString?
            verifyStr = verifyStr!.replacingOccurrences(of: "/", with: "%2F") as NSString?
            verifyStr = verifyStr!.replacingOccurrences(of: " ", with: "%20") as NSString?
            
            //Request Call
            var request = URLRequest(url: URL(string: "https://kovacadvisory.com.au/api/rest/user")!)
            request.httpMethod = "POST"
            let postData = verifyStr!.data(using: String.Encoding.nonLossyASCII.rawValue, allowLossyConversion: false)!
            let postLength = "\(postData.count)"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                activityIndicatorView.stopAnimating()
                activityIndicatorView.isHidden = true
                activityIndicatorView.removeFromSuperview()
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString!)")
                
                DispatchQueue.main.async {
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "SubmittedViewController") as! SubmittedViewController
                    
                    self.navigationController?.pushViewController(personalViewController, animated: true)
                }
                
            }
            task.resume()
            
        } catch let error as NSError {
            print(error.description)
        }
    }
}
