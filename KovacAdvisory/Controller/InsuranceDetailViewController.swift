//
//  InsuranceDetailViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class InsuranceDetailViewController: UIViewController {
    var transferDict = NSMutableDictionary()
    var haveInsurance = "No"
    var isSmoker = "No"
    var isLifeInsurance = "No"
    var isDisabilityInsurance = "No"
    var isIncomeInsurance = "No"
    var isTraumaInsurance = "No"
    
    @IBOutlet weak var insuranceView: UIView!
    @IBOutlet var traumaInsurance: UITextField!
    @IBOutlet var incomeProtection: UITextField!
    @IBOutlet var disabilityValue: UITextField!
    @IBOutlet var lifeValue: UITextField!
    
    @IBOutlet var weightCm: UITextField!
    @IBOutlet var heightCm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(transferDict)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func haveInsuranceCoverAction(_ sender: UISwitch) {
        if sender.isOn {
            self.insuranceView.isHidden = false;
            
            haveInsurance = "Yes"
        }else{
            self.insuranceView.isHidden = true;
            
            haveInsurance = "No"
        }
    }
    
    @IBAction func smokerAction(_ sender: UISwitch) {
        if sender.isOn {
            isSmoker = "Yes"
        }else{
            isSmoker = "No"
        }
    }
    
    @IBAction func lifeInsuranceAction(_ sender: UISwitch) {
        if sender.isOn {
            isLifeInsurance = "Yes"
            lifeValue.isEnabled = true
        }else{
            lifeValue.isEnabled = false
            lifeValue.text = ""
            
            isLifeInsurance = "No"
        }
    }
    
    @IBAction func disabilityInsuranceAction(_ sender: UISwitch) {
        
        if sender.isOn {
            isDisabilityInsurance = "Yes"
            disabilityValue.isEnabled = true
            
        } else {
            disabilityValue.isEnabled = false
            disabilityValue.text = ""
            isDisabilityInsurance = "No"
        }
    }
    
    @IBAction func incomeProtectionAction(_ sender: UISwitch) {
        
        if sender.isOn {
            isIncomeInsurance = "Yes"
            incomeProtection.isEnabled = true
        } else {
            incomeProtection.isEnabled = false
            incomeProtection.text = ""
            isIncomeInsurance = "No"
        }
    }
    
    @IBAction func traumaInsuranceAction(_ sender: UISwitch) {
        if sender.isOn {
            isTraumaInsurance = "Yes"
            traumaInsurance.isEnabled = true
            
        } else {
            traumaInsurance.isEnabled = false
            traumaInsurance.text = ""
            isTraumaInsurance = "No"
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        if !self.heightCm.hasText || !self.weightCm.hasText{
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill height and weight", duration: 2)
            return
        }
        
        if isLifeInsurance == "Yes" && self.lifeValue.text == ""{
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill the value of life insurance", duration: 2)
            return
        }
        
        if isDisabilityInsurance == "Yes" && self.disabilityValue.text == ""{
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill the value of disability insurance", duration: 2)
            return
        }
        
        if isIncomeInsurance == "Yes" && self.incomeProtection.text == ""{
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill the value of Income Protection", duration: 2)
            return
        }
        
        if isTraumaInsurance == "Yes" && self.traumaInsurance.text == ""{
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill the value of Trauma Insurance", duration: 2)
            return
        }

        transferDict.setValue(haveInsurance, forKey:"emp_insurance_cover")
        transferDict.setValue(isSmoker, forKey:"emp_smoker")
        transferDict.setValue(self.heightCm.text!, forKey:"emp_height")
        transferDict.setValue(self.weightCm.text!, forKey:"emp_weight")
        transferDict.setValue(isLifeInsurance, forKey:"emp_life_insurance")
        transferDict.setValue(self.lifeValue.text!, forKey:"emp_life_insurance_value")
        transferDict.setValue(isDisabilityInsurance, forKey:"emp_disability_insurance")
        transferDict.setValue(self.disabilityValue.text!, forKey:"emp_disability_insurance_value")
        transferDict.setValue(isIncomeInsurance, forKey:"emp_income_protection")
        transferDict.setValue(self.incomeProtection.text!, forKey:"emp_income_protection_value")
        transferDict.setValue(isTraumaInsurance, forKey:"emp_trauma_insurance")
        transferDict.setValue(self.traumaInsurance.text!, forKey:"emp_trauma_insurance_value")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "AssetLiabilityViewController") as! AssetLiabilityViewController
        personalViewController.transferDict = transferDict
        self.navigationController?.pushViewController(personalViewController, animated: true)
    }
}
