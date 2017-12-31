//
//  ViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 11/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import KeychainSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!UserDefaults.standard.bool(forKey:"firstTime")) {
            UserDefaults.standard.set(true, forKey: "firstTime")
            
            var onboardingVC = OnboardingViewController()
            
            // Create slides
            let firstPage = OnboardingContentViewController.content(withTitle: "Consolidate", body: "Easily consolidate all of your super into one place", image: UIImage(named: "image1"), buttonText: nil, action: nil)
            
            let secondPage = OnboardingContentViewController.content(withTitle: "Growth", body: "Watch your super grow with an expertly managed investment portfolio", image: UIImage(named: "image2"), buttonText: nil, action: nil)
            
            let thirdPage = OnboardingContentViewController.content(withTitle: "Advice", body: "Your personal financial adviser right in the palm of your hand", image: UIImage(named: "image3"), buttonText: nil, action: nil)
            
            let fourthPage = OnboardingContentViewController.content(withTitle: "Protect", body: "Optional low cost, comprehensive life insurance", image: UIImage(named: "image4"), buttonText:nil, action:nil)
            
            let fifthPage = OnboardingContentViewController.content(withTitle: "Fast and Secure", body: "Sign up in minutes to take control of your super with all the help you need", image: UIImage(named: "image5"), buttonText:"Got it!", action: { () -> Void in
                self.dismiss(animated: true, completion: nil)
                
            }
            )
            
            // Define onboarding view controller properties
            onboardingVC = OnboardingViewController.onboard(withBackgroundImage: UIImage(named: "demoBack"), contents: [firstPage, secondPage, thirdPage, fourthPage,fifthPage])
            onboardingVC.shouldFadeTransitions = true
            onboardingVC.shouldMaskBackground = false
            onboardingVC.shouldBlurBackground = false
            onboardingVC.fadePageControlOnLastPage = true
            onboardingVC.pageControl.pageIndicatorTintColor = UIColor.darkGray
            onboardingVC.pageControl.currentPageIndicatorTintColor = UIColor.white
            onboardingVC.skipButton.setTitleColor(UIColor.white, for: .normal)
            onboardingVC.allowSkipping = false
            onboardingVC.fadeSkipButtonOnLastPage = false
            
            self.present(onboardingVC, animated: true, completion: nil)
        }
        
        let keychain = KeychainSwift()
        if (keychain.get("username") != nil) {
            DispatchQueue.main.async {
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(personalViewController, animated: true)
            }
        }
    }
    
    @IBAction func startHereAction(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (UserDefaults.standard.object(forKey: "halfForm") != nil) {
            let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
            let outData = UserDefaults.standard.data(forKey:"transferDict")
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!)
            personalViewController.transferDict = dict as! NSMutableDictionary
            
            self.navigationController?.pushViewController(personalViewController, animated: true)
        } else {
            let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "RegisterLoginViewController") as! RegisterLoginViewController
            self.navigationController?.pushViewController(personalViewController, animated: true)
            
        }
    }
}
