//
//  PersonalDetailViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 17/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import SCLAlertView

class PersonalDetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var dependentChildren: UITextField!
    
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    
    var dependentCount:Int?
    
    @IBOutlet var postCode: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var dateOfBirth: UITextField!
    
    @IBOutlet weak var streetText: UITextField!
    
    @IBOutlet weak var suburb: UITextField!
    
    @IBOutlet weak var martialStatus: UITextField!
    
    @IBOutlet weak var state: UITextField!
    var transferDict = NSMutableDictionary()
    
    var pickOption = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dependentCount = 0;
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.separatorColor = UIColor.clear
        UserDefaults.standard.set(true, forKey: "halfForm")
        
        let data = NSKeyedArchiver.archivedData(withRootObject: transferDict)
        UserDefaults.standard.set(data, forKey: "transferDict")
        // Do any additional setup after loading the view.
    }
    
    //Mark: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependentCount!
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellChildren", for: indexPath) as! ChildrenDetailTableViewCell
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if dependentCount! > 0{
            return "Dependent Children Details"
            
        }else{
            return ""
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        if !self.phoneNo.hasText || !self.gender.hasText || !self.dateOfBirth.hasText || !self.streetText.hasText || !self.suburb.hasText || !self.state.hasText || !self.postCode.hasText || !self.martialStatus.hasText || !self.dependentChildren.hasText{
            
            
            alertView.showWarning("Kovac Smart Super", subTitle: "Please fill all the details.", duration: 2)
            return
        }
        let nsMutableString = NSMutableString(string: "")
        
        for i in 0 ..< dependentCount! {
            let selectedPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: selectedPath) as! ChildrenDetailTableViewCell
            if  !cell.dobTxtfield.hasText || !cell.nameTextfield.hasText{
                alertView.showWarning("Kovac Smart Super", subTitle: "Please fill the children details", duration: 2)
                return
            }
            
            let childrenStr = "\(cell.nameTextfield.text!)-" + "\(cell.dobTxtfield.text!),"
            nsMutableString.append(childrenStr)
        }
        var trunc = String(nsMutableString)
        
        if trunc.count > 0 {
            trunc = String(trunc.dropLast())
        }
        
        transferDict.setValue(self.phoneNo.text!, forKey:"user_mobileno")
        
        transferDict.setValue(self.gender.text!, forKey:"user_gender")
        transferDict.setValue(self.dateOfBirth.text!, forKey:"user_dob")
        transferDict.setValue(self.streetText.text!, forKey:"user_address")
        transferDict.setValue(self.suburb.text!, forKey:"user_suburb")
        transferDict.setValue(self.state.text!, forKey:"user_state")
        transferDict.setValue(self.postCode.text!, forKey:"user_postcode")
        transferDict.setValue(self.martialStatus.text!, forKey:"user_marital_status")
        transferDict.setValue(self.dependentChildren.text!, forKey:"user_dependant_children")
        transferDict.setValue(trunc, forKey:"user_dependant_children_data")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "EmployeeDetailsViewController") as! EmployeeDetailsViewController
        personalViewController.transferDict = transferDict
        self.navigationController?.pushViewController(personalViewController, animated: true)
        
        
        
    }
    
    //MARK: Date input
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let dateFormatter = DateFormatter()
        
        let date = Date()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dateOfBirth.text = dateFormatter.string(from: date)
        
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(PersonalDetailViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.dateOfBirth.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK: Gender input
    @IBAction func commonPicker(_ sender: UITextField) {
        
        let pickerView = UIPickerView()
        
        if sender.tag == 0 {
            pickOption = ["male","female"]
            pickerView.tag = 0
            pickerView.delegate = self
            self.gender.inputView = pickerView
            self.gender.text = "male"
            pickerView.reloadAllComponents()
            
        }else if sender.tag == 1{
            pickOption = ["ACT","NSW","NT","QLD","TAS","VIC","WA"]
            pickerView.tag = 1
            pickerView.delegate = self
            self.state.inputView = pickerView
            pickerView.reloadAllComponents()
            self.state.text = "ACT"
            
        }else if sender.tag == 2{
            pickOption = ["Single","Married","Defacto"]
            pickerView.tag = 2
            
            pickerView.delegate = self
            self.martialStatus.inputView = pickerView
            pickerView.reloadAllComponents()
            self.martialStatus.text = "Single"
            
        }else if sender.tag == 3{
            pickOption = ["0","1","2","3","4","5","6"]
            pickerView.tag = 3
            
            pickerView.delegate = self
            self.dependentChildren.inputView = pickerView
            self.dependentChildren.text = String(dependentCount!)
            pickerView.reloadAllComponents()
            pickerView.selectRow(dependentCount!, inComponent: 0, animated: true)
        }
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
        
        if pickerView.tag == 0 {
            self.gender.text = pickOption[row] as? String
        }else if pickerView.tag == 1{
            self.state.text = pickOption[row] as? String
        }else if pickerView.tag == 2{
            self.martialStatus.text = pickOption[row] as? String
            
        }else if pickerView.tag == 3{
            self.dependentChildren.text = pickOption[row] as? String
            dependentCount = row
            self.tableView.reloadData()
        }
    }
}
