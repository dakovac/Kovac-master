//
//  SuperannuationDetailViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class SuperannuationDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var transferDict = NSMutableDictionary()
    var knowInves = "Yes"
    
    @IBOutlet weak var tableView: UITableView!
    
    var addMore:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(transferDict)
        addMore = 1;
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func knowInvestment(_ sender: UISwitch) {
        if sender.isOn{
            knowInves = "Yes"
        }else{
            knowInves = "No"
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        
        let alertView = SCLAlertView(appearance: appearance)
        let superFundNameValue = NSMutableString(string: "")
        let memberNumberValue = NSMutableString(string: "")
        let superValue = NSMutableString(string: "")
        
        for i in 0 ..< addMore! {
            let selectedPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: selectedPath) as! InvestmentFundTableViewCell
            
            let investOpt = "\(cell.investmentOption.text!),"
            let currentVal = "\(cell.currentValue.text!),"
            let superVal = "\(cell.value.text!),"
            
            if  !cell.investmentOption.hasText || !cell.currentValue.hasText || !cell.value.hasText{
                alertView.showWarning("Kovac Smart Super", subTitle: "Please fill investment option", duration: 2)
                return
            }
            
            superFundNameValue.append(investOpt)
            memberNumberValue.append(currentVal)
            superValue.append(superVal)
        }
        
        var superTrunc = String(superFundNameValue)
        var memberNoTrunc = String(memberNumberValue)
        var superVal = String(superValue)

        if superTrunc.characters.count > 1 {
            superTrunc = String(superTrunc.characters.dropLast())
        }else{
            superTrunc = "";
        }
        
        if memberNoTrunc.characters.count > 1 {
            memberNoTrunc = String(memberNoTrunc.characters.dropLast())
        }else{
            memberNoTrunc = "";
        }
        
        if superVal.characters.count > 1 {
            superVal = String(superVal.characters.dropLast())
        }else{
            superVal = "";
        }

        transferDict.setValue(superTrunc, forKey:"emp_super_fund_name")
        transferDict.setValue("", forKey:"emp_investment_option")
        transferDict.setValue(superVal, forKey:"emp_current_value")
        transferDict.setValue(memberNoTrunc, forKey:"emp_member_no")
        transferDict.setValue("", forKey:"emp_superannuation_status")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "InsuranceDetailViewController") as! InsuranceDetailViewController
        personalViewController.transferDict = transferDict
        self.navigationController?.pushViewController(personalViewController, animated: true)
    }
    
    //Mark: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addMore!
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellInvestmentFund", for: indexPath) as! InvestmentFundTableViewCell
        
        
        return cell
    }
    
    @IBAction func addMoreAction(_ sender: Any) {
        addMore! = addMore!+1;
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        if  addMore == 9 {
            addMore = 8;
            alertView.showWarning("Kovac Smart Super", subTitle: "You have reached a maximum number of investment declaration", duration: 2)
        }

        self.tableView.reloadData()
    }
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        addMore! = addMore!-1;
        
        if  addMore == 0 {
            addMore = 1
        }
        
        self.tableView.reloadData()
    }
}
