//
//  LoginViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import LocalAuthentication
import SafariServices
import SCLAlertView
import KeychainSwift

class LoginViewController: UIViewController {
    
    var runningService: Bool! = false
    var terminateService: Bool! = false
    var timer: Timer!
    let keychain = KeychainSwift()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (keychain.get("username") != nil) {
            emailTextfield.text = keychain.get("username")
            DispatchQueue.main.async {
                self.authenticateUser()
            }
        } else {
            emailTextfield.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextfield.text = ""
        passwordTextfield.text = ""
        emailTextfield.superview?.isHidden = false
        if(UIApplication.shared.isNetworkActivityIndicatorVisible){
            emailTextfield.becomeFirstResponder()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func authenticateUser() {
        emailTextfield.superview?.isHidden = true
        
        let authenticationContext = LAContext()
        
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authentication required", reply: { [unowned self] (success, error) -> Void in
            
            if(success) {
                DispatchQueue.main.async {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    self.present(mainViewController, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.keychain.clear()
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.showWarning("Kovac Smart Super", subTitle: "Failed to login automatically due to invalid authentication", duration: 2)
                    self.emailTextfield.superview?.isHidden = false
                }
            }
        })
    }
    
    @IBAction func homeBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if emailTextfield.text == "" || passwordTextfield.text == "" {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill all the details.", duration: 2)
            return
        }
        
        var request = URLRequest(url: URL(string: "https://kovacadvisory.com.au/auth.php")!)
        request.httpMethod = "POST"
        let postData = String(format: "username=%@&password=%@", emailTextfield.text!, passwordTextfield.text!).data(using: String.Encoding(rawValue: String.Encoding.nonLossyASCII.rawValue), allowLossyConversion: false)!
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
                if(responseString?.contains("true"))!{
                    self.keychain.set(self.emailTextfield.text!, forKey: "username")
                    self.keychain.set(self.passwordTextfield.text!, forKey: "password")
                                        
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    self.present(mainViewController, animated: true, completion: nil)
                } else {
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.showWarning("Kovac Smart Super", subTitle: "Invalid username or password!", duration: 2)
                }
            }
        }
        task.resume()
    }
}
