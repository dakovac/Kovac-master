//
//  AssetLiabilityViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class AssetLiabilityViewController: UIViewController {
    var transferDict = NSMutableDictionary()
    
    @IBOutlet var investmentPropertyValue: UITextField!
    @IBOutlet var ownHomeValue: UITextField!
    @IBOutlet var shareAssetValue: UITextField!
    @IBOutlet var otherAssetValue: UITextField!
    @IBOutlet var homeLoanValue: UITextField!
    @IBOutlet var otherLiabilityValue: UITextField!
    @IBOutlet var creditCardValue: UITextField!
    @IBOutlet var investmentLoanValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(transferDict)
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
        //Assets
        transferDict.setValue(self.ownHomeValue.text!, forKey:"emp_own_home")
        transferDict.setValue(self.investmentPropertyValue.text, forKey:"emp_investment_property")
        transferDict.setValue(self.shareAssetValue.text!, forKey:"emp_share_portfolio")
        transferDict.setValue(self.otherAssetValue.text!, forKey:"emp_other_assets")
        
        //Liability
        transferDict.setValue(self.otherAssetValue.text!, forKey:"emp_superannuation_status")
        transferDict.setValue(self.homeLoanValue.text!, forKey:"emp_home_loan")
        transferDict.setValue(self.investmentLoanValue.text, forKey:"emp_investment_loans")
        transferDict.setValue(self.creditCardValue.text!, forKey:"emp_credit_cards")
        transferDict.setValue(self.otherLiabilityValue.text!, forKey:"emp_other_liabilities")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "RiskProfileViewController") as! RiskProfileViewController
        personalViewController.transferDict = transferDict
        self.navigationController?.pushViewController(personalViewController, animated: true)
        
        
    }
}
