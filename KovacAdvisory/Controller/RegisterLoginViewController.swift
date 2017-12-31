//
//  RegisterLoginViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 03/07/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class RegisterLoginViewController: UIViewController {
    
    @IBOutlet var chooseEmail: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var secondName: UITextField!
    @IBOutlet weak var chooseUsername: UITextField!
    
    @IBOutlet weak var choosePassword: UITextField!
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        if !self.firstName.hasText || !self.secondName.hasText || !self.chooseEmail.hasText || !self.choosePassword.hasText || !self.chooseUsername.hasText{
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill all the details.", duration: 2)
            return
        }
        
        if (self.choosePassword.text?.characters.count)! < 6{
            alertView.showWarning("Kovac Smart Super", subTitle: "Password shouldn't be less than 6 characters.", duration: 2)
            return
        }
        
        if isValidEmail(testStr: self.chooseEmail.text!) {
            let transferDict = NSMutableDictionary()
            
            transferDict.setValue(self.firstName.text!, forKey:"user_fname")
            transferDict.setValue(self.secondName.text, forKey:"user_lname")
            transferDict.setValue(self.chooseEmail.text, forKey:"user_email")
            transferDict.setValue(self.chooseUsername.text, forKey:"user_name")
            transferDict.setValue(self.choosePassword.text, forKey:"user_password")
            transferDict.setValue("1", forKey:"halfform")
            alertView.showWait("Kovac Smart Super", subTitle: "Please wait while we submit your details", duration: 6)
            
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
                
                var request = URLRequest(url: URL(string: "https://kovacadvisory.com.au/api/rest/user")!)
                request.httpMethod = "POST"
                let postData = verifyStr!.data(using: String.Encoding.nonLossyASCII.rawValue, allowLossyConversion: false)!
                let postLength = "\(postData.count)"
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                request.httpBody = postData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("error=\(error)")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString!)")
                    
                    DispatchQueue.main.async {
                        let resp = Int(responseString!)
                        if resp! > 0{
                            
                            transferDict.setValue(resp!, forKey:"userid")
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                            personalViewController.transferDict = transferDict
                            self.navigationController?.pushViewController(personalViewController, animated: true)
                            
                            
                        }else{
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            
                            let alertView1 = SCLAlertView(appearance: appearance)
                            alertView1.showWarning("Kovac Smart Super", subTitle: "Please check the data  entered correctly or not", duration: 2)
                            
                        }
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}
