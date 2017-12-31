//
//  InvestmentFundTableViewCell.swift
//  KovacAdvisory
//
//  Created by Shivam on 16/07/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit

class InvestmentFundTableViewCell: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var investmentOption: UITextField!
    
    @IBOutlet weak var currentValue: UITextField!
    
    @IBOutlet weak var value: UITextField!
    
    
    var pickOption = NSArray()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func investmentOption(_ sender: Any) {
//        let pickerView = UIPickerView()
//        pickOption = ["High Growth","Growth","Balanced","Conservative"]
//        
//        pickerView.delegate = self
//        self.investmentOption.inputView = pickerView
//        self.investmentOption.text = "High Growth"
//        pickerView.reloadAllComponents()

        
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
        
            self.investmentOption.text = pickOption[row] as? String
        
        
    }

}
