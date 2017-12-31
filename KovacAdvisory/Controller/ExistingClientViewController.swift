//
//  ExistingClientViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class ExistingClientViewController: UIViewController {
    
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var chooseUsername: UITextField!
    @IBOutlet var emailID: UITextField!
    @IBOutlet var clientName: UITextField!
    
    @IBAction func submitBtnAction(_ sender: Any) {

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        if !self.clientName.hasText || !self.confirmPassword.hasText || !self.chooseUsername.hasText || !self.emailID.hasText{
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill all the details.", duration: 2)
            return
        }

        alertView.showWait("Kovac Smart Super", subTitle: "Please wait while we submit your details", duration: 2)

        let transferDict = NSMutableDictionary()
        
        transferDict.setValue("1", forKey:"exist")
        transferDict.setValue(self.chooseUsername.text!, forKey:"user_name")
        transferDict.setValue(self.emailID.text!, forKey:"user_email")
        transferDict.setValue(self.clientName.text!, forKey:"user_fname")
        transferDict.setValue(self.confirmPassword.text!, forKey:"user_password")
        
        print(transferDict)
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
                DispatchQueue.main.async {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    
                    let alertView1 = SCLAlertView(appearance: appearance)
                    
                    
                    alertView1.showSuccess("Kovac Smart Super", subTitle: "Thanks for submitting Details.", duration: 2)
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            task.resume()
            
        } catch let error as NSError {
            print(error.description)
        }
    }

    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
