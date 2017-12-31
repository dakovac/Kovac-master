//
//  SubmittedViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class SubmittedViewController: UIViewController {
    var userID:String!
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func contactMeAction(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        if sender.isSelected {
            
        }else{
            sender.isSelected = true
            //Request Call
            alertView.showWait("Kovac Smart Super", subTitle: "Please wait while we submit your details", duration: 2)
            
            let transferDict = NSMutableDictionary()
            
            transferDict.setValue("1", forKey:"financial_adviser")
            transferDict.setValue("Yes", forKey:"emp_personal_adviser")
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
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        
                        let alertView1 = SCLAlertView(appearance: appearance)
                        
                        
                        alertView1.showSuccess("Kovac Smart Super", subTitle: "Details submitted Successfully", duration: 2)
                    }
                }
                task.resume()
                
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    @IBAction func referAFriendAction(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "ReferFriendViewController") as! ReferFriendViewController
        //        personalViewController.userID = userID!
        self.navigationController?.pushViewController(personalViewController, animated: true)
    }
}
