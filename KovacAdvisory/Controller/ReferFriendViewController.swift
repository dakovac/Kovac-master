//
//  ReferFriendViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class ReferFriendViewController: UIViewController {
    var userID:NSString!
    
    @IBOutlet var friendEmail: UITextField!
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        self.view.endEditing(true)
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        if isValidEmail(testStr: self.friendEmail.text!) {
            
            alertView.showWait("Kovac Smart Super", subTitle: "Please wait while we submit your details", duration: 2)
            
            let transferDict = NSMutableDictionary()
            
            transferDict.setValue("1", forKey:"refer_friend")
            transferDict.setValue(self.friendEmail.text!, forKey:"emp_refer_email")
            transferDict.setValue(userID!, forKey:"userid")
            
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
                        self.friendEmail.text = ""
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        
                        let alertView1 = SCLAlertView(appearance: appearance)
                        
                        
                        alertView1.showSuccess("Kovac Smart Super", subTitle: "Thanks for giving the referral of your friend", duration: 2)
                    }
                }
                task.resume()
                
            } catch let error as NSError {
                print(error.description)
            }
            
            
        } else {
            alertView.showWarning("Kovac Smart Super", subTitle: "Please enter valid email ID.", duration: 2)
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
