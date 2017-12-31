//
//  EmployeeDetailsViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class EmployeeDetailsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var transferDict = NSMutableDictionary()
    var pickOption = NSArray()
    
    @IBOutlet weak var employmentStatus: UITextField!
    
    @IBOutlet weak var occupation: UITextField!
    
    @IBOutlet weak var taxfileNumber: UITextField!
    
    @IBOutlet weak var annualIncome: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(transferDict)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        if !self.employmentStatus.hasText || !self.occupation.hasText || !self.taxfileNumber.hasText || !self.annualIncome.hasText{
            
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill all the details.", duration: 2)
            return
        }
        transferDict.setValue(self.employmentStatus.text!, forKey:"emp_status")
        transferDict.setValue(self.occupation.text, forKey:"emp_occupation")
        transferDict.setValue(self.taxfileNumber.text!, forKey:"emp_tax_file_no")
        transferDict.setValue(self.annualIncome.text!, forKey:"emp_annual_income")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "SuperannuationDetailViewController") as! SuperannuationDetailViewController
        personalViewController.transferDict = transferDict
        self.navigationController?.pushViewController(personalViewController, animated: true)
    }
    
    @IBAction func employmentStatusAction(_ sender: UITextField) {
        let pickerView = UIPickerView()
        
        pickOption = ["Full-Time Employed","Part-Time Employed","Self-Employed","Unemployed","Retired"]
        pickerView.tag = 0
        pickerView.delegate = self
        self.employmentStatus.inputView = pickerView
        self.employmentStatus.text = "Full-Time Employed"
        pickerView.reloadAllComponents()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickOption[row] as! NSString) as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.employmentStatus.text = pickOption[row] as? String
    }
}
