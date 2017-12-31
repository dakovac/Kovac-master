//
//  RiskProfileViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit

class RiskProfileViewController: UIViewController {
    var transferDict = NSMutableDictionary()
    
    @IBOutlet var hightGrowthSwitch: UISwitch!
    
    @IBOutlet var growthSwitch: UISwitch!
    
    @IBOutlet var concervativeSwitch: UISwitch!
    @IBOutlet var balancedSwitch: UISwitch!
    
    var riskProfile = "High Growth"
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func riskProfileSwitch(_ sender: UISwitch) {
        
        if sender.tag == 0 {
            hightGrowthSwitch.setOn(true, animated: true)
            growthSwitch.setOn(false, animated: true)
            balancedSwitch.setOn(false, animated: true)
            concervativeSwitch.setOn(false, animated: true)
            
            riskProfile = "High Growth"
            
        }else if sender.tag == 1 {
            hightGrowthSwitch.setOn(false, animated: true)
            growthSwitch.setOn(true, animated: true)
            balancedSwitch.setOn(false, animated: true)
            concervativeSwitch.setOn(false, animated: true)
            riskProfile = "Growth"
            
            
        }else if sender.tag == 2 {
            hightGrowthSwitch.setOn(false, animated: true)
            growthSwitch.setOn(false, animated: true)
            balancedSwitch.setOn(true, animated: true)
            concervativeSwitch.setOn(false, animated: true)
            
            riskProfile = "Balanced"
            
        }else if sender.tag == 3 {
            hightGrowthSwitch.setOn(false, animated: true)
            growthSwitch.setOn(false, animated: true)
            balancedSwitch.setOn(false, animated: true)
            concervativeSwitch.setOn(true, animated: true)
            riskProfile = "Concervative"
        }
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        transferDict.setValue(riskProfile, forKey:"emp_risk_profile")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "PhotoUploadViewController") as! PhotoUploadViewController
        personalViewController.transferDict = transferDict
        self.navigationController?.pushViewController(personalViewController, animated: true)
    }
    
}
