//
//  ChildrenDetailTableViewCell.swift
//  KovacAdvisory
//
//  Created by Shivam on 04/07/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit

class ChildrenDetailTableViewCell: UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var nameTextfield: UITextField!

    @IBOutlet weak var dobTxtfield: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameTextfield.delegate = self;
        self.dobTxtfield.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func cellDOBAction(_ sender: UITextField) {
        let dateFormatter = DateFormatter()

        let date = Date()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dobTxtfield.text = dateFormatter.string(from: date)
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = date

        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ChildrenDetailTableViewCell.datePickerValueChanged), for: UIControlEvents.valueChanged)

    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"

        
        self.dobTxtfield.text = dateFormatter.string(from: sender.date)
    }
}
